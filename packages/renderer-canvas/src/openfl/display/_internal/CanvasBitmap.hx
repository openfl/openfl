package openfl.display._internal;

#if openfl_html5
import openfl.display.Bitmap;
#if lime
import lime._internal.graphics.ImageCanvasUtil;
#else
import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
#end

@:access(openfl.display._internal)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasBitmap
{
	public static inline function render(bitmap:Bitmap, renderer:CanvasRenderer):Void
	{
		#if (lime && openfl_html5)
		if (!bitmap._.__renderable) return;

		var alpha = renderer._.__getAlpha(bitmap._.__worldAlpha);

		if (alpha > 0 && bitmap._.__bitmapData != null && bitmap._.__bitmapData._.__isValid && bitmap._.__bitmapData.readable)
		{
			var context = renderer.context;

			renderer._.__setBlendMode(bitmap._.__worldBlendMode);
			renderer._.__pushMaskObject(bitmap, false);

			context.globalAlpha = alpha;
			var scrollRect = bitmap._.__scrollRect;

			renderer.setTransform(bitmap._.__renderTransform, context);

			if (!renderer._.__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = false;
			}

			if (scrollRect == null)
			{
				context.drawImage(bitmap._.__bitmapData._.__getElement(), 0, 0, bitmap._.__bitmapData.width, bitmap._.__bitmapData.height);
			}
			else
			{
				context.save();

				context.beginPath();
				context.rect(scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				context.clip();

				context.drawImage(bitmap._.__bitmapData._.__getElement(), 0, 0, bitmap._.__bitmapData.width, bitmap._.__bitmapData.height);

				context.restore();
			}

			if (!renderer._.__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = true;
			}

			renderer._.__popMaskObject(bitmap, false);
		}
		#end
	}
}
#end
