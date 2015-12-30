package openfl.text; #if !openfl_legacy


@:enum abstract FontType(Int) {
	
	public var DEVICE = 0;
	public var EMBEDDED = 1;
	public var EMBEDDED_CFF = 2;
	
	@:from private static inline function fromString (value:String):FontType {
		
		return switch (value) {
			
			case "embedded": EMBEDDED;
			case "embeddedCFF": EMBEDDED_CFF;
			default: return DEVICE;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case FontType.EMBEDDED: "embedded";
			case FontType.EMBEDDED_CFF: "embeddedCFF";
			default: "device";
			
		}
		
	}
	
}


#else
typedef FontType = openfl._legacy.text.FontType;
#end