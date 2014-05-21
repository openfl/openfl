/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


/**
 * The StageQuality class provides values for the <code>Stage.quality</code>
 * property.
 */
@:fakeEnum(String) extern enum StageQuality {

	/**
	 * Specifies very high rendering quality: graphics are anti-aliased using a 4
	 * x 4 pixel grid and bitmaps are always smoothed.
	 */
	BEST;

	/**
	 * Specifies high rendering quality: graphics are anti-aliased using a 4 x 4
	 * pixel grid, and bitmaps are smoothed if the movie is static.
	 */
	HIGH;

	/**
	 * Specifies low rendering quality: graphics are not anti-aliased, and
	 * bitmaps are not smoothed.
	 */
	LOW;

	/**
	 * Specifies medium rendering quality: graphics are anti-aliased using a 2 x
	 * 2 pixel grid, but bitmaps are not smoothed. This setting is suitable for
	 * movies that do not contain text.
	 */
	MEDIUM;
}


#end
