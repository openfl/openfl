/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


/**
 * The GradientType class provides values for the <code>type</code> parameter
 * in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the openfl.display.Graphics
 * class.
 */
@:fakeEnum(String) extern enum GradientType {

	/**
	 * Value used to specify a linear gradient fill.
	 */
	LINEAR;

	/**
	 * Value used to specify a radial gradient fill.
	 */
	RADIAL;
}


#end
