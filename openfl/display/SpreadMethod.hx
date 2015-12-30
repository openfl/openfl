package openfl.display; #if !openfl_legacy


@:enum abstract SpreadMethod(Int) {
	
	public var PAD = 0;
	public var REFLECT = 1;
	public var REPEAT = 2;
	
	@:from private static inline function fromString (value:String):SpreadMethod {
		
		return switch (value) {
			
			case "reflect": REFLECT;
			case "repeat": REPEAT;
			default: return PAD;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case SpreadMethod.REFLECT: "reflect";
			case SpreadMethod.REPEAT: "repeat";
			default: "pad";
			
		}
		
	}
	
}


#else
typedef SpreadMethod = openfl._legacy.display.SpreadMethod;
#end