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
		if (!bitmap._.__renderable) return;

		var alpha = renderer._.__getAlpha(bitmap._.__worldAlpha);
		// var colorTransform = renderer._.__getColorTransform (bitmap._.__worldColorTransform);
		// var blendMode = renderer._.__getBlendMode (bitmap._.__worldBlendMode);

		if (alpha > 0 && bitmap._.__bitmapData != null && bitmap._.__bitmapData._.__isValid)
		{
			var cairo = renderer.cairo;

			renderer._.__setBlendMode(bitmap._.__worldBlendMode);
			renderer._.__pushMaskObject(bitmap);

			renderer.applyMatrix(bitmap._.__renderTransform, cairo);

			var surface = bitmap._.__bitmapData.getSurface();

			if (surface != null)
			{
				var pattern = CairoPattern.createForSurface(surface);
				pattern.filter = (renderer._.__allowSmoothing && bitmap.smoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;

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

			renderer._.__popMaskObject(bitmap);

			// TODO: Find cause of leaking blend modes?
			renderer._.__setBlendMode(NORMAL);
		}
	}
}
#end
