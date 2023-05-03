package openfl.display;

#if !flash

#if !openfljs
/**
	The StageDisplayState class provides values for the
	`Stage.displayState` property.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageDisplayState(Null<Int>)

{
	/**
		Specifies that the Stage is in full-screen mode.
	**/
	public var FULL_SCREEN = 0;

	/**
		Specifies that the Stage is in full-screen mode with keyboard interactivity enabled.
	**/
	public var FULL_SCREEN_INTERACTIVE = 1;

	/**
		Specifies that the Stage is in normal mode.
	**/
	public var NORMAL = 2;

	@:from private static function fromString(value:String):StageDisplayState
	{
		return switch (value)
		{
			case "fullScreen": FULL_SCREEN;
			case "fullScreenInteractive": FULL_SCREEN_INTERACTIVE;
			case "normal": NORMAL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : StageDisplayState)
		{
			case StageDisplayState.FULL_SCREEN: "fullScreen";
			case StageDisplayState.FULL_SCREEN_INTERACTIVE: "fullScreenInteractive";
			case StageDisplayState.NORMAL: "normal";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageDisplayState(String) from String to String

{
	public var FULL_SCREEN = "fullScreen";
	public var FULL_SCREEN_INTERACTIVE = "fullScreenInteractive";
	public var NORMAL = "normal";
}
#end
#else
typedef StageDisplayState = flash.display.StageDisplayState;
#end
