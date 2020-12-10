package flash.filters;

#if flash
@:enum abstract BitmapFilterType(String) from String to String
{
	public var FULL = "full";
	public var INNER = "inner";
	public var OUTER = "outer";
}
#else
typedef BitmapFilterType = openfl.filters.BitmapFilterType;
#end
