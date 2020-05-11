package openfl.display._internal;

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
		if (video._.__active)
		{
			renderer.element.removeChild(video._.__stream._.__getVideoElement());
			video._.__active = false;
		}
		#end
	}

	public static function render(video:Video, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (video.stage != null && video._.__stream != null && video._.__worldVisible && video._.__renderable)
		{
			var videoElement = video._.__stream._.__getVideoElement();

			if (!video._.__active)
			{
				renderer._.__initializeElement(video, videoElement);
				video._.__active = true;
				video._.__dirty = true;
			}

			if (video._.__dirty)
			{
				videoElement.width = Std.int(video._.__width);
				videoElement.height = Std.int(video._.__height);
				video._.__dirty = false;
			}

			renderer._.__updateClip(video);
			renderer._.__applyStyle(video, true, true, true);
		}
		else
		{
			clear(video, renderer);
		}
		#end
	}
}
#end
