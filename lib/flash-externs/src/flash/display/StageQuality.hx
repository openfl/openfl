package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageQuality(String) from String to String

{
	public var BEST = "best";
	public var HIGH = "high";
	public var LOW = "low";
	public var MEDIUM = "medium";
}
#else
typedef StageQuality = openfl.display.StageQuality;
#end
