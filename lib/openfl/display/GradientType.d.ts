declare namespace openfl.display {
	
	/**
	 * The GradientType class provides values for the `type` parameter
	 * in the `beginGradientFill()` and
	 * `lineGradientStyle()` methods of the openfl.display.Graphics
	 * class.
	 */
	export enum GradientType {
		
		/**
		 * Value used to specify a linear gradient fill.
		 */
		LINEAR = 0,
		
		/**
		 * Value used to specify a radial gradient fill.
		 */
		RADIAL = 1
		
	}
	
}


export default openfl.display.GradientType;