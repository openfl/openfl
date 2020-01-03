package openfl._internal.renderer.canvas;

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
		if (!video.__renderable || video.__stream == null) return;

		var alpha = renderer.__getAlpha(video.__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;

		if (@:privateAccess video.__stream.__backend.video != null)
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
				context.drawImage(@:privateAccess video.__stream.__backend.video, 0, 0, video.width, video.height);
			}
			else
			{
				context.drawImage(@:privateAccess video.__stream.__backend.video, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height,
					scrollRect.x, scrollRect.y,
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
}
#end
