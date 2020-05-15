package openfl.display._internal;

#if openfl_html5
import openfl.media.Video;
import openfl.media._Video;
import openfl.net._NetStream;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMVideo
{
	public static function clear(video:Video, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if ((video._ : _Video).__active)
		{
			renderer.element.removeChild(((video._ : _Video).__stream._ : _NetStream).__getVideoElement());
			(video._ : _Video).__active = false;
		}
		#end
	}

	public static function render(video:Video, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (video.stage != null
			&& (video._ : _Video).__stream != null && (video._ : _Video).__worldVisible && (video._ : _Video).__renderable)
		{
			var videoElement = ((video._ : _Video).__stream._ : _NetStream).__getVideoElement();

			if (!(video._ : _Video).__active)
			{
				(renderer._ : _DOMRenderer).__initializeElement(video, videoElement);
				(video._ : _Video).__active = true;
				(video._ : _Video).__dirty = true;
			}

			if ((video._ : _Video).__dirty)
			{
				videoElement.width = Std.int((video._ : _Video).__width);
				videoElement.height = Std.int((video._ : _Video).__height);
				(video._ : _Video).__dirty = false;
			}

				(renderer._ : _DOMRenderer).__updateClip(video);
			(renderer._ : _DOMRenderer).__applyStyle(video, true, true, true);
		}
		else
		{
			clear(video, renderer);
		}
		#end
	}
}
#end
