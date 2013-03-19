package flash.text;
#if (flash || display)


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
