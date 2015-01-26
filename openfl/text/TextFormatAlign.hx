package openfl.text; #if !flash #if !lime_legacy


/**
 * The TextFormatAlign class provides values for text alignment in the
 * TextFormat class.
 */
enum TextFormatAlign {
	
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
	
	/**
	 * Constant; justifies text within the text field. Use the syntax
	 * <code>TextFormatAlign.JUSTIFY</code>.
	 */
	JUSTIFY;
	
	/**
	 * Constant; centers the text in the text field. Use the syntax
	 * <code>TextFormatAlign.CENTER</code>.
	 */
	CENTER;
	
}


#else
typedef TextFormatAlign = openfl._v2.text.TextFormatAlign;
#end
#else
typedef TextFormatAlign = flash.text.TextFormatAlign;
#end