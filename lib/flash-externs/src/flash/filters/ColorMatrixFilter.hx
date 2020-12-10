package flash.filters;

#if flash
@:final extern class ColorMatrixFilter extends BitmapFilter
{
	public var matrix:Array<Float>;
	public function new(matrix:Array<Float> = null);
}
#else
typedef ColorMatrixFilter = openfl.filters.ColorMatrixFilter;
#end
