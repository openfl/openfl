package openfl.desktop; #if !openfl_legacy


@:enum abstract ClipboardFormats(Int) {
	
	public var HTML_FORMAT = 0;
	public var RICH_TEXT_FORMAT = 1;
	public var TEXT_FORMAT = 2;
	
	@:from private static inline function fromString (value:String):ClipboardFormats {
		
		return switch (value) {
			
			case "air:html": HTML_FORMAT;
			case "air:rtf": RICH_TEXT_FORMAT;
			default: return TEXT_FORMAT;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case ClipboardFormats.HTML_FORMAT: "air:html";
			case ClipboardFormats.RICH_TEXT_FORMAT: "air:rtf";
			default: "air:text";
			
		}
		
	}
	
}


#end