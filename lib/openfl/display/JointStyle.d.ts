declare namespace openfl.display {
	
	/**
	 * The JointStyle class is an enumeration of constant values that specify the
	 * joint style to use in drawing lines. These constants are provided for use
	 * as values in the `joints` parameter of the
	 * `openfl.display.Graphics.lineStyle()` method. The method supports
	 * three types of joints: miter, round, and bevel, as the following example
	 * shows:
	 */
	export enum JointStyle {
		
		/**
		 * Specifies beveled joints in the `joints` parameter of the
		 * `openfl.display.Graphics.lineStyle()` method.
		 */
		BEVEL = 0,
		
		/**
		 * Specifies mitered joints in the `joints` parameter of the
		 * `openfl.display.Graphics.lineStyle()` method.
		 */
		MITER = 1,
		
		/**
		 * Specifies round joints in the `joints` parameter of the
		 * `openfl.display.Graphics.lineStyle()` method.
		 */
		ROUND = 2
		
	}
	
}


export default openfl.display.JointStyle;