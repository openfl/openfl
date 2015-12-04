package openfl.text; #if (!display && !flash) #if !openfl_legacy


/**
 * The FontStyle class provides values for the TextRenderer class.
 */
enum FontStyle {
	
	REGULAR;
	ITALIC;
	BOLD_ITALIC;
	BOLD;
	
}


#else
typedef FontStyle = openfl._legacy.text.FontStyle;
#end
#else


/**
 * The FontStyle class provides values for the TextRenderer class.
 */

#if flash
@:native("flash.text.FontStyle")
#end

@:fakeEnum(String) extern enum FontStyle {
	
	/**
	 * Defines the plain style of a font for the <code>fontStyle</code> parameter
	 * in the <code>setAdvancedAntiAliasingTable()</code> method. Use the syntax
	 * <code>FontStyle.REGULAR</code>.
	 */
	REGULAR;
	
	/**
	 * Defines the italic style of a font for the <code>fontStyle</code>
	 * parameter in the <code>setAdvancedAntiAliasingTable()</code> method. Use
	 * the syntax <code>FontStyle.ITALIC</code>.
	 */
	ITALIC;
	
	/**
	 * Defines the italic style of a font for the <code>fontStyle</code>
	 * parameter in the <code>setAdvancedAntiAliasingTable()</code> method. Use
	 * the syntax <code>FontStyle.ITALIC</code>.
	 */
	BOLD_ITALIC;
	
	/**
	 * Defines the bold style of a font for the <code>fontStyle</code> parameter
	 * in the <code>setAdvancedAntiAliasingTable()</code> method. Use the syntax
	 * <code>FontStyle.BOLD</code>.
	 */
	BOLD;
	
}


#end