package flash.display;

#if flash
@:enum abstract StageQuality(String) from String to String
{
	public var BEST = "best";
	public var HIGH = "high";
	public var LOW = "low";
	public var MEDIUM = "medium";
}
#else
typedef StageQuality = openfl.display.StageQuality;
#end
