package openfl.display;

/**
 * The GradientType class provides values for the `type` parameter
 * in the `beginGradientFill()` and
 * `lineGradientStyle()` methods of the openfl.display.Graphics
 * class.
 */
@:enum abstract GradientType(String) from String to String
{
	/**
	 * Value used to specify a linear gradient fill.
	 */
	public var LINEAR = "linear";

	/**
	 * Value used to specify a radial gradient fill.
	 */
	public var RADIAL = "radial";
}
