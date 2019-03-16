package openfl.text;

/**
 * The FontStyle class provides values for the TextRenderer class.
 */
@:enum abstract FontStyle(String) from String to String
{
	/**
	 * Defines the bold style of a font for the `fontStyle` parameter
	 * in the `setAdvancedAntiAliasingTable()` method. Use the syntax
	 * `FontStyle.BOLD`.
	 */
	public var BOLD = "bold";

	/**
	 * Defines the italic style of a font for the `fontStyle`
	 * parameter in the `setAdvancedAntiAliasingTable()` method. Use
	 * the syntax `FontStyle.ITALIC`.
	 */
	public var BOLD_ITALIC = "boldItalic";

	/**
	 * Defines the italic style of a font for the `fontStyle`
	 * parameter in the `setAdvancedAntiAliasingTable()` method. Use
	 * the syntax `FontStyle.ITALIC`.
	 */
	public var ITALIC = "italic";

	/**
	 * Defines the plain style of a font for the `fontStyle` parameter
	 * in the `setAdvancedAntiAliasingTable()` method. Use the syntax
	 * `FontStyle.REGULAR`.
	 */
	public var REGULAR = "regular";
}
