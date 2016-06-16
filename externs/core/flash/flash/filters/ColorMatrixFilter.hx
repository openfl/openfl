package flash.filters; #if (!display && flash)


@:final extern class ColorMatrixFilter extends BitmapFilter {
	
	
	public var matrix (default, set):Array<Float>;
	
	
	public function new (matrix:Array<Float> = null);
	
	
}


#else
typedef ColorMatrixFilter = openfl.filters.ColorMatrixFilter;
#end