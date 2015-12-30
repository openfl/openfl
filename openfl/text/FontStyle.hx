package openfl.text; #if !openfl_legacy


@:enum abstract FontStyle(Int) {
	
	public var BOLD = 0;
	public var BOLD_ITALIC = 1;
	public var ITALIC = 2;
	public var REGULAR = 3;
	
	@:from private static inline function fromString (value:String):FontStyle {
		
		return switch (value) {
			
			case "bold": BOLD;
			case "boldItalic": BOLD_ITALIC;
			case "italic": ITALIC;
			default: return REGULAR;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case FontStyle.BOLD: "bold";
			case FontStyle.BOLD_ITALIC: "boldItalic";
			case FontStyle.ITALIC: "italic";
			default: "regular";
			
		}
		
	}
	
}


#else
typedef FontStyle = openfl._legacy.text.FontStyle;
#end