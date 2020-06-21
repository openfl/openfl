package openfl.desktop;

/**
	The ClipboardFormats class defines constants for the names of the standard
	data formats used with the Clipboard class. Flash Player 10 only supports
	TEXT_FORMAT, RICH_TEXT_FORMAT, and HTML_FORMAT.
**/
@:enum abstract ClipboardFormats(String) from String to String
{
	/**
		HTML data.
	**/
	public var HTML_FORMAT = "air:html";

	/**
		Rich Text Format data.
	**/
	public var RICH_TEXT_FORMAT = "air:rtf";

	/**
		String data.
	**/
	public var TEXT_FORMAT = "air:text";
}
