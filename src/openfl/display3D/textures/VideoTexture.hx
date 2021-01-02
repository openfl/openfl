package openfl.display3D.textures;

#if !flash
import haxe.Timer;
import openfl.display3D._internal.GLTexture;
import openfl.events.Event;
import openfl.net.NetStream;

/**
	Prior to Flash Player 21, the use of video in Stage3D required the use of the Video
	object (which is not hardware accelerated), copying of video frame to a BitmapData
	object, and loading of the data onto the GPU which is CPU intensive. Thus, Video
	texture object was introduced. It allows hardware decoded video to be used in Stage 3D
	content.

	For Flash Player 22, video texture objects were added to support NetStream and Cameras
	in a manner consistent/ similar to StageVideo. Such textures can be used as source
	textures in the stage3D rendering pipeline. The textures can be used as rectangular,
	RGB, no mipmap textures in the rendering of a scene. They are treated as ARGB texture
	by the shaders (that is, the AGAL shaders do not have to bother about YUV->RGB
	conversion) and so the standard shaders with static images can be used without change.
	The image used by the rendering pipeline is the latest up-to-date frame at the time the
	rendering occurs using this texture. There is no tearing in a video frame, however if
	the same texture is used several times, some of the instances may be from different
	timestamps.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:access(openfl.net.NetStream)
@:access(openfl.events.Event)
@:final class VideoTexture extends TextureBase
{
	/**
		An integer specifying the height of the video stream, in pixels.

		For a live stream, this value is the same as the Camera.height property of the
		Camera object that is capturing the video stream. For a recorded video file, this
		value is the height of the video. The `NetStream.Video.DimensionChange` event is
		dispatched in the case of recorded videos when this value changes.
	**/
	public var videoHeight(default, null):Int;

	/**
		An integer specifying the width of the video stream, in pixels.

		For a live stream, this value is the same as the Camera.width property of the
		Camera object that is capturing the video stream. For a recorded video file, this
		value is the width of the video. The `NetStream.Video.DimensionChange` event is
		dispatched in the case of recorded videos when this value changes.
	**/
	public var videoWidth(default, null):Int;

	@:noCompletion private var __cacheTime:Float;
	@:noCompletion private var __netStream:NetStream;

	@:noCompletion private function new(context:Context3D)
	{
		super(context);

		__textureTarget = __context.gl.TEXTURE_2D;
	}

	#if false
	/**
		Specifies a video stream from a camera to be rendered within the texture of the
		VideoTexture object.

		Use this method to attach live video captured by the user to the VideoTexture
		object. To drop the connection to the VideoTexture object, set the value of the
		`theCamera` parameter to `null`.

		@param	theCamera
	**/
	// public function attachCamera(theCamera:Camera):Void {}
	#end

	/**
		Specifies a video stream to be rendered within the texture of the VideoTexture
		object.

		A video file can be stored on the local file system or on Flash Media Server. If
		the value of the netStream argument is `null`, the video is no longer played in the
		VideoTexture object.

		@param	netStream
	**/
	public function attachNetStream(netStream:NetStream):Void
	{
		#if (js && html5)
		if (__netStream != null)
		{
			__netStream.__video.removeEventListener("canplay", __onCanPlay, false);
		}
		#end

		__cacheTime = -1;
		__netStream = netStream;

		if (__netStream != null)
		{
			#if (js && html5)
			if (__netStream.__video.readyState >= 2)
			{
				Timer.delay(function()
				{
					__textureReady();
				}, 0);
			}
			else
			{
				__netStream.__video.addEventListener("canplay", __onCanPlay, false);
			}
			#end
		}
	}

	public override function dispose():Void
	{
		#if openfl_html5
		if (__netStream != null && __netStream.__video != null)
		{
			__netStream.__video.removeEventListener("timeupdate", __onTimeUpdate);
		}
		#end

		super.dispose();
	}

	#if (js && html5)
	@:noCompletion private function __onCanPlay(_):Void
	{
		__netStream.__video.addEventListener("timeupdate", __onTimeUpdate);
		__textureReady();
	}

	@:noCompletion private function __onTimeUpdate(_):Void
	{
		if (__netStream != null && __netStream.__video.currentTime != __cacheTime && __netStream.__video.readyState >= 2)
		{
			__textureReady();
		}
	}
	#end

	@:noCompletion private override function __getTexture():GLTexture
	{
		#if (js && html5)
		if (__netStream.__video.currentTime != __cacheTime && __netStream.__video.readyState >= 2)
		{
			var gl = __context.gl;

			__context.__bindGLTexture2D(__textureID);
			gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, __netStream.__video);
			__cacheTime = __netStream.__video.currentTime;
		}
		#end

		return __textureID;
	}

	@:noCompletion private function __textureReady():Void
	{
		#if (js && html5)
		videoWidth = __netStream.__video.videoWidth;
		videoHeight = __netStream.__video.videoHeight;
		#end

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.TEXTURE_READY);
		#else
		event = new Event(Event.TEXTURE_READY);
		#end

		dispatchEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end
	}
}
#else
typedef VideoTexture = flash.display3D.textures.VideoTexture;
#end
