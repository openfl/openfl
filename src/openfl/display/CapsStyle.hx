package openfl.display;


@:enum abstract CapsStyle(Null<Int>) {
	
	public var NONE = 0;
	public var ROUND = 1;
	public var SQUARE = 2;
	
	@:from private static function fromString (value:String):CapsStyle {
		
		return switch (value) {
			
			case "none": NONE;
			case "round": ROUND;
			case "square": SQUARE;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case CapsStyle.NONE: "none";
			case CapsStyle.ROUND: "round";
			case CapsStyle.SQUARE: "square";
			default: null;
			
		}
		
	}
	
}