package openfl.display; #if !flash


/**
 * The GradientType class provides values for the <code>type</code> parameter
 * in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the openfl.display.Graphics
 * class.
 */
enum GradientType {
	
	/**
	 * Value used to specify a radial gradient fill.
	 */
	RADIAL;
	
	/**
	 * Value used to specify a linear gradient fill.
	 */
	LINEAR;
	
}


#else
typedef GradientType = flash.display.GradientType;
#end