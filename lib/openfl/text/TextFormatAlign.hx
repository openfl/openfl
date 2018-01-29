package openfl.text; #if (display || !flash)


/**
 * The TextFormatAlign class provides values for text alignment in the
 * TextFormat class.
 */
@:enum abstract TextFormatAlign(Null<Int>) {
	
	/**
	 * Constant; centers the text in the text field. Use the syntax
	 * `TextFormatAlign.CENTER`.
	 */
	public var CENTER = 0;
	
	public var END = 1;
	
	/**
	 * Constant; justifies text within the text field. Use the syntax
	 * `TextFormatAlign.JUSTIFY`.
	 */
	public var JUSTIFY = 2;
	
	/**
	 * Constant; aligns text to the left within the text field. Use the syntax
	 * `TextFormatAlign.LEFT`.
	 */
	public var LEFT = 3;
	
	/**
	 * Constant; aligns text to the right within the text field. Use the syntax
	 * `TextFormatAlign.RIGHT`.
	 */
	public var RIGHT = 4;
	
	public var START = 5;
	
	@:from private static function fromString (value:String):TextFormatAlign {
		
		return switch (value) {
			
			case "center": CENTER;
			case "end": END;
			case "justify": JUSTIFY;
			case "left": LEFT;
			case "right": RIGHT;
			case "start": START;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case TextFormatAlign.CENTER: "center";
			case TextFormatAlign.END: "end";
			case TextFormatAlign.JUSTIFY: "justify";
			case TextFormatAlign.LEFT: "left";
			case TextFormatAlign.RIGHT: "right";
			case TextFormatAlign.START: "start";
			default: null;
			
		}
		
	}
	
}


#else
typedef TextFormatAlign = flash.text.TextFormatAlign;
#end