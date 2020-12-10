package openfl.desktop;

#if !flash
#if !openfljs
@:enum abstract ClipboardFormats(Null<Int>)
{
	public var HTML_FORMAT = 0;
	public var RICH_TEXT_FORMAT = 1;
	public var TEXT_FORMAT = 2;

	@:from private static function fromString(value:String):ClipboardFormats
	{
		return switch (value)
		{
			case "air:html": HTML_FORMAT;
			case "air:rtf": RICH_TEXT_FORMAT;
			case "air:text": TEXT_FORMAT;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : ClipboardFormats)
		{
			case ClipboardFormats.HTML_FORMAT: "air:html";
			case ClipboardFormats.RICH_TEXT_FORMAT: "air:rtf";
			case ClipboardFormats.TEXT_FORMAT: "air:text";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract ClipboardFormats(String) from String to String
{
	public var HTML_FORMAT = "air:html";
	public var RICH_TEXT_FORMAT = "air:rtf";
	public var TEXT_FORMAT = "air:text";
}
#end
#else
typedef ClipboardFormats = flash.desktop.ClipboardFormats;
#end
