package openfl.display._internal;

#if lime
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoPattern;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.BitmapData)
class CairoBitmapData
{
	public static inline function renderDrawable(bitmapData:BitmapData, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		if (!bitmapData.readable) return;

		var cairo = renderer.cairo;

		renderer.applyMatrix(bitmapData.__renderTransform, cairo);

		var surface = bitmapData.getSurface();

		if (surface != null)
		{
			var pattern = CairoPattern.createForSurface(surface);

			if (!renderer.__allowSmoothing || cairo.antialias == NONE)
			{
				pattern.filter = CairoFilter.NEAREST;
			}
			else
			{
				pattern.filter = CairoFilter.GOOD;
			}

			cairo.source = pattern;
			cairo.paint();
		}
		#end
	}

	public static inline function renderDrawableMask(tilemap:Tilemap, renderer:CairoRenderer):Void {}
}
