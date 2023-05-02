package openfl.globalization;

#if !flash
#if !openfljs
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract DateTimeStyle(Null<Int>)

{
	public var CUSTOM = 0;
	public var LONG = 1;
	public var MEDIUM = 2;
	public var NONE = 3;
	public var SHORT = 4;

	@:noCompletion private inline static function fromInt(value:Null<Int>):DateTimeStyle
	{
		return cast value;
	}

	@:from private static function fromString(value:String):DateTimeStyle
	{
		return switch (value)
		{
			case "custom": CUSTOM;
			case "long": LONG;
			case "medium": MEDIUM;
			case "none": NONE;
			case "short": SHORT;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : DateTimeStyle)
		{
			case DateTimeStyle.CUSTOM: "custom";
			case DateTimeStyle.LONG: "long";
			case DateTimeStyle.MEDIUM: "medium";
			case DateTimeStyle.NONE: "none";
			case DateTimeStyle.SHORT: "short";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract DateTimeStyle(String) from String to String

{
	public var CUSTOM = "custom";
	public var LONG = "long";
	public var MEDIUM = "medium";
	public var NONE = "none";
	public var SHORT = "short";

	@:noCompletion private inline static function fromInt(value:Null<Int>):DateTimeStyle
	{
		return switch (value)
		{
			case 0: CUSTOM;
			case 1: LONG;
			case 2: MEDIUM;
			case 3: NONE;
			case 4: SHORT;
			default: null;
		}
	}
}
#end
#else
typedef DateTimeStyle = flash.globalization.DateTimeStyle;
#end
