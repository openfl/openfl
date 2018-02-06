import AntiAliasType from "./AntiAliasType";
import GridFitType from "./GridFitType";
import TextFieldAutoSize from "./TextFieldAutoSize";
import TextFormat from "./TextFormat";
import TextLineMetrics from "./TextLineMetrics";
import TextFieldType from "./TextFieldType";
import InteractiveObject from "./../display/InteractiveObject";
import Rectangle from "./../geom/Rectangle";


declare namespace openfl.text {
	
	
	/**
	 * The TextField class is used to create display objects for text display and
	 * input. <ph outputclass="flexonly">You can use the TextField class to
	 * perform low-level text rendering. However, in Flex, you typically use the
	 * Label, Text, TextArea, and TextInput controls to process text. <ph
	 * outputclass="flashonly">You can give a text field an instance name in the
	 * Property inspector and use the methods and properties of the TextField
	 * class to manipulate it with ActionScript. TextField instance names are
	 * displayed in the Movie Explorer and in the Insert Target Path dialog box in
	 * the Actions panel.
	 *
	 * To create a text field dynamically, use the `TextField()`
	 * constructor.
	 *
	 * The methods of the TextField class let you set, select, and manipulate
	 * text in a dynamic or input text field that you create during authoring or
	 * at runtime. 
	 *
	 * ActionScript provides several ways to format your text at runtime. The
	 * TextFormat class lets you set character and paragraph formatting for
	 * TextField objects. You can apply Cascading Style Sheets(CSS) styles to
	 * text fields by using the `TextField.styleSheet` property and the
	 * StyleSheet class. You can use CSS to style built-in HTML tags, define new
	 * formatting tags, or apply styles. You can assign HTML formatted text, which
	 * optionally uses CSS styles, directly to a text field. HTML text that you
	 * assign to a text field can contain embedded media(movie clips, SWF files,
	 * GIF files, PNG files, and JPEG files). The text wraps around the embedded
	 * media in the same way that a web browser wraps text around media embedded
	 * in an HTML document. 
	 *
	 * Flash Player supports a subset of HTML tags that you can use to format
	 * text. See the list of supported HTML tags in the description of the
	 * `htmlText` property.
	 * 
	 * @:event change                    Dispatched after a control value is
	 *                                  modified, unlike the
	 *                                  `textInput` event, which is
	 *                                  dispatched before the value is modified.
	 *                                  Unlike the W3C DOM Event Model version of
	 *                                  the `change` event, which
	 *                                  dispatches the event only after the
	 *                                  control loses focus, the ActionScript 3.0
	 *                                  version of the `change` event
	 *                                  is dispatched any time the control
	 *                                  changes. For example, if a user types text
	 *                                  into a text field, a `change`
	 *                                  event is dispatched after every keystroke.
	 * @:event link                      Dispatched when a user clicks a hyperlink
	 *                                  in an HTML-enabled text field, where the
	 *                                  URL begins with "event:". The remainder of
	 *                                  the URL after "event:" is placed in the
	 *                                  text property of the LINK event.
	 *
	 *                                  **Note:** The default behavior,
	 *                                  adding the text to the text field, occurs
	 *                                  only when Flash Player generates the
	 *                                  event, which in this case happens when a
	 *                                  user attempts to input text. You cannot
	 *                                  put text into a text field by sending it
	 *                                  `textInput` events.
	 * @:event scroll                    Dispatched by a TextField object
	 *                                  _after_ the user scrolls.
	 * @:event textInput                 Flash Player dispatches the
	 *                                  `textInput` event when a user
	 *                                  enters one or more characters of text.
	 *                                  Various text input methods can generate
	 *                                  this event, including standard keyboards,
	 *                                  input method editors(IMEs), voice or
	 *                                  speech recognition systems, and even the
	 *                                  act of pasting plain text with no
	 *                                  formatting or style information.
	 * @:event textInteractionModeChange Flash Player dispatches the
	 *                                  `textInteractionModeChange`
	 *                                  event when a user changes the interaction
	 *                                  mode of a text field. for example on
	 *                                  Android, one can toggle from NORMAL mode
	 *                                  to SELECTION mode using context menu
	 *                                  options
	 */
	export class TextField extends InteractiveObject {
		
		
		/**
		 * The type of anti-aliasing used for this text field. Use
		 * `flash.text.AntiAliasType` constants for this property. You can
		 * control this setting only if the font is embedded(with the
		 * `embedFonts` property set to `true`). The default
		 * setting is `flash.text.AntiAliasType.NORMAL`.
		 *
		 * To set values for this property, use the following string values:
		 */
		public readonly antiAliasType:AntiAliasType;
		
		/**
		 * Controls automatic sizing and alignment of text fields. Acceptable values
		 * for the `TextFieldAutoSize` constants:
		 * `TextFieldAutoSize.NONE`(the default),
		 * `TextFieldAutoSize.LEFT`, `TextFieldAutoSize.RIGHT`,
		 * and `TextFieldAutoSize.CENTER`.
		 *
		 * If `autoSize` is set to `TextFieldAutoSize.NONE`
		 * (the default) no resizing occurs.
		 *
		 * If `autoSize` is set to `TextFieldAutoSize.LEFT`,
		 * the text is treated as left-justified text, meaning that the left margin
		 * of the text field remains fixed and any resizing of a single line of the
		 * text field is on the right margin. If the text includes a line break(for
		 * example, `"\n"` or `"\r"`), the bottom is also
		 * resized to fit the next line of text. If `wordWrap` is also set
		 * to `true`, only the bottom of the text field is resized and the
		 * right side remains fixed.
		 *
		 * If `autoSize` is set to
		 * `TextFieldAutoSize.RIGHT`, the text is treated as
		 * right-justified text, meaning that the right margin of the text field
		 * remains fixed and any resizing of a single line of the text field is on
		 * the left margin. If the text includes a line break(for example,
		 * `"\n" or "\r")`, the bottom is also resized to fit the next
		 * line of text. If `wordWrap` is also set to `true`,
		 * only the bottom of the text field is resized and the left side remains
		 * fixed.
		 *
		 * If `autoSize` is set to
		 * `TextFieldAutoSize.CENTER`, the text is treated as
		 * center-justified text, meaning that any resizing of a single line of the
		 * text field is equally distributed to both the right and left margins. If
		 * the text includes a line break(for example, `"\n"` or
		 * `"\r"`), the bottom is also resized to fit the next line of
		 * text. If `wordWrap` is also set to `true`, only the
		 * bottom of the text field is resized and the left and right sides remain
		 * fixed.
		 * 
		 * @throws ArgumentError The `autoSize` specified is not a member
		 *                       of flash.text.TextFieldAutoSize.
		 */
		public autoSize:TextFieldAutoSize;
		
		/**
		 * Specifies whether the text field has a background fill. If
		 * `true`, the text field has a background fill. If
		 * `false`, the text field has no background fill. Use the
		 * `backgroundColor` property to set the background color of a
		 * text field.
		 * 
		 * @default false
		 */
		public background:boolean;
		
		/**
		 * The color of the text field background. The default value is
		 * `0xFFFFFF`(white). This property can be retrieved or set, even
		 * if there currently is no background, but the color is visible only if the
		 * text field has the `background` property set to
		 * `true`.
		 */
		public backgroundColor:number;
		
		/**
		 * Specifies whether the text field has a border. If `true`, the
		 * text field has a border. If `false`, the text field has no
		 * border. Use the `borderColor` property to set the border color.
		 * 
		 * @default false
		 */
		public border:boolean;
		
		/**
		 * The color of the text field border. The default value is
		 * `0x000000`(black). This property can be retrieved or set, even
		 * if there currently is no border, but the color is visible only if the text
		 * field has the `border` property set to `true`.
		 */
		public borderColor:number;
		
		/**
		 * An integer(1-based index) that indicates the bottommost line that is
		 * currently visible in the specified text field. Think of the text field as
		 * a window onto a block of text. The `scrollV` property is the
		 * 1-based index of the topmost visible line in the window.
		 *
		 * All the text between the lines indicated by `scrollV` and
		 * `bottomScrollV` is currently visible in the text field.
		 */
		public readonly bottomScrollV:number;
		
		/**
		 * The index of the insertion point(caret) position. If no insertion point
		 * is displayed, the value is the position the insertion point would be if
		 * you restored focus to the field(typically where the insertion point last
		 * was, or 0 if the field has not had focus).
		 *
		 * Selection span indexes are zero-based(for example, the first position
		 * is 0, the second position is 1, and so on).
		 */
		public readonly caretIndex:number;
		
		/**
		 * Specifies the format applied to newly inserted text, such as text entered
		 * by a user or text inserted with the `replaceSelectedText()`
		 * method.
		 *
		 * **Note:** When selecting characters to be replaced with
		 * `setSelection()` and `replaceSelectedText()`, the
		 * `defaultTextFormat` will be applied only if the text has been
		 * selected up to and including the last character. Here is an example:
		 *
		 * ```
		 * var my_txt:TextField new TextField();
		 * my_txt.text = "Flash Macintosh version"; var my_fmt:TextFormat = new
		 * TextFormat(); my_fmt.color = 0xFF0000; my_txt.defaultTextFormat = my_fmt;
		 * my_txt.setSelection(6,15); // partial text selected - defaultTextFormat
		 * not applied my_txt.setSelection(6,23); // text selected to end -
		 * defaultTextFormat applied my_txt.replaceSelectedText("Windows version");
		 * ```
		 *
		 * When you access the `defaultTextFormat` property, the
		 * returned TextFormat object has all of its properties defined. No property
		 * is `null`.
		 *
		 * **Note:** You can't set this property if a style sheet is applied to
		 * the text field.
		 * 
		 * @throws Error This method cannot be used on a text field with a style
		 *               sheet.
		 */
		public defaultTextFormat:TextFormat;
		
		/**
		 * Specifies whether the text field is a password text field. If the value of
		 * this property is `true`, the text field is treated as a
		 * password text field and hides the input characters using asterisks instead
		 * of the actual characters. If `false`, the text field is not
		 * treated as a password text field. When password mode is enabled, the Cut
		 * and Copy commands and their corresponding keyboard shortcuts will not
		 * function. This security mechanism prevents an unscrupulous user from using
		 * the shortcuts to discover a password on an unattended computer.
		 * 
		 * @default false
		 */
		public displayAsPassword:boolean;
		
		/**
		 * Specifies whether to render by using embedded font outlines. If
		 * `false`, Flash Player renders the text field by using device
		 * fonts.
		 *
		 * If you set the `embedFonts` property to `true`
		 * for a text field, you must specify a font for that text by using the
		 * `font` property of a TextFormat object applied to the text
		 * field. If the specified font is not embedded in the SWF file, the text is
		 * not displayed.
		 * 
		 * @default false
		 */
		public embedFonts:boolean;
		
		/**
		 * The type of grid fitting used for this text field. This property applies
		 * only if the `flash.text.AntiAliasType` property of the text
		 * field is set to `flash.text.AntiAliasType.ADVANCED`.
		 *
		 * The type of grid fitting used determines whether Flash Player forces
		 * strong horizontal and vertical lines to fit to a pixel or subpixel grid,
		 * or not at all.
		 *
		 * For the `flash.text.GridFitType` property, you can use the
		 * following string values:
		 * 
		 * @default pixel
		 */
		public gridFitType:GridFitType;
		
		/**
		 * Contains the HTML representation of the text field contents.
		 *
		 * Flash Player supports the following HTML tags:
		 *
		 * Flash Player and AIR also support explicit character codes, such as
		 * &#38;(ASCII ampersand) and &#x20AC;(Unicode € symbol). 
		 */
		public htmlText:string;
		
		/**
		 * The number of characters in a text field. A character such as tab
		 * (`\t`) counts as one character.
		 */
		public readonly length:number;
		
		/**
		 * The maximum number of characters that the text field can contain, as
		 * entered by a user. A script can insert more text than
		 * `maxChars` allows; the `maxChars` property indicates
		 * only how much text a user can enter. If the value of this property is
		 * `0`, a user can enter an unlimited amount of text.
		 * 
		 * @default 0
		 */
		public maxChars:number;
		
		/**
		 * The maximum value of `scrollH`.
		 */
		public readonly maxScrollH:number;
		
		/**
		 * The maximum value of `scrollV`.
		 */
		public readonly maxScrollV:number;
		
		public mouseWheelEnabled:boolean;
		
		/**
		 * Indicates whether field is a multiline text field. If the value is
		 * `true`, the text field is multiline; if the value is
		 * `false`, the text field is a single-line text field. In a field
		 * of type `TextFieldType.INPUT`, the `multiline` value
		 * determines whether the `Enter` key creates a new line(a value
		 * of `false`, and the `Enter` key is ignored). If you
		 * paste text into a `TextField` with a `multiline`
		 * value of `false`, newlines are stripped out of the text.
		 * 
		 * @default false
		 */
		public multiline:boolean;
		
		/**
		 * Defines the number of text lines in a multiline text field. If
		 * `wordWrap` property is set to `true`, the number of
		 * lines increases when text wraps.
		 */
		public readonly numLines:number;
		
		/**
		 * Indicates the set of characters that a user can enter into the text field.
		 * If the value of the `restrict` property is `null`,
		 * you can enter any character. If the value of the `restrict`
		 * property is an empty string, you cannot enter any character. If the value
		 * of the `restrict` property is a string of characters, you can
		 * enter only characters in the string into the text field. The string is
		 * scanned from left to right. You can specify a range by using the hyphen
		 * (-) character. Only user interaction is restricted; a script can put any
		 * text into the text field. <ph outputclass="flashonly">This property does
		 * not synchronize with the Embed font options in the Property inspector.
		 *
		 * If the string begins with a caret(^) character, all characters are
		 * initially accepted and succeeding characters in the string are excluded
		 * from the set of accepted characters. If the string does not begin with a
		 * caret(^) character, no characters are initially accepted and succeeding
		 * characters in the string are included in the set of accepted
		 * characters.
		 *
		 * The following example allows only uppercase characters, spaces, and
		 * numbers to be entered into a text field:
		 * `my_txt.restrict = "A-Z 0-9";`
		 *
		 * The following example includes all characters, but excludes lowercase
		 * letters:
		 * `my_txt.restrict = "^a-z";`
		 *
		 * You can use a backslash to enter a ^ or - verbatim. The accepted
		 * backslash sequences are \-, \^ or \\. The backslash must be an actual
		 * character in the string, so when specified in ActionScript, a double
		 * backslash must be used. For example, the following code includes only the
		 * dash(-) and caret(^):
		 * `my_txt.restrict = "\\-\\^";`
		 *
		 * The ^ can be used anywhere in the string to toggle between including
		 * characters and excluding characters. The following code includes only
		 * uppercase letters, but excludes the uppercase letter Q:
		 * `my_txt.restrict = "A-Z^Q";`
		 *
		 * You can use the `\u` escape sequence to construct
		 * `restrict` strings. The following code includes only the
		 * characters from ASCII 32(space) to ASCII 126(tilde).
		 * `my_txt.restrict = "\u0020-\u007E";`
		 * 
		 * @default null
		 */
		public restrict:string;
		
		/**
		 * The current horizontal scrolling position. If the `scrollH`
		 * property is 0, the text is not horizontally scrolled. This property value
		 * is an integer that represents the horizontal position in pixels.
		 *
		 * The units of horizontal scrolling are pixels, whereas the units of
		 * vertical scrolling are lines. Horizontal scrolling is measured in pixels
		 * because most fonts you typically use are proportionally spaced; that is,
		 * the characters can have different widths. Flash Player performs vertical
		 * scrolling by line because users usually want to see a complete line of
		 * text rather than a partial line. Even if a line uses multiple fonts, the
		 * height of the line adjusts to fit the largest font in use.
		 *
		 * **Note: **The `scrollH` property is zero-based, not
		 * 1-based like the `scrollV` vertical scrolling property.
		 */
		public scrollH:number;
		
		/**
		 * The vertical position of text in a text field. The `scrollV`
		 * property is useful for directing users to a specific paragraph in a long
		 * passage, or creating scrolling text fields.
		 *
		 * The units of vertical scrolling are lines, whereas the units of
		 * horizontal scrolling are pixels. If the first line displayed is the first
		 * line in the text field, scrollV is set to 1(not 0). Horizontal scrolling
		 * is measured in pixels because most fonts are proportionally spaced; that
		 * is, the characters can have different widths. Flash performs vertical
		 * scrolling by line because users usually want to see a complete line of
		 * text rather than a partial line. Even if there are multiple fonts on a
		 * line, the height of the line adjusts to fit the largest font in use.
		 */
		public scrollV:number;
		
		/**
		 * A Boolean value that indicates whether the text field is selectable. The
		 * value `true` indicates that the text is selectable. The
		 * `selectable` property controls whether a text field is
		 * selectable, not whether a text field is editable. A dynamic text field can
		 * be selectable even if it is not editable. If a dynamic text field is not
		 * selectable, the user cannot select its text.
		 *
		 * If `selectable` is set to `false`, the text in
		 * the text field does not respond to selection commands from the mouse or
		 * keyboard, and the text cannot be copied with the Copy command. If
		 * `selectable` is set to `true`, the text in the text
		 * field can be selected with the mouse or keyboard, and the text can be
		 * copied with the Copy command. You can select text this way even if the
		 * text field is a dynamic text field instead of an input text field. 
		 * 
		 * @default true
		 */
		public selectable:boolean;
		
		/**
		 * The zero-based character index value of the first character in the current
		 * selection. For example, the first character is 0, the second character is
		 * 1, and so on. If no text is selected, this property is the value of
		 * `caretIndex`.
		 */
		public readonly selectionBeginIndex:number;
		
		/**
		 * The zero-based character index value of the last character in the current
		 * selection. For example, the first character is 0, the second character is
		 * 1, and so on. If no text is selected, this property is the value of
		 * `caretIndex`.
		 */
		public readonly selectionEndIndex:number;
		
		/**
		 * The sharpness of the glyph edges in this text field. This property applies
		 * only if the `flash.text.AntiAliasType` property of the text
		 * field is set to `flash.text.AntiAliasType.ADVANCED`. The range
		 * for `sharpness` is a number from -400 to 400. If you attempt to
		 * set `sharpness` to a value outside that range, Flash sets the
		 * property to the nearest value in the range(either -400 or 400).
		 * 
		 * @default 0
		 */
		public sharpness:number;
		
		/**
		 * A string that is the current text in the text field. Lines are separated
		 * by the carriage return character(`'\r'`, ASCII 13). This
		 * property contains unformatted text in the text field, without HTML tags.
		 *
		 * To get the text in HTML form, use the `htmlText`
		 * property.
		 */
		public text:string;
		
		/**
		 * The color of the text in a text field, in hexadecimal format. The
		 * hexadecimal color system uses six digits to represent color values. Each
		 * digit has 16 possible values or characters. The characters range from 0-9
		 * and then A-F. For example, black is `0x000000`; white is
		 * `0xFFFFFF`.
		 * 
		 * @default 0(0x000000)
		 */
		public textColor:number;
		
		/**
		 * The height of the text in pixels.
		 */
		public readonly textHeight:number;
		
		/**
		 * The width of the text in pixels.
		 */
		public readonly textWidth:number;
		
		/**
		 * The type of the text field. Either one of the following TextFieldType
		 * constants: `TextFieldType.DYNAMIC`, which specifies a dynamic
		 * text field, which a user cannot edit, or `TextFieldType.INPUT`,
		 * which specifies an input text field, which a user can edit.
		 * 
		 * @default dynamic
		 * @throws ArgumentError The `type` specified is not a member of
		 *                       flash.text.TextFieldType.
		 */
		public type:TextFieldType;
		
		/**
		 * A Boolean value that indicates whether the text field has word wrap. If
		 * the value of `wordWrap` is `true`, the text field
		 * has word wrap; if the value is `false`, the text field does not
		 * have word wrap. The default value is `false`.
		 */
		public wordWrap:boolean;
		
		
		/**
		 * Creates a new TextField instance. After you create the TextField instance,
		 * call the `addChild()` or `addChildAt()` method of
		 * the parent DisplayObjectContainer object to add the TextField instance to
		 * the display list.
		 *
		 * The default size for a text field is 100 x 100 pixels.
		 */
		public constructor ();
		
		
		/**
		 * Appends the string specified by the `newText` parameter to the
		 * end of the text of the text field. This method is more efficient than an
		 * addition assignment(`+=`) on a `text` property
		 * (such as `someTextField.text += moreText`), particularly for a
		 * text field that contains a significant amount of content.
		 * 
		 * @param newText The string to append to the existing text.
		 */
		public appendText (text:string):void;
		
		
		/**
		 * Returns a rectangle that is the bounding box of the character.
		 * 
		 * @param charIndex The zero-based index value for the character(for
		 *                  example, the first position is 0, the second position is
		 *                  1, and so on).
		 * @return A rectangle with `x` and `y` minimum and
		 *         maximum values defining the bounding box of the character.
		 */
		public getCharBoundaries (charIndex:number):Rectangle;
		
		
		/**
		 * Returns the zero-based index value of the character at the point specified
		 * by the `x` and `y` parameters.
		 * 
		 * @param x The _x_ coordinate of the character.
		 * @param y The _y_ coordinate of the character.
		 * @return The zero-based index value of the character(for example, the
		 *         first position is 0, the second position is 1, and so on). Returns
		 *         -1 if the point is not over any character.
		 */
		public getCharIndexAtPoint (x:number, y:number):number;
		
		
		public getFirstCharInParagraph (charIndex:number):number;
		
		
		/**
		 * Returns the zero-based index value of the line at the point specified by
		 * the `x` and `y` parameters.
		 * 
		 * @param x The _x_ coordinate of the line.
		 * @param y The _y_ coordinate of the line.
		 * @return The zero-based index value of the line(for example, the first
		 *         line is 0, the second line is 1, and so on). Returns -1 if the
		 *         point is not over any line.
		 */
		public getLineIndexAtPoint (x:number, y:number):number;
		
		
		public getLineIndexOfChar (charIndex:number):number;
		
		
		public getLineLength (lineIndex:number):number;
		
		
		/**
		 * Returns metrics information about a given text line.
		 * 
		 * @param lineIndex The line number for which you want metrics information.
		 * @return A TextLineMetrics object.
		 * @throws RangeError The line number specified is out of range.
		 */
		public getLineMetrics (lineIndex:number):TextLineMetrics;
		
		
		/**
		 * Returns the character index of the first character in the line that the
		 * `lineIndex` parameter specifies.
		 * 
		 * @param lineIndex The zero-based index value of the line(for example, the
		 *                  first line is 0, the second line is 1, and so on).
		 * @return The zero-based index value of the first character in the line.
		 * @throws RangeError The line number specified is out of range.
		 */
		public getLineOffset (lineIndex:number):number;
		
		
		/**
		 * Returns the text of the line specified by the `lineIndex`
		 * parameter.
		 * 
		 * @param lineIndex The zero-based index value of the line(for example, the
		 *                  first line is 0, the second line is 1, and so on).
		 * @return The text string contained in the specified line.
		 * @throws RangeError The line number specified is out of range.
		 */
		public getLineText (lineIndex:number):string;
		
		
		public getParagraphLength (charIndex:number):number;
		
		
		/**
		 * Returns a TextFormat object that contains formatting information for the
		 * range of text that the `beginIndex` and `endIndex`
		 * parameters specify. Only properties that are common to the entire text
		 * specified are set in the resulting TextFormat object. Any property that is
		 * _mixed_, meaning that it has different values at different points in
		 * the text, has a value of `null`.
		 *
		 * If you do not specify values for these parameters, this method is
		 * applied to all the text in the text field. 
		 *
		 * The following table describes three possible usages:
		 * 
		 * @return The TextFormat object that represents the formatting properties
		 *         for the specified text.
		 * @throws RangeError The `beginIndex` or `endIndex`
		 *                    specified is out of range.
		 */
		public getTextFormat (beginIndex?:number, endIndex?:number):TextFormat;
		
		
		public replaceSelectedText (value:string):void;
		
		
		public replaceText (beginIndex:number, endIndex:number, newText:string):void;
		
		
		/**
		 * Sets as selected the text designated by the index values of the first and
		 * last characters, which are specified with the `beginIndex` and
		 * `endIndex` parameters. If the two parameter values are the
		 * same, this method sets the insertion point, as if you set the
		 * `caretIndex` property.
		 * 
		 * @param beginIndex The zero-based index value of the first character in the
		 *                   selection(for example, the first character is 0, the
		 *                   second character is 1, and so on).
		 * @param endIndex   The zero-based index value of the last character in the
		 *                   selection.
		 */
		public setSelection (beginIndex:number, endIndex:number):void;
		
		
		/**
		 * Applies the text formatting that the `format` parameter
		 * specifies to the specified text in a text field. The value of
		 * `format` must be a TextFormat object that specifies the desired
		 * text formatting changes. Only the non-null properties of
		 * `format` are applied to the text field. Any property of
		 * `format` that is set to `null` is not applied. By
		 * default, all of the properties of a newly created TextFormat object are
		 * set to `null`.
		 *
		 * **Note:** This method does not work if a style sheet is applied to
		 * the text field.
		 *
		 * The `setTextFormat()` method changes the text formatting
		 * applied to a range of characters or to the entire body of text in a text
		 * field. To apply the properties of format to all text in the text field, do
		 * not specify values for `beginIndex` and `endIndex`.
		 * To apply the properties of the format to a range of text, specify values
		 * for the `beginIndex` and the `endIndex` parameters.
		 * You can use the `length` property to determine the index
		 * values.
		 *
		 * The two types of formatting information in a TextFormat object are
		 * character level formatting and paragraph level formatting. Each character
		 * in a text field can have its own character formatting settings, such as
		 * font name, font size, bold, and italic.
		 *
		 * For paragraphs, the first character of the paragraph is examined for
		 * the paragraph formatting settings for the entire paragraph. Examples of
		 * paragraph formatting settings are left margin, right margin, and
		 * indentation.
		 *
		 * Any text inserted manually by the user, or replaced by the
		 * `replaceSelectedText()` method, receives the default text field
		 * formatting for new text, and not the formatting specified for the text
		 * insertion point. To set the default formatting for new text, use
		 * `defaultTextFormat`.
		 * 
		 * @param format A TextFormat object that contains character and paragraph
		 *               formatting information.
		 * @throws Error      This method cannot be used on a text field with a style
		 *                    sheet.
		 * @throws RangeError The `beginIndex` or `endIndex`
		 *                    specified is out of range.
		 */
		public setTextFormat (format:TextFormat, beginIndex?:number, endIndex?:number):void;
		
		
	}
	
	
}


export default openfl.text.TextField;