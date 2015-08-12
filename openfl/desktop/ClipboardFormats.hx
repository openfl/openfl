package openfl.desktop; #if !flash #if !openfl_legacy


@:enum abstract ClipboardFormats(String) from String to String {
	
	public var HTML_FORMAT = "air:html";
	public var RICH_TEXT_FORMAT = "air:rtf";
	public var TEXT_FORMAT = "air:text";
	
}


#end
#else
typedef ClipboardFormats = flash.desktop.ClipboardFormats;
#end