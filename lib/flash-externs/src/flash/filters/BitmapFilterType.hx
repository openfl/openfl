package flash.filters;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract BitmapFilterType(String) from String to String

{
	public var FULL = "full";
	public var INNER = "inner";
	public var OUTER = "outer";
}
#else
typedef BitmapFilterType = openfl.filters.BitmapFilterType;
#end
