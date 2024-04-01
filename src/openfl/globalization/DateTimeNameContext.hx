package openfl.globalization;

#if !flash
/**
	The DateTimeNameContext class enumerates constant values representing the
	formatting context in which a month name or weekday name is used. These
	constants are used for the context parameters for the DateTimeFormatter's
	`getMonthNames()` and `getWeekDayNames()` methods.

	The context parameter only changes the results of those methods for certain
	locales and operating systems. For most locales, the lists of month names
	and weekday names do not differ by context.
**/
#if !openfljs
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract DateTimeNameContext(Null<Int>)

{
	/**
		Indicates that the date element name is used within a date format.
	**/
	public var FORMAT = 0;

	/**
		Indicates that the date element name is used in a "stand alone" context,
		independent of other formats. For example, the name can be used to show
		only the month name in a calendar or the weekday name in a date chooser.
	**/
	public var STANDALONE = 1;

	@:noCompletion private inline static function fromInt(value:Null<Int>):DateTimeNameContext
	{
		return cast value;
	}

	@:from private static function fromString(value:String):DateTimeNameContext
	{
		return switch (value)
		{
			case "format": FORMAT;
			case "standalone": STANDALONE;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : DateTimeNameContext)
		{
			case DateTimeNameContext.FORMAT: "format";
			case DateTimeNameContext.STANDALONE: "standalone";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract DateTimeNameContext(String) from String to String

{
	public var FORMAT = "format";
	public var STANDALONE = "standalone";

	@:noCompletion private inline static function fromInt(value:Null<Int>):DateTimeNameContext
	{
		return switch (value)
		{
			case 0: FORMAT;
			case 1: STANDALONE;
			default: null;
		}
	}
}
#end
#else
typedef DateTimeNameContext = flash.globalization.DateTimeNameContext;
#end
