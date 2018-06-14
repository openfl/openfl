package openfl.filters;


/**
 * The BitmapFilterType class contains values to set the type of a
 * BitmapFilter.
 */
@:enum abstract BitmapFilterType(String) from String to String {
	
	/**
	 * Defines the setting that applies a filter to the entire area of an object.
	 */
	public var FULL = "full";
	
	/**
	 * Defines the setting that applies a filter to the inner area of an object.
	 */
	public var INNER = "inner";
	
	/**
	 * Defines the setting that applies a filter to the outer area of an object.
	 */
	public var OUTER = "outer";
	
}