package openfl.display;


/**
 * The SpreadMethod class provides values for the `spreadMethod`
 * parameter in the `beginGradientFill()` and
 * `lineGradientStyle()` methods of the Graphics class.
 *
 * The following example shows the same gradient fill using various spread
 * methods:
 */
@:enum abstract SpreadMethod(String) from String to String {
	
	/**
	 * Specifies that the gradient use the _pad_ spread method.
	 */
	public var PAD = "pad";
	
	/**
	 * Specifies that the gradient use the _reflect_ spread method.
	 */
	public var REFLECT = "reflect";
	
	/**
	 * Specifies that the gradient use the _repeat_ spread method.
	 */
	public var REPEAT = "repeat";
	
}