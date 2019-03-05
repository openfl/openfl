package openfl.filters;

#if (display || !flash)
@:jsRequire("openfl/filters/ColorMatrixFilter", "default")
@:final extern class ColorMatrixFilter extends BitmapFilter
{
	public var matrix(default, set):Array<Float>;
	public function new(matrix:Array<Float> = null);
}
#else
typedef ColorMatrixFilter = flash.filters.ColorMatrixFilter;
#end
