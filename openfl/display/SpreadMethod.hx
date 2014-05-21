/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


/**
 * The SpreadMethod class provides values for the <code>spreadMethod</code>
 * parameter in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the Graphics class.
 *
 * <p>The following example shows the same gradient fill using various spread
 * methods:</p>
 */
@:fakeEnum(String) extern enum SpreadMethod {

	/**
	 * Specifies that the gradient use the <i>pad</i> spread method.
	 */
	PAD;

	/**
	 * Specifies that the gradient use the <i>reflect</i> spread method.
	 */
	REFLECT;

	/**
	 * Specifies that the gradient use the <i>repeat</i> spread method.
	 */
	REPEAT;
}


#end
