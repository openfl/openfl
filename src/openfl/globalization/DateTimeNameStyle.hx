package openfl.globalization;

#if !flash
#if !openfljs
@:enum abstract DateTimeNameStyle(Null<Int>)
{
	public var FULL = 0;
	public var LONG_ABBREVIATION = 1;
	public var SHORT_ABBREVIATION = 2;

	@:noCompletion private inline static function fromInt(value:Null<Int>):DateTimeNameStyle
	{
		return cast value;
	}

	@:from private static function fromString(value:String):DateTimeNameStyle
	{
		return switch (value)
		{
			case "full": FULL;
			case "longAbbreviation": LONG_ABBREVIATION;
			case "shortAbbreviation": SHORT_ABBREVIATION;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : DateTimeNameStyle)
		{
			case DateTimeNameStyle.FULL: "full";
			case DateTimeNameStyle.LONG_ABBREVIATION: "longAbbreviation";
			case DateTimeNameStyle.SHORT_ABBREVIATION: "shortAbbreviation";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract DateTimeNameStyle(String) from String to String
{
	public var FULL = "full";
	public var LONG_ABBREVIATION = "longAbbreviation";
	public var SHORT_ABBREVIATION = "shortAbbreviation";

	@:noCompletion private inline static function fromInt(value:Null<Int>):DateTimeNameContext
	{
		return switch (value)
		{
			case 0: FULL;
			case 1: LONG_ABBREVIATION;
			case 2: SHORT_ABBREVIATION;
			default: null;
		}
	}
}
#end
#else
typedef DateTimeNameStyle = flash.globalization.DateTimeNameStyle;
#end
