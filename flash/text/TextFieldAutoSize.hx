package flash.text;
#if (flash || display)


/**
 * The TextFieldAutoSize class is an enumeration of constant values used in
 * setting the <code>autoSize</code> property of the TextField class.
 */
@:fakeEnum(String) extern enum TextFieldAutoSize {

	/**
	 * Specifies that the text is to be treated as center-justified text. Any
	 * resizing of a single line of a text field is equally distributed to both
	 * the right and left sides.
	 */
	CENTER;

	/**
	 * Specifies that the text is to be treated as left-justified text, meaning
	 * that the left side of the text field remains fixed and any resizing of a
	 * single line is on the right side.
	 */
	LEFT;

	/**
	 * Specifies that no resizing is to occur.
	 */
	NONE;

	/**
	 * Specifies that the text is to be treated as right-justified text, meaning
	 * that the right side of the text field remains fixed and any resizing of a
	 * single line is on the left side.
	 */
	RIGHT;
}


#end
