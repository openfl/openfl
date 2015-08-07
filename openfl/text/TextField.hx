package openfl.text; #if !flash #if !openfl_legacy


import lime.ui.MouseCursor;
import openfl._internal.renderer.cairo.CairoTextField;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl._internal.text.TextEngine;
import openfl._internal.text.TextFormatRange;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.InteractiveObject;
import openfl.events.FocusEvent;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Lib;

#if (js && html5)
import js.html.DivElement;
#end


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
 * <p>To create a text field dynamically, use the <code>TextField()</code>
 * constructor.</p>
 *
 * <p>The methods of the TextField class let you set, select, and manipulate
 * text in a dynamic or input text field that you create during authoring or
 * at runtime. </p>
 *
 * <p>ActionScript provides several ways to format your text at runtime. The
 * TextFormat class lets you set character and paragraph formatting for
 * TextField objects. You can apply Cascading Style Sheets(CSS) styles to
 * text fields by using the <code>TextField.styleSheet</code> property and the
 * StyleSheet class. You can use CSS to style built-in HTML tags, define new
 * formatting tags, or apply styles. You can assign HTML formatted text, which
 * optionally uses CSS styles, directly to a text field. HTML text that you
 * assign to a text field can contain embedded media(movie clips, SWF files,
 * GIF files, PNG files, and JPEG files). The text wraps around the embedded
 * media in the same way that a web browser wraps text around media embedded
 * in an HTML document. </p>
 *
 * <p>Flash Player supports a subset of HTML tags that you can use to format
 * text. See the list of supported HTML tags in the description of the
 * <code>htmlText</code> property.</p>
 * 
 * @event change                    Dispatched after a control value is
 *                                  modified, unlike the
 *                                  <code>textInput</code> event, which is
 *                                  dispatched before the value is modified.
 *                                  Unlike the W3C DOM Event Model version of
 *                                  the <code>change</code> event, which
 *                                  dispatches the event only after the
 *                                  control loses focus, the ActionScript 3.0
 *                                  version of the <code>change</code> event
 *                                  is dispatched any time the control
 *                                  changes. For example, if a user types text
 *                                  into a text field, a <code>change</code>
 *                                  event is dispatched after every keystroke.
 * @event link                      Dispatched when a user clicks a hyperlink
 *                                  in an HTML-enabled text field, where the
 *                                  URL begins with "event:". The remainder of
 *                                  the URL after "event:" is placed in the
 *                                  text property of the LINK event.
 *
 *                                  <p><b>Note:</b> The default behavior,
 *                                  adding the text to the text field, occurs
 *                                  only when Flash Player generates the
 *                                  event, which in this case happens when a
 *                                  user attempts to input text. You cannot
 *                                  put text into a text field by sending it
 *                                  <code>textInput</code> events.</p>
 * @event scroll                    Dispatched by a TextField object
 *                                  <i>after</i> the user scrolls.
 * @event textInput                 Flash Player dispatches the
 *                                  <code>textInput</code> event when a user
 *                                  enters one or more characters of text.
 *                                  Various text input methods can generate
 *                                  this event, including standard keyboards,
 *                                  input method editors(IMEs), voice or
 *                                  speech recognition systems, and even the
 *                                  act of pasting plain text with no
 *                                  formatting or style information.
 * @event textInteractionModeChange Flash Player dispatches the
 *                                  <code>textInteractionModeChange</code>
 *                                  event when a user changes the interaction
 *                                  mode of a text field. for example on
 *                                  Android, one can toggle from NORMAL mode
 *                                  to SELECTION mode using context menu
 *                                  options
 */

@:access(openfl.display.Graphics)
@:access(openfl.geom.Rectangle)
@:access(openfl._internal.text.TextEngine)
@:access(openfl.text.TextFormat)


class TextField extends InteractiveObject {
	
	
	@:noCompletion private static var __defaultTextFormat:TextFormat;
	
	/**
	 * The type of anti-aliasing used for this text field. Use
	 * <code>flash.text.AntiAliasType</code> constants for this property. You can
	 * control this setting only if the font is embedded(with the
	 * <code>embedFonts</code> property set to <code>true</code>). The default
	 * setting is <code>flash.text.AntiAliasType.NORMAL</code>.
	 *
	 * <p>To set values for this property, use the following string values:</p>
	 */
	public var antiAliasType (get, set):AntiAliasType;
	
	/**
	 * Controls automatic sizing and alignment of text fields. Acceptable values
	 * for the <code>TextFieldAutoSize</code> constants:
	 * <code>TextFieldAutoSize.NONE</code>(the default),
	 * <code>TextFieldAutoSize.LEFT</code>, <code>TextFieldAutoSize.RIGHT</code>,
	 * and <code>TextFieldAutoSize.CENTER</code>.
	 *
	 * <p>If <code>autoSize</code> is set to <code>TextFieldAutoSize.NONE</code>
	 * (the default) no resizing occurs.</p>
	 *
	 * <p>If <code>autoSize</code> is set to <code>TextFieldAutoSize.LEFT</code>,
	 * the text is treated as left-justified text, meaning that the left margin
	 * of the text field remains fixed and any resizing of a single line of the
	 * text field is on the right margin. If the text includes a line break(for
	 * example, <code>"\n"</code> or <code>"\r"</code>), the bottom is also
	 * resized to fit the next line of text. If <code>wordWrap</code> is also set
	 * to <code>true</code>, only the bottom of the text field is resized and the
	 * right side remains fixed.</p>
	 *
	 * <p>If <code>autoSize</code> is set to
	 * <code>TextFieldAutoSize.RIGHT</code>, the text is treated as
	 * right-justified text, meaning that the right margin of the text field
	 * remains fixed and any resizing of a single line of the text field is on
	 * the left margin. If the text includes a line break(for example,
	 * <code>"\n" or "\r")</code>, the bottom is also resized to fit the next
	 * line of text. If <code>wordWrap</code> is also set to <code>true</code>,
	 * only the bottom of the text field is resized and the left side remains
	 * fixed.</p>
	 *
	 * <p>If <code>autoSize</code> is set to
	 * <code>TextFieldAutoSize.CENTER</code>, the text is treated as
	 * center-justified text, meaning that any resizing of a single line of the
	 * text field is equally distributed to both the right and left margins. If
	 * the text includes a line break(for example, <code>"\n"</code> or
	 * <code>"\r"</code>), the bottom is also resized to fit the next line of
	 * text. If <code>wordWrap</code> is also set to <code>true</code>, only the
	 * bottom of the text field is resized and the left and right sides remain
	 * fixed.</p>
	 * 
	 * @throws ArgumentError The <code>autoSize</code> specified is not a member
	 *                       of flash.text.TextFieldAutoSize.
	 */
	public var autoSize (get, set):TextFieldAutoSize;
	
	/**
	 * Specifies whether the text field has a background fill. If
	 * <code>true</code>, the text field has a background fill. If
	 * <code>false</code>, the text field has no background fill. Use the
	 * <code>backgroundColor</code> property to set the background color of a
	 * text field.
	 * 
	 * @default false
	 */
	public var background (get, set):Bool;
	
	/**
	 * The color of the text field background. The default value is
	 * <code>0xFFFFFF</code>(white). This property can be retrieved or set, even
	 * if there currently is no background, but the color is visible only if the
	 * text field has the <code>background</code> property set to
	 * <code>true</code>.
	 */
	public var backgroundColor (get, set):Int;
	
	/**
	 * Specifies whether the text field has a border. If <code>true</code>, the
	 * text field has a border. If <code>false</code>, the text field has no
	 * border. Use the <code>borderColor</code> property to set the border color.
	 * 
	 * @default false
	 */
	public var border (get, set):Bool;
	
	/**
	 * The color of the text field border. The default value is
	 * <code>0x000000</code>(black). This property can be retrieved or set, even
	 * if there currently is no border, but the color is visible only if the text
	 * field has the <code>border</code> property set to <code>true</code>.
	 */
	public var borderColor (get, set):Int;
	
	/**
	 * An integer(1-based index) that indicates the bottommost line that is
	 * currently visible in the specified text field. Think of the text field as
	 * a window onto a block of text. The <code>scrollV</code> property is the
	 * 1-based index of the topmost visible line in the window.
	 *
	 * <p>All the text between the lines indicated by <code>scrollV</code> and
	 * <code>bottomScrollV</code> is currently visible in the text field.</p>
	 */
	public var bottomScrollV (get, null):Int;
	
	/**
	 * The index of the insertion point(caret) position. If no insertion point
	 * is displayed, the value is the position the insertion point would be if
	 * you restored focus to the field(typically where the insertion point last
	 * was, or 0 if the field has not had focus).
	 *
	 * <p>Selection span indexes are zero-based(for example, the first position
	 * is 0, the second position is 1, and so on).</p>
	 */
	public var caretIndex (get, null):Int;
	
	/**
	 * Specifies the format applied to newly inserted text, such as text entered
	 * by a user or text inserted with the <code>replaceSelectedText()</code>
	 * method.
	 *
	 * <p><b>Note:</b> When selecting characters to be replaced with
	 * <code>setSelection()</code> and <code>replaceSelectedText()</code>, the
	 * <code>defaultTextFormat</code> will be applied only if the text has been
	 * selected up to and including the last character. Here is an example:</p>
	 * <pre xml:space="preserve"> var my_txt:TextField new TextField();
	 * my_txt.text = "Flash Macintosh version"; var my_fmt:TextFormat = new
	 * TextFormat(); my_fmt.color = 0xFF0000; my_txt.defaultTextFormat = my_fmt;
	 * my_txt.setSelection(6,15); // partial text selected - defaultTextFormat
	 * not applied my_txt.setSelection(6,23); // text selected to end -
	 * defaultTextFormat applied my_txt.replaceSelectedText("Windows version");
	 * </pre>
	 *
	 * <p>When you access the <code>defaultTextFormat</code> property, the
	 * returned TextFormat object has all of its properties defined. No property
	 * is <code>null</code>.</p>
	 *
	 * <p><b>Note:</b> You can't set this property if a style sheet is applied to
	 * the text field.</p>
	 * 
	 * @throws Error This method cannot be used on a text field with a style
	 *               sheet.
	 */
	public var defaultTextFormat (get, set):TextFormat;
	
	/**
	 * Specifies whether the text field is a password text field. If the value of
	 * this property is <code>true</code>, the text field is treated as a
	 * password text field and hides the input characters using asterisks instead
	 * of the actual characters. If <code>false</code>, the text field is not
	 * treated as a password text field. When password mode is enabled, the Cut
	 * and Copy commands and their corresponding keyboard shortcuts will not
	 * function. This security mechanism prevents an unscrupulous user from using
	 * the shortcuts to discover a password on an unattended computer.
	 * 
	 * @default false
	 */
	public var displayAsPassword (get, set):Bool;
	
	/**
	 * Specifies whether to render by using embedded font outlines. If
	 * <code>false</code>, Flash Player renders the text field by using device
	 * fonts.
	 *
	 * <p>If you set the <code>embedFonts</code> property to <code>true</code>
	 * for a text field, you must specify a font for that text by using the
	 * <code>font</code> property of a TextFormat object applied to the text
	 * field. If the specified font is not embedded in the SWF file, the text is
	 * not displayed.</p>
	 * 
	 * @default false
	 */
	public var embedFonts (get, set):Bool;
	
	/**
	 * The type of grid fitting used for this text field. This property applies
	 * only if the <code>flash.text.AntiAliasType</code> property of the text
	 * field is set to <code>flash.text.AntiAliasType.ADVANCED</code>.
	 *
	 * <p>The type of grid fitting used determines whether Flash Player forces
	 * strong horizontal and vertical lines to fit to a pixel or subpixel grid,
	 * or not at all.</p>
	 *
	 * <p>For the <code>flash.text.GridFitType</code> property, you can use the
	 * following string values:</p>
	 * 
	 * @default pixel
	 */
	public var gridFitType (get, set):GridFitType;
	
	/**
	 * Contains the HTML representation of the text field contents.
	 *
	 * <p>Flash Player supports the following HTML tags:</p>
	 *
	 * <p>Flash Player and AIR also support explicit character codes, such as
	 * &#38;(ASCII ampersand) and &#x20AC;(Unicode € symbol). </p>
	 */
	public var htmlText (get, set):String;
	
	/**
	 * The number of characters in a text field. A character such as tab
	 * (<code>\t</code>) counts as one character.
	 */
	public var length (get, null):Int;
	
	/**
	 * The maximum number of characters that the text field can contain, as
	 * entered by a user. A script can insert more text than
	 * <code>maxChars</code> allows; the <code>maxChars</code> property indicates
	 * only how much text a user can enter. If the value of this property is
	 * <code>0</code>, a user can enter an unlimited amount of text.
	 * 
	 * @default 0
	 */
	public var maxChars (get, set):Int;
	
	/**
	 * The maximum value of <code>scrollH</code>.
	 */
	public var maxScrollH (get, null):Int;
	
	/**
	 * The maximum value of <code>scrollV</code>.
	 */
	public var maxScrollV (get, null):Int;
	
	/**
	 * Indicates whether field is a multiline text field. If the value is
	 * <code>true</code>, the text field is multiline; if the value is
	 * <code>false</code>, the text field is a single-line text field. In a field
	 * of type <code>TextFieldType.INPUT</code>, the <code>multiline</code> value
	 * determines whether the <code>Enter</code> key creates a new line(a value
	 * of <code>false</code>, and the <code>Enter</code> key is ignored). If you
	 * paste text into a <code>TextField</code> with a <code>multiline</code>
	 * value of <code>false</code>, newlines are stripped out of the text.
	 * 
	 * @default false
	 */
	public var multiline (get, set):Bool;
	
	/**
	 * Defines the number of text lines in a multiline text field. If
	 * <code>wordWrap</code> property is set to <code>true</code>, the number of
	 * lines increases when text wraps.
	 */
	public var numLines (get, null):Int;
	
	/**
	 * Indicates the set of characters that a user can enter into the text field.
	 * If the value of the <code>restrict</code> property is <code>null</code>,
	 * you can enter any character. If the value of the <code>restrict</code>
	 * property is an empty string, you cannot enter any character. If the value
	 * of the <code>restrict</code> property is a string of characters, you can
	 * enter only characters in the string into the text field. The string is
	 * scanned from left to right. You can specify a range by using the hyphen
	 * (-) character. Only user interaction is restricted; a script can put any
	 * text into the text field. <ph outputclass="flashonly">This property does
	 * not synchronize with the Embed font options in the Property inspector.
	 *
	 * <p>If the string begins with a caret(^) character, all characters are
	 * initially accepted and succeeding characters in the string are excluded
	 * from the set of accepted characters. If the string does not begin with a
	 * caret(^) character, no characters are initially accepted and succeeding
	 * characters in the string are included in the set of accepted
	 * characters.</p>
	 *
	 * <p>The following example allows only uppercase characters, spaces, and
	 * numbers to be entered into a text field:</p>
	 * <pre xml:space="preserve"> my_txt.restrict = "A-Z 0-9"; </pre>
	 *
	 * <p>The following example includes all characters, but excludes lowercase
	 * letters:</p>
	 * <pre xml:space="preserve"> my_txt.restrict = "^a-z"; </pre>
	 *
	 * <p>You can use a backslash to enter a ^ or - verbatim. The accepted
	 * backslash sequences are \-, \^ or \\. The backslash must be an actual
	 * character in the string, so when specified in ActionScript, a double
	 * backslash must be used. For example, the following code includes only the
	 * dash(-) and caret(^):</p>
	 * <pre xml:space="preserve"> my_txt.restrict = "\\-\\^"; </pre>
	 *
	 * <p>The ^ can be used anywhere in the string to toggle between including
	 * characters and excluding characters. The following code includes only
	 * uppercase letters, but excludes the uppercase letter Q:</p>
	 * <pre xml:space="preserve"> my_txt.restrict = "A-Z^Q"; </pre>
	 *
	 * <p>You can use the <code>\u</code> escape sequence to construct
	 * <code>restrict</code> strings. The following code includes only the
	 * characters from ASCII 32(space) to ASCII 126(tilde).</p>
	 * <pre xml:space="preserve"> my_txt.restrict = "\u0020-\u007E"; </pre>
	 * 
	 * @default null
	 */
	public var restrict (get, set):String;
	
	/**
	 * The current horizontal scrolling position. If the <code>scrollH</code>
	 * property is 0, the text is not horizontally scrolled. This property value
	 * is an integer that represents the horizontal position in pixels.
	 *
	 * <p>The units of horizontal scrolling are pixels, whereas the units of
	 * vertical scrolling are lines. Horizontal scrolling is measured in pixels
	 * because most fonts you typically use are proportionally spaced; that is,
	 * the characters can have different widths. Flash Player performs vertical
	 * scrolling by line because users usually want to see a complete line of
	 * text rather than a partial line. Even if a line uses multiple fonts, the
	 * height of the line adjusts to fit the largest font in use.</p>
	 *
	 * <p><b>Note: </b>The <code>scrollH</code> property is zero-based, not
	 * 1-based like the <code>scrollV</code> vertical scrolling property.</p>
	 */
	public var scrollH (get, set):Int;
	
	/**
	 * The vertical position of text in a text field. The <code>scrollV</code>
	 * property is useful for directing users to a specific paragraph in a long
	 * passage, or creating scrolling text fields.
	 *
	 * <p>The units of vertical scrolling are lines, whereas the units of
	 * horizontal scrolling are pixels. If the first line displayed is the first
	 * line in the text field, scrollV is set to 1(not 0). Horizontal scrolling
	 * is measured in pixels because most fonts are proportionally spaced; that
	 * is, the characters can have different widths. Flash performs vertical
	 * scrolling by line because users usually want to see a complete line of
	 * text rather than a partial line. Even if there are multiple fonts on a
	 * line, the height of the line adjusts to fit the largest font in use.</p>
	 */
	public var scrollV (get, set):Int;
	
	/**
	 * A Boolean value that indicates whether the text field is selectable. The
	 * value <code>true</code> indicates that the text is selectable. The
	 * <code>selectable</code> property controls whether a text field is
	 * selectable, not whether a text field is editable. A dynamic text field can
	 * be selectable even if it is not editable. If a dynamic text field is not
	 * selectable, the user cannot select its text.
	 *
	 * <p>If <code>selectable</code> is set to <code>false</code>, the text in
	 * the text field does not respond to selection commands from the mouse or
	 * keyboard, and the text cannot be copied with the Copy command. If
	 * <code>selectable</code> is set to <code>true</code>, the text in the text
	 * field can be selected with the mouse or keyboard, and the text can be
	 * copied with the Copy command. You can select text this way even if the
	 * text field is a dynamic text field instead of an input text field. </p>
	 * 
	 * @default true
	 */
	public var selectable (get, set):Bool;
	
	/**
	 * The zero-based character index value of the first character in the current
	 * selection. For example, the first character is 0, the second character is
	 * 1, and so on. If no text is selected, this property is the value of
	 * <code>caretIndex</code>.
	 */
	public var selectionBeginIndex (get, null):Int;
	
	/**
	 * The zero-based character index value of the last character in the current
	 * selection. For example, the first character is 0, the second character is
	 * 1, and so on. If no text is selected, this property is the value of
	 * <code>caretIndex</code>.
	 */
	public var selectionEndIndex (get, null):Int;
	
	/**
	 * The sharpness of the glyph edges in this text field. This property applies
	 * only if the <code>flash.text.AntiAliasType</code> property of the text
	 * field is set to <code>flash.text.AntiAliasType.ADVANCED</code>. The range
	 * for <code>sharpness</code> is a number from -400 to 400. If you attempt to
	 * set <code>sharpness</code> to a value outside that range, Flash sets the
	 * property to the nearest value in the range(either -400 or 400).
	 * 
	 * @default 0
	 */
	public var sharpness (get, set):Float;
	
	/**
	 * A string that is the current text in the text field. Lines are separated
	 * by the carriage return character(<code>'\r'</code>, ASCII 13). This
	 * property contains unformatted text in the text field, without HTML tags.
	 *
	 * <p>To get the text in HTML form, use the <code>htmlText</code>
	 * property.</p>
	 */
	public var text (get, set):String;
	
	/**
	 * The color of the text in a text field, in hexadecimal format. The
	 * hexadecimal color system uses six digits to represent color values. Each
	 * digit has 16 possible values or characters. The characters range from 0-9
	 * and then A-F. For example, black is <code>0x000000</code>; white is
	 * <code>0xFFFFFF</code>.
	 * 
	 * @default 0(0x000000)
	 */
	public var textColor (get, set):Int;
	
	/**
	 * The height of the text in pixels.
	 */
	public var textHeight (get, null):Float;
	
	/**
	 * The width of the text in pixels.
	 */
	public var textWidth (get, null):Float;
	
	/**
	 * The type of the text field. Either one of the following TextFieldType
	 * constants: <code>TextFieldType.DYNAMIC</code>, which specifies a dynamic
	 * text field, which a user cannot edit, or <code>TextFieldType.INPUT</code>,
	 * which specifies an input text field, which a user can edit.
	 * 
	 * @default dynamic
	 * @throws ArgumentError The <code>type</code> specified is not a member of
	 *                       flash.text.TextFieldType.
	 */
	public var type (get, set):TextFieldType;
	
	/**
	 * A Boolean value that indicates whether the text field has word wrap. If
	 * the value of <code>wordWrap</code> is <code>true</code>, the text field
	 * has word wrap; if the value is <code>false</code>, the text field does not
	 * have word wrap. The default value is <code>false</code>.
	 */
	public var wordWrap (get, set):Bool;
	
	@:noCompletion private var __bounds:Rectangle;
	@:noCompletion private var __caretIndex:Int;
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __isHTML:Bool;
	@:noCompletion private var __layoutDirty:Bool;
	@:noCompletion private var __textEngine:TextEngine;
	@:noCompletion private var __textFormat:TextFormat;
	
	#if (js && html5)
	@:noCompletion private var __div:DivElement;
	#end
	
	
	/**
	 * Creates a new TextField instance. After you create the TextField instance,
	 * call the <code>addChild()</code> or <code>addChildAt()</code> method of
	 * the parent DisplayObjectContainer object to add the TextField instance to
	 * the display list.
	 *
	 * <p>The default size for a text field is 100 x 100 pixels.</p>
	 */
	public function new () {
		
		super ();
		
		__caretIndex = -1;
		__graphics = new Graphics ();
		__textEngine = new TextEngine (this);
		__layoutDirty = true;
		
		if (__defaultTextFormat == null) {
			
			__defaultTextFormat = new TextFormat ("Times New Roman", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			__defaultTextFormat.blockIndent = 0;
			__defaultTextFormat.bullet = false;
			__defaultTextFormat.letterSpacing = 0;
			__defaultTextFormat.kerning = false;
			
		}
		
		__textFormat = __defaultTextFormat.clone ();
		__textEngine.textFormatRanges.push (new TextFormatRange (__textFormat, 0, 0));
		
	}
	
	
	/**
	 * Appends the string specified by the <code>newText</code> parameter to the
	 * end of the text of the text field. This method is more efficient than an
	 * addition assignment(<code>+=</code>) on a <code>text</code> property
	 * (such as <code>someTextField.text += moreText</code>), particularly for a
	 * text field that contains a significant amount of content.
	 * 
	 * @param newText The string to append to the existing text.
	 */
	public function appendText (text:String):Void {
		
		__textEngine.text += text;
		__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end = text.length;
		
		__dirty = true;
		__layoutDirty = true;
		
	}
	
	
	/**
	 * Returns a rectangle that is the bounding box of the character.
	 * 
	 * @param charIndex The zero-based index value for the character(for
	 *                  example, the first position is 0, the second position is
	 *                  1, and so on).
	 * @return A rectangle with <code>x</code> and <code>y</code> minimum and
	 *         maximum values defining the bounding box of the character.
	 */
	public function getCharBoundaries (a:Int):Rectangle {
		
		openfl.Lib.notImplemented ("TextField.getCharBoundaries");
		
		return null;
		
	}
	
	
	/**
	 * Returns the zero-based index value of the character at the point specified
	 * by the <code>x</code> and <code>y</code> parameters.
	 * 
	 * @param x The <i>x</i> coordinate of the character.
	 * @param y The <i>y</i> coordinate of the character.
	 * @return The zero-based index value of the character(for example, the
	 *         first position is 0, the second position is 1, and so on). Returns
	 *         -1 if the point is not over any character.
	 */
	public function getCharIndexAtPoint (x:Float, y:Float):Int {
		
		openfl.Lib.notImplemented ("TextField.getCharIndexAtPoint");
		
		return 0;
		
	}
	
	
	/**
	 * Returns the zero-based index value of the line at the point specified by
	 * the <code>x</code> and <code>y</code> parameters.
	 * 
	 * @param x The <i>x</i> coordinate of the line.
	 * @param y The <i>y</i> coordinate of the line.
	 * @return The zero-based index value of the line(for example, the first
	 *         line is 0, the second line is 1, and so on). Returns -1 if the
	 *         point is not over any line.
	 */
	public function getLineIndexAtPoint (x:Float, y:Float):Int {
		
		openfl.Lib.notImplemented ("TextField.getLineIndexAtPoint");
		
		return 0;
		
	}
	
	
	/**
	 * Returns metrics information about a given text line.
	 * 
	 * @param lineIndex The line number for which you want metrics information.
	 * @return A TextLineMetrics object.
	 * @throws RangeError The line number specified is out of range.
	 */
	public function getLineMetrics (lineIndex:Int):TextLineMetrics {
		
		__updateLayout ();
		
		var ascender = __textEngine.lineAscents[lineIndex];
		var descender = __textEngine.lineDescents[lineIndex];
		var leading = __textEngine.lineLeadings[lineIndex];
		var lineHeight = __textEngine.lineHeights[lineIndex];
		var lineWidth = __textEngine.lineWidths[lineIndex];
		
		var margin = switch (__textFormat.align) {
			
			case LEFT, JUSTIFY: 2;
			case RIGHT: (__textEngine.bounds.width - lineWidth) - 2;
			case CENTER: (__textEngine.bounds.width - lineWidth) / 2;
			
		}
		
		return new TextLineMetrics (margin, lineWidth, lineHeight, ascender, descender, leading); 
		
	}
	
	
	/**
	 * Returns the character index of the first character in the line that the
	 * <code>lineIndex</code> parameter specifies.
	 * 
	 * @param lineIndex The zero-based index value of the line(for example, the
	 *                  first line is 0, the second line is 1, and so on).
	 * @return The zero-based index value of the first character in the line.
	 * @throws RangeError The line number specified is out of range.
	 */
	public function getLineOffset (lineIndex:Int):Int {
		
		openfl.Lib.notImplemented ("TextField.getLineOffset");
		
		return 0;
		
	}
	
	
	/**
	 * Returns the text of the line specified by the <code>lineIndex</code>
	 * parameter.
	 * 
	 * @param lineIndex The zero-based index value of the line(for example, the
	 *                  first line is 0, the second line is 1, and so on).
	 * @return The text string contained in the specified line.
	 * @throws RangeError The line number specified is out of range.
	 */
	public function getLineText (lineIndex:Int):String {
		
		openfl.Lib.notImplemented ("TextField.getLineText");
		
		return "";
		
	}
	
	
	/**
	 * Returns a TextFormat object that contains formatting information for the
	 * range of text that the <code>beginIndex</code> and <code>endIndex</code>
	 * parameters specify. Only properties that are common to the entire text
	 * specified are set in the resulting TextFormat object. Any property that is
	 * <i>mixed</i>, meaning that it has different values at different points in
	 * the text, has a value of <code>null</code>.
	 *
	 * <p>If you do not specify values for these parameters, this method is
	 * applied to all the text in the text field. </p>
	 *
	 * <p>The following table describes three possible usages:</p>
	 * 
	 * @return The TextFormat object that represents the formatting properties
	 *         for the specified text.
	 * @throws RangeError The <code>beginIndex</code> or <code>endIndex</code>
	 *                    specified is out of range.
	 */
	public function getTextFormat (beginIndex:Int = 0, endIndex:Int = 0):TextFormat {
		
		// TODO: handle index
		
		return __textFormat.clone ();
		
	}
	
	
	/**
	 * Sets as selected the text designated by the index values of the first and
	 * last characters, which are specified with the <code>beginIndex</code> and
	 * <code>endIndex</code> parameters. If the two parameter values are the
	 * same, this method sets the insertion point, as if you set the
	 * <code>caretIndex</code> property.
	 * 
	 * @param beginIndex The zero-based index value of the first character in the
	 *                   selection(for example, the first character is 0, the
	 *                   second character is 1, and so on).
	 * @param endIndex   The zero-based index value of the last character in the
	 *                   selection.
	 */
	public function setSelection (beginIndex:Int, endIndex:Int) {
		
		__textEngine.setSelection (beginIndex, endIndex);
		
	}
	
	
	/**
	 * Applies the text formatting that the <code>format</code> parameter
	 * specifies to the specified text in a text field. The value of
	 * <code>format</code> must be a TextFormat object that specifies the desired
	 * text formatting changes. Only the non-null properties of
	 * <code>format</code> are applied to the text field. Any property of
	 * <code>format</code> that is set to <code>null</code> is not applied. By
	 * default, all of the properties of a newly created TextFormat object are
	 * set to <code>null</code>.
	 *
	 * <p><b>Note:</b> This method does not work if a style sheet is applied to
	 * the text field.</p>
	 *
	 * <p>The <code>setTextFormat()</code> method changes the text formatting
	 * applied to a range of characters or to the entire body of text in a text
	 * field. To apply the properties of format to all text in the text field, do
	 * not specify values for <code>beginIndex</code> and <code>endIndex</code>.
	 * To apply the properties of the format to a range of text, specify values
	 * for the <code>beginIndex</code> and the <code>endIndex</code> parameters.
	 * You can use the <code>length</code> property to determine the index
	 * values.</p>
	 *
	 * <p>The two types of formatting information in a TextFormat object are
	 * character level formatting and paragraph level formatting. Each character
	 * in a text field can have its own character formatting settings, such as
	 * font name, font size, bold, and italic.</p>
	 *
	 * <p>For paragraphs, the first character of the paragraph is examined for
	 * the paragraph formatting settings for the entire paragraph. Examples of
	 * paragraph formatting settings are left margin, right margin, and
	 * indentation.</p>
	 *
	 * <p>Any text inserted manually by the user, or replaced by the
	 * <code>replaceSelectedText()</code> method, receives the default text field
	 * formatting for new text, and not the formatting specified for the text
	 * insertion point. To set the default formatting for new text, use
	 * <code>defaultTextFormat</code>.</p>
	 * 
	 * @param format A TextFormat object that contains character and paragraph
	 *               formatting information.
	 * @throws Error      This method cannot be used on a text field with a style
	 *                    sheet.
	 * @throws RangeError The <code>beginIndex</code> or <code>endIndex</code>
	 *                    specified is out of range.
	 */
	public function setTextFormat (format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void {
		
		if (format.font != null) __textFormat.font = format.font;
		if (format.size != null) __textFormat.size = format.size;
		if (format.color != null) __textFormat.color = format.color;
		if (format.bold != null) __textFormat.bold = format.bold;
		if (format.italic != null) __textFormat.italic = format.italic;
		if (format.underline != null) __textFormat.underline = format.underline;
		if (format.url != null) __textFormat.url = format.url;
		if (format.target != null) __textFormat.target = format.target;
		if (format.align != null) __textFormat.align = format.align;
		if (format.leftMargin != null) __textFormat.leftMargin = format.leftMargin;
		if (format.rightMargin != null) __textFormat.rightMargin = format.rightMargin;
		if (format.indent != null) __textFormat.indent = format.indent;
		if (format.leading != null) __textFormat.leading = format.leading;
		if (format.blockIndent != null) __textFormat.blockIndent = format.blockIndent;
		if (format.bullet != null) __textFormat.bullet = format.bullet;
		if (format.kerning != null) __textFormat.kerning = format.kerning;
		if (format.letterSpacing != null) __textFormat.letterSpacing = format.letterSpacing;
		if (format.tabStops != null) __textFormat.tabStops = format.tabStops;
		
		__dirty = true;
		__layoutDirty = true;
		
	}
	
	
	@:noCompletion private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		__updateLayout ();
		var bounds = Rectangle.__temp;
		__textEngine.bounds.__transform (bounds, matrix);
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	@:noCompletion private override function __getCursor ():MouseCursor {
		
		return (type == INPUT && selectable) ? TEXT : null;
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (!visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
		
		__getTransform ();
		__updateLayout ();
		
		var px = __worldTransform.__transformInverseX (x, y);
		var py = __worldTransform.__transformInverseY (x, y);
		
		if (__textEngine.bounds.contains (px, py)) {
			
			if (stack != null) {
				
				stack.push (this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion public override function __renderCairo (renderSession:RenderSession):Void {
		
		CairoTextField.render (this, renderSession);
		super.__renderCairo (renderSession);
		
	}
	
	
	@:noCompletion public override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasTextField.render (this, renderSession);
		super.__renderCanvas (renderSession);
		
	}
	
	
	@:noCompletion public override function __renderDOM (renderSession:RenderSession):Void {
		
		//DOMTextField.render (this, renderSession);
		
	}
	
	
	@:noCompletion public override function __renderGL (renderSession:RenderSession):Void {
		
		#if !disable_cairo_graphics
		
		#if lime_cairo
		CairoTextField.render (this, renderSession);
		#else
		//CanvasTextField.render (this, renderSession);
		#end
		
		GLRenderer.renderBitmap (this, renderSession);
		
		#else
		
		//GLTextField.render (this, renderSession);
		
		#end
		
	}
	
	
	@:noCompletion private function __startTextInput ():Void {
		
		Lib.application.window.enableTextEvents = true;
		Lib.application.window.onTextInput.add (window_onTextInput);
		
		__caretIndex = 0;
		
	}
	
	
	@:noCompletion private function __stopTextInput ():Void {
		
		Lib.application.window.enableTextEvents = false;
		Lib.application.window.onTextInput.remove (window_onTextInput);
		
	}
	
	
	@:noCompletion private function __updateLayout ():Void {
		
		if (__layoutDirty) {
			
			__textEngine.update ();
			__layoutDirty = false;
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_antiAliasType ():AntiAliasType {
		
		return __textEngine.antiAliasType;
		
	}
	
	
	@:noCompletion private function set_antiAliasType (value:AntiAliasType):AntiAliasType {
		
		if (value != __textEngine.antiAliasType) {
			
			//__dirty = true;
			
		}
		
		return __textEngine.antiAliasType = value;
		
	}
	
	
	@:noCompletion private function get_autoSize ():TextFieldAutoSize {
		
		return __textEngine.autoSize;
		
	}
	
	
	@:noCompletion private function set_autoSize (value:TextFieldAutoSize):TextFieldAutoSize {
		
		if (value != __textEngine.autoSize) {
			
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.autoSize = value;
		
	}
	
	
	@:noCompletion private function get_background ():Bool {
		
		return __textEngine.background;
		
	}
	
	
	@:noCompletion private function set_background (value:Bool):Bool {
		
		if (value != __textEngine.background) {
			
			__dirty = true;
			
		}
		
		return __textEngine.background = value;
		
	}
	
	
	@:noCompletion private function get_backgroundColor ():Int {
		
		return __textEngine.backgroundColor;
		
	}
	
	
	@:noCompletion private function set_backgroundColor (value:Int):Int {
		
		if (value != __textEngine.backgroundColor) {
			
			__dirty = true;
			
		}
		
		return __textEngine.backgroundColor = value;
		
	}
	
	
	@:noCompletion private function get_border ():Bool {
		
		return __textEngine.border;
		
	}
	
	
	@:noCompletion private function set_border (value:Bool):Bool {
		
		if (value != __textEngine.border) {
			
			__dirty = true;
			//__layoutDirty = true;
			
		}
		
		return __textEngine.border = value;
		
	}
	
	
	@:noCompletion private function get_borderColor ():Int {
		
		return __textEngine.borderColor;
		
	}
	
	
	@:noCompletion private function set_borderColor (value:Int):Int {
		
		if (value != __textEngine.borderColor) {
			
			__dirty = true;
			
		}
		
		return __textEngine.borderColor = value;
		
	}
	
	
	@:noCompletion private function get_bottomScrollV ():Int {
		
		// TODO: Only return lines that are visible
		
		return this.numLines;
		
	}
	
	
	@:noCompletion private function get_caretIndex ():Int {
		
		return __caretIndex;
		
	}
	
	
	@:noCompletion private function get_defaultTextFormat ():TextFormat {
		
		return __textFormat.clone ();
		
	}
	
	
	@:noCompletion private function set_defaultTextFormat (value:TextFormat):TextFormat {
		
		//__textFormat = __defaultTextFormat.clone ();
		__textFormat.__merge (value);
		return value;
		
	}
	
	
	@:noCompletion private function get_displayAsPassword ():Bool {
		
		return __textEngine.displayAsPassword;
		
	}
	
	
	@:noCompletion private function set_displayAsPassword (value:Bool):Bool {
		
		if (value != __textEngine.displayAsPassword) {
			
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.displayAsPassword = value;
		
	}
	
	
	@:noCompletion private function get_embedFonts ():Bool {
		
		return __textEngine.embedFonts;
		
	}
	
	
	@:noCompletion private function set_embedFonts (value:Bool):Bool {
		
		//if (value != __textEngine.embedFonts) {
			//
			//__dirty = true;
			//__layoutDirty = true;
			//
		//}
		
		return __textEngine.embedFonts = value;
		
	}
	
	
	@:noCompletion private function get_gridFitType ():GridFitType {
		
		return __textEngine.gridFitType;
		
	}
	
	
	@:noCompletion private function set_gridFitType (value:GridFitType):GridFitType {
		
		//if (value != __textEngine.gridFitType) {
			//
			//__dirty = true;
			//__layoutDirty = true;
			//
		//}
		
		return __textEngine.gridFitType = value;
		
	}
	
	
	@:noCompletion private override function get_height ():Float {
		
		__updateLayout ();
		return __textEngine.bounds.height;
		
	}
	
	
	@:noCompletion private override function set_height (value:Float):Float {
		
		if (scaleY != 1 || value != __textEngine.height) {
			
			__setTransformDirty ();
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		scaleY = 1;
		return __textEngine.height = value;
		
	}
	
	
	@:noCompletion private function get_htmlText ():String {
		
		return __textEngine.text;
		
	}
	
	
	@:noCompletion private function set_htmlText (value:String):String {
		
		if (!__isHTML || __textEngine.text != value) {
			
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		__isHTML = true;
		
		if (#if (js && html5) #if dom false && #end __div == null #else true #end) {
			
			value = new EReg ("<br>", "g").replace (value, "\n");
			value = new EReg ("<br/>", "g").replace (value, "\n");
			
			// crude solution
			
			var segments = value.split ("<font");
			
			if (segments.length == 1) {
				
				value = new EReg ("<.*?>", "g").replace (value, "");
				
				if (__textEngine.textFormatRanges.length > 1) {
					
					__textEngine.textFormatRanges.splice (1, __textEngine.textFormatRanges.length - 1);
					
				}
				
				var range = __textEngine.textFormatRanges[0];
				range.format = __textFormat;
				range.start = 0;
				range.end = value.length;
				
				//#if (js && html5)
				//if (text != value && __hiddenInput != null) {
					//
					//var selectionStart = __hiddenInput.selectionStart;
					//var selectionEnd = __hiddenInput.selectionEnd;
					//__hiddenInput.value = value;
					//__hiddenInput.selectionStart = selectionStart;
					//__hiddenInput.selectionEnd = selectionEnd;
					//
				//}	
				//#end
				return __textEngine.text = value;
				
			} else {
				
				__textEngine.textFormatRanges.splice (0, __textEngine.textFormatRanges.length);
				
				value = "";
				
				// crude search for font
				
				for (segment in segments) {
					
					if (segment == "") continue;
					
					var closeFontIndex = segment.indexOf ("</font>");
					
					if (closeFontIndex > -1) {
						
						var start = segment.indexOf (">") + 1;
						var end = closeFontIndex;
						var format = __textFormat.clone ();
						
						var faceIndex = segment.indexOf ("face=");
						var colorIndex = segment.indexOf ("color=");
						var sizeIndex = segment.indexOf ("size=");
						
						if (faceIndex > -1 && faceIndex < start) {
							
							format.font = segment.substr (faceIndex + 6, segment.indexOf ("\"", faceIndex));
							
						}
						
						if (colorIndex > -1 && colorIndex < start) {
							
							format.color = Std.parseInt ("0x" + segment.substr (colorIndex + 8, 6));
							
						}
						
						if (sizeIndex > -1 && sizeIndex < start) {
							
							format.size = Std.parseInt (segment.substr (sizeIndex + 6, segment.indexOf ("\"", sizeIndex)));
							
						}
						
						var sub = segment.substring (start, end);
						sub = new EReg ("<.*?>", "g").replace (sub, "");
						
						__textEngine.textFormatRanges.push (new TextFormatRange (format, value.length, value.length + sub.length));
						value += sub;
						
						if (closeFontIndex + 7 < segment.length) {
							
							sub = segment.substr (closeFontIndex + 7);
							__textEngine.textFormatRanges.push (new TextFormatRange (__textFormat, value.length, value.length + sub.length));
							value += sub;
							
						}
						
					} else {
						
						__textEngine.textFormatRanges.push (new TextFormatRange (__textFormat, value.length, value.length + segment.length));
						value += segment;
						
					}
					
				}
				
			}
			
		}
		
		//#if (js && html5)
		//if (text != value && __hiddenInput != null) {
			//
			//var selectionStart = __hiddenInput.selectionStart;
			//var selectionEnd = __hiddenInput.selectionEnd;
			//__hiddenInput.value = value;
			//__hiddenInput.selectionStart = selectionStart;
			//__hiddenInput.selectionEnd = selectionEnd;
			//
		//}	
		//#end
		return __textEngine.text = value;
		
	}
	
	
	@:noCompletion private function get_length ():Int {
		
		if (__textEngine.text != null) {
			
			return __textEngine.text.length;
			
		}
		
		return 0;
		
	}
	
	
	@:noCompletion private function get_maxChars ():Int {
		
		return __textEngine.maxChars;
		
	}
	
	
	@:noCompletion private function set_maxChars (value:Int):Int {
		
		if (value != __textEngine.maxChars) {
			
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.maxChars = value;
		
	}
	
	
	@:noCompletion private function get_maxScrollH ():Int { 
		
		return 0;
		
	}
	
	
	@:noCompletion private function get_maxScrollV ():Int { 
		
		return 1;
		
	}
	
	
	@:noCompletion private function get_multiline ():Bool {
		
		return __textEngine.multiline;
		
	}
	
	
	@:noCompletion private function set_multiline (value:Bool):Bool {
		
		if (value != __textEngine.multiline) {
			
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.multiline = value;
		
	}
	
	
	@:noCompletion private function get_numLines ():Int {
		
		__updateLayout ();
		return __textEngine.lineBreaks.length + 1;
		
	}
	
	
	@:noCompletion private function get_restrict ():String {
		
		return __textEngine.restrict;
		
	}
	
	
	@:noCompletion private function set_restrict (value:String):String {
		
		return __textEngine.restrict = value;
		
	}
	
	
	@:noCompletion private function get_scrollH ():Int {
		
		return __textEngine.scrollH;
		
	}
	
	
	@:noCompletion private function set_scrollH (value:Int):Int {
		
		if (value != __textEngine.scrollH) {
			
			__dirty = true;
			
		}
		
		return __textEngine.scrollH = value;
		
	}
	
	
	@:noCompletion private function get_scrollV ():Int {
		
		return __textEngine.scrollV;
		
	}
	
	
	@:noCompletion private function set_scrollV (value:Int):Int {
		
		if (value != __textEngine.scrollV) {
			
			__dirty = true;
			
		}
		
		return __textEngine.scrollV = value;
		
	}
	
	
	@:noCompletion private function get_selectable ():Bool {
		
		return __textEngine.selectable;
		
	}
	
	
	@:noCompletion private function set_selectable (value:Bool):Bool {
		
		if (value != __textEngine.selectable && type == INPUT) {
			
			if (stage != null && stage.focus == this) {
				
				__startTextInput ();
				
			} else if (!value) {
				
				__stopTextInput ();
				
			}
			
		}
		
		return __textEngine.selectable = value;
		
	}
	
	
	@:noCompletion private function get_selectionBeginIndex ():Int {
		
		return __textEngine.getSelectionBeginIndex ();
		
	}
	
	
	@:noCompletion private function get_selectionEndIndex ():Int {
		
		return __textEngine.getSelectionEndIndex ();
		
	}
	
	
	@:noCompletion private function get_sharpness ():Float {
		
		return __textEngine.sharpness;
		
	}
	
	
	@:noCompletion private function set_sharpness (value:Float):Float {
		
		if (value != __textEngine.sharpness) {
			
			__dirty = true;
			
		}
		
		return __textEngine.sharpness = value;
		
	}
	
	
	@:noCompletion private function get_text ():String {
		
		return __textEngine.text;
		
	}
	
	
	@:noCompletion private function set_text (value:String):String {
		
		//#if (js && html5)
		//if (text != value && __hiddenInput != null) {
			//
			//var selectionStart = __hiddenInput.selectionStart;
			//var selectionEnd = __hiddenInput.selectionEnd;
			//__hiddenInput.value = value;
			//__hiddenInput.selectionStart = selectionStart;
			//__hiddenInput.selectionEnd = selectionEnd;
			//
		//}	
		//#end
		
		if (__isHTML || __textEngine.text != value) {
			
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		if (__textEngine.textFormatRanges.length > 1) {
			
			__textEngine.textFormatRanges.splice (1, __textEngine.textFormatRanges.length - 1);
			
		}
		
		var range = __textEngine.textFormatRanges[0];
		range.format = __textFormat;
		range.start = 0;
		range.end = value.length;
		
		__isHTML = false;
		
		return __textEngine.text = value;
		
	}
	
	
	@:noCompletion private function get_textColor ():Int { 
		
		return __textFormat.color;
		
	}
	
	
	@:noCompletion private function set_textColor (value:Int):Int {
		
		if (value != __textFormat.color) __dirty = true;
		
		for (range in __textEngine.textFormatRanges) {
			
			range.format.color = value;
			
		}
		
		return __textFormat.color = value;
		
	}
	
	@:noCompletion private function get_textWidth ():Float {
		
		__updateLayout ();
		return __textEngine.textWidth;
		
	}
	
	
	@:noCompletion private function get_textHeight ():Float {
		
		__updateLayout ();
		return __textEngine.textHeight;
		
	}
	
	
	@:noCompletion private function get_type ():TextFieldType {
		
		return __textEngine.type;
		
	}
	
	
	@:noCompletion private function set_type (value:TextFieldType):TextFieldType {
		
		if (value != __textEngine.type) {
			
			if (value == TextFieldType.INPUT) {
				
				addEventListener (FocusEvent.FOCUS_IN, this_onFocusIn);
				addEventListener (FocusEvent.FOCUS_OUT, this_onFocusOut);
				
				if (stage != null && stage.focus == this) {
					
					this_onFocusIn (null);
					
				}
				
			} else {
				
				__stopTextInput ();
				
			}
			
			__dirty = true;
			
		}
		
		return __textEngine.type = value;
		
	}
	
	
	override private function get_width ():Float {
		
		__updateLayout ();
		return __textEngine.bounds.width;
		
	}
	
	
	override private function set_width (value:Float):Float {
		
		if (scaleX != 1 || __textEngine.width != value) {
			
			__setTransformDirty ();
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		scaleX = 1;
		return __textEngine.width = value;
		
	}
	
	
	@:noCompletion private function get_wordWrap ():Bool {
		
		return __textEngine.wordWrap;
		
	}
	
	
	@:noCompletion private function set_wordWrap (value:Bool):Bool {
		
		if (value != __textEngine.wordWrap) {
			
			__dirty = true;
			__layoutDirty = true;
			
		}
		
		return __textEngine.wordWrap = value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function this_onFocusIn (event:FocusEvent):Void {
		
		if (selectable && type == INPUT) {
			
			__startTextInput ();
			
		}
		
	}
	
	
	@:noCompletion private function this_onFocusOut (event:FocusEvent):Void {
		
		__stopTextInput ();
		
	}
	
	
	@:noCompletion private function window_onTextInput (value:String):Void {
		
		__textEngine.text = __textEngine.text.substring (0, __caretIndex) + value + __textEngine.text.substring (__caretIndex);
		
		for (range in __textEngine.textFormatRanges) {
			
			if (range.start <= __caretIndex && range.end >= __caretIndex) {
				
				range.end += value.length;
				
			}
			
		}
		
		__dirty = true;
		__layoutDirty = true;
		
	}
	
	
}


#else
typedef TextField = openfl._legacy.text.TextField;
#end
#else
typedef TextField = flash.text.TextField;
#end