package openfl.text; #if !openfl_legacy


@:enum abstract FontStyle(String) from String to String {
	
	public var BOLD = "bold";
	public var BOLD_ITALIC = "boldItalic";
	public var ITALIC = "italic";
	public var REGULAR = "regular";
	
}


#else
typedef FontStyle = openfl._legacy.text.FontStyle;
#end