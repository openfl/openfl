package openfl.filters; #if !flash


/**
 * The BitmapFilterType class contains values to set the type of a
 * BitmapFilter.
 */
class BitmapFilterType {
	
	
	/**
	 * Defines the setting that applies a filter to the entire area of an object.
	 */
	public static var FULL = "full";
	
	/**
	 * Defines the setting that applies a filter to the inner area of an object.
	 */
	public static var INNER = "inner";
	
	/**
	 * Defines the setting that applies a filter to the outer area of an object.
	 */
	public static var OUTER = "outer";
	
	
}


#else
typedef BitmapFilterType = flash.filters.BitmapFilterType;
#end