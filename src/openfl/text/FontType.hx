package openfl.text; #if !openfljs


@:enum abstract FontType(Null<Int>) {
	
	public var DEVICE = 0;
	public var EMBEDDED = 1;
	public var EMBEDDED_CFF = 2;
	
	@:from private static function fromString (value:String):FontType {
		
		return switch (value) {
			
			case "device": DEVICE;
			case "embedded": EMBEDDED;
			case "embeddedCFF": EMBEDDED_CFF;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case FontType.DEVICE: "device";
			case FontType.EMBEDDED: "embedded";
			case FontType.EMBEDDED_CFF: "embeddedCFF";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract FontType(String) from String to String {
	
	public var DEVICE = "device";
	public var EMBEDDED = "embedded";
	public var EMBEDDED_CFF = "embeddedCFF";
	
}


#end