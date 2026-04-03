#define VIDEOGL_EXPORTS
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <mfapi.h>
#include <mfidl.h>
#include <mfreadwrite.h>
#include <mferror.h>
#include <string>
#include <cmath>
#include <stdio.h>
#include <algorithm>
#include <mutex>
#include <memory>
#include <unordered_map>
#include <vector>
#include <GL/gl.h>

#pragma comment(lib, "opengl32.lib")
#pragma comment(lib, "mfplat")
#pragma comment(lib, "mfreadwrite")
#pragma comment(lib, "mfuuid")
#pragma comment(lib, "Ole32.lib")

#ifndef GL_CLAMP_TO_EDGE
#define GL_CLAMP_TO_EDGE 0x812F
#endif

#ifndef GL_RG
#define GL_RG 0x8227
#endif

#ifndef GL_TEXTURE_SWIZZLE_R
#define GL_TEXTURE_SWIZZLE_R 0x8E42
#define GL_TEXTURE_SWIZZLE_G 0x8E43
#define GL_TEXTURE_SWIZZLE_B 0x8E44
#define GL_TEXTURE_SWIZZLE_A 0x8E45
#define GL_TEXTURE_SWIZZLE_RGBA 0x8E46
#endif

#ifndef GL_R8
#define GL_R8 0x8229
#endif

#ifndef GL_RG8
#define GL_RG8 0x822B
#endif

#ifndef GL_UNPACK_ROW_LENGTH
#define GL_UNPACK_ROW_LENGTH 0x0CF2
#endif

typedef void (*PFNGLTEXSTORAGE2DPROC)(
    GLenum target,
    GLsizei levels,
    GLenum internalformat,
    GLsizei width,
    GLsizei height
);

int clamp(int val, int minVal, int maxVal)
{
	return (val < minVal) ? minVal : (val > maxVal) ? maxVal
													: val;
}

struct VideoState
{
	IMFSourceReader *reader = nullptr;
	unsigned char *pixelBuffer = nullptr;
	int frameWidth = 0;
	int frameHeight = 0;
	GLuint yTextureID = 0;
	GLuint uvTextureID = 0;
	LONGLONG currentAudioPosition = 0;
	LONGLONG currentVideoPosition = 0;
	std::vector<uint8_t> audioLeftover;
	std::vector<uint8_t> packedYPlane;
	std::vector<uint8_t> packedUVPlane;
	std::mutex mutex;
};

bool supportsUnpackRowLength = false;
PFNGLTEXSTORAGE2DPROC glTexStorage2D = nullptr;
std::mutex videoStatesMutex;
std::unordered_map<int, std::shared_ptr<VideoState>> videoStates;
int nextVideoHandle = 1;
int mediaFoundationInitCount = 0;

std::wstring widen(const char *utf8)
{
	int len = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, nullptr, 0);
	std::wstring wstr(len, 0);
	MultiByteToWideChar(CP_UTF8, 0, utf8, -1, &wstr[0], len);
	return wstr;
}

void detectGLCapabilities()
{
	supportsUnpackRowLength = false;

	const char *glVersion = (const char *)glGetString(GL_VERSION);
	const char *glExtensions = (const char *)glGetString(GL_EXTENSIONS);

	if (glVersion == nullptr)
	{
		return;
	}

	if (glExtensions != nullptr && strstr(glExtensions, "GL_UNPACK_ROW_LENGTH") != nullptr)
	{
		supportsUnpackRowLength = true;
		return;
	}

	if (atof(glVersion) >= 3.0)
	{
		supportsUnpackRowLength = true;
	}
}

void loadOpenGLExtensions()
{
	glTexStorage2D = (PFNGLTEXSTORAGE2DPROC)wglGetProcAddress("glTexStorage2D");

	if (!glTexStorage2D)
	{
		printf("Warning: glTexStorage2D not available. Falling back to glTexImage2D.\n");
	}
}

static std::shared_ptr<VideoState> getVideoState(int handle)
{
	std::lock_guard<std::mutex> lock(videoStatesMutex);
	auto it = videoStates.find(handle);
	if (it == videoStates.end())
	{
		return nullptr;
	}

	return it->second;
}

static bool retainMediaFoundation()
{
	std::lock_guard<std::mutex> lock(videoStatesMutex);

	if (mediaFoundationInitCount == 0)
	{
		if (FAILED(MFStartup(MF_VERSION)))
		{
			return false;
		}
	}

	mediaFoundationInitCount++;
	return true;
}

static void releaseMediaFoundation()
{
	bool shouldShutdown = false;

	{
		std::lock_guard<std::mutex> lock(videoStatesMutex);

		if (mediaFoundationInitCount > 0)
		{
			mediaFoundationInitCount--;
			shouldShutdown = (mediaFoundationInitCount == 0);
		}
	}

	if (shouldShutdown)
	{
		MFShutdown();
	}
}

static void releaseReader(VideoState &state)
{
	if (state.reader)
	{
		state.reader->Release();
		state.reader = nullptr;
	}
}

static void releaseTextures(VideoState &state)
{
	if (state.yTextureID != 0)
	{
		glDeleteTextures(1, &state.yTextureID);
		state.yTextureID = 0;
	}

	if (state.uvTextureID != 0)
	{
		glDeleteTextures(1, &state.uvTextureID);
		state.uvTextureID = 0;
	}
}

static void resetState(VideoState &state)
{
	state.pixelBuffer = nullptr;
	state.audioLeftover.clear();
	state.packedYPlane.clear();
	state.packedUVPlane.clear();
	state.frameWidth = 0;
	state.frameHeight = 0;
	state.currentAudioPosition = 0;
	state.currentVideoPosition = 0;
}

void initVideoTextures(VideoState &state, int width, int height)
{
	bool resized = ((state.yTextureID != 0 || state.uvTextureID != 0)
		&& (state.frameWidth != width || state.frameHeight != height));
	if (resized)
	{
		releaseTextures(state);
	}

	state.frameWidth = width;
	state.frameHeight = height;

	int uvWidth = width / 2;
	int uvHeight = height / 2;

	if (state.yTextureID == 0)
	{
		glGenTextures(1, &state.yTextureID);
		glBindTexture(GL_TEXTURE_2D, state.yTextureID);
		GLint swizzle[] = {GL_RED, GL_RED, GL_RED, GL_ONE};
		glTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_SWIZZLE_RGBA, swizzle);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

		if (glTexStorage2D)
		{
			glTexStorage2D(GL_TEXTURE_2D, 1, GL_R8, width, height);
		}
		else
		{
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, width, height, 0, GL_RED, GL_UNSIGNED_BYTE, nullptr);
		}
	}

	if (state.uvTextureID == 0)
	{
		glGenTextures(1, &state.uvTextureID);
		glBindTexture(GL_TEXTURE_2D, state.uvTextureID);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

		if (glTexStorage2D)
		{
			glTexStorage2D(GL_TEXTURE_2D, 1, GL_RG8, uvWidth, uvHeight);
		}
		else
		{
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RG, uvWidth, uvHeight, 0, GL_RG, GL_UNSIGNED_BYTE, nullptr);
		}
	}
}

extern "C" int video_create()
{
	loadOpenGLExtensions();
	detectGLCapabilities();

	if (!retainMediaFoundation())
	{
		return 0;
	}

	auto state = std::make_shared<VideoState>();
	int handle = 0;

	{
		std::lock_guard<std::mutex> lock(videoStatesMutex);

		int attempts = 0;
		while (attempts < 0x7FFFFFFF)
		{
			int candidate = nextVideoHandle++;
			if (nextVideoHandle <= 0)
			{
				nextVideoHandle = 1;
			}

			if (candidate > 0 && videoStates.find(candidate) == videoStates.end())
			{
				videoStates[candidate] = state;
				handle = candidate;
				break;
			}

			attempts++;
		}
	}

	if (handle == 0)
	{
		releaseMediaFoundation();
	}

	return handle;
}

extern "C" bool video_init()
{
	loadOpenGLExtensions();
	detectGLCapabilities();
	if (!retainMediaFoundation())
	{
		return false;
	}

	releaseMediaFoundation();
	return true;
}

extern "C" unsigned int video_gl_get_texture_id_y(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
	{
		return 0;
	}

	std::lock_guard<std::mutex> lock(state->mutex);
	return static_cast<unsigned int>(state->yTextureID);
}

extern "C" unsigned int video_gl_get_texture_id_uv(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
	{
		return 0;
	}

	std::lock_guard<std::mutex> lock(state->mutex);
	return static_cast<unsigned int>(state->uvTextureID);
}

extern "C" int video_get_width(int handle, const char *path)
{
	if (!getVideoState(handle))
	{
		return -1;
	}

	IMFSourceReader *probeReader = nullptr;
	auto widePath = widen(path);
	HRESULT hr = MFCreateSourceReaderFromURL(widePath.c_str(), nullptr, &probeReader);
	if (FAILED(hr))
		return -1;

	IMFMediaType *actualType = nullptr;
	hr = probeReader->GetNativeMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, 0, &actualType);
	if (FAILED(hr))
	{
		probeReader->Release();
		return -1;
	}

	UINT32 w = 0, h = 0;
	hr = MFGetAttributeSize(actualType, MF_MT_FRAME_SIZE, &w, &h);
	actualType->Release();
	probeReader->Release();

	return SUCCEEDED(hr) ? static_cast<int>(w) : -1;
}

extern "C" int video_get_height(int handle, const char *path)
{
	if (!getVideoState(handle))
	{
		return -1;
	}

	IMFSourceReader *probeReader = nullptr;
	auto widePath = widen(path);
	HRESULT hr = MFCreateSourceReaderFromURL(widePath.c_str(), nullptr, &probeReader);
	if (FAILED(hr))
		return -1;

	IMFMediaType *actualType = nullptr;
	hr = probeReader->GetNativeMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, 0, &actualType);
	if (FAILED(hr))
	{
		probeReader->Release();
		return -1;
	}

	UINT32 w = 0, h = 0;
	hr = MFGetAttributeSize(actualType, MF_MT_FRAME_SIZE, &w, &h);
	actualType->Release();
	probeReader->Release();

	return SUCCEEDED(hr) ? static_cast<int>(h) : -1;
}

extern "C" bool video_gl_load(int handle, const char *path)
{
	auto state = getVideoState(handle);
	if (!state)
	{
		return false;
	}

	std::lock_guard<std::mutex> lock(state->mutex);
	state->audioLeftover.clear();

	IMFSourceReader *newReader = nullptr;
	IMFMediaType *type = nullptr;
	IMFMediaType *actualType = nullptr;
	IMFMediaType *audioType = nullptr;
	UINT32 w = 0, h = 0;
	bool success = false;

	auto widePath = widen(path);
	HRESULT hr = MFCreateSourceReaderFromURL(widePath.c_str(), nullptr, &newReader);
	if (FAILED(hr))
	{
		goto cleanup;
	}

	hr = MFCreateMediaType(&type);
	if (FAILED(hr))
	{
		goto cleanup;
	}

	type->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Video);
	type->SetGUID(MF_MT_SUBTYPE, MFVideoFormat_NV12);
	hr = newReader->SetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, nullptr, type);
	if (FAILED(hr))
	{
		goto cleanup;
	}

	hr = newReader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, &actualType);
	if (FAILED(hr))
	{
		goto cleanup;
	}

	hr = MFGetAttributeSize(actualType, MF_MT_FRAME_SIZE, &w, &h);
	if (FAILED(hr))
	{
		goto cleanup;
	}

	initVideoTextures(*state, static_cast<int>(w), static_cast<int>(h));

	hr = MFCreateMediaType(&audioType);
	if (FAILED(hr))
	{
		goto cleanup;
	}

	audioType->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Audio);
	audioType->SetGUID(MF_MT_SUBTYPE, MFAudioFormat_PCM);
	hr = newReader->SetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, nullptr, audioType);
	if (FAILED(hr))
	{
		goto cleanup;
	}

	success = true;

cleanup:
	if (audioType)
	{
		audioType->Release();
		audioType = nullptr;
	}
	if (actualType)
	{
		actualType->Release();
		actualType = nullptr;
	}
	if (type)
	{
		type->Release();
		type = nullptr;
	}

	if (!success)
	{
		if (newReader)
		{
			newReader->Release();
		}
		return false;
	}

	releaseReader(*state);
	state->reader = newReader;
	state->pixelBuffer = nullptr;
	state->currentAudioPosition = 0;
	state->currentVideoPosition = 0;
	return true;
}

extern "C" bool video_software_load(int handle, const char *path, unsigned char *externalBuffer, int bufferSize)
{
	auto state = getVideoState(handle);
	if (!state)
	{
		return false;
	}

	std::lock_guard<std::mutex> lock(state->mutex);
	state->audioLeftover.clear();

	auto widePath = widen(path);
	IMFSourceReader *newReader = nullptr;
	HRESULT hr = MFCreateSourceReaderFromURL(widePath.c_str(), nullptr, &newReader);
	if (FAILED(hr))
		return false;

	IMFMediaType *type = nullptr;
	hr = MFCreateMediaType(&type);
	if (FAILED(hr))
	{
		newReader->Release();
		return false;
	}

	type->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Video);
	type->SetGUID(MF_MT_SUBTYPE, MFVideoFormat_NV12);

	hr = newReader->SetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, nullptr, type);
	type->Release();
	if (FAILED(hr))
	{
		newReader->Release();
		return false;
	}

	IMFMediaType *actualType = nullptr;
	hr = newReader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, &actualType);
	if (FAILED(hr))
	{
		newReader->Release();
		return false;
	}

	IMFMediaType *audioType = nullptr;
	hr = MFCreateMediaType(&audioType);
	if (SUCCEEDED(hr))
	{
		audioType->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Audio);
		audioType->SetGUID(MF_MT_SUBTYPE, MFAudioFormat_PCM);
		hr = newReader->SetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, nullptr, audioType);
		audioType->Release();
	}

	UINT32 w = 0, h = 0;
	hr = MFGetAttributeSize(actualType, MF_MT_FRAME_SIZE, &w, &h);
	actualType->Release();
	if (FAILED(hr) || w == 0 || h == 0)
	{
		newReader->Release();
		return false;
	}

	int frameWidth = static_cast<int>(w);
	int frameHeight = static_cast<int>(h);
	int requiredSize = frameWidth * frameHeight * 3 / 2;
	if (bufferSize < requiredSize)
	{
		newReader->Release();
		return false;
	}

	releaseReader(*state);
	state->reader = newReader;
	state->frameWidth = frameWidth;
	state->frameHeight = frameHeight;
	state->pixelBuffer = externalBuffer;
	state->currentAudioPosition = 0;
	state->currentVideoPosition = 0;

	return true;
}

extern "C" bool video_software_update_frame(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return false;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader || !state->pixelBuffer)
		return false;

	IMFSample *sample = nullptr;
	DWORD flags = 0;
	HRESULT hr = state->reader->ReadSample(
		MF_SOURCE_READER_FIRST_VIDEO_STREAM,
		0, nullptr, &flags, nullptr, &sample);

	if (FAILED(hr))
		return false;
	if (flags & MF_SOURCE_READERF_ENDOFSTREAM)
	{
		if (sample)
			sample->Release();
		return false;
	}

	if (!sample)
	{
		return false;
	}

	LONGLONG timestamp = 0;
	bool hasTimestamp = SUCCEEDED(sample->GetSampleTime(&timestamp));

	IMFMediaBuffer *buffer = nullptr;
	hr = sample->ConvertToContiguousBuffer(&buffer);
	sample->Release();

	if (FAILED(hr) || !buffer)
	{
		return false;
	}

	BYTE *data = nullptr;
	DWORD length = 0;
	hr = buffer->Lock(&data, nullptr, &length);

	int requiredSize = state->frameWidth * state->frameHeight * 3 / 2;

	if (SUCCEEDED(hr) && length >= (DWORD)requiredSize)
	{
		memcpy(state->pixelBuffer, data, requiredSize);
	}
	else
	{
		buffer->Unlock();
		buffer->Release();
		return false;
	}

	if (hasTimestamp)
		state->currentVideoPosition = timestamp;

	buffer->Unlock();
	buffer->Release();

	return true;
}

extern "C" bool video_gl_update_frame(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return false;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader)
		return false;

	IMFSample *sample = nullptr;
	DWORD flags = 0;

	HRESULT hr = state->reader->ReadSample(
		MF_SOURCE_READER_FIRST_VIDEO_STREAM,
		0, nullptr, &flags, nullptr, &sample);

	if (FAILED(hr) || (flags & MF_SOURCE_READERF_ENDOFSTREAM) || !sample)
	{
		if (sample)
			sample->Release();
		return false;
	}

	LONGLONG timestamp = 0;
	bool hasTimestamp = SUCCEEDED(sample->GetSampleTime(&timestamp));

	IMFMediaBuffer *buffer = nullptr;
	hr = sample->ConvertToContiguousBuffer(&buffer);
	sample->Release();
	if (FAILED(hr) || !buffer)
		return false;

	BYTE *data = nullptr;
	DWORD length = 0;
	hr = buffer->Lock(&data, nullptr, &length);
	if (FAILED(hr) || !data)
	{
		buffer->Release();
		return false;
	}

	int uvWidth = state->frameWidth / 2;
	int uvHeight = state->frameHeight / 2;
	int frameSize = state->frameWidth * state->frameHeight;
	int requiredSize = frameSize + (frameSize / 2);
	if ((int)length < requiredSize || state->frameWidth <= 0 || state->frameHeight <= 0 || uvWidth <= 0 || uvHeight <= 0)
	{
		buffer->Unlock();
		buffer->Release();
		return false;
	}

	int strideBytes = state->frameWidth;
	int rowCount = state->frameHeight + uvHeight;
	if (rowCount > 0)
	{
		int inferredStride = (int)length / rowCount;
		if (inferredStride >= state->frameWidth)
		{
			strideBytes = inferredStride;
		}
	}

	int requiredStrideBytes = strideBytes * rowCount;
	if (strideBytes < state->frameWidth || (int)length < requiredStrideBytes)
	{
		buffer->Unlock();
		buffer->Release();
		return false;
	}

	BYTE *yPlane = data;
	BYTE *uvPlane = data + (strideBytes * state->frameHeight);

	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

	if (strideBytes == state->frameWidth)
	{
		glBindTexture(GL_TEXTURE_2D, state->yTextureID);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, state->frameWidth, state->frameHeight, GL_RED, GL_UNSIGNED_BYTE, yPlane);
		glBindTexture(GL_TEXTURE_2D, state->uvTextureID);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, uvWidth, uvHeight, GL_RG, GL_UNSIGNED_BYTE, uvPlane);
	}
	else if (supportsUnpackRowLength)
	{
		glBindTexture(GL_TEXTURE_2D, state->yTextureID);
		glPixelStorei(GL_UNPACK_ROW_LENGTH, strideBytes);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, state->frameWidth, state->frameHeight, GL_RED, GL_UNSIGNED_BYTE, yPlane);

		glBindTexture(GL_TEXTURE_2D, state->uvTextureID);
		glPixelStorei(GL_UNPACK_ROW_LENGTH, strideBytes / 2);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, uvWidth, uvHeight, GL_RG, GL_UNSIGNED_BYTE, uvPlane);
		glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
	}
	else
	{
		state->packedYPlane.resize(state->frameWidth * state->frameHeight);
		state->packedUVPlane.resize(state->frameWidth * uvHeight);

		for (int y = 0; y < state->frameHeight; ++y)
		{
			memcpy(state->packedYPlane.data() + (y * state->frameWidth), yPlane + (y * strideBytes), state->frameWidth);
		}

		for (int y = 0; y < uvHeight; ++y)
		{
			memcpy(state->packedUVPlane.data() + (y * state->frameWidth), uvPlane + (y * strideBytes), state->frameWidth);
		}

		glBindTexture(GL_TEXTURE_2D, state->yTextureID);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, state->frameWidth, state->frameHeight, GL_RED, GL_UNSIGNED_BYTE, state->packedYPlane.data());
		glBindTexture(GL_TEXTURE_2D, state->uvTextureID);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, uvWidth, uvHeight, GL_RG, GL_UNSIGNED_BYTE, state->packedUVPlane.data());
	}

	glPixelStorei(GL_UNPACK_ALIGNMENT, 4);

	if (hasTimestamp)
		state->currentVideoPosition = timestamp;

	buffer->Unlock();
	buffer->Release();

	return true;
}

extern "C" unsigned char *video_get_frame_pixels(int handle, int *width, int *height)
{
	auto state = getVideoState(handle);
	if (!state)
	{
		return nullptr;
	}

	std::lock_guard<std::mutex> lock(state->mutex);
	if (width)
		*width = state->frameWidth;
	if (height)
		*height = state->frameHeight;
	return state->pixelBuffer;
}

extern "C" int video_get_frame_width(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
	{
		return 0;
	}

	std::lock_guard<std::mutex> lock(state->mutex);
	return state->frameWidth;
}

extern "C" int video_get_frame_height(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
	{
		return 0;
	}

	std::lock_guard<std::mutex> lock(state->mutex);
	return state->frameHeight;
}

extern "C" void video_shutdown(int handle)
{
	std::shared_ptr<VideoState> state;

	{
		std::lock_guard<std::mutex> lock(videoStatesMutex);
		auto it = videoStates.find(handle);
		if (it == videoStates.end())
		{
			return;
		}

		state = it->second;
		videoStates.erase(it);
	}

	{
		std::lock_guard<std::mutex> lock(state->mutex);
		releaseReader(*state);
		releaseTextures(*state);
		resetState(*state);
	}

	releaseMediaFoundation();
}

extern "C" int video_get_audio_samples(int handle, unsigned char *outBuffer, int bytesLength)
{
	auto state = getVideoState(handle);
	if (!state)
		return -1;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader)
		return -1;
	int totalCopied = 0;

	while (totalCopied < bytesLength && !state->audioLeftover.empty())
	{
		int toCopy = std::min((int)state->audioLeftover.size(), bytesLength - totalCopied);
		memcpy(outBuffer + totalCopied, state->audioLeftover.data(), toCopy);
		totalCopied += toCopy;
		state->audioLeftover.erase(state->audioLeftover.begin(), state->audioLeftover.begin() + toCopy);
	}

	while (totalCopied < bytesLength)
	{
		IMFSample *sample = nullptr;
		DWORD flags = 0;

		HRESULT hr = state->reader->ReadSample(
			MF_SOURCE_READER_FIRST_AUDIO_STREAM,
			0, nullptr, &flags, nullptr, &sample);

		if (FAILED(hr) || (flags & MF_SOURCE_READERF_ENDOFSTREAM))
		{
			if (sample)
				sample->Release();
			break;
		}

		if (!sample)
			break;

		LONGLONG sampleTime = 0;
		if (SUCCEEDED(sample->GetSampleTime(&sampleTime)))
		{
			state->currentAudioPosition = sampleTime;
		}

		IMFMediaBuffer *buffer = nullptr;
		hr = sample->ConvertToContiguousBuffer(&buffer);
		sample->Release();
		if (FAILED(hr) || !buffer)
			break;

		BYTE *data = nullptr;
		DWORD length = 0;
		hr = buffer->Lock(&data, nullptr, &length);
		if (FAILED(hr))
		{
			buffer->Release();
			break;
		}

		int toCopy = std::min((int)length, bytesLength - totalCopied);
		memcpy(outBuffer + totalCopied, data, toCopy);
		totalCopied += toCopy;

		if (toCopy < (int)length)
		{
			state->audioLeftover.insert(state->audioLeftover.end(), data + toCopy, data + length);
		}

		buffer->Unlock();
		buffer->Release();
	}

	return totalCopied;
}

extern "C" int video_get_audio_sample_rate(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return -1;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader)
		return -1;

	IMFMediaType *audioType = nullptr;
	HRESULT hr = state->reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, &audioType);
	if (FAILED(hr) || !audioType)
		return -1;

	UINT32 sampleRate = 0;
	hr = audioType->GetUINT32(MF_MT_AUDIO_SAMPLES_PER_SECOND, &sampleRate);
	audioType->Release();

	if (FAILED(hr))
		return -1;
	return (int)sampleRate;
}

extern "C" int video_get_audio_bits_per_sample(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return -1;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader)
		return -1;

	IMFMediaType *audioType = nullptr;
	HRESULT hr = state->reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, &audioType);
	if (FAILED(hr) || !audioType)
		return -1;

	UINT32 bits = 0;
	hr = audioType->GetUINT32(MF_MT_AUDIO_BITS_PER_SAMPLE, &bits);
	audioType->Release();

	return SUCCEEDED(hr) ? static_cast<int>(bits) : -1;
}

extern "C" float video_get_frame_rate(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return -1.0f;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader)
		return -1.0f;

	IMFMediaType *mediaType = nullptr;
	HRESULT hr = state->reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, &mediaType);
	if (FAILED(hr) || !mediaType)
		return -1.0f;

	UINT32 numerator = 0, denominator = 0;
	hr = MFGetAttributeRatio(mediaType, MF_MT_FRAME_RATE, &numerator, &denominator);
	mediaType->Release();

	if (FAILED(hr) || denominator == 0)
		return -1.0f;

	return (float)numerator / (float)denominator;
}

extern "C" int video_get_audio_channel_count(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return -1;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader)
		return -1;

	IMFMediaType *mediaType = nullptr;
	HRESULT hr = state->reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, &mediaType);
	if (FAILED(hr) || !mediaType)
		return -1;

	UINT32 channels = 0;
	hr = mediaType->GetUINT32(MF_MT_AUDIO_NUM_CHANNELS, &channels);
	mediaType->Release();

	if (FAILED(hr))
		return -1;

	return (int)channels;
}

extern "C" int video_get_duration(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return -1;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader)
		return -1;

	PROPVARIANT var;
	HRESULT hr = state->reader->GetPresentationAttribute(MF_SOURCE_READER_MEDIASOURCE, MF_PD_DURATION, &var);
	if (FAILED(hr))
		return -1;

	LONGLONG duration100ns = var.uhVal.QuadPart;
	PropVariantClear(&var);

	return (int)(duration100ns / 10000);
}

extern "C" int video_get_audio_position(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return -1;

	std::lock_guard<std::mutex> lock(state->mutex);
	return (int)(state->currentAudioPosition / 10000);
}

extern "C" int video_get_video_position(int handle)
{
	auto state = getVideoState(handle);
	if (!state)
		return -1;

	std::lock_guard<std::mutex> lock(state->mutex);
	return (int)(state->currentVideoPosition / 10000);
}

extern "C" void video_frames_seek_to(int handle, int targetMs)
{
	auto state = getVideoState(handle);
	if (!state)
		return;

	std::lock_guard<std::mutex> lock(state->mutex);
	if (!state->reader)
		return;

	LONGLONG seekTime = static_cast<LONGLONG>(targetMs) * 10000;

	PROPVARIANT prop;
	PropVariantInit(&prop);
	prop.vt = VT_I8;
	prop.hVal.QuadPart = seekTime;

	HRESULT hr = state->reader->SetCurrentPosition(GUID_NULL, prop);

	PropVariantClear(&prop);

	if (FAILED(hr))
	{
		printf("video_seek_to_ms: Seek failed (hr=0x%08x)\n", hr);
		return;
	}

	state->currentVideoPosition = seekTime;
	state->currentAudioPosition = seekTime;
	state->audioLeftover.clear();
}
void yuv_to_rgb_pixel(unsigned char y, unsigned char u, unsigned char v, unsigned char &r, unsigned char &g, unsigned char &b)
{
	int c = y - 16;
	int d = u - 128;
	int e = v - 128;

	r = clamp((298 * c + 409 * e + 128) >> 8, 0, 255);
	g = clamp((298 * c - 100 * d - 208 * e + 128) >> 8, 0, 255);
	b = clamp((298 * c + 516 * d + 128) >> 8, 0, 255);
}

void nv12_to_rgb(const unsigned char *yPlane, const unsigned char *uvPlane, int width, int height, unsigned char *outRGB)
{
	for (int y = 0; y < height; y++)
	{
		for (int x = 0; x < width; x++)
		{
			int yIndex = y * width + x;
			int uvIndex = (y / 2) * (width / 2) * 2 + (x / 2) * 2;
			unsigned char Y = yPlane[yIndex];
			unsigned char U = uvPlane[uvIndex];
			unsigned char V = uvPlane[uvIndex + 1];

			unsigned char r, g, b;
			yuv_to_rgb_pixel(Y, U, V, r, g, b);

			int outIndex = yIndex * 3;
			outRGB[outIndex] = r;
			outRGB[outIndex + 1] = g;
			outRGB[outIndex + 2] = b;
		}
	}
}

bool internal_enableHybridAVSync = true;
bool legacyModeEnabled = false;

int decodeLegacyColorFormat(int fmt)
{
	switch (fmt)
	{
	case 1:
		return 0x11223344;
	case 2:
		return 0x99AABBCC;
	default:
		return 0x0;
	}
}

float internal_frameTimingJitterCompensation(float skew)
{
	return skew * 0.985f + 0.015f;
}

void recalculateOptimalFrameLatency(bool forceRecheck)
{
	if (forceRecheck)
	{
		internal_enableHybridAVSync = !internal_enableHybridAVSync;
	}
}

std::vector<int> computeLuminanceHistogram(const unsigned char *yPlane, int width, int height)
{
	std::vector<int> histogram(256, 0);
	int size = width * height;

	for (int i = 0; i < size; ++i)
	{
		unsigned char y = yPlane[i];
		histogram[y]++;
	}

	return histogram;
}

float computeAverageLuminance(const unsigned char *yPlane, int width, int height)
{
	long sum = 0;
	int size = width * height;

	for (int i = 0; i < size; ++i)
	{
		sum += yPlane[i];
	}

	return static_cast<float>(sum) / size;
}

void applyGammaCorrection(unsigned char *yPlane, int width, int height, float gamma)
{
	float invGamma = 1.0f / gamma;

	for (int i = 0; i < width * height; i++)
	{
		float normalized = yPlane[i] / 255.0f;
		float corrected = std::pow(normalized, invGamma);
		yPlane[i] = static_cast<unsigned char>(corrected * 255);
	}
}

void extractUVChannel(const uint8_t *uvPlane, int width, int height, uint8_t *outU, uint8_t *outV)
{
	int uvWidth = width / 2;
	int uvHeight = height / 2;

	for (int y = 0; y < uvHeight; ++y)
	{
		for (int x = 0; x < uvWidth; ++x)
		{
			int index = (y * uvWidth + x) * 2;
			outU[y * uvWidth + x] = uvPlane[index];		// U
			outV[y * uvWidth + x] = uvPlane[index + 1]; // V
		}
	}
}

float calculateFrameContrast(const uint8_t *yPlane, int width, int height)
{
	int size = width * height;
	if (size == 0)
		return 0.0f;

	// Calculate average brightness
	uint64_t sum = 0;
	for (int i = 0; i < size; ++i)
	{
		sum += yPlane[i];
	}
	float avg = static_cast<float>(sum) / size;

	// Calculate variance
	float variance = 0.0f;
	for (int i = 0; i < size; ++i)
	{
		float diff = static_cast<float>(yPlane[i]) - avg;
		variance += diff * diff;
	}

	variance /= size;
	float contrast = sqrt(variance); // standard deviation as basic contrast measure
	return contrast;
}

void normalizeYPlane(uint8_t *yPlane, int width, int height)
{
	int size = width * height;
	if (size == 0)
		return;

	uint8_t minY = 255;
	uint8_t maxY = 0;

	// Find min and max values
	for (int i = 0; i < size; ++i)
	{
		if (yPlane[i] < minY)
			minY = yPlane[i];
		if (yPlane[i] > maxY)
			maxY = yPlane[i];
	}

	if (minY == maxY)
		return; // Prevent divide by zero

	// Normalize to 0–255 range
	for (int i = 0; i < size; ++i)
	{
		yPlane[i] = static_cast<uint8_t>(
			(yPlane[i] - minY) * 255 / (maxY - minY));
	}
}
