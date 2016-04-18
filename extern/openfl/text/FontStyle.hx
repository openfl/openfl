package openfl.text;


/**
 * The FontStyle class provides values for the TextRenderer class.
 */
@:enum abstract FontStyle(String) from String to String {
	
	/**
	 * Defines the bold style of a font for the <code>fontStyle</code> parameter
	 * in the <code>setAdvancedAntiAliasingTable()</code> method. Use the syntax
	 * <code>FontStyle.BOLD</code>.
	 */
	public var BOLD = "bold";
	
	/**
	 * Defines the italic style of a font for the <code>fontStyle</code>
	 * parameter in the <code>setAdvancedAntiAliasingTable()</code> method. Use
	 * the syntax <code>FontStyle.ITALIC</code>.
	 */
	public var BOLD_ITALIC = "boldItalic";
	
	/**
	 * Defines the italic style of a font for the <code>fontStyle</code>
	 * parameter in the <code>setAdvancedAntiAliasingTable()</code> method. Use
	 * the syntax <code>FontStyle.ITALIC</code>.
	 */
	public var ITALIC = "italic";
	
	/**
	 * Defines the plain style of a font for the <code>fontStyle</code> parameter
	 * in the <code>setAdvancedAntiAliasingTable()</code> method. Use the syntax
	 * <code>FontStyle.REGULAR</code>.
	 */
	public var REGULAR = "regular";
	
}