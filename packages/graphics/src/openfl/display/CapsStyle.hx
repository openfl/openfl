package openfl.display;

#if !flash

#if !openfljs
/**
	The CapsStyle class is an enumeration of constant values that specify the
	caps style to use in drawing lines. The constants are provided for use as
	values in the `caps` parameter of the
	`openfl.display.Graphics.lineStyle()` method. You can specify the
	following three types of caps:

	![The three types of caps: NONE, ROUND, and SQUARE.](/images/linecap.jpg)
**/
@:enum abstract CapsStyle(Null<Int>)
{
	/**
		Used to specify no caps in the `caps` parameter of the
		`openfl.display.Graphics.lineStyle()` method.
	**/
	public var NONE = 0;

	/**
		Used to specify round caps in the `caps` parameter of the
		`openfl.display.Graphics.lineStyle()` method.
	**/
	public var ROUND = 1;

	/**
		Used to specify square caps in the `caps` parameter of the
		`openfl.display.Graphics.lineStyle()` method.
	**/
	public var SQUARE = 2;

	@:noCompletion private inline static function fromInt(value:Null<Int>):CapsStyle
	{
		return cast value;
	}

	@:from private static function fromString(value:String):CapsStyle
	{
		return switch (value)
		{
			case "none": NONE;
			case "round": ROUND;
			case "square": SQUARE;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : CapsStyle)
		{
			case CapsStyle.NONE: "none";
			case CapsStyle.ROUND: "round";
			case CapsStyle.SQUARE: "square";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract CapsStyle(String) from String to String
{
	public var NONE = "none";
	public var ROUND = "round";
	public var SQUARE = "square";

	@:noCompletion private inline static function fromInt(value:Null<Int>):CapsStyle
	{
		return switch (value)
		{
			case 0: NONE;
			case 1: ROUND;
			case 2: SQUARE;
			default: null;
		}
	}
}
#end
#else
typedef CapsStyle = flash.display.CapsStyle;
#end
