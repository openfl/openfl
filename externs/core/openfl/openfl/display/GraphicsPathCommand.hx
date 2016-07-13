package openfl.display;


/**
 * Defines the values to use for specifying path-drawing commands.
 *
 * <p>The values in this class are used by the
 * <code>Graphics.drawPath()</code> method, or stored in the
 * <code>commands</code> vector of a GraphicsPath object.</p>
 */
@:enum abstract GraphicsPathCommand(Int) from Int to Int {
	
	#if flash @:require(flash11) #end public var CUBIC_CURVE_TO = 6;
	public var CURVE_TO = 3;
	public var LINE_TO = 2;
	public var MOVE_TO = 1;
	public var NO_OP = 0;
	public var WIDE_LINE_TO = 5;
	public var WIDE_MOVE_TO = 4;
	
}