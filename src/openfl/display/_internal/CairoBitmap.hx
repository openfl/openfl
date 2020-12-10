package openfl.display._internal;

import openfl.display.Bitmap;
import openfl.display.CairoRenderer;
#if lime
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoPattern;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class CairoBitmap
{
	public static inline function render(bitmap:Bitmap, renderer:CairoRenderer):Void
	{
		#if lime
		if (!bitmap.__renderable) return;

		var alpha = renderer.__getAlpha(bitmap.__worldAlpha);
		// var colorTransform = renderer.__getColorTransform (bitmap.__worldColorTransform);
		// var blendMode = renderer.__getBlendMode (bitmap.__worldBlendMode);

		if (alpha > 0 && bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid)
		{
			var cairo = renderer.cairo;

			renderer.__setBlendMode(bitmap.__worldBlendMode);
			renderer.__pushMaskObject(bitmap);

			renderer.applyMatrix(bitmap.__renderTransform, cairo);

			var surface = bitmap.__bitmapData.getSurface();

			if (surface != null)
			{
				var pattern = CairoPattern.createForSurface(surface);
				pattern.filter = (renderer.__allowSmoothing && bitmap.smoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;

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

			renderer.__popMaskObject(bitmap);

			// TODO: Find cause of leaking blend modes?
			renderer.__setBlendMode(NORMAL);
		}
		#end
	}

	public static inline function renderDrawable(bitmap:Bitmap, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		renderer.__updateCacheBitmap(bitmap, /*!__worldColorTransform.__isDefault ()*/ false);

		var __bitmapData = bitmap.__bitmapData;
		var __cacheBitmap = bitmap.__cacheBitmap;

		if (__bitmapData != null && __bitmapData.image != null)
		{
			bitmap.__imageVersion = __bitmapData.image.version;
		}

		if (__cacheBitmap != null && !bitmap.__isCacheBitmapRender)
		{
			CairoBitmap.render(__cacheBitmap, renderer);
		}
		else
		{
			CairoDisplayObject.render(bitmap, renderer);
			CairoBitmap.render(bitmap, renderer);
		}

		renderer.__renderEvent(bitmap);
		#end
	}

	public static inline function renderDrawableMask(bitmap:Bitmap, renderer:CairoRenderer):Void
	{
		renderer.cairo.rectangle(0, 0, bitmap.width, bitmap.height);
	}
}
