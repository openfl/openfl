package openfl.system;


@:enum abstract TouchscreenType(Null<Int>) {
	
	public var FINGER = 0;
	public var NONE = 1;
	public var STYLUS = 2;
	
	@:from private static function fromString (value:String):TouchscreenType {
		
		return switch (value) {
			
			case "finger": FINGER;
			case "none": NONE;
			case "stylus": STYLUS;
			default: null;
			
		}
		
	}
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case TouchscreenType.FINGER: "finger";
			case TouchscreenType.NONE: "none";
			case TouchscreenType.STYLUS: "stylus";
			default: null;
			
		}
		
	}
	
}