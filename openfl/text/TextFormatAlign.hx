package openfl.text; #if (!display && !flash) #if !openfl_legacy


enum TextFormatAlign {
	
	LEFT;
	RIGHT;
	JUSTIFY;
	CENTER;
	
}


#else
typedef TextFormatAlign = openfl._legacy.text.TextFormatAlign;
#end
#else


/**
 * The TextFormatAlign class provides values for text alignment in the
 * TextFormat class.
 */

#if flash
@:native("flash.text.TextFormatAlign")
#end


@:fakeEnum(String) extern enum TextFormatAlign {
	
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
	
	#if (flash && !doc_gen)
	@:noCompletion @:dox(hide) END;
	#end
	
	#if (flash && !doc_gen)
	@:noCompletion @:dox(hide) START;
	#end
	
	
}


#end