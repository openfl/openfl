package openfl.display;

#if (!flash && sys)
/**
**/
@:enum abstract NativeWindowDisplayState(Null<Int>)
{
	/**
	**/
	public var NORMAL = 0;

	/**
	**/
	public var MAXIMIZED = 1;

	/**
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
