package openfl.display; #if !flash


/**
 * Defines the values to use for specifying path-drawing commands.
 *
 * The values in this class are used by the
 * `Graphics.drawPath()` method, or stored in the
 * `commands` vector of a GraphicsPath object.
 */
@:enum abstract GraphicsPathCommand(Int) from Int to Int from UInt to UInt {
	
	public var CUBIC_CURVE_TO = 6;
	public var CURVE_TO = 3;
	public var LINE_TO = 2;
	public var MOVE_TO = 1;
	public var NO_OP = 0;
	public var WIDE_LINE_TO = 5;
	public var WIDE_MOVE_TO = 4;
	
}


#else
typedef GraphicsPathCommand = flash.display.GraphicsPathCommand;
#end