package openfl.display; #if (display || !flash)


/**
 * The StageDisplayState class provides values for the
 * `Stage.displayState` property.
 */
@:enum abstract StageDisplayState(Null<Int>) {
	
	/**
	 * Specifies that the Stage is in full-screen mode.
	 */
	public var FULL_SCREEN = 0;
	
	/**
	 * Specifies that the Stage is in full-screen mode with keyboard interactivity enabled.
	 */
	public var FULL_SCREEN_INTERACTIVE = 1;
	
	/**
	 * Specifies that the Stage is in normal mode.
	 */
	public var NORMAL = 2;
	
	@:from private static function fromString (value:String):StageDisplayState {
		
		return switch (value) {
			
			case "fullScreen": FULL_SCREEN;
			case "fullScreenInteractive": FULL_SCREEN_INTERACTIVE;
			case "normal": NORMAL;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case StageDisplayState.FULL_SCREEN: "fullScreen";
			case StageDisplayState.FULL_SCREEN_INTERACTIVE: "fullScreenInteractive";
			case StageDisplayState.NORMAL: "normal";
			default: null;
			
		}
		
	}
	
}


#else
typedef StageDisplayState = flash.display.StageDisplayState;
#end