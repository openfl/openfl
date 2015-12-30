package openfl.display; #if !openfl_legacy


@:enum abstract StageScaleMode(Int) {
	
	public var EXACT_FIT = 0;
	public var NO_BORDER = 1;
	public var NO_SCALE = 2;
	public var SHOW_ALL = 3;
	
	@:from private static inline function fromString (value:String):StageScaleMode {
		
		return switch (value) {
			
			case "exactFit": EXACT_FIT;
			case "noBorder": NO_BORDER;
			case "showAll": SHOW_ALL;
			default: return NO_SCALE;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case StageScaleMode.EXACT_FIT: "exactFit";
			case StageScaleMode.NO_BORDER: "noBorder";
			case StageScaleMode.SHOW_ALL: "showAll";
			default: "noScale";
			
		}
		
	}
	
}


#else
typedef StageScaleMode = openfl._legacy.display.StageScaleMode;
#end