package flash.text;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract TextFieldAutoSize(String) from String to String

{
	public var CENTER = "center";
	public var LEFT = "left";
	public var NONE = "none";
	public var RIGHT = "right";
}
#else
typedef TextFieldAutoSize = openfl.text.TextFieldAutoSize;
#end
