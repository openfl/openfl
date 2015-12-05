package openfl.display; #if (!display && !flash)


enum GradientType {
	
	RADIAL;
	LINEAR;
	
}


#else


/**
 * The GradientType class provides values for the <code>type</code> parameter
 * in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the openfl.display.Graphics
 * class.
 */

#if flash
@:native("flash.display.GradientType")
#end

@:fakeEnum(String) extern enum GradientType {
	
	/**
	 * Value used to specify a radial gradient fill.
	 */
	RADIAL;
	
	/**
	 * Value used to specify a linear gradient fill.
	 */
	LINEAR;
	
}


#end