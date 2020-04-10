import Bitmap from "../../../display/Bitmap";
import * as internal from "../../utils/InternalAccess";
import CanvasRenderer from "./CanvasRenderer";
// import openfl._internal.backend.lime_standalone.ImageCanvasUtil;

export default class CanvasBitmap
{
	public static render(bitmap: Bitmap, renderer: CanvasRenderer): void
	{
		if (!(<internal.DisplayObject><any>bitmap).__renderable) return;

		var alpha = renderer.__getAlpha((<internal.DisplayObject><any>bitmap).__worldAlpha);

		if (alpha > 0 && bitmap.bitmapData != null && (<internal.BitmapData><any>bitmap.bitmapData).__isValid && bitmap.bitmapData.readable)
		{
			var context = renderer.context;

			renderer.__setBlendMode((<internal.DisplayObject><any>bitmap).__worldBlendMode);
			renderer.__pushMaskObject(bitmap, false);

			context.globalAlpha = alpha;
			var scrollRect = (<internal.DisplayObject><any>bitmap).__scrollRect;

			renderer.setTransform((<internal.DisplayObject><any>bitmap).__renderTransform, context);

			if (!(<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = false;
			}

			if (scrollRect == null)
			{
				context.drawImage((<internal.BitmapData><any>bitmap.bitmapData).__getElement(), 0, 0, bitmap.bitmapData.width, bitmap.bitmapData.height);
			}
			else
			{
				context.save();

				context.beginPath();
				context.rect(scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				context.clip();

				context.drawImage((<internal.BitmapData><any>bitmap.bitmapData).__getElement(), 0, 0, bitmap.bitmapData.width, bitmap.bitmapData.height);

				context.restore();
			}

			if (!(<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = true;
			}

			renderer.__popMaskObject(bitmap, false);
		}
	}
}
