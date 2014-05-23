package openfl.filters;


#if display
@:final extern class ColorMatrixFilter extends BitmapFilter {
	var matrix : Array<Dynamic>;
	function new(?matrix : Array<Dynamic>) : Void;
}
#end