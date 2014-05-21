/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.filters;
#if display


/**
 * The BitmapFilterQuality class contains values to set the rendering quality
 * of a BitmapFilter object.
 */
extern class BitmapFilterQuality {

	/**
	 * Defines the high quality filter setting.
	 */
	static inline var HIGH : Int = 3;

	/**
	 * Defines the low quality filter setting.
	 */
	static inline var LOW : Int = 1;

	/**
	 * Defines the medium quality filter setting.
	 */
	static inline var MEDIUM : Int = 2;
}


#end
