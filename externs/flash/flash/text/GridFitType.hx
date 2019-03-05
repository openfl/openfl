package flash.text;

#if flash
@:enum abstract GridFitType(String) from String to String
{
	public var NONE = "none";
	public var PIXEL = "pixel";
	public var SUBPIXEL = "subpixel";
}
#else
typedef GridFitType = openfl.text.GridFitType;
#end
