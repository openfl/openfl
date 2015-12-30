package openfl.desktop;


#if flash
@:native("flash.desktop.ClipboardFormats")
#end

@:enum abstract ClipboardFormats(String) from String to String {
	
	public var HTML_FORMAT = "air:html";
	public var RICH_TEXT_FORMAT = "air:rtf";
	public var TEXT_FORMAT = "air:text";
	
}