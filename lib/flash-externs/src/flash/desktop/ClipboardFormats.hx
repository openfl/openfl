package flash.desktop;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ClipboardFormats(String) from String to String

{
	public var HTML_FORMAT = "air:html";
	public var RICH_TEXT_FORMAT = "air:rtf";
	public var TEXT_FORMAT = "air:text";
	#if air
	public var BITMAP_FORMAT = "air:bitmap";
	public var FILE_LIST_FORMAT = "air:file list";
	public var FILE_PROMISE_LIST_FORMAT = "air:file promise list";
	public var URL_FORMAT = "air:url";
	#end
}
#else
typedef ClipboardFormats = openfl.desktop.ClipboardFormats;
#end
