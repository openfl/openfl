package openfl.display._internal;

#if openfl_html5
import openfl.media.Video;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasVideo
{
	public static function render(video:Video, renderer:CanvasRenderer):Void
	{
		#if (lime && openfl_html5)
		if (!video._.__renderable || video._.__stream == null) return;

		var alpha = renderer._.__getAlpha(video._.__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;
		var videoElement = video._.__stream._.__getVideoElement();

		if (videoElement != null)
		{
			renderer._.__setBlendMode(video._.__worldBlendMode);
			renderer._.__pushMaskObject(video);

			context.globalAlpha = alpha;
			var scrollRect = video._.__scrollRect;
			var smoothing = video.smoothing;

			renderer.setTransform(video._.__worldTransform, context);

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

			renderer._.__popMaskObject(video);
		}
		#end
	}
}
#end
