namespace openfl.display
{
	/**
		The StageQuality class provides values for the `Stage.quality`
		property.
	**/
	export enum StageQuality
	{
		/**
			Specifies very high rendering quality: graphics are anti-aliased using a 4
			x 4 pixel grid and bitmaps are always smoothed.
		**/
		BEST = "best",

		/**
			Specifies high rendering quality: graphics are anti-aliased using a 4 x 4
			pixel grid, and bitmaps are smoothed if the movie is static.
		**/
		HIGH = "high",

		/**
			Specifies low rendering quality: graphics are not anti-aliased, and
			bitmaps are not smoothed.
		**/
		LOW = "low",

		/**
			Specifies medium rendering quality: graphics are anti-aliased using a 2 x
			2 pixel grid, but bitmaps are not smoothed. This setting is suitable for
			movies that do not contain text.
		**/
		MEDIUM = "medium"
	}
}

export default openfl.display.StageQuality;
