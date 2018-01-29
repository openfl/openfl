package openfl.text; #if (display || !flash)


/**
 * The TextFieldAutoSize class is an enumeration of constant values used in
 * setting the `autoSize` property of the TextField class.
 */
@:enum abstract TextFieldAutoSize(Null<Int>) {
	
	/**
	 * Specifies that the text is to be treated as center-justified text. Any
	 * resizing of a single line of a text field is equally distributed to both
	 * the right and left sides.
	 */
	public var CENTER = 0;
	
	/**
	 * Specifies that the text is to be treated as left-justified text, meaning
	 * that the left side of the text field remains fixed and any resizing of a
	 * single line is on the right side.
	 */
	public var LEFT = 1;
	
	/**
	 * Specifies that no resizing is to occur.
	 */
	public var NONE = 2;
	
	/**
	 * Specifies that the text is to be treated as right-justified text, meaning
	 * that the right side of the text field remains fixed and any resizing of a
	 * single line is on the left side.
	 */
	public var RIGHT = 3;
	
	@:from private static function fromString (value:String):TextFieldAutoSize {
		
		return switch (value) {
			
			case "center": CENTER;
			case "left": LEFT;
			case "none": NONE;
			case "right": RIGHT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case TextFieldAutoSize.CENTER: "center";
			case TextFieldAutoSize.LEFT: "left";
			case TextFieldAutoSize.NONE: "none";
			case TextFieldAutoSize.RIGHT: "right";
			default: null;
			
		}
		
	}
	
}


#else
typedef TextFieldAutoSize = flash.text.TextFieldAutoSize;
#end