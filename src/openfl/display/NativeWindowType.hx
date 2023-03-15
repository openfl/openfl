package openfl.display;

#if (!flash && sys)
/**
**/
@:enum abstract NativeWindowType(Null<Int>)
{
	/**
	**/
	public var LIGHTWEIGHT = 0;

	/**
	**/
	public var NORMAL = 1;

	/**
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
