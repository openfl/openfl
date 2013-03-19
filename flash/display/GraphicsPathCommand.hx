package flash.display;
#if (flash || display)


/**
 * Defines the values to use for specifying path-drawing commands.
 *
 * <p>The values in this class are used by the
 * <code>Graphics.drawPath()</code> method, or stored in the
 * <code>commands</code> vector of a GraphicsPath object.</p>
 */
@:fakeEnum(Int) extern enum GraphicsPathCommand {
	NO_OP;
	MOVE_TO;
	LINE_TO;
	CURVE_TO;
	WIDE_MOVE_TO;
	WIDE_LINE_TO;
	CUBIC_CURVE_TO;
}


#end
