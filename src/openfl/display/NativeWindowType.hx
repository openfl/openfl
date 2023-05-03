package openfl.display;

#if (!flash && sys)
/**
	The NativeWindowType class defines constants for the `type` property of the
	NativeWindowInitOptions object used to create a native window.

	**Note:** The type value is specified when a window is created and cannot be
	changed.

	@see `openfl.display.NativeWindow`
	@see `openfl.display.NativeWindowInitOptions`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract NativeWindowType(Null<Int>)

{
	/**
		A minimal window. Lightweight windows cannot have system chrome and do
		not appear on the Windows or Linux task bar. In addition, lightweight
		windows do not have the System (Alt-Space) menu on Windows. Lightweight
		windows are suitable for notification bubbles and controls such as
		combo-boxes that open a short-lived display area. When the lightweight
		type is used, `systemChrome` must be set to
		`NativeWindowSystemChrome.NONE`.
	**/
	public var LIGHTWEIGHT = 0;

	/**
		A typical window. Normal windows use full-size chrome and appear on the
		Windows or Linux task bar.
	**/
	public var NORMAL = 1;

	/**
		A utility window. Utility windows use a slimmer version of the system
		chrome and do not appear on the Windows task bar.
	**/
	public var UTILITY = 2;

	@:noCompletion private inline static function fromInt(value:Null<Int>):NativeWindowType
	{
		return cast value;
	}

	@:from private static function fromString(value:String):NativeWindowType
	{
		return switch (value)
		{
			case "lightweight": LIGHTWEIGHT;
			case "normal": NORMAL;
			case "utility": UTILITY;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : NativeWindowType)
		{
			case NativeWindowType.LIGHTWEIGHT: "lightweight";
			case NativeWindowType.NORMAL: "normal";
			case NativeWindowType.UTILITY: "utility";
			default: null;
		}
	}
}
#else
#if air
typedef NativeWindowType = flash.display.NativeWindowType;
#end
#end
