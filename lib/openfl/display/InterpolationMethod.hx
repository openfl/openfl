package openfl.display; #if (display || !flash)


/**
 * The InterpolationMethod class provides values for the
 * `interpolationMethod` parameter in the
 * `Graphics.beginGradientFill()` and
 * `Graphics.lineGradientStyle()` methods. This parameter
 * determines the RGB space to use when rendering the gradient.
 */
@:enum abstract InterpolationMethod(Null<Int>) {
	
	/**
	 * Specifies that the RGB interpolation method should be used. This means
	 * that the gradient is rendered with exponential sRGB(standard RGB) space.
	 * The sRGB space is a W3C-endorsed standard that defines a non-linear
	 * conversion between red, green, and blue component values and the actual
	 * intensity of the visible component color.
	 *
	 * For example, consider a simple linear gradient between two colors(with
	 * the `spreadMethod` parameter set to
	 * `SpreadMethod.REFLECT`). The different interpolation methods
	 * affect the appearance as follows: 
	 */
	public var LINEAR_RGB = 0;
	
	/**
	 * Specifies that the RGB interpolation method should be used. This means
	 * that the gradient is rendered with exponential sRGB(standard RGB) space.
	 * The sRGB space is a W3C-endorsed standard that defines a non-linear
	 * conversion between red, green, and blue component values and the actual
	 * intensity of the visible component color.
	 *
	 * For example, consider a simple linear gradient between two colors(with
	 * the `spreadMethod` parameter set to
	 * `SpreadMethod.REFLECT`). The different interpolation methods
	 * affect the appearance as follows: 
	 */
	public var RGB = 1;
	
	@:from private static function fromString (value:String):InterpolationMethod {
		
		return switch (value) {
			
			case "linearRGB": LINEAR_RGB;
			case "rgb": RGB;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case InterpolationMethod.LINEAR_RGB: "linearRGB";
			case InterpolationMethod.RGB: "rgb";
			default: null;
			
		}
		
	}
	
}


#else
typedef InterpolationMethod = flash.display.InterpolationMethod;
#end