package openfl.display;


/**
 * The StageQuality class provides values for the <code>Stage.quality</code>
 * property.
 */

#if flash
@:native("flash.display.StageQuality")
#end


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
	 * Specifies medium rendering quality: graphics are anti-aliased using a 2 x
	 * 2 pixel grid, but bitmaps are not smoothed. This setting is suitable for
	 * movies that do not contain text.
	 */
	MEDIUM;
	
	/**
	 * Specifies low rendering quality: graphics are not anti-aliased, and
	 * bitmaps are not smoothed.
	 */
	LOW;
	
}