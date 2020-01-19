package openfl._internal.renderer.dom;

#if openfl_html5
import openfl.media.Video;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMVideo
{
	public static function clear(video:Video, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (video.__active)
		{
			renderer.element.removeChild(video.__stream.__getVideoElement());
			video.__active = false;
		}
		#end
	}

	public static function render(video:Video, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (video.stage != null && video.__stream != null && video.__worldVisible && video.__renderable)
		{
			var videoElement = video.__stream.__getVideoElement();

			if (!video.__active)
			{
				renderer.__initializeElement(video, videoElement);
				video.__active = true;
				video.__dirty = true;
			}

			if (video.__dirty)
			{
				videoElement.width = Std.int(video.__width);
				videoElement.height = Std.int(video.__height);
				video.__dirty = false;
			}

			renderer.__updateClip(video);
			renderer.__applyStyle(video, true, true, true);
		}
		else
		{
			clear(video, renderer);
		}
		#end
	}
}
#end
