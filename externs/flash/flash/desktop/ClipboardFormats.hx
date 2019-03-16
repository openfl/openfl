package flash.desktop;

#if flash
@:enum abstract ClipboardFormats(String) from String to String
{
	public var HTML_FORMAT = "air:html";
	public var RICH_TEXT_FORMAT = "air:rtf";
	public var TEXT_FORMAT = "air:text";
	#if air
	public var BITMAP_FORMAT = "air:bitmap";
	public var FILE_LIST_FORMAT = "air:file list";
	public var FILE_PROMISE_LIST_FORMAT = "air:file promise list";
	#end
}
#else
typedef ClipboardFormats = openfl.desktop.ClipboardFormats;
#end
