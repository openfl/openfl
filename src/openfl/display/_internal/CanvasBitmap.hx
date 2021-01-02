package openfl.display._internal;

import openfl.display.Bitmap;
import openfl.display.CanvasRenderer;
#if lime
import lime._internal.graphics.ImageCanvasUtil; // TODO

#end
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasBitmap
{
	public static inline function render(bitmap:Bitmap, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
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
				context.drawImage(bitmap.__bitmapData.image.src, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y,
					scrollRect.width, scrollRect.height);
			}

			if (!renderer.__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = true;
			}

			renderer.__popMaskObject(bitmap, false);
		}
		#end
	}

	public static function renderDrawable(bitmap:Bitmap, renderer:CanvasRenderer):Void
	{
		renderer.__updateCacheBitmap(bitmap, /*!__worldColorTransform.__isDefault ()*/ false);

		if (bitmap.__bitmapData != null && bitmap.__bitmapData.image != null)
		{
			bitmap.__imageVersion = bitmap.__bitmapData.image.version;
		}

		if (bitmap.__cacheBitmap != null && !bitmap.__isCacheBitmapRender)
		{
			CanvasBitmap.render(bitmap.__cacheBitmap, renderer);
		}
		else
		{
			CanvasDisplayObject.render(bitmap, renderer);
			CanvasBitmap.render(bitmap, renderer);
		}

		renderer.__renderEvent(bitmap);
	}

	public static function renderDrawableMask(bitmap:Bitmap, renderer:CanvasRenderer):Void
	{
		renderer.context.rect(0, 0, bitmap.width, bitmap.height);
	}
}
