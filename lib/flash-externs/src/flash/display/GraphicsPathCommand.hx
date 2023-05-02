package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GraphicsPathCommand(Int) from Int to Int from UInt to UInt

{
	public var CUBIC_CURVE_TO = 6;
	public var CURVE_TO = 3;
	public var LINE_TO = 2;
	public var MOVE_TO = 1;
	public var NO_OP = 0;
	public var WIDE_LINE_TO = 5;
	public var WIDE_MOVE_TO = 4;
}
#else
typedef GraphicsPathCommand = openfl.display.GraphicsPathCommand;
#end
