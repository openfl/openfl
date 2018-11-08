declare namespace openfl.display {
	
	/**
	 * The CapsStyle class is an enumeration of constant values that specify the
	 * caps style to use in drawing lines. The constants are provided for use as
	 * values in the `caps` parameter of the
	 * `openfl.display.Graphics.lineStyle()` method. You can specify the
	 * following three types of caps:
	 */
	export enum CapsStyle {
		
		/**
		 * Used to specify no caps in the `caps` parameter of the
		 * `openfl.display.Graphics.lineStyle()` method.
		 */
		NONE = "none",
		
		/**
		 * Used to specify round caps in the `caps` parameter of the
		 * `openfl.display.Graphics.lineStyle()` method.
		 */
		ROUND = "round",
		
		/**
		 * Used to specify square caps in the `caps` parameter of the
		 * `openfl.display.Graphics.lineStyle()` method.
		 */
		SQUARE = "square"
		
	}
	
}


export default openfl.display.CapsStyle;