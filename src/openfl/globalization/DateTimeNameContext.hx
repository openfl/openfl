package openfl.globalization;

#if !flash
#if !openfljs
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract DateTimeNameContext(Null<Int>)

{
	public var FORMAT = 0;
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
