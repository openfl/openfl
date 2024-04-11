package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageAlign(String) from String to String

{
	public var BOTTOM = "bottom";
	public var BOTTOM_LEFT = "bottomLeft";
	public var BOTTOM_RIGHT = "bottomRight";
	public var LEFT = "left";
	public var RIGHT = "right";
	public var TOP = "top";
	public var TOP_LEFT = "topLeft";
	public var TOP_RIGHT = "topRight";
}
#else
typedef StageAlign = openfl.display.StageAlign;
#end
