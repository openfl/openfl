package openfl.display; #if !openfljs


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


@:enum abstract StageDisplayState(String) from String to String {
	
	public var FULL_SCREEN = "fullScreen";
	public var FULL_SCREEN_INTERACTIVE = "fullScreenInteractive";
	public var NORMAL = "normal";
	
}


#end