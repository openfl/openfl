package openfl.display; #if !openfl_legacy


@:enum abstract PixelSnapping(Int) {
	
	public var ALWAYS = 0;
	public var AUTO = 1;
	public var NEVER = 2;
	
	@:from private static inline function fromString (value:String):PixelSnapping {
		
		return switch (value) {
			
			case "always": ALWAYS;
			case "never": NEVER;
			default: return AUTO;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case PixelSnapping.ALWAYS: "always";
			case PixelSnapping.NEVER: "never";
			default: "auto";
			
		}
		
	}
	
}


#else
typedef PixelSnapping = openfl._legacy.display.PixelSnapping;
#end