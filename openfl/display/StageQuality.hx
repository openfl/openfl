package openfl.display; #if !openfl_legacy


@:enum abstract StageQuality(Int) {
	
	public var BEST = 0;
	public var HIGH = 1;
	public var LOW = 2;
	public var MEDIUM = 3;
	
	@:from private static inline function fromString (value:String):StageQuality {
		
		return switch (value) {
			
			case "best": BEST;
			case "low": LOW;
			case "medium": MEDIUM;
			default: return HIGH;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case StageQuality.BEST: "best";
			case StageQuality.LOW: "low";
			case StageQuality.MEDIUM: "medium";
			default: "high";
			
		}
		
	}
	
}


#else
typedef StageQuality = openfl._legacy.display.StageQuality;
#end