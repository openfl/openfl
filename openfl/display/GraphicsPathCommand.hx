package openfl.display; #if (!display && !flash)


class GraphicsPathCommand {
	
	public static inline var LINE_TO = 2;
	public static inline var MOVE_TO = 1;
	public static inline var CURVE_TO = 3;
	public static inline var WIDE_LINE_TO = 5;
	public static inline var WIDE_MOVE_TO = 4;
	public static inline var NO_OP = 0;
	public static inline var CUBIC_CURVE_TO = 6;
	
}


#else


/**
 * Defines the values to use for specifying path-drawing commands.
 *
 * <p>The values in this class are used by the
 * <code>Graphics.drawPath()</code> method, or stored in the
 * <code>commands</code> vector of a GraphicsPath object.</p>
 */

#if flash
@:native("flash.display.GraphicsPathCommand")
#end

extern class GraphicsPathCommand {
	
	public static inline var LINE_TO = 2;
	public static inline var MOVE_TO = 1;
	public static inline var CURVE_TO = 3;
	#if flash @:require(flash11) #end public static inline var CUBIC_CURVE_TO = 6;
	public static inline var WIDE_LINE_TO = 5;
	public static inline var WIDE_MOVE_TO = 4;
	public static inline var NO_OP = 0;
	
}


#end