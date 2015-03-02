package openfl.display; #if !flash #if !lime_legacy


/**
 * The SpreadMethod class provides values for the <code>spreadMethod</code>
 * parameter in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the Graphics class.
 *
 * <p>The following example shows the same gradient fill using various spread
 * methods:</p>
 */
enum SpreadMethod {
	
	/**
	 * Specifies that the gradient use the <i>repeat</i> spread method.
	 */
	REPEAT;
	
	/**
	 * Specifies that the gradient use the <i>reflect</i> spread method.
	 */
	REFLECT;
	
	/**
	 * Specifies that the gradient use the <i>pad</i> spread method.
	 */
	PAD;
	
}


#else
typedef SpreadMethod = openfl._v2.display.SpreadMethod;
#end
#else
typedef SpreadMethod = flash.display.SpreadMethod;
#end