declare namespace openfl.display {
	
	/**
	 * The SpreadMethod class provides values for the `spreadMethod`
	 * parameter in the `beginGradientFill()` and
	 * `lineGradientStyle()` methods of the Graphics class.
	 *
	 * The following example shows the same gradient fill using various spread
	 * methods:
	 */
	export enum SpreadMethod {
		
		/**
		 * Specifies that the gradient use the _pad_ spread method.
		 */
		PAD = 0,
		
		/**
		 * Specifies that the gradient use the _reflect_ spread method.
		 */
		REFLECT = 1,
		
		/**
		 * Specifies that the gradient use the _repeat_ spread method.
		 */
		REPEAT = 2
		
	}
	
}


export default openfl.display.SpreadMethod;