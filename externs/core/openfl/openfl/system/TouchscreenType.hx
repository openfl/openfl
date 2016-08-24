package openfl.system; #if (display || !flash)


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
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case TouchscreenType.FINGER: "finger";
			case TouchscreenType.NONE: "none";
			case TouchscreenType.STYLUS: "stylus";
			default: null;
			
		}
		
	}
	
}


#else
typedef TouchscreenType = flash.system.TouchscreenType;
#end