package openfl.display;

#if (!flash && sys)
/**
	The NativeWindowDisplayState class defines constants for the names of the
	window display states.

	**Note:** The fullscreen modes are set using the Stage object `displayState`
	property, not the window `displayState`.

	@see `openfl.display.NativeWindow`
	@see `openfl.display.NativeWindow.displayState`
	@see `openfl.display.Stage.displayState`
	@see `openfl.display.StageDisplayState`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract NativeWindowDisplayState(Null<Int>)

{
	/**
		The normal display state.
	**/
	public var NORMAL = 0;

	/**
		The maximized display state.
	**/
	public var MAXIMIZED = 1;

	/**
		The minimized display state.
	**/
	public var MINIMIZED = 2;

	@:noCompletion private inline static function fromInt(value:Null<Int>):NativeWindowDisplayState
	{
		return cast value;
	}

	@:from private static function fromString(value:String):NativeWindowDisplayState
	{
		return switch (value)
		{
			case "maximized": MAXIMIZED;
			case "minimized": MINIMIZED;
			case "normal": NORMAL;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : NativeWindowDisplayState)
		{
			case NativeWindowDisplayState.MAXIMIZED: "maximized";
			case NativeWindowDisplayState.MINIMIZED: "minimized";
			case NativeWindowDisplayState.NORMAL: "normal";
			default: null;
		}
	}
}
#else
#if air
typedef NativeWindowDisplayState = flash.display.NativeWindowDisplayState;
#end
#end
