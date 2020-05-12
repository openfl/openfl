package openfl.text;

#if !flash
import haxe.Timer;
import openfl.text._internal.HTMLParser;
import openfl.text._internal.TextEngine;
import openfl.text._internal.TextFormatRange;
import openfl.text._internal.TextLayoutGroup;
import openfl.desktop.Clipboard;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.InteractiveObject;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.net.URLRequest;
import openfl.ui.Keyboard;
import openfl.ui.MouseCursor;
import openfl.Lib;
#if openfl_html5
import js.html.DivElement;
#end

/**
	The TextField class is used to create display objects for text display and
	input. <ph outputclass="flexonly">You can use the TextField class to
	perform low-level text rendering. However, in Flex, you typically use the
	Label, Text, TextArea, and TextInput controls to process text. <ph
	outputclass="flashonly">You can give a text field an instance name in the
	Property inspector and use the methods and properties of the TextField
	class to manipulate it with ActionScript. TextField instance names are
	displayed in the Movie Explorer and in the Insert Target Path dialog box in
	the Actions panel.

	To create a text field dynamically, use the `TextField()`
	constructor.

	The methods of the TextField class let you set, select, and manipulate
	text in a dynamic or input text field that you create during authoring or
	at runtime.

	ActionScript provides several ways to format your text at runtime. The
	TextFormat class lets you set character and paragraph formatting for
	TextField objects. You can apply Cascading Style Sheets(CSS) styles to
	text fields by using the `TextField.styleSheet` property and the
	StyleSheet class. You can use CSS to style built-in HTML tags, define new
	formatting tags, or apply styles. You can assign HTML formatted text, which
	optionally uses CSS styles, directly to a text field. HTML text that you
	assign to a text field can contain embedded media(movie clips, SWF files,
	GIF files, PNG files, and JPEG files). The text wraps around the embedded
	media in the same way that a web browser wraps text around media embedded
	in an HTML document.

	Flash Player supports a subset of HTML tags that you can use to format
	text. See the list of supported HTML tags in the description of the
	`htmlText` property.

	@event change                    Dispatched after a control value is
									 modified, unlike the
									 `textInput` event, which is
									 dispatched before the value is modified.
									 Unlike the W3C DOM Event Model version of
									 the `change` event, which
									 dispatches the event only after the
									 control loses focus, the ActionScript 3.0
									 version of the `change` event
									 is dispatched any time the control
									 changes. For example, if a user types text
									 into a text field, a `change`
									 event is dispatched after every keystroke.
	@event link                      Dispatched when a user clicks a hyperlink
									 in an HTML-enabled text field, where the
									 URL begins with "event:". The remainder of
									 the URL after "event:" is placed in the
									 text property of the LINK event.

									 **Note:** The default behavior,
									 adding the text to the text field, occurs
									 only when Flash Player generates the
									 event, which in this case happens when a
									 user attempts to input text. You cannot
									 put text into a text field by sending it
									 `textInput` events.
	@event scroll                    Dispatched by a TextField object
									 _after_ the user scrolls.
	@event textInput                 Flash Player dispatches the
									 `textInput` event when a user
									 enters one or more characters of text.
									 Various text input methods can generate
									 this event, including standard keyboards,
									 input method editors(IMEs), voice or
									 speech recognition systems, and even the
									 act of pasting plain text with no
									 formatting or style information.
	@event textInteractionModeChange Flash Player dispatches the
									 `textInteractionModeChange`
									 event when a user changes the interaction
									 mode of a text field. for example on
									 Android, one can toggle from NORMAL mode
									 to SELECTION mode using context menu
									 options
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Graphics)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:access(openfl.text._internal.TextEngine)
@:access(openfl.text.TextFormat)
class TextField extends InteractiveObject
{
	@:noCompletion private static var __defaultTextFormat:TextFormat;
	@:noCompletion private static var __missingFontWarning:Map<String, Bool> = new Map();

	/**
		When set to `true` and the text field is not in focus, Flash Player
		highlights the selection in the text field in gray. When set to
		`false` and the text field is not in focus, Flash Player does not
		highlight the selection in the text field.

		@default false
	**/
	// var alwaysShowSelection : Bool;

	/**
		The type of anti-aliasing used for this text field. Use
		`openfl.text.AntiAliasType` constants for this property. You can
		control this setting only if the font is embedded(with the
		`embedFonts` property set to `true`). The default
		setting is `openfl.text.AntiAliasType.NORMAL`.

		To set values for this property, use the following string values:
	**/
	public var antiAliasType(get, set):AntiAliasType;

	/**
		Controls automatic sizing and alignment of text fields. Acceptable values
		for the `TextFieldAutoSize` constants:
		`TextFieldAutoSize.NONE`(the default),
		`TextFieldAutoSize.LEFT`, `TextFieldAutoSize.RIGHT`,
		and `TextFieldAutoSize.CENTER`.

		If `autoSize` is set to `TextFieldAutoSize.NONE`
		(the default) no resizing occurs.

		If `autoSize` is set to `TextFieldAutoSize.LEFT`,
		the text is treated as left-justified text, meaning that the left margin
		of the text field remains fixed and any resizing of a single line of the
		text field is on the right margin. If the text includes a line break(for
		example, `"\n"` or `"\r"`), the bottom is also
		resized to fit the next line of text. If `wordWrap` is also set
		to `true`, only the bottom of the text field is resized and the
		right side remains fixed.

		If `autoSize` is set to
		`TextFieldAutoSize.RIGHT`, the text is treated as
		right-justified text, meaning that the right margin of the text field
		remains fixed and any resizing of a single line of the text field is on
		the left margin. If the text includes a line break(for example,
		`"\n" or "\r")`, the bottom is also resized to fit the next
		line of text. If `wordWrap` is also set to `true`,
		only the bottom of the text field is resized and the left side remains
		fixed.

		If `autoSize` is set to
		`TextFieldAutoSize.CENTER`, the text is treated as
		center-justified text, meaning that any resizing of a single line of the
		text field is equally distributed to both the right and left margins. If
		the text includes a line break(for example, `"\n"` or
		`"\r"`), the bottom is also resized to fit the next line of
		text. If `wordWrap` is also set to `true`, only the
		bottom of the text field is resized and the left and right sides remain
		fixed.

		@throws ArgumentError The `autoSize` specified is not a member
							  of openfl.text.TextFieldAutoSize.
	**/
	public var autoSize(get, set):TextFieldAutoSize;

	/**
		Specifies whether the text field has a background fill. If
		`true`, the text field has a background fill. If
		`false`, the text field has no background fill. Use the
		`backgroundColor` property to set the background color of a
		text field.

		@default false
	**/
	public var background(get, set):Bool;

	/**
		The color of the text field background. The default value is
		`0xFFFFFF`(white). This property can be retrieved or set, even
		if there currently is no background, but the color is visible only if the
		text field has the `background` property set to
		`true`.
	**/
	public var backgroundColor(get, set):Int;

	/**
		Specifies whether the text field has a border. If `true`, the
		text field has a border. If `false`, the text field has no
		border. Use the `borderColor` property to set the border color.

		@default false
	**/
	public var border(get, set):Bool;

	/**
		The color of the text field border. The default value is
		`0x000000`(black). This property can be retrieved or set, even
		if there currently is no border, but the color is visible only if the text
		field has the `border` property set to `true`.
	**/
	public var borderColor(get, set):Int;

	/**
		An integer(1-based index) that indicates the bottommost line that is
		currently visible in the specified text field. Think of the text field as
		a window onto a block of text. The `scrollV` property is the
		1-based index of the topmost visible line in the window.

		All the text between the lines indicated by `scrollV` and
		`bottomScrollV` is currently visible in the text field.
	**/
	public var bottomScrollV(get, never):Int;

	/**
		The index of the insertion point(caret) position. If no insertion point
		is displayed, the value is the position the insertion point would be if
		you restored focus to the field(typically where the insertion point last
		was, or 0 if the field has not had focus).

		Selection span indexes are zero-based(for example, the first position
		is 0, the second position is 1, and so on).
	**/
	public var caretIndex(get, never):Int;

	/**
		A Boolean value that specifies whether extra white space (spaces, line
		breaks, and so on) in a text field with HTML text is removed. The
		default value is `false`. The `condenseWhite` property only affects
		text set with the `htmlText` property, not the `text` property. If you
		set text with the `text` property, `condenseWhite` is ignored.
		If `condenseWhite` is set to `true`, use standard HTML commands such
		as `<BR>` and `<P>` to place line breaks in the text field.

		Set the `condenseWhite` property before setting the `htmlText`
		property.
	**/
	// var condenseWhite : Bool;

	/**
		Specifies the format applied to newly inserted text, such as text entered
		by a user or text inserted with the `replaceSelectedText()`
		method.

		**Note:** When selecting characters to be replaced with
		`setSelection()` and `replaceSelectedText()`, the
		`defaultTextFormat` will be applied only if the text has been
		selected up to and including the last character. Here is an example:

		```
		var my_txt:TextField new TextField();
		my_txt.text = "Flash Macintosh version"; var my_fmt:TextFormat = new
		TextFormat(); my_fmt.color = 0xFF0000; my_txt.defaultTextFormat = my_fmt;
		my_txt.setSelection(6,15); // partial text selected - defaultTextFormat
		not applied my_txt.setSelection(6,23); // text selected to end -
		defaultTextFormat applied my_txt.replaceSelectedText("Windows version");
		```

		When you access the `defaultTextFormat` property, the
		returned TextFormat object has all of its properties defined. No property
		is `null`.

		**Note:** You can't set this property if a style sheet is applied to
		the text field.

		@throws Error This method cannot be used on a text field with a style
					  sheet.
	**/
	public var defaultTextFormat(get, set):TextFormat;

	/**
		Specifies whether the text field is a password text field. If the value of
		this property is `true`, the text field is treated as a
		password text field and hides the input characters using asterisks instead
		of the actual characters. If `false`, the text field is not
		treated as a password text field. When password mode is enabled, the Cut
		and Copy commands and their corresponding keyboard shortcuts will not
		function. This security mechanism prevents an unscrupulous user from using
		the shortcuts to discover a password on an unattended computer.

		@default false
	**/
	public var displayAsPassword(get, set):Bool;

	/**
		Specifies whether to render by using embedded font outlines. If
		`false`, Flash Player renders the text field by using device
		fonts.

		If you set the `embedFonts` property to `true`
		for a text field, you must specify a font for that text by using the
		`font` property of a TextFormat object applied to the text
		field. If the specified font is not embedded in the SWF file, the text is
		not displayed.

		@default false
	**/
	public var embedFonts(get, set):Bool;

	/**
		The type of grid fitting used for this text field. This property
		applies only if the `openfl.text.AntiAliasType` property of the text
		field is set to `openfl.text.AntiAliasType.ADVANCED`.
		The type of grid fitting used determines whether Flash Player forces
		strong horizontal and vertical lines to fit to a pixel or subpixel
		grid, or not at all.

		For the `openfl.text.GridFitType` property, you can use the following
		string values:

		| String value | Description |
		| --- | --- |
		| `openfl.text.GridFitType.NONE` | Specifies no grid fitting. Horizontal and vertical lines in the glyphs are not forced to the pixel grid. This setting is recommended for animation or for large font sizes. |
		| `openfl.text.GridFitType.PIXEL` | Specifies that strong horizontal and vertical lines are fit to the pixel grid. This setting works only for left-aligned text fields. To use this setting, the `openfl.dispaly.AntiAliasType` property of the text field must be set to `openfl.text.AntiAliasType.ADVANCED`. This setting generally provides the best legibility for left-aligned text. |
		| `openfl.text.GridFitType.SUBPIXEL` | Specifies that strong horizontal and vertical lines are fit to the subpixel grid on an LCD monitor. To use this setting, the `openfl.text.AntiAliasType` property of the text field must be set to `openfl.text.AntiAliasType.ADVANCED`. The `openfl.text.GridFitType.SUBPIXEL` setting is often good for right-aligned or centered dynamic text, and it is sometimes a useful trade-off for animation versus text quality. |

		@default pixel
	**/
	public var gridFitType(get, set):GridFitType;

	/**
		Contains the HTML representation of the text field contents.
		Flash Player supports the following HTML tags:

		| Tag |  Description  |
		| --- | --- |
		| Anchor tag | The `<a>` tag creates a hypertext link and supports the following attributes:<ul><li>`target`: Specifies the name of the target window where you load the page. Options include `_self`, `_blank`, `_parent`, and `_top`. The `_self` option specifies the current frame in the current window, `_blank` specifies a new window, `_parent` specifies the parent of the current frame, and `_top` specifies the top-level frame in the current window.</li><li>`href`: Specifies a URL or an ActionScript `link` event.The URL can be either absolute or relative to the location of the SWF file that is loading the page. An example of an absolute reference to a URL is `http://www.adobe.com`; an example of a relative reference is `/index.html`. Absolute URLs must be prefixed with http://; otherwise, Flash Player or AIR treats them as relative URLs. You can use the `link` event to cause the link to execute an ActionScript function in a SWF file instead of opening a URL. To specify a `link` event, use the event scheme instead of the http scheme in your `href` attribute. An example is `href="event:myText"` instead of `href="http://myURL"`; when the user clicks a hypertext link that contains the event scheme, the text field dispatches a `link` TextEvent with its `text` property set to "`myText`". You can then create an ActionScript function that executes whenever the link TextEvent is dispatched. You can also define `a:link`, `a:hover`, and `a:active` styles for anchor tags by using style sheets.</li></ul> |
		| Bold tag | The `<b>` tag renders text as bold. A bold typeface must be available for the font used. |
		| Break tag | The `<br>` tag creates a line break in the text field. Set the text field to be a multiline text field to use this tag.  |
		| Font tag | The `<font>` tag specifies a font or list of fonts to display the text.The font tag supports the following attributes:<ul><li>`color`: Only hexadecimal color (`#FFFFFF`) values are supported.</li><li>`face`: Specifies the name of the font to use. As shown in the following example, you can specify a list of comma-delimited font names, in which case Flash Player selects the first available font. If the specified font is not installed on the local computer system or isn't embedded in the SWF file, Flash Player selects a substitute font.</li><li>`size`: Specifies the size of the font. You can use absolute pixel sizes, such as 16 or 18, or relative point sizes, such as +2 or -4.</li></ul> |
		| Image tag | The `<img>` tag lets you embed external image files (JPEG, GIF, PNG), SWF files, and movie clips inside text fields. Text automatically flows around images you embed in text fields. You must set the text field to be multiline to wrap text around an image.<br>The `<img>` tag supports the following attributes:<ul><li>`src`: Specifies the URL to an image or SWF file, or the linkage identifier for a movie clip symbol in the library. This attribute is required; all other attributes are optional. External files (JPEG, GIF, PNG, and SWF files) do not show until they are downloaded completely.</li><li>`width`: The width of the image, SWF file, or movie clip being inserted, in pixels.</li><li>`height`: The height of the image, SWF file, or movie clip being inserted, in pixels.</li><li>`align`: Specifies the horizontal alignment of the embedded image within the text field. Valid values are `left` and `right`. The default value is `left`.</li><li>`hspace`: Specifies the amount of horizontal space that surrounds the image where no text appears. The default value is 8.</li><li>`vspace`: Specifies the amount of vertical space that surrounds the image where no text appears. The default value is 8.</li><li>`id`: Specifies the name for the movie clip instance (created by Flash Player) that contains the embedded image file, SWF file, or movie clip. This approach is used to control the embedded content with ActionScript.</li><li>`checkPolicyFile`: Specifies that Flash Player checks for a URL policy file on the server associated with the image domain. If a policy file exists, SWF files in the domains listed in the file can access the data of the loaded image, for example, by calling the `BitmapData.draw()` method with this image as the `source` parameter. For more information related to security, see the Flash Player Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).</li></ul>Flash displays media embedded in a text field at full size. To specify the dimensions of the media you are embedding, use the `<img>` tag `height` and `width` attributes. <br>In general, an image embedded in a text field appears on the line following the `<img>` tag. However, when the `<img>` tag is the first character in the text field, the image appears on the first line of the text field.<br>For AIR content in the application security sandbox, AIR ignores `img` tags in HTML content in ActionScript TextField objects. This is to prevent possible phishing attacks. |
		| Italic tag | The `<i>` tag displays the tagged text in italics. An italic typeface must be available for the font used. |
		| List item tag | The `<li>` tag places a bullet in front of the text that it encloses.<br>**Note:** Because Flash Player and AIR do not recognize ordered and unordered list tags (`<ol>` and `<ul>`, they do not modify how your list is rendered. All lists are unordered and all list items use bullets. |
		| Paragraph tag | The `<p>` tag creates a new paragraph. The text field must be set to be a multiline text field to use this tag. The `<p>` tag supports the following attributes:<ul><li>align: Specifies alignment of text within the paragraph; valid values are `left`, `right`, `justify`, and `center`.</li><li>class: Specifies a CSS style class defined by a openfl.text.StyleSheet object.</li></ul> |
		| Span tag | The `<span>` tag is available only for use with CSS text styles. It supports the following attribute:<ul><li>class: Specifies a CSS style class defined by a openfl.text.StyleSheet object.</li></ul> |
		| Text format tag | The `<textformat>` tag lets you use a subset of paragraph formatting properties of the TextFormat class within text fields, including line leading, indentation, margins, and tab stops. You can combine `<textformat>` tags with the built-in HTML tags.<br>The `<textformat>` tag has the following attributes:<li>`blockindent`: Specifies the block indentation in points; corresponds to `TextFormat.blockIndent`.</li><li>`indent`: Specifies the indentation from the left margin to the first character in the paragraph; corresponds to `TextFormat.indent`. Both positive and negative numbers are acceptable.</li><li>`leading`: Specifies the amount of leading (vertical space) between lines; corresponds to `TextFormat.leading`. Both positive and negative numbers are acceptable.</li><li>`leftmargin`: Specifies the left margin of the paragraph, in points; corresponds to `TextFormat.leftMargin`.</li><li>`rightmargin`: Specifies the right margin of the paragraph, in points; corresponds to `TextFormat.rightMargin`.</li><li>`tabstops`: Specifies custom tab stops as an array of non-negative integers; corresponds to `TextFormat.tabStops`.</li></ul> |
		| Underline tag | The `<u>` tag underlines the tagged text. |

		Flash Player and AIR support the following HTML entities:

		| Entity | Description |
		| --- | --- |
		| &amp;lt; | < (less than) |
		| &amp;gt; | > (greater than) |
		| &amp;amp; | & (ampersand) |
		| &amp;quot; | " (double quotes) |
		| &amp;apos; | ' (apostrophe, single quote) |

		Flash Player and AIR also support explicit character codes, such as
		&#38; (ASCII ampersand) and &#x20AC; (Unicode € symbol).
	**/
	public var htmlText(get, set):String;

	/**
		The number of characters in a text field. A character such as tab
		(`\t`) counts as one character.
	**/
	public var length(get, never):Int;

	/**
		The maximum number of characters that the text field can contain, as
		entered by a user. A script can insert more text than
		`maxChars` allows; the `maxChars` property indicates
		only how much text a user can enter. If the value of this property is
		`0`, a user can enter an unlimited amount of text.

		@default 0
	**/
	public var maxChars(get, set):Int;

	/**
		The maximum value of `scrollH`.
	**/
	public var maxScrollH(get, never):Int;

	/**
		The maximum value of `scrollV`.
	**/
	public var maxScrollV(get, never):Int;

	/**
		A Boolean value that indicates whether Flash Player automatically scrolls
		multiline text fields when the user clicks a text field and rolls the mouse wheel.
		By default, this value is `true`. This property is useful if you want to prevent
		mouse wheel scrolling of text fields, or implement your own text field scrolling.
	**/
	public var mouseWheelEnabled(get, set):Bool;

	/**
		Indicates whether field is a multiline text field. If the value is
		`true`, the text field is multiline; if the value is
		`false`, the text field is a single-line text field. In a field
		of type `TextFieldType.INPUT`, the `multiline` value
		determines whether the `Enter` key creates a new line(a value
		of `false`, and the `Enter` key is ignored). If you
		paste text into a `TextField` with a `multiline`
		value of `false`, newlines are stripped out of the text.

		@default false
	**/
	public var multiline(get, set):Bool;

	/**
		Defines the number of text lines in a multiline text field. If
		`wordWrap` property is set to `true`, the number of
		lines increases when text wraps.
	**/
	public var numLines(get, never):Int;

	/**
		Indicates the set of characters that a user can enter into the text field.
		If the value of the `restrict` property is `null`,
		you can enter any character. If the value of the `restrict`
		property is an empty string, you cannot enter any character. If the value
		of the `restrict` property is a string of characters, you can
		enter only characters in the string into the text field. The string is
		scanned from left to right. You can specify a range by using the hyphen
		(-) character. Only user interaction is restricted; a script can put any
		text into the text field. <ph outputclass="flashonly">This property does
		not synchronize with the Embed font options in the Property inspector.

		If the string begins with a caret(^) character, all characters are
		initially accepted and succeeding characters in the string are excluded
		from the set of accepted characters. If the string does not begin with a
		caret(^) character, no characters are initially accepted and succeeding
		characters in the string are included in the set of accepted
		characters.

		The following example allows only uppercase characters, spaces, and
		numbers to be entered into a text field:
		`my_txt.restrict = "A-Z 0-9";`

		The following example includes all characters, but excludes lowercase
		letters:
		`my_txt.restrict = "^a-z";`

		You can use a backslash to enter a ^ or - verbatim. The accepted
		backslash sequences are \-, \^ or \\. The backslash must be an actual
		character in the string, so when specified in ActionScript, a double
		backslash must be used. For example, the following code includes only the
		dash(-) and caret(^):
		`my_txt.restrict = "\\-\\^";`

		The ^ can be used anywhere in the string to toggle between including
		characters and excluding characters. The following code includes only
		uppercase letters, but excludes the uppercase letter Q:
		`my_txt.restrict = "A-Z^Q";`

		You can use the `\u` escape sequence to construct
		`restrict` strings. The following code includes only the
		characters from ASCII 32(space) to ASCII 126(tilde).
		`my_txt.restrict = "\u0020-\u007E";`

		@default null
	**/
	public var restrict(get, set):String;

	/**
		The current horizontal scrolling position. If the `scrollH`
		property is 0, the text is not horizontally scrolled. This property value
		is an integer that represents the horizontal position in pixels.

		The units of horizontal scrolling are pixels, whereas the units of
		vertical scrolling are lines. Horizontal scrolling is measured in pixels
		because most fonts you typically use are proportionally spaced; that is,
		the characters can have different widths. Flash Player performs vertical
		scrolling by line because users usually want to see a complete line of
		text rather than a partial line. Even if a line uses multiple fonts, the
		height of the line adjusts to fit the largest font in use.

		**Note: **The `scrollH` property is zero-based, not
		1-based like the `scrollV` vertical scrolling property.
	**/
	public var scrollH(get, set):Int;

	/**
		The vertical position of text in a text field. The `scrollV`
		property is useful for directing users to a specific paragraph in a long
		passage, or creating scrolling text fields.

		The units of vertical scrolling are lines, whereas the units of
		horizontal scrolling are pixels. If the first line displayed is the first
		line in the text field, scrollV is set to 1(not 0). Horizontal scrolling
		is measured in pixels because most fonts are proportionally spaced; that
		is, the characters can have different widths. Flash performs vertical
		scrolling by line because users usually want to see a complete line of
		text rather than a partial line. Even if there are multiple fonts on a
		line, the height of the line adjusts to fit the largest font in use.
	**/
	public var scrollV(get, set):Int;

	/**
		A Boolean value that indicates whether the text field is selectable. The
		value `true` indicates that the text is selectable. The
		`selectable` property controls whether a text field is
		selectable, not whether a text field is editable. A dynamic text field can
		be selectable even if it is not editable. If a dynamic text field is not
		selectable, the user cannot select its text.

		If `selectable` is set to `false`, the text in
		the text field does not respond to selection commands from the mouse or
		keyboard, and the text cannot be copied with the Copy command. If
		`selectable` is set to `true`, the text in the text
		field can be selected with the mouse or keyboard, and the text can be
		copied with the Copy command. You can select text this way even if the
		text field is a dynamic text field instead of an input text field.

		@default true
	**/
	public var selectable(get, set):Bool;

	// var selectedText(default,never) : String;

	/**
		The zero-based character index value of the first character in the current
		selection. For example, the first character is 0, the second character is
		1, and so on. If no text is selected, this property is the value of
		`caretIndex`.
	**/
	public var selectionBeginIndex(get, never):Int;

	/**
		The zero-based character index value of the last character in the current
		selection. For example, the first character is 0, the second character is
		1, and so on. If no text is selected, this property is the value of
		`caretIndex`.
	**/
	public var selectionEndIndex(get, never):Int;

	/**
		The sharpness of the glyph edges in this text field. This property applies
		only if the `openfl.text.AntiAliasType` property of the text
		field is set to `openfl.text.AntiAliasType.ADVANCED`. The range
		for `sharpness` is a number from -400 to 400. If you attempt to
		set `sharpness` to a value outside that range, Flash sets the
		property to the nearest value in the range(either -400 or 400).

		@default 0
	**/
	public var sharpness(get, set):Float;

	/**
		Attaches a style sheet to the text field. For information on creating
		style sheets, see the StyleSheet class and the _ActionScript 3.0
		Developer's Guide(_ : _TextField).
		You can change the style sheet associated with a text field at any
		time. If you change the style sheet in use, the text field is redrawn
		with the new style sheet. You can set the style sheet to `null` or
		`undefined` to remove the style sheet. If the style sheet in use is
		removed, the text field is redrawn without a style sheet.

		**Note:** If the style sheet is removed, the contents of both
		`TextField.text` and ` TextField.htmlText` change to incorporate the
		formatting previously applied by the style sheet. To preserve the
		original `TextField.htmlText` contents without the formatting, save
		the value in a variable before removing the style sheet.
	**/
	// var styleSheet : StyleSheet;

	/**
		A string that is the current text in the text field. Lines are separated
		by the carriage return character(`'\r'`, ASCII 13). This
		property contains unformatted text in the text field, without HTML tags.

		To get the text in HTML form, use the `htmlText`
		property.
	**/
	public var text(get, set):String;

	/**
		The color of the text in a text field, in hexadecimal format. The
		hexadecimal color system uses six digits to represent color values. Each
		digit has 16 possible values or characters. The characters range from 0-9
		and then A-F. For example, black is `0x000000`; white is
		`0xFFFFFF`.

		@default 0(0x000000)
	**/
	public var textColor(get, set):Int;

	/**
		The height of the text in pixels.
	**/
	public var textHeight(get, never):Float;

	/**
		The interaction mode property, Default value is
		TextInteractionMode.NORMAL. On mobile platforms, the normal mode
		implies that the text can be scrolled but not selected. One can switch
		to the selectable mode through the in-built context menu on the text
		field. On Desktop, the normal mode implies that the text is in
		scrollable as well as selection mode.
	**/
	// @:require(flash11) var textInteractionMode(default,never) : TextInteractionMode;

	/**
		The width of the text in pixels.
	**/
	public var textWidth(get, never):Float;

	/**
		The thickness of the glyph edges in this text field. This property
		applies only when `openfl.text.AntiAliasType` is set to
		`openfl.text.AntiAliasType.ADVANCED`.
		The range for `thickness` is a number from -200 to 200. If you attempt
		to set `thickness` to a value outside that range, the property is set
		to the nearest value in the range (either -200 or 200).

		@default 0
	**/
	// var thickness : Float;

	/**
		The type of the text field. Either one of the following TextFieldType
		constants: `TextFieldType.DYNAMIC`, which specifies a dynamic
		text field, which a user cannot edit, or `TextFieldType.INPUT`,
		which specifies an input text field, which a user can edit.

		@default dynamic
		@throws ArgumentError The `type` specified is not a member of
							  openfl.text.TextFieldType.
	**/
	public var type(get, set):TextFieldType;

	/**
		Specifies whether to copy and paste the text formatting along with the
		text. When set to `true`, Flash Player copies and pastes formatting
		(such as alignment, bold, and italics) when you copy and paste between
		text fields. Both the origin and destination text fields for the copy
		and paste procedure must have `useRichTextClipboard` set to `true`.
		The default value is `false`.
	**/
	// var useRichTextClipboard : Bool;

	/**
		A Boolean value that indicates whether the text field has word wrap. If
		the value of `wordWrap` is `true`, the text field
		has word wrap; if the value is `false`, the text field does not
		have word wrap. The default value is `false`.
	**/
	public var wordWrap(get, set):Bool;

	/**
		Creates a new TextField instance. After you create the TextField instance,
		call the `addChild()` or `addChildAt()` method of
		the parent DisplayObjectContainer object to add the TextField instance to
		the display list.

		The default size for a text field is 100 x 100 pixels.
	**/
	public function new()
	{
		if (_ == null)
		{
			_ = new _TextField(this);
		}

		super();
	}

	/**
		Appends the string specified by the `newText` parameter to the
		end of the text of the text field. This method is more efficient than an
		addition assignment(`+=`) on a `text` property
		(such as `someTextField.text += moreText`), particularly for a
		text field that contains a significant amount of content.

		@param newText The string to append to the existing text.
	**/
	public function appendText(text:String):Void
	{
		(_ : _TextField).appendText(text);
	}

	// function copyRichText() : String;

	/**
		Returns a rectangle that is the bounding box of the character.

		@param charIndex The zero-based index value for the character (for
						 example, the first position is 0, the second position is
						 1, and so on).
		@return A rectangle with `x` and `y` minimum and
				maximum values defining the bounding box of the character.
	**/
	public function getCharBoundaries(charIndex:Int):Rectangle
	{
		return (_ : _TextField).getCharBoundaries(charIndex);
	}

	/**
		Returns the zero-based index value of the character at the point specified
		by the `x` and `y` parameters.

		@param x The _x_ coordinate of the character.
		@param y The _y_ coordinate of the character.
		@return The zero-based index value of the character(for example, the
				first position is 0, the second position is 1, and so on). Returns
				-1 if the point is not over any character.
	**/
	public function getCharIndexAtPoint(x:Float, y:Float):Int
	{
		return (_ : _TextField).getCharIndexAtPoint(x, y);
	}

	/**
		Given a character index, returns the index of the first character in
		the same paragraph.

		@param charIndex The zero-based index value of the character (for
						 example, the first character is 0, the second
						 character is 1, and so on).
		@return The zero-based index value of the first character in the same
				paragraph.
		@throws RangeError The character index specified is out of range.
	**/
	public function getFirstCharInParagraph(charIndex:Int):Int
	{
		return (_ : _TextField).getFirstCharInParagraph(charIndex);
	}

	/**
		Returns a DisplayObject reference for the given `id`, for an image or
		SWF file that has been added to an HTML-formatted text field by using
		an `<img>` tag. The `<img>` tag is in the following format:

		```html
		<img src='filename.jpg' id='instanceName' />
		```

		@param id The `id` to match (in the `id` attribute of the `<img>`
				  tag).
		@return The display object corresponding to the image or SWF file with
				the matching `id` attribute in the `<img>` tag of the text
				field. For media loaded from an external source, this object
				is a Loader object, and, once loaded, the media object is a
				child of that Loader object. For media embedded in the SWF
				file, it is the loaded object. If no `<img>` tag with the
				matching `id` exists, the method returns `null`.
	**/
	// function getImageReference(id : String) : openfl.display.DisplayObject;

	/**
		Returns the zero-based index value of the line at the point specified by
		the `x` and `y` parameters.

		@param x The _x_ coordinate of the line.
		@param y The _y_ coordinate of the line.
		@return The zero-based index value of the line(for example, the first
				line is 0, the second line is 1, and so on). Returns -1 if the
				point is not over any line.
	**/
	public function getLineIndexAtPoint(x:Float, y:Float):Int
	{
		return (_ : _TextField).getLineIndexAtPoint(x, y);
	}

	/**
		Returns the zero-based index value of the line containing the
		character specified by the `charIndex` parameter.

		@param charIndex The zero-based index value of the character (for
						 example, the first character is 0, the second
						 character is 1, and so on).
		@return The zero-based index value of the line.
		@throws RangeError The character index specified is out of range.
	**/
	public function getLineIndexOfChar(charIndex:Int):Int
	{
		return (_ : _TextField).getLineIndexOfChar(charIndex);
	}

	/**
		Returns the number of characters in a specific text line.

		@param lineIndex The line number for which you want the length.
		@return The number of characters in the line.
		@throws RangeError The line number specified is out of range.
	**/
	public function getLineLength(lineIndex:Int):Int
	{
		return (_ : _TextField).getLineLength(lineIndex);
	}

	/**
		Returns metrics information about a given text line.

		@param lineIndex The line number for which you want metrics information.
		@return A TextLineMetrics object.
		@throws RangeError The line number specified is out of range.
	**/
	public function getLineMetrics(lineIndex:Int):TextLineMetrics
	{
		return (_ : _TextField).getLineMetrics(lineIndex);
	}

	/**
		Returns the character index of the first character in the line that the
		`lineIndex` parameter specifies.

		@param lineIndex The zero-based index value of the line(for example, the
						 first line is 0, the second line is 1, and so on).
		@return The zero-based index value of the first character in the line.
		@throws RangeError The line number specified is out of range.
	**/
	public function getLineOffset(lineIndex:Int):Int
	{
		return (_ : _TextField).getLineOffset(lineIndex);
	}

	/**
		Returns the text of the line specified by the `lineIndex`
		parameter.

		@param lineIndex The zero-based index value of the line(for example, the
						 first line is 0, the second line is 1, and so on).
		@return The text string contained in the specified line.
		@throws RangeError The line number specified is out of range.
	**/
	public function getLineText(lineIndex:Int):String
	{
		return (_ : _TextField).getLineText(lineIndex);
	}

	/**
		Given a character index, returns the length of the paragraph
		containing the given character. The length is relative to the first
		character in the paragraph (as returned by
		`getFirstCharInParagraph()`), not to the character index passed in.

		@param charIndex The zero-based index value of the character (for
						 example, the first character is 0, the second
						 character is 1, and so on).
		@return Returns the number of characters in the paragraph.
		@throws RangeError The character index specified is out of range.
	**/
	public function getParagraphLength(charIndex:Int):Int
	{
		return (_ : _TextField).getParagraphLength(charIndex);
	}

	// function getRawText() : String;

	/**
		Returns a TextFormat object that contains formatting information for
		the range of text that the `beginIndex` and `endIndex` parameters
		specify. Only properties that are common to the entire text specified
		are set in the resulting TextFormat object. Any property that is
		_mixed_, meaning that it has different values at different points in
		the text, has a value of `null`.
		If you do not specify values for these parameters, this method is
		applied to all the text in the text field.

		The following table describes three possible usages:

		| Usage | Description |
		| --- | --- |
		| `my_textField.getTextFormat()` | Returns a TextFormat object containing formatting information for all text in a text field. Only properties that are common to all text in the text field are set in the resulting TextFormat object. Any property that is _mixed_, meaning that it has different values at different points in the text, has a value of `null`. |
		| `my_textField.getTextFormat(beginIndex:Number)` | Returns a TextFormat object containing a copy of the text format of the character at the `beginIndex` position. |
		| `my_textField.getTextFormat(beginIndex:Number,endIndex:Number)` | Returns a TextFormat object containing formatting information for the span of text from `beginIndex` to `endIndex-1`. Only properties that are common to all of the text in the specified range are set in the resulting TextFormat object. Any property that is mixed (that is, has different values at different points in the range) has its value set to `null`. |

		@return The TextFormat object that represents the formatting
				properties for the specified text.
		@throws RangeError The `beginIndex` or `endIndex` specified is out of
						   range.
	**/
	public function getTextFormat(beginIndex:Int = -1, endIndex:Int = -1):TextFormat
	{
		return (_ : _TextField).getTextFormat(beginIndex, endIndex);
	}

	/**
		Returns true if an embedded font is available with the specified
		`fontName` and `fontStyle` where `Font.fontType` is
		`openfl.text.FontType.EMBEDDED`. Starting with Flash Player 10, two
		kinds of embedded fonts can appear in a SWF file. Normal embedded
		fonts are only used with TextField objects. CFF embedded fonts are
		only used with the openfl.text.engine classes. The two types are
		distinguished by the `fontType` property of the `Font` class, as
		returned by the `enumerateFonts()` function.
		TextField cannot use a font of type `EMBEDDED_CFF`. If `embedFonts` is
		set to `true` and the only font available at run time with the
		specified name and style is of type `EMBEDDED_CFF`, Flash Player fails
		to render the text, as if no embedded font were available with the
		specified name and style.

		If both `EMBEDDED` and `EMBEDDED_CFF` fonts are available with the
		same name and style, the `EMBEDDED` font is selected and text renders
		with the `EMBEDDED` font.

		@param fontName  The name of the embedded font to check.
		@param fontStyle Specifies the font style to check. Use
						 `openfl.text.FontStyle`
		@return `true` if a compatible embedded font is available, otherwise
				`false`.
		@throws ArgumentError The `fontStyle` specified is not a member of
							  `openfl.text.FontStyle`.
	**/
	// @:require(flash10) static function isFontCompatible(fontName : String, fontStyle : String) : Bool;

	/**
		Replaces the current selection with the contents of the `value`
		parameter. The text is inserted at the position of the current
		selection, using the current default character format and default
		paragraph format. The text is not treated as HTML.
		You can use the `replaceSelectedText()` method to insert and delete
		text without disrupting the character and paragraph formatting of the
		rest of the text.

		**Note:** This method does not work if a style sheet is applied to the
		text field.

		@param value The string to replace the currently selected text.
		@throws Error This method cannot be used on a text field with a style
					  sheet.
	**/
	public function replaceSelectedText(value:String):Void
	{
		(_ : _TextField).replaceSelectedText(value);
	}

	/**
		Replaces the range of characters that the `beginIndex` and `endIndex`
		parameters specify with the contents of the `newText` parameter. As
		designed, the text from `beginIndex` to `endIndex-1` is replaced.
		**Note:** This method does not work if a style sheet is applied to the
		text field.

		@param beginIndex The zero-based index value for the start position of
						  the replacement range.
		@param endIndex   The zero-based index position of the first character
						  after the desired text span.
		@param newText    The text to use to replace the specified range of
						  characters.
		@throws Error This method cannot be used on a text field with a style
					  sheet.
	**/
	public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void
	{
		(_ : _TextField).replaceText(beginIndex, endIndex, newText);
	}

	/**
		Sets as selected the text designated by the index values of the first and
		last characters, which are specified with the `beginIndex` and
		`endIndex` parameters. If the two parameter values are the
		same, this method sets the insertion point, as if you set the
		`caretIndex` property.

		@param beginIndex The zero-based index value of the first character in the
						  selection(for example, the first character is 0, the
						  second character is 1, and so on).
		@param endIndex   The zero-based index value of the last character in the
						  selection.
	**/
	public function setSelection(beginIndex:Int, endIndex:Int):Void
	{
		(_ : _TextField).setSelection(beginIndex, endIndex);
	}

	/**
		Applies the text formatting that the `format` parameter
		specifies to the specified text in a text field. The value of
		`format` must be a TextFormat object that specifies the desired
		text formatting changes. Only the non-null properties of
		`format` are applied to the text field. Any property of
		`format` that is set to `null` is not applied. By
		default, all of the properties of a newly created TextFormat object are
		set to `null`.

		**Note:** This method does not work if a style sheet is applied to
		the text field.

		The `setTextFormat()` method changes the text formatting
		applied to a range of characters or to the entire body of text in a text
		field. To apply the properties of format to all text in the text field, do
		not specify values for `beginIndex` and `endIndex`.
		To apply the properties of the format to a range of text, specify values
		for the `beginIndex` and the `endIndex` parameters.
		You can use the `length` property to determine the index
		values.

		The two types of formatting information in a TextFormat object are
		character level formatting and paragraph level formatting. Each character
		in a text field can have its own character formatting settings, such as
		font name, font size, bold, and italic.

		For paragraphs, the first character of the paragraph is examined for
		the paragraph formatting settings for the entire paragraph. Examples of
		paragraph formatting settings are left margin, right margin, and
		indentation.

		Any text inserted manually by the user, or replaced by the
		`replaceSelectedText()` method, receives the default text field
		formatting for new text, and not the formatting specified for the text
		insertion point. To set the default formatting for new text, use
		`defaultTextFormat`.

		@param format A TextFormat object that contains character and paragraph
					  formatting information.
		@throws Error      This method cannot be used on a text field with a style
						   sheet.
		@throws RangeError The `beginIndex` or `endIndex`
						   specified is out of range.
	**/
	public function setTextFormat(format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void
	{
		(_ : _TextField).setTextFormat(format, beginIndex, endIndex);
	}

	// Get & Set Methods

	@:noCompletion private function get_antiAliasType():AntiAliasType
	{
		return (_ : _TextField).antiAliasType;
	}

	@:noCompletion private function set_antiAliasType(value:AntiAliasType):AntiAliasType
	{
		return (_ : _TextField).antiAliasType = value;
	}

	@:noCompletion private function get_autoSize():TextFieldAutoSize
	{
		return (_ : _TextField).autoSize;
	}

	@:noCompletion private function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize
	{
		return (_ : _TextField).autoSize = value;
	}

	@:noCompletion private function get_background():Bool
	{
		return (_ : _TextField).background;
	}

	@:noCompletion private function set_background(value:Bool):Bool
	{
		return (_ : _TextField).background = value;
	}

	@:noCompletion private function get_backgroundColor():Int
	{
		return (_ : _TextField).backgroundColor;
	}

	@:noCompletion private function set_backgroundColor(value:Int):Int
	{
		return (_ : _TextField).backgroundColor = value;
	}

	@:noCompletion private function get_border():Bool
	{
		return (_ : _TextField).border;
	}

	@:noCompletion private function set_border(value:Bool):Bool
	{
		return (_ : _TextField).border = value;
	}

	@:noCompletion private function get_borderColor():Int
	{
		return (_ : _TextField).borderColor;
	}

	@:noCompletion private function set_borderColor(value:Int):Int
	{
		return (_ : _TextField).borderColor = value;
	}

	@:noCompletion private function get_bottomScrollV():Int
	{
		return (_ : _TextField).bottomScrollV;
	}

	@:noCompletion private function get_caretIndex():Int
	{
		return (_ : _TextField).caretIndex;
	}

	@:noCompletion private function get_defaultTextFormat():TextFormat
	{
		return (_ : _TextField).defaultTextFormat;
	}

	@:noCompletion private function set_defaultTextFormat(value:TextFormat):TextFormat
	{
		return (_ : _TextField).defaultTextFormat = value;
	}

	@:noCompletion private function get_displayAsPassword():Bool
	{
		return (_ : _TextField).displayAsPassword;
	}

	@:noCompletion private function set_displayAsPassword(value:Bool):Bool
	{
		return (_ : _TextField).displayAsPassword = value;
	}

	@:noCompletion private function get_embedFonts():Bool
	{
		return (_ : _TextField).embedFonts;
	}

	@:noCompletion private function set_embedFonts(value:Bool):Bool
	{
		return (_ : _TextField).embedFonts = value;
	}

	@:noCompletion private function get_gridFitType():GridFitType
	{
		return (_ : _TextField).gridFitType;
	}

	@:noCompletion private function set_gridFitType(value:GridFitType):GridFitType
	{
		return (_ : _TextField).gridFitType = value;
	}

	@:noCompletion private function get_htmlText():String
	{
		return (_ : _TextField).htmlText;
	}

	@:noCompletion private function set_htmlText(value:String):String
	{
		return (_ : _TextField).htmlText = value;
	}

	@:noCompletion private function get_length():Int
	{
		return (_ : _TextField).length;
	}

	@:noCompletion private function get_maxChars():Int
	{
		return (_ : _TextField).maxChars;
	}

	@:noCompletion private function set_maxChars(value:Int):Int
	{
		return (_ : _TextField).maxChars = value;
	}

	@:noCompletion private function get_maxScrollH():Int
	{
		return (_ : _TextField).maxScrollH;
	}

	@:noCompletion private function get_maxScrollV():Int
	{
		return (_ : _TextField).maxScrollV;
	}

	@:noCompletion private function get_mouseWheelEnabled():Bool
	{
		return (_ : _TextField).mouseWheelEnabled;
	}

	@:noCompletion private function set_mouseWheelEnabled(value:Bool):Bool
	{
		return (_ : _TextField).mouseWheelEnabled = value;
	}

	@:noCompletion private function get_multiline():Bool
	{
		return (_ : _TextField).multiline;
	}

	@:noCompletion private function set_multiline(value:Bool):Bool
	{
		return (_ : _TextField).multiline = value;
	}

	@:noCompletion private function get_numLines():Int
	{
		return (_ : _TextField).numLines;
	}

	@:noCompletion private function get_restrict():String
	{
		return (_ : _TextField).restrict;
	}

	@:noCompletion private function set_restrict(value:String):String
	{
		return (_ : _TextField).restrict = value;
	}

	@:noCompletion private function get_scrollH():Int
	{
		return (_ : _TextField).scrollH;
	}

	@:noCompletion private function set_scrollH(value:Int):Int
	{
		return (_ : _TextField).scrollH = value;
	}

	@:noCompletion private function get_scrollV():Int
	{
		return (_ : _TextField).scrollV;
	}

	@:noCompletion private function set_scrollV(value:Int):Int
	{
		return (_ : _TextField).scrollV = value;
	}

	@:noCompletion private function get_selectable():Bool
	{
		return (_ : _TextField).selectable;
	}

	@:noCompletion private function set_selectable(value:Bool):Bool
	{
		return (_ : _TextField).selectable = value;
	}

	@:noCompletion private function get_selectionBeginIndex():Int
	{
		return (_ : _TextField).selectionBeginIndex;
	}

	@:noCompletion private function get_selectionEndIndex():Int
	{
		return (_ : _TextField).selectionEndIndex;
	}

	@:noCompletion private function get_sharpness():Float
	{
		return (_ : _TextField).sharpness;
	}

	@:noCompletion private function set_sharpness(value:Float):Float
	{
		return (_ : _TextField).sharpness = value;
	}

	@:noCompletion private override function get_tabEnabled():Bool
	{
		return (_ : _TextField).tabEnabled;
	}

	@:noCompletion private function get_text():String
	{
		return (_ : _TextField).text;
	}

	@:noCompletion private function set_text(value:String):String
	{
		return (_ : _TextField).text = value;
	}

	@:noCompletion private function get_textColor():Int
	{
		return (_ : _TextField).textColor;
	}

	@:noCompletion private function set_textColor(value:Int):Int
	{
		return (_ : _TextField).textColor = value;
	}

	@:noCompletion private function get_textWidth():Float
	{
		return (_ : _TextField).textWidth;
	}

	@:noCompletion private function get_textHeight():Float
	{
		return (_ : _TextField).textHeight;
	}

	@:noCompletion private function get_type():TextFieldType
	{
		return (_ : _TextField).type;
	}

	@:noCompletion private function set_type(value:TextFieldType):TextFieldType
	{
		return (_ : _TextField).type = value;
	}

	@:noCompletion private function get_wordWrap():Bool
	{
		return (_ : _TextField).wordWrap;
	}

	@:noCompletion private function set_wordWrap(value:Bool):Bool
	{
		return (_ : _TextField).wordWrap = value;
	}
}
#else
typedef TextField = flash.text.TextField;
#end
