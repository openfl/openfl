package openfl.display; #if !openfl_legacy


@:enum abstract TriangleCulling(Int) {
	
	public var NEGATIVE = 0;
	public var NONE = 1;
	public var POSITIVE = 2;
	
	@:from private static inline function fromString (value:String):TriangleCulling {
		
		return switch (value) {
			
			case "negative": NEGATIVE;
			case "positive": POSITIVE;
			default: return NONE;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case TriangleCulling.NEGATIVE: "negative";
			case TriangleCulling.POSITIVE: "positive";
			default: "none";
			
		}
		
	}
	
}


#else
typedef TriangleCulling = openfl._legacy.display.TriangleCulling;
#end