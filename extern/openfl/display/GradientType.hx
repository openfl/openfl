package openfl.display;


/**
 * The GradientType class provides values for the <code>type</code> parameter
 * in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the openfl.display.Graphics
 * class.
 */
@:enum abstract GradientType(String) from String to String {
	
	/**
	 * Value used to specify a linear gradient fill.
	 */
	public var LINEAR = "linear";
	
	/**
	 * Value used to specify a radial gradient fill.
	 */
	public var RADIAL = "radial";
	
}