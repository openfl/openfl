package openfl.display;

#if (!flash && sys)
/**
**/
@:enum abstract NativeWindowSystemChrome(Null<Int>)
{
	/**
	**/
	public var ALTERNATE = 0;

	/**
	**/
	public var NONE = 1;

	/**
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
