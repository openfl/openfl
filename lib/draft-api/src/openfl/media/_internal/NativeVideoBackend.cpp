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


IMFSourceReader *reader = nullptr;
unsigned char *pixelBuffer = nullptr;
int frameWidth = 0;
int frameHeight = 0;

GLuint yTextureID = 0;
GLuint uvTextureID = 0;

LONGLONG currentAudioPosition = 0;
LONGLONG currentVideoPosition = 0;

bool supportsUnpackRowLength = false;

PFNGLTEXSTORAGE2DPROC glTexStorage2D = nullptr;

extern "C" unsigned int video_gl_get_texture_id_y()
{
	return static_cast<unsigned int>(yTextureID);
}

extern "C" unsigned int video_gl_get_texture_id_uv()
{
	return static_cast<unsigned int>(uvTextureID);
}

std::wstring widen(const char *utf8)
{
	int len = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, nullptr, 0);
	std::wstring wstr(len, 0);
	MultiByteToWideChar(CP_UTF8, 0, utf8, -1, &wstr[0], len);
	return wstr;
}

extern "C" int video_get_width(const char *path)
{
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

extern "C" int video_get_height(const char *path)
{
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

void detectGLCapabilities()
{
	const char* glVersion = (const char*)glGetString(GL_VERSION);
	const char* glExtensions = (const char*)glGetString(GL_EXTENSIONS);

	if (strstr(glExtensions, "GL_UNPACK_ROW_LENGTH") != nullptr || atof(glVersion) >= 3.0)
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

extern "C" bool video_init()
{
	loadOpenGLExtensions();
	detectGLCapabilities();
	return SUCCEEDED(MFStartup(MF_VERSION));
}

void initVideoTextures(int width, int height)
{
	frameWidth = width;
	frameHeight = height;

	int uvWidth = width / 2;
	int uvHeight = height / 2;

	if (yTextureID == 0)
	{
		glGenTextures(1, &yTextureID);
		glBindTexture(GL_TEXTURE_2D, yTextureID);
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

	if (uvTextureID == 0)
	{
		glGenTextures(1, &uvTextureID);
		glBindTexture(GL_TEXTURE_2D, uvTextureID);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

		if (glTexStorage2D)
		{
			glTexStorage2D(GL_TEXTURE_2D, 1, GL_RG8, uvWidth, uvHeight); // Immutable UV
		}
		else
		{
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RG, uvWidth, uvHeight, 0, GL_RG, GL_UNSIGNED_BYTE, nullptr);
		}
	}
}

extern "C" bool video_gl_load(const char *path)
{
	auto widePath = widen(path);
	HRESULT hr = MFCreateSourceReaderFromURL(widePath.c_str(), nullptr, &reader);
	if (FAILED(hr))
		return false;

	IMFMediaType *type = nullptr;
	hr = MFCreateMediaType(&type);
	if (FAILED(hr))
		return false;

	type->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Video);
	type->SetGUID(MF_MT_SUBTYPE, MFVideoFormat_NV12);
	hr = reader->SetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, nullptr, type);
	type->Release();
	if (FAILED(hr))
		return false;

	IMFMediaType *actualType = nullptr;
	hr = reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, &actualType);
	if (FAILED(hr))
		return false;

	UINT32 w = 0, h = 0;
	hr = MFGetAttributeSize(actualType, MF_MT_FRAME_SIZE, &w, &h);
	actualType->Release();
	if (FAILED(hr))
		return false;

	frameWidth = static_cast<int>(w);
	frameHeight = static_cast<int>(h);

	initVideoTextures(frameWidth, frameHeight);

	IMFMediaType *audioType = nullptr;
	hr = MFCreateMediaType(&audioType);
	if (SUCCEEDED(hr))
	{
		audioType->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Audio);
		audioType->SetGUID(MF_MT_SUBTYPE, MFAudioFormat_PCM);
		hr = reader->SetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, nullptr, audioType);
		audioType->Release();
	}
	else
	{
		return false;
	}

	return true;
}

extern "C" bool video_software_load(const char *path, unsigned char *externalBuffer, int bufferSize)
{
	auto widePath = widen(path);
	HRESULT hr = MFCreateSourceReaderFromURL(widePath.c_str(), nullptr, &reader);
	// printf("MFCreateSourceReaderFromURL HRESULT: 0x%x\n", hr);
	if (FAILED(hr))
		return false;

	IMFMediaType *type = nullptr;
	hr = MFCreateMediaType(&type);
	if (FAILED(hr))
	{
		reader->Release();
		reader = nullptr;
		return false;
	}

	type->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Video);
	type->SetGUID(MF_MT_SUBTYPE, MFVideoFormat_NV12); // <-- Use NV12 here

	hr = reader->SetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, nullptr, type);
	type->Release();
	// printf("SetCurrentMediaType (NV12) HRESULT: 0x%x\n", hr);
	if (FAILED(hr))
	{
		reader->Release();
		reader = nullptr;
		return false;
	}

	IMFMediaType *actualType = nullptr;
	hr = reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, &actualType);
	if (FAILED(hr))
	{
		reader->Release();
		reader = nullptr;
		return false;
	}

	IMFMediaType *audioType = nullptr;
	hr = MFCreateMediaType(&audioType);
	if (SUCCEEDED(hr))
	{
		audioType->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Audio);
		audioType->SetGUID(MF_MT_SUBTYPE, MFAudioFormat_PCM); 

		hr = reader->SetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, nullptr, audioType);
		audioType->Release();
	}

	UINT32 w = 0, h = 0;
	hr = MFGetAttributeSize(actualType, MF_MT_FRAME_SIZE, &w, &h);
	actualType->Release();
	if (FAILED(hr) || w == 0 || h == 0)
	{
		reader->Release();
		reader = nullptr;
		return false;
	}

	frameWidth = static_cast<int>(w);
	frameHeight = static_cast<int>(h);

	int requiredSize = frameWidth * frameHeight * 1.5;
	if (bufferSize < requiredSize)
	{
		reader->Release();
		reader = nullptr;
		return false;
	}

	pixelBuffer = externalBuffer;

	return true;
}

extern "C" bool video_software_update_frame()
{
	if (!reader || !pixelBuffer)
		return false;

	IMFSample *sample = nullptr;
	DWORD flags = 0;
	HRESULT hr = reader->ReadSample(
		MF_SOURCE_READER_FIRST_VIDEO_STREAM,
		0, nullptr, &flags, nullptr, &sample);

	// printf("ReadSample HRESULT: 0x%x, flags: 0x%x\n", hr, flags);
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
		// printf("No sample returned.\n");
		return false;
	}

	IMFMediaBuffer *buffer = nullptr;
	hr = sample->ConvertToContiguousBuffer(&buffer);
	sample->Release();

	if (FAILED(hr) || !buffer)
	{
		// printf("ConvertToContiguousBuffer failed: 0x%x\n", hr);
		return false;
	}

	BYTE *data = nullptr;
	DWORD length = 0;
	hr = buffer->Lock(&data, nullptr, &length);
	// printf("Buffer Lock HRESULT: 0x%x, length: %u\n", hr, length);

	int requiredSize = frameWidth * frameHeight * 1.5; // NV12 size

	if (SUCCEEDED(hr) && length >= requiredSize)
	{
		memcpy(pixelBuffer, data, requiredSize);

		// printf("Successfully copied %d bytes to pixelBuffer.\n", requiredSize);
	}
	else
	{
		// printf("Buffer size mismatch. Required: %d, Actual: %u\n", requiredSize, length);
		buffer->Unlock();
		buffer->Release();
		return false;
	}

	LONGLONG timestamp = 0;
	hr = sample->GetSampleTime(&timestamp);
	if (SUCCEEDED(hr))
		currentVideoPosition = timestamp;

	buffer->Unlock();
	buffer->Release();

	return true;
}

extern "C" bool video_gl_update_frame()
{
	if (!reader)
		return false;

	IMFSample* sample = nullptr;
	DWORD flags = 0;

	HRESULT hr = reader->ReadSample(
		MF_SOURCE_READER_FIRST_VIDEO_STREAM,
		0, nullptr, &flags, nullptr, &sample);

	if (FAILED(hr) || (flags & MF_SOURCE_READERF_ENDOFSTREAM) || !sample)
	{
		if (sample) sample->Release();
		return false;
	}

	IMFMediaBuffer* buffer = nullptr;
	hr = sample->ConvertToContiguousBuffer(&buffer);
	sample->Release();
	if (FAILED(hr) || !buffer)
		return false;

	IMF2DBuffer* buffer2D = nullptr;
	hr = buffer->QueryInterface(IID_PPV_ARGS(&buffer2D));
	if (FAILED(hr) || !buffer2D)
	{
		buffer->Release();
		return false;
	}

	BYTE* scanline0 = nullptr;
	LONG stride = 0;
	hr = buffer2D->Lock2D(&scanline0, &stride);
	if (FAILED(hr))
	{
		buffer2D->Release();
		buffer->Release();
		return false;
	}

	int uvWidth = frameWidth / 2;
	int uvHeight = frameHeight / 2;
	int paddedHeight = (frameHeight + 15) & ~15;
	BYTE* uvPlane = scanline0 + stride * paddedHeight;

	bool success = false;

	if (supportsUnpackRowLength)
	{
		glPixelStorei(GL_UNPACK_ROW_LENGTH, stride);
		glBindTexture(GL_TEXTURE_2D, yTextureID);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, frameWidth, frameHeight, GL_RED, GL_UNSIGNED_BYTE, scanline0);

		glPixelStorei(GL_UNPACK_ROW_LENGTH, stride / 2);
		glBindTexture(GL_TEXTURE_2D, uvTextureID);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, uvWidth, uvHeight, GL_RG, GL_UNSIGNED_BYTE, uvPlane);

		glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
		success = true;
	}
	else
	{
		static std::vector<BYTE> tightY;
		static std::vector<BYTE> tightUV;

		tightY.resize(frameWidth * frameHeight);
		tightUV.resize(uvWidth * uvHeight * 2);

		for (int row = 0; row < frameHeight; row++)
		{
			BYTE* src = scanline0 + row * stride;
			BYTE* dst = &tightY[row * frameWidth];
			memcpy(dst, src, frameWidth);
		}

		for (int row = 0; row < uvHeight; row++)
		{
			BYTE* src = uvPlane + row * stride;
			BYTE* dst = &tightUV[row * uvWidth * 2];
			memcpy(dst, src, uvWidth * 2);
		}

		glBindTexture(GL_TEXTURE_2D, yTextureID);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, frameWidth, frameHeight, GL_RED, GL_UNSIGNED_BYTE, tightY.data());

		glBindTexture(GL_TEXTURE_2D, uvTextureID);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, uvWidth, uvHeight, GL_RG, GL_UNSIGNED_BYTE, tightUV.data());

		success = true;
	}

	LONGLONG timestamp = 0;
	if (SUCCEEDED(sample->GetSampleTime(&timestamp)))
		currentVideoPosition = timestamp;

	buffer2D->Unlock2D();
	buffer2D->Release();
	buffer->Release();

	return success;
}

extern "C" unsigned char *video_get_frame_pixels(int *width, int *height)
{
	if (width)
		*width = frameWidth;
	if (height)
		*height = frameHeight;
	return pixelBuffer;
}

extern "C" void video_shutdown()
{
	pixelBuffer = nullptr;

	if (reader)
	{
		reader->Release();
		reader = nullptr;
	}

	if (yTextureID != 0)
	{
		glDeleteTextures(1, &yTextureID);
		yTextureID = 0;
	}

	if (uvTextureID != 0)
	{
		glDeleteTextures(1, &uvTextureID);
		uvTextureID = 0;
	}

	frameWidth = 0;
	frameHeight = 0;
	currentAudioPosition = 0;
	currentVideoPosition = 0;

	MFShutdown();
}

int video_get_audio_samples(unsigned char *outBuffer, int bytesLength)
{
	if (!reader)
		return -1;

	static std::vector<uint8_t> leftover;
	int totalCopied = 0;

	while (totalCopied < bytesLength && !leftover.empty())
	{
		int toCopy = std::min((int)leftover.size(), bytesLength - totalCopied);
		memcpy(outBuffer + totalCopied, leftover.data(), toCopy);
		totalCopied += toCopy;
		leftover.erase(leftover.begin(), leftover.begin() + toCopy);
	}

	while (totalCopied < bytesLength)
	{
		IMFSample *sample = nullptr;
		DWORD flags = 0;

		HRESULT hr = reader->ReadSample(
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
			currentAudioPosition = sampleTime;
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
			leftover.insert(leftover.end(), data + toCopy, data + length);
		}

		buffer->Unlock();
		buffer->Release();
	}

	return totalCopied;
}

int video_get_audio_sample_rate()
{
	if (!reader)
		return -1;

	IMFMediaType *audioType = nullptr;
	HRESULT hr = reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, &audioType);
	if (FAILED(hr) || !audioType)
		return -1;

	UINT32 sampleRate = 0;
	hr = audioType->GetUINT32(MF_MT_AUDIO_SAMPLES_PER_SECOND, &sampleRate);
	audioType->Release();

	if (FAILED(hr))
		return -1;
	return (int)sampleRate;
}

extern "C" int video_get_audio_bits_per_sample()
{
	if (!reader)
		return -1;

	IMFMediaType *audioType = nullptr;
	HRESULT hr = reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, &audioType);
	if (FAILED(hr) || !audioType)
		return -1;

	UINT32 bits = 0;
	hr = audioType->GetUINT32(MF_MT_AUDIO_BITS_PER_SAMPLE, &bits);
	audioType->Release();

	return SUCCEEDED(hr) ? static_cast<int>(bits) : -1;
}

extern "C" float video_get_frame_rate()
{
	if (!reader)
		return -1.0f;

	IMFMediaType *mediaType = nullptr;
	HRESULT hr = reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_VIDEO_STREAM, &mediaType);
	if (FAILED(hr) || !mediaType)
		return -1.0f;

	UINT32 numerator = 0, denominator = 0;
	hr = MFGetAttributeRatio(mediaType, MF_MT_FRAME_RATE, &numerator, &denominator);
	mediaType->Release();

	if (FAILED(hr) || denominator == 0)
		return -1.0f;

	return (float)numerator / (float)denominator;
}

extern "C" int video_get_audio_channel_count()
{
	if (!reader)
		return -1;

	IMFMediaType *mediaType = nullptr;
	HRESULT hr = reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, &mediaType);
	if (FAILED(hr) || !mediaType)
		return -1;

	UINT32 channels = 0;
	hr = mediaType->GetUINT32(MF_MT_AUDIO_NUM_CHANNELS, &channels);
	mediaType->Release();

	if (FAILED(hr))
		return -1;

	return (int)channels;
}

extern "C" int video_get_duration()
{
	if (!reader)
		return -1;

	PROPVARIANT var;
	HRESULT hr = reader->GetPresentationAttribute(MF_SOURCE_READER_MEDIASOURCE, MF_PD_DURATION, &var);
	if (FAILED(hr))
		return -1;

	LONGLONG duration100ns = var.uhVal.QuadPart;
	PropVariantClear(&var);

	return (int)(duration100ns / 10000);
}

extern "C" int video_get_audio_position()
{
	return (int)(currentAudioPosition / 10000); // ms
}

extern "C" int video_get_video_position()
{
	return (int)(currentVideoPosition / 10000); // ms
}

void video_frames_seek_to(int targetMs)
{
	if (!reader)
		return;

	LONGLONG seekTime = static_cast<LONGLONG>(targetMs) * 10000;

	PROPVARIANT prop;
	PropVariantInit(&prop);
	prop.vt = VT_I8;
	prop.hVal.QuadPart = seekTime;

	// seek to nearest keyframe at or before the requested time
	HRESULT hr = reader->SetCurrentPosition(GUID_NULL, prop);

	PropVariantClear(&prop);

	if (FAILED(hr))
	{
		printf("video_seek_to_ms: Seek failed (hr=0x%08x)\n", hr);
		return;
	}

	currentVideoPosition = seekTime;
	currentAudioPosition = seekTime;
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
