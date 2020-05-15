package openfl.display._internal;

#if openfl_cairo
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoPattern;
import openfl.display.Bitmap;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.ImageBuffer)
@:access(openfl.display._internal)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class CairoBitmap
{
	public static inline function render(bitmap:Bitmap, renderer:CairoRenderer):Void
	{
		if (!(bitmap._ : _Bitmap).__renderable) return;

		var alpha = (renderer._ : _CairoRenderer).__getAlpha((bitmap._ : _Bitmap).__worldAlpha);
		// var colorTransform = (renderer._ : _CairoRenderer).__getColorTransform ((bitmap._ : _Bitmap).__worldColorTransform);
		// var blendMode = (renderer._ : _CairoRenderer).__getBlendMode ((bitmap._ : _Bitmap).__worldBlendMode);

		if (alpha > 0 && (bitmap._ : _Bitmap).__bitmapData != null && ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__isValid)
		{
			var cairo = renderer.cairo;

			(renderer._ : _CairoRenderer).__setBlendMode((bitmap._ : _Bitmap).__worldBlendMode);
			(renderer._ : _CairoRenderer).__pushMaskObject(bitmap);

			renderer.applyMatrix((bitmap._ : _Bitmap).__renderTransform, cairo);

			var surface = (bitmap._ : _Bitmap).__bitmapData.getSurface();

			if (surface != null)
			{
				var pattern = CairoPattern.createForSurface(surface);
				pattern.filter = ((renderer._ : _CairoRenderer).__allowSmoothing && bitmap.smoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;

				cairo.source = pattern;

				if (alpha == 1)
				{
					cairo.paint();
				}
				else
				{
					cairo.paintWithAlpha(alpha);
				}
			}

				(renderer._ : _CairoRenderer).__popMaskObject(bitmap);

			// TODO: Find cause of leaking blend modes?
			(renderer._ : _CairoRenderer).__setBlendMode(NORMAL);
		}
	}
}
#end
