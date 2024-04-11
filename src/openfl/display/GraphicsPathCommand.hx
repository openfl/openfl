package openfl.display;

#if !flash
/**
	Defines the values to use for specifying path-drawing commands.

	The values in this class are used by the
	`Graphics.drawPath()` method, or stored in the
	`commands` vector of a GraphicsPath object.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GraphicsPathCommand(Int) from Int to Int from UInt to UInt

{
	/**
		Specifies a drawing command that draws a curve from the current drawing position
		to the x- and y-coordinates specified in the data vector, using a 2 control points.
	**/
	public var CUBIC_CURVE_TO = 6;

	/**
		Specifies a drawing command that draws a curve from the current drawing position
		to the x- and y-coordinates specified in the data vector, using a control point.
		This command produces the same effect as the `Graphics.lineTo()` method, and uses
		two points in the data vector control and anchor: (cx, cy, ax, ay).
	**/
	public var CURVE_TO = 3;

	/**
		Specifies a drawing command that draws a line from the current drawing position to
		the x- and y-coordinates specified in the data vector. This command produces the
		same effect as the `Graphics.lineTo()` method, and uses one point in the data
		vector: (x,y).
	**/
	public var LINE_TO = 2;

	/**
		Specifies a drawing command that moves the current drawing position to the x- and
		y-coordinates specified in the data vector. This command produces the same effect as
		the `Graphics.moveTo()` method, and uses one point in the data vector: (x,y).
	**/
	public var MOVE_TO = 1;

	/**
		Represents the default "do nothing" command.
	**/
	public var NO_OP = 0;

	/**
		Specifies a "line to" drawing command, but uses two sets of coordinates (four
		values) instead of one set. This command allows you to switch between "line to"
		and "curve to" commands without changing the number of data values used per command.
		This command uses two sets in the data vector: one dummy location and one (x,y)
		location.

		The `WIDE_LINE_TO` and `WIDE_MOVE_TO` command variants consume the same number of
		parameters as does the `CURVE_TO` command.
	**/
	public var WIDE_LINE_TO = 5;

	/**
		Specifies a "move to" drawing command, but uses two sets of coordinates (four
		values) instead of one set. This command allows you to switch between "move to"
		and "curve to" commands without changing the number of data values used per
		command. This command uses two sets in the data vector: one dummy location and one
		(x,y) location.

		The `WIDE_LINE_TO` and `WIDE_MOVE_TO` command variants consume the same number of
		parameters as does the `CURVE_TO` command.
	**/
	public var WIDE_MOVE_TO = 4;
}
#else
typedef GraphicsPathCommand = flash.display.GraphicsPathCommand;
#end
