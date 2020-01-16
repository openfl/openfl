package openfl.display;

#if !flash

#if !openfljs
/**
	The StageQuality class provides values for the `Stage.quality`
	property.
**/
@:enum abstract StageQuality(Null<Int>)
{
	/**
		Specifies very high rendering quality: graphics are anti-aliased using a 4
		x 4 pixel grid and bitmaps are always smoothed.
	**/
	public var BEST = 0;

	/**
		Specifies high rendering quality: graphics are anti-aliased using a 4 x 4
		pixel grid, and bitmaps are smoothed if the movie is static.
	**/
	public var HIGH = 1;

	/**
		Specifies low rendering quality: graphics are not anti-aliased, and
		bitmaps are not smoothed.
	**/
	public var LOW = 2;

	/**
		Specifies medium rendering quality: graphics are anti-aliased using a 2 x
		2 pixel grid, but bitmaps are not smoothed. This setting is suitable for
		movies that do not contain text.
	**/
	public var MEDIUM = 3;

	@:from private static function fromString(value:String):StageQuality
	{
		return switch (value)
		{
			case "best": BEST;
			case "high": HIGH;
			case "low": LOW;
			case "medium": MEDIUM;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : StageQuality)
		{
			case StageQuality.BEST: "best";
			case StageQuality.HIGH: "high";
			case StageQuality.LOW: "low";
			case StageQuality.MEDIUM: "medium";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract StageQuality(String) from String to String
{
	public var BEST = "best";
	public var HIGH = "high";
	public var LOW = "low";
	public var MEDIUM = "medium";
}
#end
#else
typedef StageQuality = flash.display.StageQuality;
#end
