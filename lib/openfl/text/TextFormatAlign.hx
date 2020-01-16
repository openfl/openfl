package openfl.text;

/**
 * The TextFormatAlign class provides values for text alignment in the
 * TextFormat class.
 */
@:enum abstract TextFormatAlign(String) from String to String
{
	/**
	 * Constant; centers the text in the text field. Use the syntax
	 * `TextFormatAlign.CENTER`.
	 */
	public var CENTER = "center";

	public var END = "end";

	/**
	 * Constant; justifies text within the text field. Use the syntax
	 * `TextFormatAlign.JUSTIFY`.
	 */
	public var JUSTIFY = "justify";

	/**
	 * Constant; aligns text to the left within the text field. Use the syntax
	 * `TextFormatAlign.LEFT`.
	 */
	public var LEFT = "left";

	/**
	 * Constant; aligns text to the right within the text field. Use the syntax
	 * `TextFormatAlign.RIGHT`.
	 */
	public var RIGHT = "right";

	public var START = "start";
}
