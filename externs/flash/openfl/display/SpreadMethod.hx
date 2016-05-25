package openfl.display;


/**
 * The SpreadMethod class provides values for the <code>spreadMethod</code>
 * parameter in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the Graphics class.
 *
 * <p>The following example shows the same gradient fill using various spread
 * methods:</p>
 */
@:enum abstract SpreadMethod(String) from String to String {
	
	/**
	 * Specifies that the gradient use the <i>pad</i> spread method.
	 */
	public var PAD = "pad";
	
	/**
	 * Specifies that the gradient use the <i>reflect</i> spread method.
	 */
	public var REFLECT = "reflect";
	
	/**
	 * Specifies that the gradient use the <i>repeat</i> spread method.
	 */
	public var REPEAT = "repeat";
	
}