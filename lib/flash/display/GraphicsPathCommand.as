package flash.display {
	
	
	/**
	 * @externs
	 * Defines the values to use for specifying path-drawing commands.
	 *
	 * The values in this class are used by the
	 * `Graphics.drawPath()` method, or stored in the
	 * `commands` vector of a GraphicsPath object.
	 */
	final public class GraphicsPathCommand {
		
		public static const CUBIC_CURVE_TO:uint = 6;
		public static const CURVE_TO:uint = 3;
		public static const LINE_TO:uint = 2;
		public static const MOVE_TO:uint = 1;
		public static const NO_OP:uint = 0;
		public static const WIDE_LINE_TO:uint = 5;
		public static const WIDE_MOVE_TO:uint = 4;
		
	}
	
	
}