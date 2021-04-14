package openfl.display._internal;

import openfl.display.CanvasRenderer;
import openfl.media.Video;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasVideo
{
	public static function render(video:Video, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		if (!video.__renderable || video.__stream == null) return;

		var alpha = renderer.__getAlpha(video.__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;

		if (video.__stream.__video != null)
		{
			renderer.__setBlendMode(video.__worldBlendMode);
			renderer.__pushMaskObject(video);

			context.globalAlpha = alpha;
			var scrollRect = video.__scrollRect;
			var smoothing = video.smoothing;

			renderer.setTransform(video.__worldTransform, context);

			if (!smoothing)
			{
				context.imageSmoothingEnabled = false;
			}

			if (scrollRect == null)
			{
				context.drawImage(video.__stream.__video, 0, 0, video.width, video.height);
			}
			else
			{
				context.drawImage(video.__stream.__video, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y,
					scrollRect.width, scrollRect.height);
			}

			if (!smoothing)
			{
				context.imageSmoothingEnabled = true;
			}

			renderer.__popMaskObject(video);
		}
		#end
	}

	public static function renderDrawable(video:Video, renderer:CanvasRenderer):Void
	{
		CanvasVideo.render(video, renderer);
		renderer.__renderEvent(video);
	}

	public static function renderDrawableMask(video:Video, renderer:CanvasRenderer):Void {}
}
