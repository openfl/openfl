package openfl.display; #if !openfl_legacy


@:enum abstract StageQuality(String) from String to String {
	
	public var BEST = "best";
	public var HIGH = "high";
	public var LOW = "low";
	public var MEDIUM = "medium";
	
}


#else
typedef StageQuality = openfl._legacy.display.StageQuality;
#end