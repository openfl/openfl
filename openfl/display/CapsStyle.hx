package openfl.display; #if !openfl_legacy


@:enum abstract CapsStyle(Int) {
	
	public var NONE = 0;
	public var ROUND = 1;
	public var SQUARE = 2;
	
	@:from private static inline function fromString (value:String):CapsStyle {
		
		return switch (value) {
			
			case "round": ROUND;
			case "square": SQUARE;
			default: return NONE;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case CapsStyle.ROUND: "round";
			case CapsStyle.SQUARE: "square";
			default: "none";
			
		}
		
	}
	
}


#else
typedef CapsStyle = openfl._legacy.display.CapsStyle;
#end