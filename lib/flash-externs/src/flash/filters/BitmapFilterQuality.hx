package flash.filters;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract BitmapFilterQuality(Int) from Int to Int from UInt to UInt

{
	public var HIGH = 3;
	public var MEDIUM = 2;
	public var LOW = 1;
}
#else
typedef BitmapFilterQuality = openfl.filters.BitmapFilterQuality;
#end
