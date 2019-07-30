package openfl.display;


@:enum abstract StageDisplayState(Null<Int>) {
	
	public var FULL_SCREEN = 0;
	public var FULL_SCREEN_INTERACTIVE = 1;
	public var NORMAL = 2;
	
	@:from private static function fromString (value:String):StageDisplayState {
		
		return switch (value) {
			
			case "fullScreen": FULL_SCREEN;
			case "fullScreenInteractive": FULL_SCREEN_INTERACTIVE;
			case "normal": NORMAL;
			default: null;
			
		}
		
	}
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case StageDisplayState.FULL_SCREEN: "fullScreen";
			case StageDisplayState.FULL_SCREEN_INTERACTIVE: "fullScreenInteractive";
			case StageDisplayState.NORMAL: "normal";
			default: null;
			
		}
		
	}
	
}