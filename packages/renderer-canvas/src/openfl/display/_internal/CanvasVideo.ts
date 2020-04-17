import Video from "../../../media/Video";
import * as internal from "../../utils/InternalAccess";
import CanvasRenderer from "./CanvasRenderer";

export default class CanvasVideo
{
	public static render(video: Video, renderer: CanvasRenderer): void
	{
		if (!(<internal.DisplayObject><any>video).__renderable || (<internal.Video><any>video).__stream == null) return;

		var alpha = renderer.__getAlpha((<internal.DisplayObject><any>video).__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;
		var videoElement = (<internal.NetStream><any>(<internal.Video><any>video).__stream).__getVideoElement();

		if (videoElement != null)
		{
			renderer.__setBlendMode((<internal.DisplayObject><any>video).__worldBlendMode);
			renderer.__pushMaskObject(video);

			context.globalAlpha = alpha;
			var scrollRect = (<internal.DisplayObject><any>video).__scrollRect;
			var smoothing = video.smoothing;

			renderer.setTransform((<internal.DisplayObject><any>video).__worldTransform, context);

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

			renderer.__popMaskObject(video);
		}
	}
}
