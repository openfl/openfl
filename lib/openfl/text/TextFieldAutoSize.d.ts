declare namespace openfl.text {
	
	/**
	 * The TextFieldAutoSize class is an enumeration of constant values used in
	 * setting the `autoSize` property of the TextField class.
	 */
	export enum TextFieldAutoSize {
		
		/**
		 * Specifies that the text is to be treated as center-justified text. Any
		 * resizing of a single line of a text field is equally distributed to both
		 * the right and left sides.
		 */
		CENTER = 0,
		
		/**
		 * Specifies that the text is to be treated as left-justified text, meaning
		 * that the left side of the text field remains fixed and any resizing of a
		 * single line is on the right side.
		 */
		LEFT = 1,
		
		/**
		 * Specifies that no resizing is to occur.
		 */
		NONE = 2,
		
		/**
		 * Specifies that the text is to be treated as right-justified text, meaning
		 * that the right side of the text field remains fixed and any resizing of a
		 * single line is on the left side.
		 */
		RIGHT = 3
		
	}
	
}


export default openfl.text.TextFieldAutoSize;