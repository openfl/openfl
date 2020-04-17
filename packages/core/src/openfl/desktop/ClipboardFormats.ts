/**
		The ClipboardFormats class defines constants for the names of the standard
		data formats used with the Clipboard class. Flash Player 10 only supports
		TEXT_FORMAT, RICH_TEXT_FORMAT, and HTML_FORMAT.
	**/
export enum ClipboardFormats
{
	/**
		HTML data.
	**/
	HTML_FORMAT = "air:html",

	/**
		Rich Text Format data.
	**/
	RICH_TEXT_FORMAT = "air:rtf",

	/**
		String data.
	**/
	TEXT_FORMAT = "air:text"
}

export default ClipboardFormats;
