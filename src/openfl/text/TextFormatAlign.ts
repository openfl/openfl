/**
	The TextFormatAlign class provides values for text alignment in the
	TextFormat class.
**/
export enum TextFormatAlign
{
	/**
		Constant; centers the text in the text field. Use the syntax
		`TextFormatAlign.CENTER`.
	**/
	CENTER = "center",

	/**
		Constant; aligns text to the end edge of a line. Same as right for left-to-right
		languages and same as left for right-to-left languages.

		The `END` constant may only be used with the StageText class.
	**/
	END = "end",

	/**
		Constant; justifies text within the text field. Use the syntax
		`TextFormatAlign.JUSTIFY`.
	**/
	JUSTIFY = "justify",

	/**
		Constant; aligns text to the left within the text field. Use the syntax
		`TextFormatAlign.LEFT`.
	**/
	LEFT = "left",

	/**
		Constant; aligns text to the right within the text field. Use the syntax
		`TextFormatAlign.RIGHT`.
	**/
	RIGHT = "right",

	/**
		Constant; aligns text to the start edge of a line. Same as left for left-to-right
		languages and same as right for right-to-left languages.

		The `START` constant may only be used with the StageText class.
	**/
	START = "start"
}

export default TextFormatAlign;
