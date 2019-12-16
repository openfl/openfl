package openfl.filters;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/filters/ColorMatrixFilter", "default")
#end
@:final extern class ColorMatrixFilter extends BitmapFilter
{
	public var matrix(default, set):Array<Float>;
	public function new(matrix:Array<Float> = null);
}
#else
typedef ColorMatrixFilter = flash.filters.ColorMatrixFilter;
#end
