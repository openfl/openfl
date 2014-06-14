package openfl.filters; #if !flash


class BitmapFilterType {
	
	public static var FULL = "full";
	public static var INNER = "inner";
	public static var OUTER = "outer";
	
}


#else
typedef BitmapFilterType = flash.filters.BitmapFilterType;
#end