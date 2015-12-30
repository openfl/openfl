package openfl.filters;


@:enum abstract BitmapFilterType(Int) {
	
	public var FULL = 0;
	public var INNER = 1;
	public var OUTER = 2;
	
	@:from private static inline function fromString (value:String):BitmapFilterType {
		
		return switch (value) {
			
			case "full": FULL;
			case "outer": OUTER;
			default: return INNER;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case BitmapFilterType.FULL: "full";
			case BitmapFilterType.OUTER: "outer";
			default: "inner";
			
		}
		
	}
	
}