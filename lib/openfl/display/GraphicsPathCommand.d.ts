declare namespace openfl.display {
	
	/**
	 * Defines the values to use for specifying path-drawing commands.
	 *
	 * The values in this class are used by the
	 * `Graphics.drawPath()` method, or stored in the
	 * `commands` vector of a GraphicsPath object.
	 */
	export enum GraphicsPathCommand {
		
		CUBIC_CURVE_TO = 6,
		CURVE_TO = 3,
		LINE_TO = 2,
		MOVE_TO = 1,
		NO_OP = 0,
		WIDE_LINE_TO = 5,
		WIDE_MOVE_TO = 4
		
	}
	
}


export default openfl.display.GraphicsPathCommand;