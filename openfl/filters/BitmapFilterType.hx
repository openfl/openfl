/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.filters;
#if display


/**
 * The BitmapFilterType class contains values to set the type of a
 * BitmapFilter.
 */
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
