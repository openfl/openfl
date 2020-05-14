package openfl.display3D.textures;

#if openfl_gl
import haxe.Timer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GL;
import openfl.display3D.textures.VideoTexture;
import openfl.events.Event;
import openfl.net.NetStream;
#if openfl_html5
import js.html.VideoElement;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.textures.VideoTexture)
@:access(openfl.display3D.textures._VideoTexture) // TODO: Remove backend references
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D) // TODO: Remove backend references
@:access(openfl.display.Stage)
@:access(openfl.net.NetStream)
@:access(openfl.events.Event)
@:noCompletion
class _VideoTexture extends _TextureBase
{
	public var cacheTime:Float;
	public var netStream:NetStream;
	#if openfl_html5
	public var videoElement:VideoElement;
	#end

	private var videoTexture:VideoTexture;

	public function new(videoTexture:VideoTexture, context:Context3D)
	{
		this.videoTexture = videoTexture;

		super(videoTexture, context, 0, 0, null, false, 0);

		glTextureTarget = GL.TEXTURE_2D;
	}

	public function attachNetStream(netStream:NetStream):Void
	{
		#if openfl_html5
		if (this.netStream != null)
		{
			videoElement.removeEventListener("canplay", onCanPlay, false);
		}
		#end

		this.netStream = netStream;
		cacheTime = -1;

		#if openfl_html5
		if (netStream != null)
		{
			videoElement = netStream._.__getVideoElement();
			if (videoElement.readyState >= 2)
			{
				Timer.delay(function()
				{
					textureReady();
				}, 0);
			}
			else
			{
				videoElement.addEventListener("canplay", onCanPlay, false);
			}
		}
		else
		{
			videoElement = null;
		}
		#end
	}

	public override function dispose():Void
	{
		#if openfl_html5
		if (videoElement != null)
		{
			videoElement.removeEventListener("timeupdate", onTimeUpdate);
		}
		#end

		super.dispose();
	}

	#if openfl_html5
	public function onCanPlay(_):Void
	{
		videoElement.addEventListener("timeupdate", onTimeUpdate);
		textureReady();
	}

	public function onTimeUpdate(_):Void
	{
		if (videoElement.currentTime != cacheTime && videoElement.readyState >= 2)
		{
			textureReady();
		}
	}
	#end

	public override function getTexture():GLTexture
	{
		#if openfl_html5
		if (videoElement.currentTime != cacheTime && videoElement.readyState >= 2)
		{
			contextBackend.bindGLTexture2D(glTextureID);
			gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, videoElement);
			cacheTime = videoElement.currentTime;
		}
		#end

		return glTextureID;
	}

	public function textureReady():Void
	{
		#if openfl_html5
		videoTexture.videoWidth = videoElement.videoWidth;
		videoTexture.videoHeight = videoElement.videoHeight;
		#end

		var event:Event = null;

		#if openfl_pool_events
		event = _Event.__pool.get(Event.TEXTURE_READY);
		#else
		event = new Event(Event.TEXTURE_READY);
		#end

		videoTexture.dispatchEvent(event);

		#if openfl_pool_events
		_Event.__pool.release(event);
		#end
	}
}
#end
