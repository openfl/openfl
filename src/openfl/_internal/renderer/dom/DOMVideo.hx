package openfl._internal.renderer.dom;

import openfl.display.DOMRenderer;
import openfl.media.Video;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMVideo
{
	public static function clear(video:Video, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		if (video.__active)
		{
			renderer.element.removeChild(video.__stream.__video);
			video.__active = false;
		}
		#end
	}

	public static function render(video:Video, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		if (video.stage != null && video.__stream != null && video.__worldVisible && video.__renderable)
		{
			if (!video.__active)
			{
				renderer.__initializeElement(video, video.__stream.__video);
				video.__active = true;
				video.__dirty = true;
			}

			if (video.__dirty)
			{
				video.__stream.__video.width = Std.int(video.__width);
				video.__stream.__video.height = Std.int(video.__height);
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
