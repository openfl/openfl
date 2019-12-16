package flash.text;

#if flash
@:enum abstract FontStyle(String) from String to String
{
	public var BOLD = "bold";
	public var BOLD_ITALIC = "boldItalic";
	public var ITALIC = "italic";
	public var REGULAR = "regular";
}
#else
typedef FontStyle = openfl.text.FontStyle;
#end
