package openfl.display; #if !openfl_legacy


@:enum abstract StageDisplayState(Int) {
	
	public var FULL_SCREEN = 0;
	public var FULL_SCREEN_INTERACTIVE = 1;
	public var NORMAL = 2;
	
	@:from private static inline function fromString (value:String):StageDisplayState {
		
		return switch (value) {
			
			case "fullScreen": FULL_SCREEN;
			case "fullScreenInteractive": FULL_SCREEN_INTERACTIVE;
			default: return NORMAL;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case StageDisplayState.FULL_SCREEN: "fullScreen";
			case StageDisplayState.FULL_SCREEN_INTERACTIVE: "fullScreenInteractive";
			default: "normal";
			
		}
		
	}
	
}


#else
typedef StageDisplayState = openfl._legacy.display.StageDisplayState;
#end