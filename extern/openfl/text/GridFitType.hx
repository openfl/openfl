package openfl.text;


#if flash
@:native("flash.text.GridFitType")
#end

@:enum abstract GridFitType(String) from String to String {
	
	public var NONE = "none";
	public var PIXEL = "pixel";
	public var SUBPIXEL = "subpixel";
	
}