package openfl.text; #if !openfljs


@:enum abstract FontStyle(Null<Int>) {
	
	public var BOLD = 0;
	public var BOLD_ITALIC = 1;
	public var ITALIC = 2;
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


@:enum abstract FontStyle(String) from String to String {
	
	public var BOLD = "bold";
	public var BOLD_ITALIC = "boldItalic";
	public var ITALIC = "italic";
	public var REGULAR = "regular";
	
}


#end