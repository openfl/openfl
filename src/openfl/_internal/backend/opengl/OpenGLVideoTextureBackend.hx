package openfl._internal.backend.opengl;

#if openfl_gl
import haxe.Timer;
import openfl._internal.bindings.gl.GLTexture;
import openfl._internal.bindings.gl.GL;
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
@:access(openfl._internal.backend.opengl)
@:access(openfl.display3D.textures.VideoTexture)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:access(openfl.net.NetStream)
@:access(openfl.events.Event)
class OpenGLVideoTextureBackend extends OpenGLTextureBaseBackend
{
	private var cacheTime:Float;
	private var netStream:NetStream;
	private var parent:VideoTexture;
	#if openfl_html5
	private var videoElement:VideoElement;
	#end

	public function new(parent:VideoTexture)
	{
		super(parent);

		this.parent = parent;

		glTextureTarget = GL.TEXTURE_2D;
	}

	public function attachNetStream(netStream:NetStream):Void
	{
		#if openfl_html5
		if (this.netStream != null)
		{
			this.netStream.__getVideoElement().removeEventListener("canplay", onCanPlay, false);
		}
		#end

		this.netStream = netStream;
		cacheTime = -1;

		#if openfl_html5
		this.videoElement = netStream.__getVideoElement();
		if (videoElement.readyState == 2)
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
	private function onCanPlay(_):Void
	{
		videoElement.addEventListener("timeupdate", onTimeUpdate);
		textureReady();
	}

	private function onTimeUpdate(_):Void
	{
		if (videoElement.currentTime != cacheTime && videoElement.readyState >= 2)
		{
			textureReady();
		}
	}
	#end

	private override function getTexture():GLTexture
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

	private function textureReady():Void
	{
		#if openfl_html5
		parent.videoWidth = videoElement.videoWidth;
		parent.videoHeight = videoElement.videoHeight;
		#end

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.TEXTURE_READY);
		#else
		event = new Event(Event.TEXTURE_READY);
		#end

		parent.dispatchEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end
	}
}
#end
