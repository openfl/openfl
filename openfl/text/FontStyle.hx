/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.text;
#if display


/**
 * The FontStyle class provides values for the TextRenderer class.
 */
@:fakeEnum(String) extern enum FontStyle {

	/**
	 * Defines the bold style of a font for the <code>fontStyle</code> parameter
	 * in the <code>setAdvancedAntiAliasingTable()</code> method. Use the syntax
	 * <code>FontStyle.BOLD</code>.
	 */
	BOLD;

	/**
	 * Defines the italic style of a font for the <code>fontStyle</code>
	 * parameter in the <code>setAdvancedAntiAliasingTable()</code> method. Use
	 * the syntax <code>FontStyle.ITALIC</code>.
	 */
	BOLD_ITALIC;

	/**
	 * Defines the italic style of a font for the <code>fontStyle</code>
	 * parameter in the <code>setAdvancedAntiAliasingTable()</code> method. Use
	 * the syntax <code>FontStyle.ITALIC</code>.
	 */
	ITALIC;

	/**
	 * Defines the plain style of a font for the <code>fontStyle</code> parameter
	 * in the <code>setAdvancedAntiAliasingTable()</code> method. Use the syntax
	 * <code>FontStyle.REGULAR</code>.
	 */
	REGULAR;
}


#end
