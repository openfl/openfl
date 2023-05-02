package openfl.text;

#if !flash

#if !openfljs
/**
	The TextFormatAlign class provides values for text alignment in the
	TextFormat class.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract TextFormatAlign(Null<Int>)

{
	/**
		Constant; centers the text in the text field. Use the syntax
		`TextFormatAlign.CENTER`.
	**/
	public var CENTER = 0;

	/**
		Constant; aligns text to the end edge of a line. Same as right for left-to-right
		languages and same as left for right-to-left languages.

		The `END` constant may only be used with the StageText class.
	**/
	public var END = 1;

	/**
		Constant; justifies text within the text field. Use the syntax
		`TextFormatAlign.JUSTIFY`.
	**/
	public var JUSTIFY = 2;

	/**
		Constant; aligns text to the left within the text field. Use the syntax
		`TextFormatAlign.LEFT`.
	**/
	public var LEFT = 3;

	/**
		Constant; aligns text to the right within the text field. Use the syntax
		`TextFormatAlign.RIGHT`.
	**/
	public var RIGHT = 4;

	/**
		Constant; aligns text to the start edge of a line. Same as left for left-to-right
		languages and same as right for right-to-left languages.

		The `START` constant may only be used with the StageText class.
	**/
	public var START = 5;

	@:from private static function fromString(value:String):TextFormatAlign
	{
		return switch (value)
		{
			case "center": CENTER;
			case "end": END;
			case "justify": JUSTIFY;
			case "left": LEFT;
			case "right": RIGHT;
			case "start": START;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : TextFormatAlign)
		{
			case TextFormatAlign.CENTER: "center";
			case TextFormatAlign.END: "end";
			case TextFormatAlign.JUSTIFY: "justify";
			case TextFormatAlign.LEFT: "left";
			case TextFormatAlign.RIGHT: "right";
			case TextFormatAlign.START: "start";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract TextFormatAlign(String) from String to String

{
	public var CENTER = "center";
	public var END = "end";
	public var JUSTIFY = "justify";
	public var LEFT = "left";
	public var RIGHT = "right";
	public var START = "start";
}
#end
#else
typedef TextFormatAlign = flash.text.TextFormatAlign;
#end
