package openfl.display;

#if !flash
#if !openfljs
/**
	The StageQuality class provides values for the `Stage.quality`
	property.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageQuality(Null<Int>)
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

	/**
		Specifies very high rendering quality: graphics are anti-aliased using
		an 8 x 8 pixel grid, and bitmaps are smoothed.

		OpenFL renders this setting the same as `StageQuality.HIGH`.
	**/
	public var HIGH_8X8 = 4;

	/**
		Specifies very high rendering quality: graphics are anti-aliased in a
		linear sRGB color space using an 8 x 8 pixel grid, and bitmaps are
		smoothed.

		OpenFL renders this setting the same as `StageQuality.HIGH`.
	**/
	public var HIGH_8X8_LINEAR = 5;

	/**
		Specifies very high rendering quality: graphics are anti-aliased using
		a 16 x 16 pixel grid, and bitmaps are smoothed.

		OpenFL renders this setting the same as `StageQuality.HIGH`.
	**/
	public var HIGH_16X16 = 6;

	/**
		Specifies very high rendering quality: graphics are anti-aliased in a
		linear sRGB color space using a 16 x 16 pixel grid, and bitmaps are
		smoothed.

		OpenFL renders this setting the same as `StageQuality.HIGH`.
	**/
	public var HIGH_16X16_LINEAR = 7;

	@:from private static function fromString(value:String):StageQuality
	{
		return switch (value)
		{
			case "best": BEST;
			case "high": HIGH;
			case "low": LOW;
			case "medium": MEDIUM;
			case "8x8": HIGH_8X8;
			case "8x8linear": HIGH_8X8_LINEAR;
			case "16x16": HIGH_16X16;
			case "16x16linear": HIGH_16X16_LINEAR;
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
			case StageQuality.HIGH_8X8: "8x8";
			case StageQuality.HIGH_8X8_LINEAR: "8x8linear";
			case StageQuality.HIGH_16X16: "16x16";
			case StageQuality.HIGH_16X16_LINEAR: "16x16linear";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment") #if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageQuality(String) from String to String
{
	public var BEST = "best";
	public var HIGH = "high";
	public var LOW = "low";
	public var MEDIUM = "medium";
	public var HIGH_8X8 = "8x8";
	public var HIGH_8X8_LINEAR = "8x8linear";
	public var HIGH_16X16 = "16x16";
	public var HIGH_16X16_LINEAR = "16x16linear";
}
#end
#else
typedef StageQuality = flash.display.StageQuality;
#end
