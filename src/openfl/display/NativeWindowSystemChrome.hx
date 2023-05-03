package openfl.display;

#if (!flash && sys)
/**
	The NativeWindowSystemChrome class defines constants for the `systemChrome`
	property of the NativeWindowInitOptions object used to create a native window.

	System chrome refers to the operating system-specific elements of a window
	such as a title bar, minimize, maximize, and close buttons.

	**Note:** The type of system chrome used is specified when a window is
	created and cannot be changed.

	@see `openfl.display.NativeWindow`
	@see `openfl.display.NativeWindowInitOptions`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract NativeWindowSystemChrome(Null<Int>)

{
	/**
		Reserved for future use.

		Do not use.
	**/
	public var ALTERNATE = 0;

	/**
		No system chrome.
	**/
	public var NONE = 1;

	/**
		The standard chrome for the host operating system.

		Use this setting to emulate the look and feel of the native operating system.
	**/
	public var STANDARD = 2;

	@:noCompletion private inline static function fromInt(value:Null<Int>):NativeWindowSystemChrome
	{
		return cast value;
	}

	@:from private static function fromString(value:String):NativeWindowSystemChrome
	{
		return switch (value)
		{
			case "alternate": ALTERNATE;
			case "none": NONE;
			case "standard": STANDARD;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : NativeWindowSystemChrome)
		{
			case NativeWindowSystemChrome.ALTERNATE: "alternate";
			case NativeWindowSystemChrome.NONE: "none";
			case NativeWindowSystemChrome.STANDARD: "standard";
			default: null;
		}
	}
}
#else
#if air
typedef NativeWindowSystemChrome = flash.display.NativeWindowSystemChrome;
#end
#end
