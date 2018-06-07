package openfl.display; #if !openfljs


@:enum abstract StageQuality(Null<Int>) {
	
	public var BEST = 0;
	public var HIGH = 1;
	public var LOW = 2;
	public var MEDIUM = 3;
	
	@:from private static function fromString (value:String):StageQuality {
		
		return switch (value) {
			
			case "best": BEST;
			case "high": HIGH;
			case "low": LOW;
			case "medium": MEDIUM;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case StageQuality.BEST: "best";
			case StageQuality.HIGH: "high";
			case StageQuality.LOW: "low";
			case StageQuality.MEDIUM: "medium";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract StageQuality(String) from String to String {
	
	public var BEST = "best";
	public var HIGH = "high";
	public var LOW = "low";
	public var MEDIUM = "medium";
	
}


#end