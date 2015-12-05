package openfl.filters; #if (!display && !flash)


class BitmapFilterType {
	
	
	public static var FULL = "full";
	public static var INNER = "inner";
	public static var OUTER = "outer";
	
	
}


#else


/**
 * The BitmapFilterType class contains values to set the type of a
 * BitmapFilter.
 */

#if flash
@:native("flash.filters.BitmapFilterType")
#end


@:fakeEnum(String) extern enum BitmapFilterType {
	
	
	/**
	 * Defines the setting that applies a filter to the entire area of an object.
	 */
	FULL;
	
	/**
	 * Defines the setting that applies a filter to the inner area of an object.
	 */
	INNER;
	
	/**
	 * Defines the setting that applies a filter to the outer area of an object.
	 */
	OUTER;
	
	
}


#end