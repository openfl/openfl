package openfl.display;

#if !flash
#if !openfljs
@:enum abstract SpreadMethod(Null<Int>)
{
	public var PAD = 0;
	public var REFLECT = 1;
	public var REPEAT = 2;

	@:noCompletion private inline static function fromInt(value:Null<Int>):SpreadMethod
	{
		return cast value;
	}

	@:from private static function fromString(value:String):SpreadMethod
	{
		return switch (value)
		{
			case "pad": PAD;
			case "reflect": REFLECT;
			case "repeat": REPEAT;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : SpreadMethod)
		{
			case SpreadMethod.PAD: "pad";
			case SpreadMethod.REFLECT: "reflect";
			case SpreadMethod.REPEAT: "repeat";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract SpreadMethod(String) from String to String
{
	public var PAD = "pad";
	public var REFLECT = "reflect";
	public var REPEAT = "repeat";

	@:noCompletion private inline static function fromInt(value:Null<Int>):SpreadMethod
	{
		return switch (value)
		{
			case 0: PAD;
			case 1: REFLECT;
			case 2: REPEAT;
			default: null;
		}
	}
}
#end
#else
typedef SpreadMethod = flash.display.SpreadMethod;
#end
