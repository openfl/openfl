package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageDisplayState(String) from String to String

{
	public var FULL_SCREEN = "fullScreen";
	public var FULL_SCREEN_INTERACTIVE = "fullScreenInteractive";
	public var NORMAL = "normal";
}
#else
typedef StageDisplayState = openfl.display.StageDisplayState;
#end
