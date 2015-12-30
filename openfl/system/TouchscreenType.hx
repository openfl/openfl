package openfl.system;


@:enum abstract TouchscreenType(Int) {
	
	public var FINGER = 0;
	public var NONE = 1;
	public var STYLUS = 2;
	
	@:from private static inline function fromString (value:String):TouchscreenType {
		
		return switch (value) {
			
			case "finger": FINGER;
			case "stylus": STYLUS;
			default: return NONE;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case TouchscreenType.FINGER: "finger";
			case TouchscreenType.STYLUS: "stylus";
			default: "none";
			
		}
		
	}
	
}