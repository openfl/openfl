package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageAlign(String) from String to String
{
	public var BOTTOM = "B";
	public var BOTTOM_LEFT = "BL";
	public var BOTTOM_RIGHT = "BR";
	public var LEFT = "L";
	public var RIGHT = "R";
	public var TOP = "T";
	public var TOP_LEFT = "TL";
	public var TOP_RIGHT = "TR";
}
#else
typedef StageAlign = openfl.display.StageAlign;
#end
