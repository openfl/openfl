package;

/**
 * Allocation counters for the visual repro. When built with
 * `-D openfl_count_surface_allocs` the values read from instrumented fields
 * in OpenFL; otherwise stay at zero so the demo runs on any target.
 *
 *  - `surfaceAllocs`     -> `CairoGraphics.__surfaceAllocs`
 *    (cached Cairo image surface for `Graphics.__bitmap`)
 *  - `cacheBitmapAllocs` -> `DisplayObjectRenderer.__cacheBitmapAllocs`
 *    (cacheAsBitmap / filters bitmap for `DisplayObject.__cacheBitmapData`)
 */
@:access(openfl.display._internal.CairoGraphics)
@:access(openfl.display.DisplayObjectRenderer)
class AllocCounter
{
	public static var surfaceAllocs(get, never):Int;
	public static var cacheBitmapAllocs(get, never):Int;

	static function get_surfaceAllocs():Int
	{
		#if openfl_count_surface_allocs
		return openfl.display._internal.CairoGraphics.__surfaceAllocs;
		#else
		return 0;
		#end
	}

	static function get_cacheBitmapAllocs():Int
	{
		#if openfl_count_surface_allocs
		return openfl.display.DisplayObjectRenderer.__cacheBitmapAllocs;
		#else
		return 0;
		#end
	}
}
