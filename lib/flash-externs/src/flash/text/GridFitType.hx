package flash.text;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GridFitType(String) from String to String

{
	public var NONE = "none";
	public var PIXEL = "pixel";
	public var SUBPIXEL = "subpixel";
}
#else
typedef GridFitType = openfl.text.GridFitType;
#end
