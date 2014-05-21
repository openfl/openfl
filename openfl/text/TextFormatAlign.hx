/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.text;
#if display


/**
 * The TextFormatAlign class provides values for text alignment in the
 * TextFormat class.
 */
@:fakeEnum(String) extern enum TextFormatAlign {

	/**
	 * Constant; centers the text in the text field. Use the syntax
	 * <code>TextFormatAlign.CENTER</code>.
	 */
	CENTER;

	/**
	 * Constant; justifies text within the text field. Use the syntax
	 * <code>TextFormatAlign.JUSTIFY</code>.
	 */
	JUSTIFY;

	/**
	 * Constant; aligns text to the left within the text field. Use the syntax
	 * <code>TextFormatAlign.LEFT</code>.
	 */
	LEFT;

	/**
	 * Constant; aligns text to the right within the text field. Use the syntax
	 * <code>TextFormatAlign.RIGHT</code>.
	 */
	RIGHT;
}


#end
