package openfl.text.engine;

#if !flash

#if !openfljs
/**
	The FontPosture class is an enumeration of constant values used with `FontDescription.fontPosture` to set text to italic or normal.
**/
@:enum abstract FontPosture(Null<Int>)
{
	/**
		Used to indicate italic font posture.
	**/
	public var ITALIC = 0;

	/**
		Used to indicate normal font posture.
	**/
	public var NORMAL = 1;

	@:from private static function fromString(value:String):FontPosture
	{
		return switch (value)
		{
			case "italic": ITALIC;
			case "normal": NORMAL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : FontPosture)
		{
			case FontPosture.ITALIC: "italic";
			case FontPosture.NORMAL: "normal";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract FontPosture(String) from String to String
{
	public var ITALIC = "italic";
	public var NORMAL = "normal";
}
#end
#else
typedef FontPosture = flash.text.engine.FontPosture;
#end
