package flash.filters;

#if flash
@:final extern class ColorMatrixFilter extends BitmapFilter
{
	#if (haxe_ver < 4.3)
	public var matrix:Array<Float>;
	#else
	@:flash.property var matrix(get, set):Array<Float>;
	#end

	public function new(matrix:Array<Float> = null);

	#if (haxe_ver >= 4.3)
	private function get_matrix():Array<Float>;
	private function set_matrix(value:Array<Float>):Array<Float>;
	#end
}
#else
typedef ColorMatrixFilter = openfl.filters.ColorMatrixFilter;
#end
