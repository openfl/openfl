package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageQuality(String) from String to String
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
#else
typedef StageQuality = openfl.display.StageQuality;
#end
