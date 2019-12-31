package openfl._internal.renderer.canvas;

#if openfl_html5
import openfl.display.Bitmap;
#if (!lime && openfl_html5)
import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
#else
import openfl._internal.backend.lime.ImageCanvasUtil;
#end

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasBitmap
{
	public static inline function render(bitmap:Bitmap, renderer:CanvasRenderer):Void
	{
		#if (lime && openfl_html5)
		if (!bitmap.__renderable) return;

		var alpha = renderer.__getAlpha(bitmap.__worldAlpha);

		if (alpha > 0 && bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid && bitmap.__bitmapData.readable)
		{
			var context = renderer.context;

			renderer.__setBlendMode(bitmap.__worldBlendMode);
			renderer.__pushMaskObject(bitmap, false);

			ImageCanvasUtil.convertToCanvas(bitmap.__bitmapData.image);

			context.globalAlpha = alpha;
			var scrollRect = bitmap.__scrollRect;

			renderer.setTransform(bitmap.__renderTransform, context);

			if (!renderer.__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = false;
			}

			if (scrollRect == null)
			{
				context.drawImage(bitmap.__bitmapData.image.src, 0, 0, bitmap.__bitmapData.image.width, bitmap.__bitmapData.image.height);
			}
			else
			{
				context.save();

				context.beginPath();
				context.rect(scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				context.clip();

				context.drawImage(bitmap.__bitmapData.image.src, 0, 0, bitmap.__bitmapData.image.width, bitmap.__bitmapData.image.height);

				context.restore();
			}

			if (!renderer.__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = true;
			}

			renderer.__popMaskObject(bitmap, false);
		}
		#end
	}
}
#end
