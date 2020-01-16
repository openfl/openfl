package openfl.display;

#if !flash

#if !openfljs
/**
	The SpreadMethod class provides values for the `spreadMethod`
	parameter in the `beginGradientFill()` and
	`lineGradientStyle()` methods of the Graphics class.

	The following example shows the same gradient fill using various spread
	methods:
**/
@:enum abstract SpreadMethod(Null<Int>)
{
	/**
		Specifies that the gradient use the _pad_ spread method.
	**/
	public var PAD = 0;

	/**
		Specifies that the gradient use the _reflect_ spread method.
	**/
	public var REFLECT = 1;

	/**
		Specifies that the gradient use the _repeat_ spread method.
	**/
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
