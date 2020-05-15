package openfl.display._internal;

#if openfl_html5
import openfl.display._CanvasRenderer;
import openfl.media.Video;
import openfl.media._Video;
import openfl.net._NetStream;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasVideo
{
	public static function render(video:Video, renderer:CanvasRenderer):Void
	{
		#if (lime && openfl_html5)
		if (!(video._ : _Video).__renderable || (video._ : _Video).__stream == null) return;

		var alpha = (renderer._ : _CanvasRenderer).__getAlpha((video._ : _Video).__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;
		var videoElement = ((video._ : _Video).__stream._ : _NetStream).__getVideoElement();

		if (videoElement != null)
		{
			(renderer._ : _CanvasRenderer).__setBlendMode((video._ : _Video).__worldBlendMode);
			(renderer._ : _CanvasRenderer).__pushMaskObject(video);

			context.globalAlpha = alpha;
			var scrollRect = (video._ : _Video).__scrollRect;
			var smoothing = video.smoothing;

			renderer.setTransform((video._ : _Video).__worldTransform, context);

			if (!smoothing)
			{
				context.imageSmoothingEnabled = false;
			}

			if (scrollRect == null)
			{
				context.drawImage(videoElement, 0, 0, video.width, video.height);
			}
			else
			{
				context.drawImage(videoElement, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width,
					scrollRect.height);
			}

			if (!smoothing)
			{
				context.imageSmoothingEnabled = true;
			}

				(renderer._ : _CanvasRenderer).__popMaskObject(video);
		}
		#end
	}
}
#end
