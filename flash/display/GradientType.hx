package flash.display;
#if (flash || display)


/**
 * The GradientType class provides values for the <code>type</code> parameter
 * in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the flash.display.Graphics
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
