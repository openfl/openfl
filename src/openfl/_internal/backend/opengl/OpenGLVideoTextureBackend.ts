namespace openfl._internal.backend.opengl;

#if openfl_gl
import haxe.Timer;
import openfl._internal.bindings.gl.GLTexture;
import openfl._internal.bindings.gl.GL;
import openfl.display3D.textures.VideoTexture;
import Event from "openfl/events/Event";
import openfl.net.NetStream;
#if openfl_html5
import js.html.VideoElement;
#end

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl._internal.backend.opengl)
@: access(openfl.display3D.textures.VideoTexture)
@: access(openfl.display3D.Context3D)
@: access(openfl.display.Stage)
@: access(openfl.net.NetStream)
@: access(openfl.events.Event)
class OpenGLVideoTextureBackend extends OpenGLTextureBaseBackend
{
	private cacheTime: number;
	private netStream: NetStream;
	private parent: VideoTexture;
	#if openfl_html5
	private videoElement: VideoElement;
	#end

	public new(parent: VideoTexture)
	{
		super(parent);

		this.parent = parent;

		glTextureTarget = GL.TEXTURE_2D;
	}

	public attachNetStream(netStream: NetStream): void
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
			videoElement = netStream.__getVideoElement();
			if (videoElement.readyState >= 2)
			{
				Timer.delay(function ()
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

	publicdispose(): void
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
	private onCanPlay(_): void
	{
		videoElement.addEventListener("timeupdate", onTimeUpdate);
		textureReady();
	}

	private onTimeUpdate(_): void
	{
		if (videoElement.currentTime != cacheTime && videoElement.readyState >= 2)
		{
			textureReady();
		}
	}
	#end

	privategetTexture(): GLTexture
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

	private textureReady(): void
	{
		#if openfl_html5
		parent.videoWidth = videoElement.videoWidth;
		parent.videoHeight = videoElement.videoHeight;
		#end

		var event: Event = null;

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
