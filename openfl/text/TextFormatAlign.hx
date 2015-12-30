package openfl.text; #if !openfl_legacy


@:enum abstract TextFormatAlign(Int) {
	
	public var CENTER = 0;
	public var END = 1;
	public var JUSTIFY = 2;
	public var LEFT = 3;
	public var RIGHT = 4;
	public var START = 5;
	
	@:from private static inline function fromString (value:String):TextFormatAlign {
		
		return switch (value) {
			
			case "center": CENTER;
			case "end": END;
			case "justify": JUSTIFY;
			case "right": RIGHT;
			case "start": START;
			default: return LEFT;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case TextFormatAlign.CENTER: "center";
			case TextFormatAlign.END: "end";
			case TextFormatAlign.JUSTIFY: "justify";
			case TextFormatAlign.RIGHT: "right";
			case TextFormatAlign.START: "start";
			default: "left";
			
		}
		
	}
	
}


#else
typedef TextFormatAlign = openfl._legacy.text.TextFormatAlign;
#end