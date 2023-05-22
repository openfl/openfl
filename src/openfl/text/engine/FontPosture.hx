package openfl.text.engine;

#if (!flash && sys)

#if !openfljs
/**
	The FontPosture class is an enumeration of constant values used with
	`FontDescription.fontPosture` and `StageText.fontPostures` to set text to
	italic or normal.

	@see `openfl.text.StageText.fontPosture`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract FontPosture(Null<Int>)

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
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract FontPosture(String) from String to String

{
	public var ITALIC = "italic";
	public var NORMAL = "normal";
}
#end
#else
#if air
typedef FontPosture = flash.text.engine.FontPosture;
#end
#end
