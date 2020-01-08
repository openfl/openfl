package openfl._internal.backend.opengl;

#if openfl_gl
import haxe.Timer;
import openfl._internal.bindings.gl.GLTexture;
import openfl._internal.bindings.gl.GL;
import openfl.display3D.textures.VideoTexture;
import openfl.display3D.Context3D;
import openfl.events.Event;
import openfl.net.NetStream;

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
	private var netStream:NetStream;
	private var parent:VideoTexture;

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
			@:privateAccess this.netStream.__backend.video.removeEventListener("canplay", onCanPlay, false);
		}
		#end

		this.netStream = netStream;

		#if openfl_html5
		if (@:privateAccess netStream.__backend.video.readyState == 4)
		{
			Timer.delay(function()
			{
				textureReady();
			}, 0);
		}
		else
		{
			@:privateAccess netStream.__backend.video.addEventListener("canplay", onCanPlay, false);
		}
		#end
	}

	#if openfl_html5
	private function onCanPlay(_):Void
	{
		textureReady();
	}
	#end

	private override function getTexture():GLTexture
	{
		#if openfl_html5
		if ((! @:privateAccess netStream.__backend.video.paused || @:privateAccess netStream.__backend.seeking)
			&& @:privateAccess netStream.__backend.video.readyState > 0)
		{
			@:privateAccess netStream.__backend.seeking = false;
			var gl = parent.__context.__backend.gl;

			parent.__context.__backend.bindGLTexture2D(glTextureID);
			gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, @:privateAccess netStream.__backend.video);
		}
		#end

		return glTextureID;
	}

	private function textureReady():Void
	{
		#if openfl_html5
		parent.videoWidth = @:privateAccess netStream.__backend.video.videoWidth;
		parent.videoHeight = @:privateAccess netStream.__backend.video.videoHeight;
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
