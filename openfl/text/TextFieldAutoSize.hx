package openfl.text; #if !openfl_legacy


@:enum abstract TextFieldAutoSize(Int) {
	
	public var CENTER = 0;
	public var LEFT = 1;
	public var NONE = 2;
	public var RIGHT = 3;
	
	@:from private static inline function fromString (value:String):TextFieldAutoSize {
		
		return switch (value) {
			
			case "center": CENTER;
			case "left": LEFT;
			case "right": RIGHT;
			default: return NONE;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case TextFieldAutoSize.CENTER: "center";
			case TextFieldAutoSize.LEFT: "left";
			case TextFieldAutoSize.RIGHT: "right";
			default: "none";
			
		}
		
	}
	
}

#else
typedef TextFieldAutoSize = openfl._legacy.text.TextFieldAutoSize;
#end