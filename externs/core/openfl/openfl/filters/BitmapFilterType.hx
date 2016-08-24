package openfl.filters; #if (display || !flash)


/**
 * The BitmapFilterType class contains values to set the type of a
 * BitmapFilter.
 */
@:enum abstract BitmapFilterType(Null<Int>) {
	
	/**
	 * Defines the setting that applies a filter to the entire area of an object.
	 */
	public var FULL = 0;
	
	/**
	 * Defines the setting that applies a filter to the inner area of an object.
	 */
	public var INNER = 1;
	
	/**
	 * Defines the setting that applies a filter to the outer area of an object.
	 */
	public var OUTER = 2;
	
	@:from private static function fromString (value:String):BitmapFilterType {
		
		return switch (value) {
			
			case "full": FULL;
			case "inner": INNER;
			case "outer": OUTER;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case BitmapFilterType.FULL: "full";
			case BitmapFilterType.INNER: "inner";
			case BitmapFilterType.OUTER: "outer";
			default: null;
			
		}
		
	}
	
}


#else
typedef BitmapFilterType = flash.filters.BitmapFilterType;
#end