package openfl.display._internal;

#if openfl_html5
import openfl.display._CanvasRenderer;
import openfl.display.Bitmap;
import openfl.display._Bitmap;
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
		if (!(bitmap._ : _Bitmap).__renderable) return;

		var alpha = (renderer._ : _CanvasRenderer).__getAlpha((bitmap._ : _Bitmap).__worldAlpha);

		if (alpha > 0
			&& (bitmap._ : _Bitmap).__bitmapData != null
				&& ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__isValid && (bitmap._ : _Bitmap).__bitmapData.readable)
		{
			var context = renderer.context;

			(renderer._ : _CanvasRenderer).__setBlendMode((bitmap._ : _Bitmap).__worldBlendMode);
			(renderer._ : _CanvasRenderer).__pushMaskObject(bitmap, false);

			context.globalAlpha = alpha;
			var scrollRect = (bitmap._ : _Bitmap).__scrollRect;

			renderer.setTransform((bitmap._ : _Bitmap).__renderTransform, context);

			if (!(renderer._ : _CanvasRenderer).__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = false;
			}

			if (scrollRect == null)
			{
				context.drawImage(((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getElement(), 0, 0, (bitmap._ : _Bitmap).__bitmapData.width,
					(bitmap._ : _Bitmap).__bitmapData.height);
			}
			else
			{
				context.save();

				context.beginPath();
				context.rect(scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				context.clip();

				context.drawImage(((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getElement(), 0, 0, (bitmap._ : _Bitmap).__bitmapData.width,
					(bitmap._ : _Bitmap).__bitmapData.height);

				context.restore();
			}

			if (!(renderer._ : _CanvasRenderer).__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = true;
			}

				(renderer._ : _CanvasRenderer).__popMaskObject(bitmap, false);
		}
		#end
	}
}
#end
