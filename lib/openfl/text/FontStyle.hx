package openfl.text; #if (display || !flash)


/**
 * The FontStyle class provides values for the TextRenderer class.
 */
@:enum abstract FontStyle(Null<Int>) {
	
	/**
	 * Defines the bold style of a font for the `fontStyle` parameter
	 * in the `setAdvancedAntiAliasingTable()` method. Use the syntax
	 * `FontStyle.BOLD`.
	 */
	public var BOLD = 0;
	
	/**
	 * Defines the italic style of a font for the `fontStyle`
	 * parameter in the `setAdvancedAntiAliasingTable()` method. Use
	 * the syntax `FontStyle.ITALIC`.
	 */
	public var BOLD_ITALIC = 1;
	
	/**
	 * Defines the italic style of a font for the `fontStyle`
	 * parameter in the `setAdvancedAntiAliasingTable()` method. Use
	 * the syntax `FontStyle.ITALIC`.
	 */
	public var ITALIC = 2;
	
	/**
	 * Defines the plain style of a font for the `fontStyle` parameter
	 * in the `setAdvancedAntiAliasingTable()` method. Use the syntax
	 * `FontStyle.REGULAR`.
	 */
	public var REGULAR = 3;
	
	@:from private static function fromString (value:String):FontStyle {
		
		return switch (value) {
			
			case "bold": BOLD;
			case "boldItalic": BOLD_ITALIC;
			case "italic": ITALIC;
			case "regular": REGULAR;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case FontStyle.BOLD: "bold";
			case FontStyle.BOLD_ITALIC: "boldItalic";
			case FontStyle.ITALIC: "italic";
			case FontStyle.REGULAR: "regular";
			default: null;
			
		}
		
	}
	
}


#else
typedef FontStyle = flash.text.FontStyle;
#end