package flash.display;

#if flash
@:enum abstract BlendMode(String) from String to String
{
	public var ADD = "add";
	public var ALPHA = "alpha";
	public var DARKEN = "darken";
	public var DIFFERENCE = "difference";
	public var ERASE = "erase";
	public var HARDLIGHT = "hardlight";
	public var INVERT = "invert";
	public var LAYER = "layer";
	public var LIGHTEN = "lighten";
	public var MULTIPLY = "multiply";
	public var NORMAL = "normal";
	public var OVERLAY = "overlay";
	public var SCREEN = "screen";
	public var SHADER = "shader";
	public var SUBTRACT = "subtract";
}
#else
typedef BlendMode = openfl.display.BlendMode;
#end
