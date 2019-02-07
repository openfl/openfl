package openfl.display3D;

@:enum abstract Context3DBlendFactor(String) from String to String
{
	public var DESTINATION_ALPHA = "destinationAlpha";
	public var DESTINATION_COLOR = "destinationColor";
	public var ONE = "one";
	public var ONE_MINUS_DESTINATION_ALPHA = "oneMinusDestinationAlpha";
	public var ONE_MINUS_DESTINATION_COLOR = "oneMinusDestinationColor";
	public var ONE_MINUS_SOURCE_ALPHA = "oneMinusSourceAlpha";
	public var ONE_MINUS_SOURCE_COLOR = "oneMinusSourceColor";
	public var SOURCE_ALPHA = "sourceAlpha";
	public var SOURCE_COLOR = "sourceColor";
	public var ZERO = "zero";
}
