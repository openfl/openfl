package openfl.ui;


@:enum abstract MultitouchInputMode(Int) {
	
	public var GESTURE = 0;
	public var NONE = 1;
	public var TOUCH_POINT = 2;
	
	@:from private static inline function fromString (value:String):MultitouchInputMode {
		
		return switch (value) {
			
			case "gesture": GESTURE;
			case "touchPoint": TOUCH_POINT;
			default: return NONE;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case MultitouchInputMode.GESTURE: "gesture";
			case MultitouchInputMode.TOUCH_POINT: "touchPoint";
			default: "none";
			
		}
		
	}
	
}