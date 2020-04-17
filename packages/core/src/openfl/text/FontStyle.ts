/**
		The FontStyle class provides values for the TextRenderer class.
	**/
export enum FontStyle
{
	/**
		Defines the bold style of a font for the `fontStyle` parameter
		in the `setAdvancedAntiAliasingTable()` method. Use the syntax
		`FontStyle.BOLD`.
	**/
	BOLD = "bold",

	/**
		Defines the italic style of a font for the `fontStyle`
		parameter in the `setAdvancedAntiAliasingTable()` method. Use
		the syntax `FontStyle.ITALIC`.
	**/
	BOLD_ITALIC = "boldItalic",

	/**
		Defines the italic style of a font for the `fontStyle`
		parameter in the `setAdvancedAntiAliasingTable()` method. Use
		the syntax `FontStyle.ITALIC`.
	**/
	ITALIC = "italic",

	/**
		Defines the plain style of a font for the `fontStyle` parameter
		in the `setAdvancedAntiAliasingTable()` method. Use the syntax
		`FontStyle.REGULAR`.
	**/
	REGULAR = "regular"
}

export default FontStyle;
