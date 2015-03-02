package openfl.display; #if !flash #if !lime_legacy


/**
 * The StageQuality class provides values for the <code>Stage.quality</code>
 * property.
 */
enum StageQuality {
	
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


#else
typedef StageQuality = openfl._v2.display.StageQuality;
#end
#else
typedef StageQuality = flash.display.StageQuality;
#end