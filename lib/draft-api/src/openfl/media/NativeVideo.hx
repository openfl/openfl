package openfl.media;

import openfl.display.Bitmap;
#if (cpp && windows)
import lime.media.openal.AL;
import lime.media.openal.ALSource;
import lime.media.openal.ALBuffer;
import haxe.atomic.AtomicBool;
import haxe.ds.Vector;
import lime.system.BackgroundWorker;
import openfl.media._internal.GLUtil;
import cpp.Pointer;
import haxe.io.Bytes;
import haxe.io.BytesData;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.utils.UInt8Array;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.Program3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display3D.textures.RectangleTexture;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.media._internal.NativeVideoBackend;
import sys.thread.Deque;
import sys.thread.Mutex;
#end

/**
 * NativeVideo is a hardware-accelerated or software-rendered video playback component for OpenFL.
 *
 * It supports decoding and rendering NV12 video frames using a native backend (Media Foundation on Windows).
 * This class allows rendering video as a `Bitmap`, supporting both GPU and software paths depending on context.
 *
 * **Note:** This is a **BETA API** and subject to change.
 *
 * @author Christopher Speciale
 */
@:beta
#if (cpp && windows)
@:access(openfl.media._internal.NativeVideoBackend)
final class NativeVideo extends Bitmap
{
	/**
	 * Indicates whether the native video/audio playback system is supported on the current platform.
	 * Currently only `true` on Windows targets using C++.
	 */
	public static inline var isSupported:Bool = #if (cpp && windows) true #else false #end;

	/**
	 * The number of audio buffers used for streaming decoded audio into OpenAL.
	 * You may increase this value for smoother audio playback, especially on slower systems.
	 * Default is `3`.
	 */
	public static var AUDIO_BUFFER_COUNT:Int = 3;

	/**
	 * The number of video frame buffers used for preloading decoded video frames.
	 * You may increase this for smoother frame transitions or performance tuning.
	 * Default is `3`.
	 */
	public static var FRAME_BUFFER_COUNT:Int = 3;

	/**
	 * The size of each audio buffer in bytes.
	 * This value affects how frequently new audio samples are streamed.
	 * Default is `4096` bytes.
	 */
	public static var AUDIO_BUFFER_SIZE:Int = 4096;

	/**
	 * If audio leads video by at least this many milliseconds, force a seek-based resync.
	 */
	public static var AV_HARD_RESYNC_MS:Int = 1000;

	/**
	 * Minimum interval between hard resync seeks.
	 */
	public static var AV_RESYNC_COOLDOWN_MS:Int = 500;

	/**
	 * Maximum number of decode-only catch-up frames processed per update.
	 */
	public static var AV_CATCHUP_MAX_FRAMES:Int = 8;

	/**
	 * Indicates whether playback is currently active.
	 * Returns `true` if the media is playing, `false` if paused or stopped.
	 */
	public var isPlaying(get, never):Bool;

	/**
	 * The current playback position in seconds.
	 * Getting this returns the synced audio or video playback time.
	 * Setting this value seeks both audio and video streams to the given time in seconds.
	 *
	 * Setting `currentTime` will interrupt current playback and resume from the new time.
	 */
	public var currentTime(get, set):Float;

	public var duration(get, never):Float;

	/**
	 * The `SoundTransform` object applied to the audio stream of the video.
	 *
	 * This controls properties such as volume and panning for the current playback session.
	 * Setting this allows you to adjust audio playback behavior dynamically (e.g., muting,
	 * changing volume, or applying stereo panning).
	 *
	 * The transformation is applied globally to all audio data being played by this media instance.
	 *
	 * @see openfl.media.SoundTransform
	 */
	public var soundTransform(get, set):SoundTransform;

	@:noCompletion private inline function get_isPlaying():Bool
	{
		return __isPlaying.load();
	}

	@:noCompletion private inline function get_currentTime():Float
	{
		return __currentTime;
	}

	@:noCompletion private inline function set_currentTime(value:Float):Float
	{
		if (value < 0)
		{
			value = 0;
		}
		else if (value > duration)
		{
			value = duration;
		}

		__skipTo(Std.int(value * 1000));
		__processFrames();
		return value;
	}

	@:noCompletion private inline function get_duration():Float
	{
		return __videoDuration * 0.001;
	}

	@:noCompletion public inline function __getVideoWidth():Int
	{
		return __videoWidth;
	}

	@:noCompletion public inline function __getVideoHeight():Int
	{
		return __videoHeight;
	}

	@:noCompletion private inline function set_soundTransform(value:SoundTransform):SoundTransform
	{
		if (__alSource != null)
		{
			inline AL.sourcef(__alSource, AL.GAIN, value.volume);

			var pan = value.pan;
			inline AL.source3f(__alSource, AL.POSITION, pan, 0, 0);
		}

		return __soundTransform = value;
	}

	@:noCompletion private inline function get_soundTransform():SoundTransform
	{
		return __soundTransform;
	}

	@:noCompletion private var __isHardware:Bool;
	@:noCompletion private var __textureWidth:Int;
	@:noCompletion private var __textureHeight:Int;
	@:noCompletion private var __videoWidth:Int;
	@:noCompletion private var __videoHeight:Int;
	@:noCompletion private var __textureY:RectangleTexture;
	@:noCompletion private var __textureUV:RectangleTexture;
	@:noCompletion private var __videoTexture:RectangleTexture;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __videoBuffer:Bytes;
	@:noCompletion private var __bitmapBuffer:Bytes;
	@:noCompletion private var __frameRect:Rectangle;
	@:noCompletion private var __positions:VertexBuffer3D;
	@:noCompletion private var __uvs:VertexBuffer3D;
	@:noCompletion private var __indices:IndexBuffer3D;
	@:noCompletion private var __program:Program3D;
	@:noCompletion private var __positionAttributeIndex:Int = 0;
	@:noCompletion private var __texCoordAttributeIndex:Int = 1;
	@:noCompletion private var __processFrames:Void->Void;
	@:noCompletion private var __audioSampleRate:Int;
	@:noCompletion private var __audioBitsPerSample:Int;
	@:noCompletion private var __audioChannels:Int;
	@:noCompletion private var __audioBuffers:Vector<Bytes>;
	@:noCompletion private var __alAudioBuffers:Array<ALBuffer>;
	@:noCompletion private var __alSource:ALSource;
	@:noCompletion private var __audioThreadActive:AtomicBool;
	@:noCompletion private var __audioBufferReadIndex:Int;
	@:noCompletion private var __secondsPerBuffer:Float;
	@:noCompletion private var __audioCallbackQueue:Deque<Void->Void>;
	#if (cpp || (hl && hl_ver >= "1.13"))
	@:noCompletion private var __audioBufferReady:Vector<AtomicBool>;
	@:noCompletion private var __isPlaying:AtomicBool;
	#end
	@:noCompletion private var __audioBufferReadyMutex:Mutex = new Mutex();
	@:noCompletion private var __sampleBuffer:Bytes;
	@:noCompletion private var __frameRate:Float;
	@:noCompletion private var __frameDuration:Float;
	@:noCompletion private var __frameDurationMS:Int;
	@:noCompletion private var __videoDuration:Int;
	@:noCompletion private var __videoThread:BackgroundWorker;
	@:noCompletion private var __audioThread:BackgroundWorker;
	@:noCompletion private var __timerThread:BackgroundWorker;
	@:noCompletion private var __frameBuffers:Vector<BitmapData>;
	@:noCompletion private var __audioWritten:Int;
	@:noCompletion private var __decoderThread:BackgroundWorker = new BackgroundWorker();
	@:noCompletion private var __currentTime:Float = 0.0;
	@:noCompletion private var __lastResyncAtMS:Int = -1000000;
	@:noCompletion private var __soundTransform:SoundTransform;
	@:noCompletion private var __backendHandle:Int = 0;

	/**
	 * Creates a new NativeVideo instance.
	 *
	 * @param width The texture width to use for rendering.
	 * @param height The texture height to use for rendering.
	 * @param smoothing Whether to apply smoothing to the output bitmap.
	 * @throws An error if the video backend cannot be initialized.
	 */
	public function new(width:Int, height:Int, smoothing:Bool = false)
	{
		__backendHandle = __videoCreate();
		if (__backendHandle <= 0)
		{
			throw "Could not initialize Native Video Backend";
		}
		__isPlaying = new AtomicBool(false);
		__audioThreadActive = new AtomicBool(false);

		__isHardware = Lib.current.stage.window.context.type != "cairo";
		__processFrames = __isHardware ? __processGLFrames : __processSoftwareFrames;

		super(null, null, smoothing);

		__textureWidth = width;
		__textureHeight = height;
		__soundTransform = new SoundTransform();
	}

	/**
	 * Loads a video from the specified path.
	 *
	 * @param path The file path to the video.
	 * @throws An error if the video cannot be loaded or is unsupported.
	 */
	public function load(path:String):Void
	{
		__ensureBackendHandle();
		__videoWidth = __videoGetWidth(__backendHandle, path);
		__videoHeight = __videoGetHeight(__backendHandle, path);

		if (__videoWidth == -1 || __videoHeight == -1)
		{
			throw "Video not supported.";
		}

		// Allow auto-size behavior when constructor receives non-positive values.
		if (__textureWidth <= 0)
		{
			__textureWidth = __videoWidth;
		}
		if (__textureHeight <= 0)
		{
			__textureHeight = __videoHeight;
		}

		if (__isHardware)
		{
			if (!__videoGLLoad(__backendHandle, path))
			{
				throw "Video not supported.";
			}

			var decodedWidth = __videoGetFrameWidth(__backendHandle);
			var decodedHeight = __videoGetFrameHeight(__backendHandle);
			if (decodedWidth > 0 && decodedHeight > 0)
			{
				__videoWidth = decodedWidth;
				__videoHeight = decodedHeight;
			}

			__context = Lib.current.stage.context3D;
			__videoTexture = __context.createRectangleTexture(__textureWidth, __textureHeight, BGRA, true);
			__textureY = __context.createRectangleTexture(__videoWidth, __videoHeight, null, false);
			__textureUV = __context.createRectangleTexture(Std.int(__videoWidth * 0.5), Std.int(__videoHeight * 0.5), null, false);

			@:privateAccess
			__textureY.__textureID = __getTextureIDY(__backendHandle);
			@:privateAccess
			__textureUV.__textureID = __getTextureIDUV(__backendHandle);

			@:privateAccess
			__textureY.__internalFormat = __textureY.__format = GLUtil.RED(__context);
			@:privateAccess
			__textureUV.__internalFormat = __textureUV.__format = GLUtil.RG(__context);

			__setupData();
			__createProgram();
			this.bitmapData = BitmapData.fromTexture(__videoTexture);
			this.width = __textureWidth;
			this.height = __textureHeight;
		}
		else
		{
			__frameRect = new Rectangle(0, 0, __videoWidth, __videoHeight);

			var bmd:BitmapData = new BitmapData(__videoWidth, __videoHeight, false, 0x0);
			this.bitmapData = bmd;

			this.width = __textureWidth;
			this.height = __textureHeight;

			__ensureSoftwareVideoBuffer();

			if (!__videoSoftwareLoad(__backendHandle, path, __videoBuffer.getData(), __videoBuffer.length))
			{
				throw "Video not supported.";
			}
		}

		__loadMetaData();

		__setupAL();
		__setupBuffers();
		__setupThreads();
	}

	/**
	 * Unloads the current video and releases resources.
	 */
	public function unload(dispose:Bool = false):Void
	{
		stop();

		if (__audioThread != null) __audioThread.cancel();
		__waitForAudioThreadToExit();

		if (__backendHandle > 0)
		{
			__videoShutdown(__backendHandle);
			__backendHandle = 0;
		}

		if (dispose && __isHardware && __context != null)
		{
			if (__videoTexture != null) __videoTexture.dispose();
			if (__textureY != null) __textureY.dispose();
			if (__textureUV != null) __textureUV.dispose();
			if (__program != null) __program.dispose();
			if (__positions != null) __positions.dispose();
			if (__uvs != null) __uvs.dispose();
			if (__indices != null) __indices.dispose();

			if (this.bitmapData != null)
			{
				this.bitmapData.dispose();
				this.bitmapData = null;
			}
		}

		__disposeALResources();
		__audioBuffers = null;

		if (__videoThread != null) __videoThread.cancel();
		if (__timerThread != null) __timerThread.cancel();
		if (__decoderThread != null) __decoderThread.cancel();

		__audioThread = null;
		__videoThread = null;
		__timerThread = null;
		__decoderThread = null;

		__unloadBuffers();

		__isPlaying.exchange(false);
		__currentTime = 0;
	}

	/**
	 * Starts video playback.
	 */
	public function play():Void
	{
		__setPlayingState(true);
		// __runAudioThread();
		__runThreads();
	}

	/**
	 * Stops video playback.
	 */
	public function stop():Void
	{
		__setPlayingState(false);
	}

	@:noCompletion private #if !debug inline #end function __setPlayingState(value:Bool):Void
	{
		__isPlaying.exchange(value);
	}

	@:noCompletion private inline function __ensureBackendHandle():Void
	{
		if (__backendHandle <= 0)
		{
			__backendHandle = __videoCreate();
			if (__backendHandle <= 0)
			{
				throw "Could not initialize Native Video Backend";
			}
		}
	}

	@:noCompletion private function __setupAL():Void
	{
		// var alObj = NativeVideoUtil.setupAL(AUDIO_BUFFER_COUNT);
		// __alAudioBuffers = alObj.buffers;
		// __alSource = alObj.source;

		// @:inline
		// AL.sourceQueueBuffers(__alSource, AUDIO_BUFFER_COUNT, __alAudioBuffers);
		// @:inline
		// AL.sourcePlay(__alSource);
	}

	@:noCompletion private function __setupThreads():Void
	{
		__audioThread = new BackgroundWorker();
		__audioCallbackQueue = new Deque();

		__decoderThread = new BackgroundWorker();
	}

	@:noCompletion private function __runThreads():Void
	{
		__runAudioThread();
	}

	@:noCompletion private function __fillBuffer(index:Int):Bool
	{
		var currentBuffer:ALBuffer = __alAudioBuffers[index];
		var position:Int = 0;

		// while(position < __sampleBuffer.length){
		var bytesAvailable:Int = __videoGetAudioSamples(__backendHandle, __sampleBuffer);
		if (bytesAvailable <= 0)
		{
			// if(bytesAvailable == -1){
			return false;
			// }
			// break;
		}

		position += bytesAvailable;
		// }

		// do we need to do this?
		/* if (position < bufferSize) {
			for (i in position...bufferSize) __sampleBuffer.set(i, 0);
			position = bufferSize; // Now it's a full buffer of valid audio data
		}*/

		var pcmData:UInt8Array = UInt8Array.fromBytes(__sampleBuffer);
		@:inline AL.bufferData(currentBuffer, __audioChannelFormat, pcmData, position, Std.int(__audioSampleRate));
		// @:inline AL.sourceQueueBuffer(__alSource, currentBuffer);

		return true;
	}

	@:noCompletion private var __audioChannelFormat:Int;

	@:noCompletion private function __prefillAudioBuffers():Void
	{
		for (i in 0...__alAudioBuffers.length)
		{
			__fillBuffer(i);
			@:inline AL.sourceQueueBuffer(__alSource, __alAudioBuffers[i]);
		}
	}

	@:noCompletion private function __createAudioBuffers():Void
	{
		__alAudioBuffers = inline AL.genBuffers(AUDIO_BUFFER_COUNT);
	}

	@:noCompletion private function __runAudioThread():Void
	{
		__alSource = inline AL.createSource();
		__alAudioBuffers = [];

		/* 	for (i in 0...AUDIO_BUFFER_COUNT) {
			__alAudioBuffers.push(inline AL.createBuffer());
		}*/

		__createAudioBuffers();

		var bufferSize:Int = AUDIO_BUFFER_SIZE;
		var bytesPerSample:Int = __audioBitsPerSample >> 3;
		var bytesPerFrame:Int = bytesPerSample * __audioChannels;
		var framesPerBuffer:Int = Std.int(bufferSize / bytesPerFrame);
		__sampleBuffer = Bytes.alloc(bufferSize);

		__audioChannelFormat = switch (__audioChannels)
		{
			case 1: AL.FORMAT_MONO16;
			case 2: AL.FORMAT_STEREO16;
			default: throw "Unsupported audio channel count: " + __audioChannels;
		}

		__prefillAudioBuffers();
		// TODO this, not here please
		soundTransform = __soundTransform;
		@:inline AL.sourcePlay(__alSource);

		__audioThread.doWork.add((_) ->
		{
			__audioThreadActive.store(true);
			try
			{
				while (isPlaying)
				{
					var state = inline AL.getSourcei(__alSource, AL.SOURCE_STATE);
					var processed:Int = inline AL.getSourcei(__alSource, AL.BUFFERS_PROCESSED);
					if (processed > 0)
					{
						__currentTime += (processed * __secondsPerBuffer);
					}
					for (_ in 0...processed)
					{
						var buf = inline AL.sourceUnqueueBuffer(__alSource);
						var index:Int = __alAudioBuffers.indexOf(buf);
						if (index >= 0)
						{
							if (__fillBuffer(index))
							{
								inline AL.sourceQueueBuffer(__alSource, buf);
							}
							else
							{
								__setPlayingState(false);
								break;
							}
						}
					}

					if (state != AL.PLAYING && inline AL.getSourcei(__alSource, AL.BUFFERS_QUEUED) > 0)
					{
						inline AL.sourcePlay(__alSource);
					}

					Sys.sleep(__secondsPerBuffer);
				}
			}
			catch (e:Dynamic) {}

			__disposeALResources();
			__audioThreadActive.store(false);
		});

		__audioThread.run();
	}

	@:noCompletion private function __waitForAudioThreadToExit(timeoutSeconds:Float = 1.0):Void
	{
		var timeoutAt:Float = Sys.time() + timeoutSeconds;
		while (__audioThreadActive.load() && Sys.time() < timeoutAt)
		{
			Sys.sleep(0.005);
		}
	}

	@:noCompletion private function __disposeALResources():Void
	{
		var source = __alSource;
		var buffers = __alAudioBuffers;

		__alSource = null;
		__alAudioBuffers = null;
		__sampleBuffer = null;

		if (source != null)
		{
			inline AL.sourceStop(source);
		}

		if (buffers != null)
		{
			for (buf in buffers)
			{
				if (buf != null)
				{
					@:inline AL.deleteBuffer(buf);
				}
			}
		}

		if (source != null)
		{
			inline AL.deleteSource(source);
		}
	}

	@:noCompletion private function __clearAudioBuffers():Void
	{
		if (__alSource == null || __alAudioBuffers == null || __alAudioBuffers.length == 0 || __sampleBuffer == null)
		{
			return;
		}

		var shouldResume:Bool = isPlaying && inline AL.getSourcei(__alSource, AL.SOURCE_STATE) == AL.PLAYING;
		inline AL.sourceStop(__alSource);

		// Only unqueue processed buffers; unqueueing "queued" buffers directly is invalid on some drivers.
		var maxDrainPasses:Int = __alAudioBuffers.length + 1;
		var pass:Int = 0;
		while (pass < maxDrainPasses)
		{
			var processed:Int = inline AL.getSourcei(__alSource, AL.BUFFERS_PROCESSED);
			if (processed <= 0)
			{
				break;
			}

			for (_ in 0...processed)
			{
				inline AL.sourceUnqueueBuffer(__alSource);
			}

			pass++;
		}

		var queued:Int = inline AL.getSourcei(__alSource, AL.BUFFERS_QUEUED);
		if (queued > 0)
		{
			// Some drivers may not expose all queued buffers as processed after stop.
			// Recreate source/buffers to guarantee a clean queue after seek.
			for (buf in __alAudioBuffers)
			{
				if (buf != null)
				{
					@:inline AL.deleteBuffer(buf);
				}
			}
			inline AL.deleteSource(__alSource);

			__alSource = inline AL.createSource();
			__createAudioBuffers();
			soundTransform = __soundTransform;
		}

		__prefillAudioBuffers();

		if (shouldResume && isPlaying)
		{
			@:inline AL.sourcePlay(__alSource);
		}
	}

	@:noCompletion private function __loadMetaData():Void
	{
		__audioSampleRate = __videoGetAudioSampleRate(__backendHandle);
		__frameRate = __videoGetFrameRate(__backendHandle);
		__frameDuration = 1.0 / __frameRate;
		__frameDurationMS = Std.int(__frameDuration * 1000);
		__audioChannels = __videoGetAudioChannelCount(__backendHandle);
		__videoDuration = __videoGetDuration(__backendHandle);
		__audioBitsPerSample = __videoGetAudioBitsPerSample(__backendHandle);
	}

	@:noCompletion override private function __enterFrame(deltaTime:Int):Void
	{
		super.__enterFrame(deltaTime);
		__updatePlaybackFrame();
	}

	@:noCompletion public function __updatePlaybackFrame():Void
	{
		if (!isPlaying) return;

		// Use backend-reported audio position as the authoritative clock when available.
		var audioPos:Int = __videoGetAudioPosition(__backendHandle);
		if (audioPos >= 0)
		{
			__currentTime = audioPos * 0.001;
		}
		else
		{
			audioPos = Std.int(currentTime * 1000);
		}

		var videoPos:Int = __videoGetVideoPosition(__backendHandle);
		var diff:Int = audioPos - videoPos;

		// UI stalls (such as native window move/resize) can pause rendering while decode/audio threads continue.
		// Avoid repeated short seeks: only hard-resync on large drift, and rate-limit those seeks.
		if (diff >= AV_HARD_RESYNC_MS)
		{
			if (audioPos - __lastResyncAtMS >= AV_RESYNC_COOLDOWN_MS)
			{
				__lastResyncAtMS = audioPos;
				__skipTo(audioPos);
				// Render one frame immediately after seek so videoPos can catch up before next update.
				__processFrames();
			}
			return;
		}

		if (diff < -(__frameDurationMS * 2))
		{
			return;
		}

		if (__frameDurationMS > 0 && diff > __frameDurationMS)
		{
			var catchupFrames:Int = Std.int(diff / __frameDurationMS);
			if (catchupFrames > AV_CATCHUP_MAX_FRAMES)
			{
				catchupFrames = AV_CATCHUP_MAX_FRAMES;
			}

			while (catchupFrames-- > 0)
			{
				if (__isHardware)
				{
					if (!__videoGLUpdateFrame(__backendHandle))
					{
						stop();
						return;
					}
				}
				else
				{
					if (!__videoSoftwareUpdateFrame(__backendHandle))
					{
						stop();
						return;
					}
				}
			}
		}

		__processFrames();
	}

	@:noCompletion private function __processGLFrames():Void
	{
		if (!__videoGLUpdateFrame(__backendHandle))
		{
			stop();
			return;
		}

		__context.setRenderToTexture(__videoTexture, true);
		__context.setProgram(__program);
		__context.setTextureAt(0, __textureY);
		__context.setTextureAt(1, __textureUV);

		// GLSL attribute locations are driver-assigned unless explicitly bound.
		__context.setVertexBufferAt(__positionAttributeIndex, __positions, 0, FLOAT_2);
		__context.setVertexBufferAt(__texCoordAttributeIndex, __uvs, 0, FLOAT_2);
		__context.drawTriangles(__indices);
		__context.setRenderToBackBuffer();

		@:privateAccess
		this.bitmapData.__texture = __videoTexture;
		this.bitmapData = this.bitmapData;
	}

	@:noCompletion private function __processSoftwareFrames():Void
	{
		if (!__videoSoftwareUpdateFrame(__backendHandle))
		{
			stop();
			return;
		}

		nv12ToRGBA(__videoBuffer, __bitmapBuffer, __videoWidth, __videoHeight);
		this.bitmapData.setPixels(__frameRect, __bitmapBuffer);
	}

	@:noCompletion private function __skipTo(time:Int):Void
	{
		__videoFramesSeekTo(__backendHandle, time);
		__currentTime = __videoGetAudioPosition(__backendHandle) * .001;
		__clearAudioBuffers();
	}

	@:noCompletion private function __unloadBuffers():Void
	{
		__bitmapBuffer = null;
		__videoBuffer = null;
		__audioBuffers = null;
	}

	@:noCompletion private function __setupBuffers():Void
	{
		if (!__isHardware)
		{
			__ensureSoftwareVideoBuffer();
			__ensureSoftwareBitmapBuffer();
		}
		else
		{
			// video gl buffers!
		}

		var bytesPerSample:Int = __audioBitsPerSample >> 3;

		var bytesPerFrame:Int = bytesPerSample * __audioChannels;
		var totalFrames = AUDIO_BUFFER_SIZE / bytesPerFrame;

		__secondsPerBuffer = totalFrames / __audioSampleRate;
	}

	@:noCompletion private function __ensureSoftwareVideoBuffer():Void
	{
		var videoBufferLength:Int = Std.int(__videoWidth * __videoHeight * 1.5);

		if (__videoBuffer == null || __videoBuffer.length != videoBufferLength)
		{
			__videoBuffer = Bytes.alloc(videoBufferLength);
		}
	}

	@:noCompletion private function __ensureSoftwareBitmapBuffer():Void
	{
		var bitmapBufferLength:Int = __videoWidth * __videoHeight * 4;

		if (__bitmapBuffer == null || __bitmapBuffer.length != bitmapBufferLength)
		{
			__bitmapBuffer = Bytes.alloc(bitmapBufferLength);
		}
	}

	@:noCompletion private function __setupData():Void
	{
		// Compute aspect ratios
		var videoAspect = __videoWidth / __videoHeight;
		var texAspect = __textureWidth / __textureHeight;

		var sx = 1.0;
		var sy = 1.0;

		if (videoAspect > texAspect)
		{
			sy = texAspect / videoAspect;
		}
		else
		{
			sx = videoAspect / texAspect;
		}

		// Set up the position buffer (screen position scaling)
		var posData = new Float32Array([
			-1 * sx, -1 * sy,
			 1 * sx, -1 * sy,
			-1 * sx,  1 * sy,
			 1 * sx,  1 * sy
		]);
		__positions = __context.createVertexBuffer(4, 2);
		__positions.uploadFromTypedArray(posData, 0);

		// Y/UV source textures are allocated at native video dimensions,
		// so UV coordinates should always address the full [0..1] range.
		var uvData = new Float32Array([
			0, 0,
			1, 0,
			0, 1,
			1, 1
		]);
		__uvs = __context.createVertexBuffer(4, 2);
		__uvs.uploadFromTypedArray(uvData, 0);

		// Upload index buffer
		__indices = __context.createIndexBuffer(6);
		__indices.uploadFromTypedArray(new UInt16Array([0, 1, 2, 2, 1, 3]), 0);
	}

	@:noCompletion private function __createProgram():Void
	{
		var vertexShader:String = "attribute vec2 aPosition;
attribute vec2 aTexCoord;

varying vec2 vTexCoord;

void main() {
    vTexCoord = aTexCoord;
    gl_Position = vec4(aPosition, 0.0, 1.0);
}";

		// Context3D GLSL sampler binding maps uniforms by trailing numeric suffix.
		// Keep these names aligned with setTextureAt(0/1) calls in __processGLFrames.
		var fragmentShader:String = "
		uniform sampler2D u_tex0; // Swizzled Y texture (GL_RED mapped to RGB)
		uniform sampler2D u_tex1; // UV texture (GL_RG)

		varying vec2 vTexCoord;

		void main() {
			vec2 uvCoord = vTexCoord; // Use scaled UVs from vertex shader

			vec3 yColor = texture2D(u_tex0, uvCoord).rgb;

			vec2 uv = texture2D(u_tex1, uvCoord).rg;

			float y = clamp((yColor.r * 255.0 - 16.0) / 219.0, 0.0, 1.0);

			float u = (uv.r * 255.0 - 128.0) / 224.0;
			float v = (uv.g * 255.0 - 128.0) / 224.0;

			float r = y + 1.5748 * v;
			float g = y - 0.1873 * u - 0.4681 * v;
			float b = y + 1.8556 * u;

			gl_FragColor = vec4(r, g, b, 1.0);
		}
			";

		__program = __context.createProgram(GLSL);
		__program.uploadSources(vertexShader, fragmentShader);
		__positionAttributeIndex = __program.getAttributeIndex("aPosition");
		__texCoordAttributeIndex = __program.getAttributeIndex("aTexCoord");

		// Fallback to conventional slots if the shader compiler does not report a location.
		if (__positionAttributeIndex < 0)
		{
			__positionAttributeIndex = 0;
		}
		if (__texCoordAttributeIndex < 0)
		{
			__texCoordAttributeIndex = 1;
		}
	}

	@:noCompletion private static function __videoCreate():Int
	{
		return NativeVideoBackend.__videoCreate();
	}

	@:noCompletion private static function __videoSoftwareLoad(handle:Int, path:String, buffer:BytesData, length:Int):Bool
	{
		return NativeVideoBackend.__videoSoftwareLoad(handle, path, Pointer.ofArray(buffer), length);
	}

	@:noCompletion private static function __videoSoftwareUpdateFrame(handle:Int):Bool
	{
		return NativeVideoBackend.__videoSoftwareUpdateFrame(handle);
	}

	@:noCompletion private static function __videoGLLoad(handle:Int, path:String):Bool
	{
		return NativeVideoBackend.__videoGLLoad(handle, path);
	}

	@:noCompletion private static function __videoGLUpdateFrame(handle:Int):Bool
	{
		return NativeVideoBackend.__videoGLUpdateFrame(handle);
	}

	@:noCompletion private static function __videoGetWidth(handle:Int, path:String):Int
	{
		return NativeVideoBackend.__videoGetWidth(handle, path);
	}

	@:noCompletion private static function __videoGetHeight(handle:Int, path:String):Int
	{
		return NativeVideoBackend.__videoGetHeight(handle, path);
	}

	@:noCompletion private static function __videoShutdown(handle:Int):Void
	{
		NativeVideoBackend.__videoShutdown(handle);
	}

	@:noCompletion private static function __videoGetAudioSamples(handle:Int, buffer:Bytes):Int
	{
		return NativeVideoBackend.__videoGetAudioSamples(handle, Pointer.ofArray(buffer.getData()), buffer.length);
	}

	@:noCompletion private static function __videoGetAudioSampleRate(handle:Int):Int
	{
		return NativeVideoBackend.__videoGetAudioSampleRate(handle);
	}

	@:noCompletion private static function __videoGetAudioBitsPerSample(handle:Int):Int
	{
		return NativeVideoBackend.__videoGetAudioBitsPerSample(handle);
	}

	@:noCompletion private static function __videoGetFrameRate(handle:Int):Float
	{
		return NativeVideoBackend.__videoGetFrameRate(handle);
	}

	@:noCompletion private static function __videoGetAudioChannelCount(handle:Int):Int
	{
		return NativeVideoBackend.__videoGetAudioChannelCount(handle);
	}

	@:noCompletion private static function __videoGetDuration(handle:Int):Int
	{
		return NativeVideoBackend.__videoGetDuration(handle);
	}

	@:noCompletion private static function __videoGetAudioPosition(handle:Int):Int
	{
		return NativeVideoBackend.__videoGetAudioPosition(handle);
	}

	@:noCompletion private static function __videoGetVideoPosition(handle:Int):Int
	{
		return NativeVideoBackend.__videoGetVideoPosition(handle);
	}

	@:noCompletion private static function __videoGetFrameWidth(handle:Int):Int
	{
		return NativeVideoBackend.__videoGetFrameWidth(handle);
	}

	@:noCompletion private static function __videoGetFrameHeight(handle:Int):Int
	{
		return NativeVideoBackend.__videoGetFrameHeight(handle);
	}

	@:noCompletion private static function __videoFramesSeekTo(handle:Int, time:Int):Void
	{
		NativeVideoBackend.__videoFramesSeekTo(handle, time);
	}

	@:noCompletion private static function __getTextureIDY(handle:Int):Int
	{
		return NativeVideoBackend.__getTextureIDY(handle);
	}

	@:noCompletion private static function __getTextureIDUV(handle:Int):Int
	{
		return NativeVideoBackend.__getTextureIDUV(handle);
	}

	@:noCompletion private static function nv12ToRGBA(nv12:Bytes, rgba:Bytes, width:Int, height:Int)
	{
		var frameSize = width * height;
		var uvOffset = frameSize + width * 2; // skip first UV row
		var maxUVRows = ((height - 4) >> 1); // only read UV rows for 270 Y lines

		for (y in 0...height)
		{
			var yRow = y * width;
			var uvRowIndex = (y >> 1);
			if (uvRowIndex >= maxUVRows) continue; // prevent UV overflow

			var uvRow = uvOffset + uvRowIndex * width;

			for (x in 0...width)
			{
				var Y = nv12.get(yRow + x) & 0xFF;
				var U = nv12.get(uvRow + (x & ~1)) & 0xFF;
				var V = nv12.get(uvRow + (x & ~1) + 1) & 0xFF;

				var C = Y - 16;
				var D = U - 128;
				var E = V - 128;

				var R = (298 * C + 409 * E + 128) >> 8;
				var G = (298 * C - 100 * D - 208 * E + 128) >> 8;
				var B = (298 * C + 516 * D + 128) >> 8;

				var rgbaIndex = 4 * (y * width + x);
				rgba.set(rgbaIndex, clamp(B));
				rgba.set(rgbaIndex + 1, clamp(G));
				rgba.set(rgbaIndex + 2, clamp(R));
				rgba.set(rgbaIndex + 3, 255);
			}
		}
	}

	@:noCompletion private inline static function clamp(v:Int):Int
	{
		return v < 0 ? 0 : (v > 255 ? 255 : v);
	}
#else
final class NativeVideo extends Bitmap
{
	public function new(Width:Int, height:Int, smoothing:Bool = false)
	{
		super();
		Lib.notImplemented();
	}
#end
}
