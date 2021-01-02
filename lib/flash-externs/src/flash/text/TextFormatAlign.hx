package flash.text;

#if flash
@:enum abstract TextFormatAlign(String) from String to String
{
	public var CENTER = "center";
	public var END = "end";
	public var JUSTIFY = "justify";
	public var LEFT = "left";
	public var RIGHT = "right";
	public var START = "start";
}
#else
typedef TextFormatAlign = openfl.text.TextFormatAlign;
#end
