/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


/**
 * The InterpolationMethod class provides values for the
 * <code>interpolationMethod</code> parameter in the
 * <code>Graphics.beginGradientFill()</code> and
 * <code>Graphics.lineGradientStyle()</code> methods. This parameter
 * determines the RGB space to use when rendering the gradient.
 */
@:fakeEnum(String) extern enum InterpolationMethod {

	/**
	 * Specifies that the RGB interpolation method should be used. This means
	 * that the gradient is rendered with exponential sRGB(standard RGB) space.
	 * The sRGB space is a W3C-endorsed standard that defines a non-linear
	 * conversion between red, green, and blue component values and the actual
	 * intensity of the visible component color.
	 *
	 * <p>For example, consider a simple linear gradient between two colors(with
	 * the <code>spreadMethod</code> parameter set to
	 * <code>SpreadMethod.REFLECT</code>). The different interpolation methods
	 * affect the appearance as follows: </p>
	 */
	LINEAR_RGB;

	/**
	 * Specifies that the RGB interpolation method should be used. This means
	 * that the gradient is rendered with exponential sRGB(standard RGB) space.
	 * The sRGB space is a W3C-endorsed standard that defines a non-linear
	 * conversion between red, green, and blue component values and the actual
	 * intensity of the visible component color.
	 *
	 * <p>For example, consider a simple linear gradient between two colors(with
	 * the <code>spreadMethod</code> parameter set to
	 * <code>SpreadMethod.REFLECT</code>). The different interpolation methods
	 * affect the appearance as follows: </p>
	 */
	RGB;
}


#end
