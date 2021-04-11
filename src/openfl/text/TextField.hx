package openfl.text;

#if !flash
import haxe.Timer;
import openfl.text._internal.HTMLParser;
import openfl.text._internal.TextEngine;
import openfl.text._internal.TextFormatRange;
import openfl.text._internal.TextLayoutGroup;
import openfl.text._internal.UTF8String;
import openfl.utils._internal.Log;
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
#if lime
import lime.system.Clipboard;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
#end
#if (js && html5)
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
	public var htmlText(get, set):UTF8String;

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
	public var restrict(get, set):UTF8String;

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
		Developer's Guide_.
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
	public var text(get, set):UTF8String;

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

	// The thickness of the glyph edges in this text field. This property
	// applies only when `openfl.text.AntiAliasType` is set to
	// `openfl.text.AntiAliasType.ADVANCED`.
	// The range for `thickness` is a number from -200 to 200. If you attempt
	// to set `thickness` to a value outside that range, the property is set
	// to the nearest value in the range (either -200 or 200).
	// @default 0
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

	@:noCompletion private var __bounds:Rectangle;
	@:noCompletion private var __caretIndex:Int;
	@:noCompletion private var __cursorTimer:Timer;
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __displayAsPassword:Bool;
	@:noCompletion private var __domRender:Bool;
	@:noCompletion private var __inputEnabled:Bool;
	@:noCompletion private var __isHTML:Bool;
	@:noCompletion private var __layoutDirty:Bool;
	@:noCompletion private var __mouseScrollVCounter:Int = 0;
	@:noCompletion private var __mouseWheelEnabled:Bool;
	@:noCompletion private var __offsetX:Float;
	@:noCompletion private var __offsetY:Float;
	@:noCompletion private var __selectionIndex:Int;
	@:noCompletion private var __showCursor:Bool;
	@:noCompletion private var __text:UTF8String;
	@:noCompletion private var __htmlText:UTF8String;
	@:noCompletion private var __textEngine:TextEngine;
	@:noCompletion private var __textFormat:TextFormat;
	#if (js && html5)
	@:noCompletion private var __div:DivElement;
	@:noCompletion private var __renderedOnCanvasWhileOnDOM:Bool = false;
	@:noCompletion private var __rawHtmlText:String;
	@:noCompletion private var __forceCachedBitmapUpdate:Bool = false;
	#end

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(TextField.prototype, {
			"antiAliasType": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_antiAliasType (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_antiAliasType (v); }")
			},
			"autoSize": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_autoSize (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_autoSize (v); }")
			},
			"background": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_background (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_background (v); }")
			},
			"backgroundColor": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_backgroundColor (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_backgroundColor (v); }")
			},
			"border": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_border (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_border (v); }")
			},
			"borderColor": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_borderColor (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_borderColor (v); }")
			},
			"bottomScrollV": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_bottomScrollV (); }")},
			"defaultTextFormat": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_defaultTextFormat (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_defaultTextFormat (v); }")
			},
			"displayAsPassword": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_displayAsPassword (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_displayAsPassword (v); }")
			},
			"embedFonts": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_embedFonts (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_embedFonts (v); }")
			},
			"gridFitType": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_gridFitType (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_gridFitType (v); }")
			},
			"htmlText": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_htmlText (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_htmlText (v); }")
			},
			"length": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_length (); }")},
			"maxChars": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_maxChars (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_maxChars (v); }")
			},
			"maxScrollH": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_maxScrollH (); }")},
			"maxScrollV": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_maxScrollV (); }")},
			"mouseWheelEnabled": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_mouseWheelEnabled (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_mouseWheelEnabled (v); }")
			},
			"multiline": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_multiline (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_multiline (v); }")
			},
			"numLines": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_numLines (); }")},
			"restrict": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_restrict (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_restrict (v); }")
			},
			"scrollH": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_scrollH (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_scrollH (v); }")
			},
			"scrollV": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_scrollV (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_scrollV (v); }")
			},
			"selectable": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_selectable (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_selectable (v); }")
			},
			"selectionBeginIndex": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_selectionBeginIndex (); }")},
			"selectionEndIndex": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_selectionEndIndex (); }")},
			"sharpness": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_sharpness (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_sharpness (v); }")
			},
			"text": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_text (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_text (v); }")
			},
			"textColor": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_textColor (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_textColor (v); }")
			},
			"textHeight": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_textHeight (); }")},
			"textWidth": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_textWidth (); }")},
			"type": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_type (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_type (v); }")
			},
			"wordWrap": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_wordWrap (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_wordWrap (v); }")
			},
		});
	}
	#end

	/**
		Creates a new TextField instance. After you create the TextField instance,
		call the `addChild()` or `addChildAt()` method of
		the parent DisplayObjectContainer object to add the TextField instance to
		the display list.

		The default size for a text field is 100 x 100 pixels.
	**/
	public function new()
	{
		super();

		__drawableType = TEXT_FIELD;
		__caretIndex = -1;
		__displayAsPassword = false;
		__graphics = new Graphics(this);
		__textEngine = new TextEngine(this);
		__layoutDirty = true;
		__offsetX = 0;
		__offsetY = 0;
		__mouseWheelEnabled = true;
		__text = "";

		doubleClickEnabled = true;

		if (__defaultTextFormat == null)
		{
			__defaultTextFormat = new TextFormat("Times New Roman", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			__defaultTextFormat.blockIndent = 0;
			__defaultTextFormat.bullet = false;
			__defaultTextFormat.letterSpacing = 0;
			__defaultTextFormat.kerning = false;
		}

		__textFormat = __defaultTextFormat.clone();
		__textEngine.textFormatRanges.push(new TextFormatRange(__textFormat, 0, 0));

		addEventListener(MouseEvent.MOUSE_DOWN, this_onMouseDown);
		addEventListener(FocusEvent.FOCUS_IN, this_onFocusIn);
		addEventListener(FocusEvent.FOCUS_OUT, this_onFocusOut);
		addEventListener(KeyboardEvent.KEY_DOWN, this_onKeyDown);
		addEventListener(MouseEvent.MOUSE_WHEEL, this_onMouseWheel);

		addEventListener(MouseEvent.DOUBLE_CLICK, this_onDoubleClick);
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
		if (text == null || text == "") return;

		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty();

		__updateText(__text + text);

		__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end = __text.length;

		__selectionIndex = __caretIndex = __text.length;
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
		if (charIndex < 0 || charIndex > __text.length - 1) return null;

		var rect = new Rectangle();

		if (__getCharBoundaries(charIndex, rect))
		{
			return rect;
		}
		else
		{
			return null;
		}
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
		if (x <= 2 || x > width + 4 || y <= 0 || y > height + 4) return -1;

		__updateLayout();

		x += scrollH;

		for (i in 0...scrollV - 1)
		{
			y += __textEngine.lineHeights[i];
		}

		for (group in __textEngine.layoutGroups)
		{
			if (y >= group.offsetY && y <= group.offsetY + group.height)
			{
				if (x >= group.offsetX && x <= group.offsetX + group.width)
				{
					var advance = 0.0;

					for (i in 0...group.positions.length)
					{
						advance += group.getAdvance(i);

						if (x <= group.offsetX + advance)
						{
							return group.startIndex + i;
						}
					}

					return group.endIndex;
				}
			}
		}

		return -1;
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
		if (charIndex < 0 || charIndex > text.length) return -1;
		if (__textEngine.lineBreaks.length == 0) return 0;

		for (i in 0...__textEngine.lineBreaks.length)
		{
			if (charIndex <= __textEngine.lineBreaks[i])
			{
				return i == 0 ? 0 : __textEngine.lineBreaks[i - 1] + 1;
			}
		}

		return __textEngine.lineBreaks[__textEngine.lineBreaks.length - 1] + 1;
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
		__updateLayout();

		if (x <= 2 || x > width + 4 || y <= 0 || y > height + 4) return -1;

		for (i in 0...scrollV - 1)
		{
			y += __textEngine.lineHeights[i];
		}

		for (group in __textEngine.layoutGroups)
		{
			if (y >= group.offsetY && y <= group.offsetY + group.height)
			{
				return group.lineIndex;
			}
		}

		return -1;
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
		if (charIndex < 0 || charIndex > __text.length) return -1;

		__updateLayout();

		for (group in __textEngine.layoutGroups)
		{
			if (group.startIndex <= charIndex && group.endIndex >= charIndex)
			{
				return group.lineIndex;
			}
		}

		return -1;
	}

	/**
		Returns the number of characters in a specific text line.

		@param lineIndex The line number for which you want the length.
		@return The number of characters in the line.
		@throws RangeError The line number specified is out of range.
	**/
	public function getLineLength(lineIndex:Int):Int
	{
		__updateLayout();

		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return 0;

		var startIndex = -1;
		var endIndex = -1;

		for (group in __textEngine.layoutGroups)
		{
			if (group.lineIndex == lineIndex)
			{
				if (startIndex == -1) startIndex = group.startIndex;
			}
			else if (group.lineIndex == lineIndex + 1)
			{
				endIndex = group.startIndex;
				break;
			}
		}

		if (endIndex == -1) endIndex = __text.length;
		return endIndex - startIndex;
	}

	/**
		Returns metrics information about a given text line.

		@param lineIndex The line number for which you want metrics information.
		@return A TextLineMetrics object.
		@throws RangeError The line number specified is out of range.
	**/
	public function getLineMetrics(lineIndex:Int):TextLineMetrics
	{
		__updateLayout();

		var ascender = __textEngine.lineAscents[lineIndex];
		var descender = __textEngine.lineDescents[lineIndex];
		var leading = __textEngine.lineLeadings[lineIndex];
		var lineHeight = __textEngine.lineHeights[lineIndex];
		var lineWidth = __textEngine.lineWidths[lineIndex];

		// TODO: Handle START and END based on language (don't assume LTR)

		var margin = switch (__textFormat.align)
		{
			case LEFT, JUSTIFY, START: 2;
			case RIGHT, END: (__textEngine.width - lineWidth) - 2;
			case CENTER: (__textEngine.width - lineWidth) / 2;
		}

		return new TextLineMetrics(margin, lineWidth, lineHeight, ascender, descender, leading);
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
		__updateLayout();

		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return -1;

		for (group in __textEngine.layoutGroups)
		{
			if (group.lineIndex == lineIndex)
			{
				return group.startIndex;
			}
		}

		return 0;
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
		__updateLayout();

		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return null;

		var startIndex = -1;
		var endIndex = -1;

		for (group in __textEngine.layoutGroups)
		{
			if (group.lineIndex == lineIndex)
			{
				if (startIndex == -1) startIndex = group.startIndex;
			}
			else if (group.lineIndex == lineIndex + 1)
			{
				endIndex = group.startIndex;
				break;
			}
		}

		if (endIndex == -1) endIndex = __text.length;

		return __textEngine.text.substring(startIndex, endIndex);
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
		if (charIndex < 0 || charIndex > text.length) return -1;

		var startIndex = getFirstCharInParagraph(charIndex);

		if (charIndex >= text.length) return text.length - startIndex + 1;

		var endIndex = __textEngine.getLineBreakIndex(charIndex) + 1;

		if (endIndex == 0) endIndex = __text.length;
		return endIndex - startIndex;
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
		var format = null;

		if (beginIndex >= text.length || beginIndex < -1 || endIndex > text.length || endIndex < -1)
			throw new RangeError("The supplied index is out of bounds");

		if (beginIndex == -1) beginIndex = 0;
		if (endIndex == -1) endIndex = text.length;

		if (beginIndex >= endIndex) return new TextFormat();

		for (group in __textEngine.textFormatRanges)
		{
			if ((group.start <= beginIndex && group.end > beginIndex) || (group.start < endIndex && group.end >= endIndex))
			{
				if (format == null)
				{
					format = group.format.clone();
				}
				else
				{
					if (group.format.font != format.font) format.font = null;
					if (group.format.size != format.size) format.size = null;
					if (group.format.color != format.color) format.color = null;
					if (group.format.bold != format.bold) format.bold = null;
					if (group.format.italic != format.italic) format.italic = null;
					if (group.format.underline != format.underline) format.underline = null;
					if (group.format.url != format.url) format.url = null;
					if (group.format.target != format.target) format.target = null;
					if (group.format.align != format.align) format.align = null;
					if (group.format.leftMargin != format.leftMargin) format.leftMargin = null;
					if (group.format.rightMargin != format.rightMargin) format.rightMargin = null;
					if (group.format.indent != format.indent) format.indent = null;
					if (group.format.leading != format.leading) format.leading = null;
					if (group.format.blockIndent != format.blockIndent) format.blockIndent = null;
					if (group.format.bullet != format.bullet) format.bullet = null;
					if (group.format.kerning != format.kerning) format.kerning = null;
					if (group.format.letterSpacing != format.letterSpacing) format.letterSpacing = null;
					if (group.format.tabStops != format.tabStops) format.tabStops = null;
				}
			}
		}

		if (format == null) format = new TextFormat();
		return format;
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
		__replaceSelectedText(value, false);
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
		__replaceText(beginIndex, endIndex, newText, false);
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
		__selectionIndex = beginIndex;
		__caretIndex = endIndex;

		__updateScrollV();
		__updateScrollH();

		if (stage != null && stage.focus == this)
		{
			__stopCursorTimer();
			__startCursorTimer();
		}
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
	public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void
	{
		var max = text.length;
		var range;

		if (beginIndex == -1)
		{
			if (endIndex == -1) endIndex = max;
			beginIndex = 0;
		}
		else if (endIndex == -1)
		{
			endIndex = beginIndex + 1;
		}

		if (beginIndex == endIndex) return;
		if (beginIndex < 0 || endIndex <= 0 || endIndex < beginIndex || beginIndex >= max || endIndex > max) throw new RangeError();

		// there are 11 cases that have to be handled
		// the order and logic of cases really matters!!
		//	beginIndex == 0 && endIndex == max -> replace all format ranges with new one
		//	existing range.end < beginIndex -> continue
		//	existing range.start >= endIndex -> done
		//	existing range encompassed by beginIndex...endIndex ->
		//		existing range == new range -> merge new format into existing
		//		range.start == beginIndex -> existing.start = endIndex, insert new before existing
		//		range.end == endIndex -> existing.end = beginIndex, insert new after existing
		//		else -> split existing into two (existing.end = beginIndex; newExisting.start = endIndex), insert new in between
		//	existing range completely encompasses beginIndex...endIndex
		// 		if they start with the same index -> overwrite
		// 		else -> delete existing
		//	existing range encompasses beginIndex but not endIndex -> existing.start = endIndex
		//	existing range encompasses endIndex but not beginIndex -> existing.end = beginIndex, insert new

		if (beginIndex == 0 && endIndex == max)
		{
			// set text format for the whole textfield
			__textEngine.textFormatRanges.length = 1;

			range = __textEngine.textFormatRanges[0];
			range.start = 0;
			range.end = max;
			range.format.__merge(format);
		}
		else
		{
			var index = 0;
			var newRange;

			while (index < __textEngine.textFormatRanges.length)
			{
				range = __textEngine.textFormatRanges[index];

				if (range.end <= beginIndex)
				{
					// skip until relevant format ranges
					index++;
				}
				else if (range.start >= endIndex)
				{
					// stop iterating if set format range has been handled
					break;
				}
				else if (range.start <= beginIndex && range.end >= endIndex)
				{
					if (range.start == beginIndex && range.end == endIndex)
					{
						// set format range matches an existing range exactly
						range.format = range.format.clone();
						range.format.__merge(format);
						break;
					}
					else if (range.start == beginIndex)
					{
						// existing range encompasses set format range, with start == beginIndex
						newRange = new TextFormatRange(range.format.clone(), beginIndex, endIndex);
						newRange.format.__merge(format);
						__textEngine.textFormatRanges.insertAt(index, newRange);
						range.start = endIndex;
						index += 2;
					}
					else if (range.end == endIndex)
					{
						// existing range encompasses set format range, with end == endIndex
						newRange = new TextFormatRange(range.format.clone(), beginIndex, endIndex);
						newRange.format.__merge(format);
						__textEngine.textFormatRanges.insertAt(index + 1, newRange);

						range.end = beginIndex;
						break;
					}
					else
					{
						// existing range completely encompasses set format range
						newRange = new TextFormatRange(range.format.clone(), beginIndex, endIndex);
						newRange.format.__merge(format);
						__textEngine.textFormatRanges.insertAt(index + 1, newRange);

						newRange = new TextFormatRange(range.format.clone(), endIndex, range.end);
						__textEngine.textFormatRanges.insertAt(index + 2, newRange);

						range.end = beginIndex;
						break;
					}
				}
				else if (range.start >= beginIndex && range.end <= endIndex)
				{
					// set format range completely encompasses this existing range
					if (range.start == beginIndex)
					{
						// deleted range would disappear and not be replaced in this case
						range.format = range.format.clone();
						range.format.__merge(format);
						range.end = endIndex;
					}
					else
					{
						// delete range
						__textEngine.textFormatRanges.removeAt(index);
					}
				}
				else if (range.start > beginIndex && range.end > beginIndex)
				{
					// set format range is within the first part of the range
					range.start = endIndex;
					break;
				}
				else if (range.start < beginIndex && range.end <= endIndex)
				{
					// set format range is within the second part of the range
					newRange = new TextFormatRange(range.format.clone(), beginIndex, endIndex);
					newRange.format.__merge(format);
					__textEngine.textFormatRanges.insertAt(index + 1, newRange);
					range.end = beginIndex;
					index += 2;
				}
				else
				{
					// should never happen, throw an error
					index++;
					Log.warn("You found a bug in OpenFL's text code! Please save a copy of your project and contact Joshua Granick (@singmajesty) so we can fix this.");
				}
			}
			/*
				// robust catchers for myriad edge cases
				// TODO: should this be here? it would force getLayoutGroups() to never soft fail and report there's a text bug
				if (__textEngine.textFormatRanges.length == 0)
				{
					newRange = new TextFormatRange(defaultTextFormat.clone(), 0, endIndex);
					newRange.format.__merge(format);
					__textEngine.textFormatRanges.push(newRange);
				}
				else if (__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end < __text.length)
				{
					newRange = new TextFormatRange(defaultTextFormat.clone(), __textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end, __text.length);
					newRange.format.__merge(format);
					__textEngine.textFormatRanges.push(newRange);
				}
				else if (__textEngine.textFormatRanges[0].start > 0)
				{
					newRange = new TextFormatRange(defaultTextFormat.clone(), 0, __textEngine.textFormatRanges[0].start);
					newRange.format.__merge(format);
					__textEngine.textFormatRanges.unshift(newRange);
				}
			 */
		}

		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty();
	}

	@:noCompletion private override function __allowMouseFocus():Bool
	{
		return __textEngine.type == INPUT || tabEnabled || selectable;
	}

	@:noCompletion private function __caretBeginningOfLine():Void
	{
		__caretIndex = getLineOffset(getLineIndexOfChar(__caretIndex));
	}

	@:noCompletion private function __caretBeginningOfNextLine():Void
	{
		var lineIndex = getLineIndexOfChar(__caretIndex);

		if (lineIndex < __textEngine.numLines - 1)
		{
			__caretIndex = getLineOffset(lineIndex + 1);
		}
		else
		{
			__caretIndex = __text.length;
		}
	}

	@:noCompletion private function __caretBeginningOfPreviousLine():Void
	{
		var lineIndex = getLineIndexOfChar(__caretIndex);

		if (lineIndex > 0)
		{
			var index = getLineOffset(getLineIndexOfChar(__caretIndex));

			if (__caretIndex == index)
			{
				__caretIndex = getLineOffset(lineIndex - 1);
			}
			else
			{
				__caretIndex = index;
			}
		}
	}

	@:noCompletion private function __caretEndOfLine():Void
	{
		var lineIndex = getLineIndexOfChar(__caretIndex);

		if (lineIndex < __textEngine.numLines - 1)
		{
			__caretIndex = getLineOffset(lineIndex + 1) - 1;
		}
		else
		{
			__caretIndex = __text.length;
		}
	}

	@:noCompletion private function __caretNextCharacter():Void
	{
		if (__caretIndex < __text.length)
		{
			__caretIndex++;
		}
	}

	@:noCompletion private function __caretNextLine():Void
	{
		var lineIndex = getLineIndexOfChar(__caretIndex);

		if (lineIndex < __textEngine.numLines - 1)
		{
			__caretIndex = __getCharIndexOnDifferentLine(caretIndex, lineIndex + 1);
		}
	}

	@:noCompletion private function __caretPreviousCharacter():Void
	{
		if (__caretIndex > 0)
		{
			__caretIndex--;
		}
	}

	@:noCompletion private function __caretPreviousLine():Void
	{
		var lineIndex = getLineIndexOfChar(__caretIndex);

		if (lineIndex > 0)
		{
			__caretIndex = __getCharIndexOnDifferentLine(caretIndex, lineIndex - 1);
		}
	}

	@:noCompletion private function __disableInput():Void
	{
		if (__inputEnabled && stage != null)
		{
			#if lime
			stage.window.textInputEnabled = false;
			stage.window.onTextInput.remove(window_onTextInput);
			stage.window.onKeyDown.remove(window_onKeyDown);
			#end

			__inputEnabled = false;
			__stopCursorTimer();
		}
	}

	@:noCompletion private override function __dispatch(event:Event):Bool
	{
		if (event.eventPhase == AT_TARGET && event.type == MouseEvent.MOUSE_UP)
		{
			var event:MouseEvent = cast event;
			var group = __getGroup(mouseX, mouseY, true);

			if (group != null)
			{
				var url = group.format.url;

				if (url != null && url != "")
				{
					if (StringTools.startsWith(url, "event:"))
					{
						dispatchEvent(new TextEvent(TextEvent.LINK, false, false, url.substr(6)));
					}
					else
					{
						Lib.getURL(new URLRequest(url));
					}
				}
			}
		}

		return super.__dispatch(event);
	}

	@:noCompletion private function __enableInput():Void
	{
		#if lime
		if (stage != null)
		{
			stage.window.textInputEnabled = true;

			if (!__inputEnabled)
			{
				stage.window.textInputEnabled = true;

				if (!stage.window.onTextInput.has(window_onTextInput))
				{
					stage.window.onTextInput.add(window_onTextInput);
					stage.window.onKeyDown.add(window_onKeyDown);
				}

				__inputEnabled = true;
				__startCursorTimer();
			}
		}
		#end
	}

	@:noCompletion private inline function __getAdvance(position):Float
	{
		#if (js && html5)
		return position;
		#else
		return position.advance.x;
		#end
	}

	@:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		__updateLayout();

		var bounds = Rectangle.__pool.get();
		bounds.copyFrom(__textEngine.bounds);

		matrix.tx += __offsetX;
		matrix.ty += __offsetY;

		bounds.__transform(bounds, matrix);

		rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);

		Rectangle.__pool.release(bounds);
	}

	@:noCompletion private function __getCharBoundaries(charIndex:Int, rect:Rectangle):Bool
	{
		if (charIndex < 0 || charIndex > __text.length - 1) return false;

		__updateLayout();

		for (group in __textEngine.layoutGroups)
		{
			if (charIndex >= group.startIndex && charIndex < group.endIndex)
			{
				try
				{
					var x = group.offsetX;

					for (i in 0...(charIndex - group.startIndex))
					{
						x += group.getAdvance(i);
					}

					// TODO: Is this actually right for combining characters?
					var lastPosition = group.getAdvance(charIndex - group.startIndex);

					rect.setTo(x, group.offsetY, lastPosition, group.ascent + group.descent);
					return true;
				}
				catch (e:Dynamic) {}
			}
		}

		return false;
	}

	@:noCompletion private function __getCharIndexOnDifferentLine(charIndex:Int, lineIndex:Int):Int
	{
		if (charIndex < 0 || charIndex > __text.length) return -1;
		if (lineIndex < 0 || lineIndex > __textEngine.numLines - 1) return -1;

		var x:Null<Float> = null, y:Null<Float> = null;

		for (group in __textEngine.layoutGroups)
		{
			if (charIndex >= group.startIndex && charIndex <= group.endIndex)
			{
				x = group.offsetX;

				for (i in 0...(charIndex - group.startIndex))
				{
					x += group.getAdvance(i);
				}

				if (y != null) return __getPosition(x, y);
			}

			if (group.lineIndex == lineIndex)
			{
				y = group.offsetY + group.height / 2;

				for (i in 0...scrollV - 1)
				{
					y -= __textEngine.lineHeights[i];
				}

				if (x != null) return __getPosition(x, y);
			}
		}

		return -1;
	}

	@:noCompletion private override function __getCursor():MouseCursor
	{
		var group = __getGroup(mouseX, mouseY, true);

		if (group != null && group.format.url != "")
		{
			return BUTTON;
		}
		else if (__textEngine.selectable)
		{
			return IBEAM;
		}

		return null;
	}

	@:noCompletion private function __getGroup(x:Float, y:Float, precise = false):TextLayoutGroup
	{
		__updateLayout();

		x += scrollH;

		for (i in 0...scrollV - 1)
		{
			y += __textEngine.lineHeights[i];
		}

		if (!precise && y > __textEngine.textHeight) y = __textEngine.textHeight;

		var firstGroup = true;
		var group, nextGroup;

		for (i in 0...__textEngine.layoutGroups.length)
		{
			group = __textEngine.layoutGroups[i];

			if (i < __textEngine.layoutGroups.length - 1)
			{
				nextGroup = __textEngine.layoutGroups[i + 1];
			}
			else
			{
				nextGroup = null;
			}

			if (firstGroup)
			{
				if (y < group.offsetY) y = group.offsetY;
				if (x < group.offsetX) x = group.offsetX;
				firstGroup = false;
			}

			if ((y >= group.offsetY && y <= group.offsetY + group.height) || (!precise && nextGroup == null))
			{
				if ((x >= group.offsetX && x <= group.offsetX + group.width)
					|| (!precise && (nextGroup == null || nextGroup.lineIndex != group.lineIndex)))
				{
					return group;
				}
			}
		}

		return null;
	}

	@:noCompletion private function __getPosition(x:Float, y:Float):Int
	{
		var group = __getGroup(x, y);

		if (group == null)
		{
			return __text.length;
		}

		var advance = 0.0;

		for (i in 0...group.positions.length)
		{
			advance += group.getAdvance(i);

			if (x <= group.offsetX + advance)
			{
				if (x <= group.offsetX + (advance - group.getAdvance(i)) + (group.getAdvance(i) / 2))
				{
					return group.startIndex + i;
				}
				else
				{
					return (group.startIndex + i < group.endIndex) ? group.startIndex + i + 1 : group.endIndex;
				}
			}
		}

		return group.endIndex;
	}

	@:noCompletion private override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
		if (mask != null && !mask.__hitTestMask(x, y)) return false;

		__getRenderTransform();
		__updateLayout();

		var px = __renderTransform.__transformInverseX(x, y);
		var py = __renderTransform.__transformInverseY(x, y);

		if (__textEngine.bounds.contains(px, py))
		{
			if (stack != null)
			{
				stack.push(hitObject);
			}

			return true;
		}

		return false;
	}

	@:noCompletion private override function __hitTestMask(x:Float, y:Float):Bool
	{
		__getRenderTransform();
		__updateLayout();

		var px = __renderTransform.__transformInverseX(x, y);
		var py = __renderTransform.__transformInverseY(x, y);

		if (__textEngine.bounds.contains(px, py))
		{
			return true;
		}

		return false;
	}

	@:noCompletion private function __replaceSelectedText(value:String, restrict:Bool = true):Void
	{
		if (value == null) value = "";
		if (value == "" && __selectionIndex == __caretIndex) return;

		var startIndex = __caretIndex < __selectionIndex ? __caretIndex : __selectionIndex;
		var endIndex = __caretIndex > __selectionIndex ? __caretIndex : __selectionIndex;

		if (startIndex == endIndex && __textEngine.maxChars > 0 && __text.length == __textEngine.maxChars) return;

		if (startIndex > __text.length) startIndex = __text.length;
		if (endIndex > __text.length) endIndex = __text.length;
		if (endIndex < startIndex)
		{
			var cache = endIndex;
			endIndex = startIndex;
			startIndex = cache;
		}
		if (startIndex < 0) startIndex = 0;

		__replaceText(startIndex, endIndex, value, restrict);
	}

	@:noCompletion private function __replaceText(beginIndex:Int, endIndex:Int, newText:String, restrict:Bool):Void
	{
		if (endIndex < beginIndex || beginIndex < 0 || endIndex > __text.length || newText == null) return;

		if (restrict)
		{
			newText = __textEngine.restrictText(newText);

			if (__textEngine.maxChars > 0)
			{
				var removeLength = (endIndex - beginIndex);
				var maxLength = __textEngine.maxChars - __text.length + removeLength;

				if (maxLength <= 0)
				{
					newText = "";
				}
				else if (maxLength < newText.length)
				{
					newText = newText.substr(0, maxLength);
				}
			}
		}

		__updateText(__text.substring(0, beginIndex) + newText + __text.substring(endIndex));

		var offset = newText.length - (endIndex - beginIndex);

		var i = 0;
		var range;

		while (i < __textEngine.textFormatRanges.length)
		{
			range = __textEngine.textFormatRanges[i];

			if (beginIndex == endIndex)
			{
				if (range.start == range.end)
				{
					// this should only ever be true if there is no text (start == end == 0)
					if (range.start != 0)
					{
						Log.warn("You found a bug in OpenFL's text code! Please save a copy of your project and contact Joshua Granick (@singmajesty) so we can fix this.");
					}
					else
					{
						range.end += offset;
					}
				}
				else if (range.end < beginIndex)
				{
					// do nothing, range is completely before insertion point
				}
				else if (range.start >= beginIndex)
				{
					// shift range, range is after insertion point
					range.start += offset;
					range.end += offset;
				}
				else if (range.start < beginIndex && range.end >= endIndex)
				{
					// shift end, range overlaps insertion point
					// insertions use the format to the left of the insertion point, when beginIndex == endIndex
					range.end += offset;
				}
			}
			else
			{
				if (range.end <= beginIndex)
				{
					// do nothing, range is before selection
				}
				else if (range.start > endIndex)
				{
					// shift start and end, range is after selection
					range.start += offset;
					range.end += offset;
				}
				else if (range.start <= beginIndex && range.end > endIndex)
				{
					// shift end, range overlaps and extends after selection
					range.end += offset;
				}
				else if (range.start >= beginIndex && range.end <= endIndex)
				{
					// delete, range is encompassed by selection
					__textEngine.textFormatRanges.splice(i--, 1);
				}
				else if (range.end > endIndex && range.start > beginIndex && range.start <= endIndex)
				{
					// set start and shift end, beginning of range overlaps selection
					// replacements use the format to the right of the selection, when beginIndex != endIndex
					range.start = beginIndex;
					range.end += offset;
				}
				else if (range.start < beginIndex && range.end > beginIndex && range.end <= endIndex)
				{
					// set end, end of range overlaps selection
					range.end = beginIndex;
				}
			}

			i++;
		}

		// robust catchers for myriad edge cases
		if (__textEngine.textFormatRanges.length == 0)
		{
			// add DTF, all format ranges were deleted
			__textEngine.textFormatRanges.push(new TextFormatRange(defaultTextFormat.clone(), 0, newText.length));
		}
		else if (beginIndex == endIndex && __textEngine.textFormatRanges[0].start > 0)
		{
			// prefix DTF, text was inserted without a format
			__textEngine.textFormatRanges.unshift(new TextFormatRange(defaultTextFormat.clone(), 0, __textEngine.textFormatRanges[0].start));
		}
		else if (beginIndex != endIndex && __textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end < __text.length)
		{
			// append DTF, text was replaced without a format
			__textEngine.textFormatRanges.push(new TextFormatRange(defaultTextFormat.clone(),
				__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end, __text.length));
		}

		__selectionIndex = __caretIndex = beginIndex + newText.length;

		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty();
	}

	@:noCompletion private function __startCursorTimer():Void
	{
		if (type == INPUT)
		{
			__cursorTimer = Timer.delay(__startCursorTimer, 600);
			__showCursor = !__showCursor;
			__dirty = true;
			__setRenderDirty();
		}
	}

	@:noCompletion private function __startTextInput():Void
	{
		if (__caretIndex < 0)
		{
			__caretIndex = __text.length;
			__selectionIndex = __caretIndex;
		}

		var enableInput = #if (js && html5) (DisplayObject.__supportDOM ? __renderedOnCanvasWhileOnDOM : true) #else true #end;

		if (enableInput)
		{
			__enableInput();
		}
	}

	@:noCompletion private function __stopCursorTimer():Void
	{
		if (__cursorTimer != null)
		{
			__cursorTimer.stop();
			__cursorTimer = null;
		}

		if (__showCursor)
		{
			__showCursor = false;
			__dirty = true;
			__setRenderDirty();
		}
	}

	@:noCompletion private function __stopTextInput():Void
	{
		var disableInput = #if (js && html5) (DisplayObject.__supportDOM ? __renderedOnCanvasWhileOnDOM : true) #else true #end;

		if (disableInput)
		{
			__disableInput();
		}
	}

	@:noCompletion private function __updateLayout():Void
	{
		if (__layoutDirty)
		{
			var cacheWidth = __textEngine.width;
			__textEngine.update();

			if (__textEngine.autoSize != NONE)
			{
				if (__textEngine.width != cacheWidth)
				{
					switch (__textEngine.autoSize)
					{
						case RIGHT:
							x += cacheWidth - __textEngine.width;

						case CENTER:
							x += (cacheWidth - __textEngine.width) / 2;

						default:
					}
				}

				__textEngine.getBounds();
			}

			__layoutDirty = false;

			setSelection(__selectionIndex, __caretIndex);
		}
	}

	@:noCompletion private function __updateScrollH():Void
	{
		__updateLayout();

		if (textWidth <= width - 4)
		{
			scrollH = 0;
			return;
		}

		var tempScrollH = scrollH;

		// margins are ignored here

		if (__caretIndex == 0 || getLineOffset(getLineIndexOfChar(__caretIndex)) == __caretIndex)
		{
			// first index in a line is always at 0 scrollH
			tempScrollH = 0;
		}
		else
		{
			var caret = Rectangle.__pool.get();
			var written = false;

			if (__caretIndex < __text.length)
			{
				written = __getCharBoundaries(__caretIndex, caret);
			}
			if (!written)
			{
				// \n and \r don't have character boundaries, as well as when caretIndex == text.length
				// written doesn't need to be checked again, covered earlier
				__getCharBoundaries(__caretIndex - 1, caret);
				caret.x += caret.width; // shift rectangle to where the caret is
			}

			while (caret.x < tempScrollH && tempScrollH > 0)
			{
				tempScrollH -= 24;
			}
			while (caret.x > tempScrollH + width - 4)
			{
				tempScrollH += 24;
			}

			Rectangle.__pool.release(caret);
		}

		if (tempScrollH > 0 && type != INPUT)
		{
			// input text leaves some room after scrolling to the last character in a line. dynamic text does not
			var lineLength = getLineLength(getLineIndexOfChar(__caretIndex));
			if (scrollH + width - 4 > lineLength)
			{
				scrollH = Math.ceil(lineLength - width + 4);
			}
		}

		if (tempScrollH < 0)
		{
			scrollH = 0;
		}
		else if (tempScrollH > maxScrollH)
		{
			scrollH = maxScrollH;
		}
		else
		{
			scrollH = tempScrollH;
		}

		// TODO: Handle drag select
	}

	@:noCompletion private function __updateScrollV():Void
	{
		__updateLayout();

		if (textHeight <= height - 4)
		{
			scrollV = 1;
			return;
		}

		var lineIndex = getLineIndexOfChar(__caretIndex);

		if (lineIndex == -1 && __caretIndex > 0)
		{
			// new paragraph
			lineIndex = getLineIndexOfChar(__caretIndex - 1) + 1;
		}

		if (lineIndex + 1 < scrollV)
		{
			scrollV = lineIndex + 1;
		}
		else if (lineIndex + 1 > bottomScrollV)
		{
			var i = lineIndex, tempHeight = 0.0;

			while (i >= 0)
			{
				if (tempHeight + __textEngine.lineHeights[i] <= height - 4)
				{
					tempHeight += __textEngine.lineHeights[i];
					i--;
				}
				else
					break;
			}

			scrollV = i + 2;
		}
		else
		{
			// TODO: can this be avoided? this doesn't need to hit the setter each time, just a couple times
			scrollV = scrollV;
		}
	}

	@:noCompletion private function __updateMouseDrag():Void
	{
		if (mouseX > this.width - 1)
		{
			scrollH += Std.int(Math.max(Math.min((mouseX - this.width) * .1, 10), 1));
		}
		else if (mouseX < 1)
		{
			scrollH -= Std.int(Math.max(Math.min(mouseX * -.1, 10), 1));
		}

		__mouseScrollVCounter++;

		if (__mouseScrollVCounter > stage.frameRate / 10)
		{
			if (mouseY > this.height - 2)
			{
				scrollV += Std.int(Math.max(Math.min((mouseY - this.height) * .03, 5), 1));
			}
			else if (mouseY < 2)
			{
				scrollV -= Std.int(Math.max(Math.min(mouseY * -.03, 5), 1));
			}
			__mouseScrollVCounter = 0;
		}
		stage_onMouseMove(null);
	}

	@:noCompletion private function __updateText(value:String):Void
	{
		#if (js && html5)
		if (DisplayObject.__supportDOM && __renderedOnCanvasWhileOnDOM)
		{
			__forceCachedBitmapUpdate = __text != value;
		}
		#end

		// applies maxChars and restrict on text

		__textEngine.text = value;
		__text = __textEngine.text;

		if (__text.length < __caretIndex)
		{
			__selectionIndex = __caretIndex = __text.length;
		}

		if (!__displayAsPassword #if (js && html5) || (DisplayObject.__supportDOM && !__renderedOnCanvasWhileOnDOM) #end)
		{
			__textEngine.text = __text;
		}
		else
		{
			var length = text.length;
			var mask = "";

			for (i in 0...length)
			{
				mask += "*";
			}

			__textEngine.text = mask;
		}
	}

	@:noCompletion private override function __updateTransforms(overrideTransform:Matrix = null):Void
	{
		super.__updateTransforms(overrideTransform);
		__renderTransform.__translateTransformed(__offsetX, __offsetY);
	}

	// Getters & Setters
	@:noCompletion private function get_antiAliasType():AntiAliasType
	{
		return __textEngine.antiAliasType;
	}

	@:noCompletion private function set_antiAliasType(value:AntiAliasType):AntiAliasType
	{
		if (value != __textEngine.antiAliasType)
		{
			// __dirty = true;
		}

		return __textEngine.antiAliasType = value;
	}

	@:noCompletion private function get_autoSize():TextFieldAutoSize
	{
		return __textEngine.autoSize;
	}

	@:noCompletion private function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize
	{
		if (value != __textEngine.autoSize)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		return __textEngine.autoSize = value;
	}

	@:noCompletion private function get_background():Bool
	{
		return __textEngine.background;
	}

	@:noCompletion private function set_background(value:Bool):Bool
	{
		if (value != __textEngine.background)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.background = value;
	}

	@:noCompletion private function get_backgroundColor():Int
	{
		return __textEngine.backgroundColor;
	}

	@:noCompletion private function set_backgroundColor(value:Int):Int
	{
		if (value != __textEngine.backgroundColor)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.backgroundColor = value;
	}

	@:noCompletion private function get_border():Bool
	{
		return __textEngine.border;
	}

	@:noCompletion private function set_border(value:Bool):Bool
	{
		if (value != __textEngine.border)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.border = value;
	}

	@:noCompletion private function get_borderColor():Int
	{
		return __textEngine.borderColor;
	}

	@:noCompletion private function set_borderColor(value:Int):Int
	{
		if (value != __textEngine.borderColor)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.borderColor = value;
	}

	@:noCompletion private function get_bottomScrollV():Int
	{
		__updateLayout();

		return __textEngine.bottomScrollV;
	}

	@:noCompletion private function get_caretIndex():Int
	{
		return __caretIndex;
	}

	@:noCompletion private function get_defaultTextFormat():TextFormat
	{
		return __textFormat.clone();
	}

	@:noCompletion private function set_defaultTextFormat(value:TextFormat):TextFormat
	{
		__textFormat.__merge(value);

		__layoutDirty = true;
		__dirty = true;
		__setRenderDirty();

		return value;
	}

	@:noCompletion private function get_displayAsPassword():Bool
	{
		return __displayAsPassword;
	}

	@:noCompletion private function set_displayAsPassword(value:Bool):Bool
	{
		if (value != __displayAsPassword)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();

			__displayAsPassword = value;
			__updateText(__text);
		}

		return value;
	}

	@:noCompletion private function get_embedFonts():Bool
	{
		return __textEngine.embedFonts;
	}

	@:noCompletion private function set_embedFonts(value:Bool):Bool
	{
		// if (value != __textEngine.embedFonts) {
		//
		// __dirty = true;
		// __layoutDirty = true;
		//
		// }

		return __textEngine.embedFonts = value;
	}

	@:noCompletion private function get_gridFitType():GridFitType
	{
		return __textEngine.gridFitType;
	}

	@:noCompletion private function set_gridFitType(value:GridFitType):GridFitType
	{
		// if (value != __textEngine.gridFitType) {
		//
		// __dirty = true;
		// __layoutDirty = true;
		//
		// }

		return __textEngine.gridFitType = value;
	}

	@:noCompletion private override function get_height():Float
	{
		__updateLayout();
		return __textEngine.height * Math.abs(scaleY);
	}

	@:noCompletion private override function set_height(value:Float):Float
	{
		if (value != __textEngine.height)
		{
			__setTransformDirty();
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();

			__textEngine.height = value;
		}

		return __textEngine.height * Math.abs(scaleY);
	}

	@:noCompletion private function get_htmlText():String
	{
		#if (js && html5)
		return __isHTML ? __rawHtmlText : __text;
		#else
		return __text;
		#end
	}

	@:noCompletion private function set_htmlText(value:String):String
	{
		if (!__isHTML || __text != value)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		__isHTML = true;

		#if (js && html5)
		__rawHtmlText = value;
		#end

		value = HTMLParser.parse(value, __textFormat, __textEngine.textFormatRanges);

		#if (js && html5)
		if (DisplayObject.__supportDOM)
		{
			if (__textEngine.textFormatRanges.length > 1)
			{
				__textEngine.textFormatRanges.splice(1, __textEngine.textFormatRanges.length - 1);
			}

			var range = __textEngine.textFormatRanges[0];
			range.format = __textFormat;
			range.start = 0;

			if (__renderedOnCanvasWhileOnDOM)
			{
				range.end = value.length;
				__updateText(value);
			}
			else
			{
				range.end = __rawHtmlText.length;
				__updateText(__rawHtmlText);
			}
		}
		else
		{
			__updateText(value);
		}
		#else
		__updateText(value);
		#end
		__selectionIndex = __caretIndex = length;

		return value;
	}

	@:noCompletion private function get_length():Int
	{
		if (__text != null)
		{
			return __text.length;
		}

		return 0;
	}

	@:noCompletion private function get_maxChars():Int
	{
		return __textEngine.maxChars;
	}

	@:noCompletion private function set_maxChars(value:Int):Int
	{
		if (value != __textEngine.maxChars)
		{
			__textEngine.maxChars = value;

			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_maxScrollH():Int
	{
		__updateLayout();

		return __textEngine.maxScrollH;
	}

	@:noCompletion private function get_maxScrollV():Int
	{
		__updateLayout();

		return __textEngine.maxScrollV;
	}

	@:noCompletion private function get_mouseWheelEnabled():Bool
	{
		return __mouseWheelEnabled;
	}

	@:noCompletion private function set_mouseWheelEnabled(value:Bool):Bool
	{
		return __mouseWheelEnabled = value;
	}

	@:noCompletion private function get_multiline():Bool
	{
		return __textEngine.multiline;
	}

	@:noCompletion private function set_multiline(value:Bool):Bool
	{
		if (value != __textEngine.multiline)
		{
			__dirty = true;
			__layoutDirty = true;
			__updateText(__text);
			// __updateScrollV();
			__updateScrollH();
			__setRenderDirty();
		}

		return __textEngine.multiline = value;
	}

	@:noCompletion private function get_numLines():Int
	{
		__updateLayout();

		return __textEngine.numLines;
	}

	@:noCompletion private function get_restrict():String
	{
		return __textEngine.restrict;
	}

	@:noCompletion private function set_restrict(value:String):String
	{
		if (__textEngine.restrict != value)
		{
			__textEngine.restrict = value;
			__updateText(__text);
		}

		return value;
	}

	@:noCompletion private function get_scrollH():Int
	{
		return __textEngine.scrollH;
	}

	@:noCompletion private function set_scrollH(value:Int):Int
	{
		__updateLayout();

		if (value > __textEngine.maxScrollH) value = __textEngine.maxScrollH;
		if (value < 0) value = 0;

		if (value != __textEngine.scrollH)
		{
			__dirty = true;
			__setRenderDirty();
			__textEngine.scrollH = value;
			dispatchEvent(new Event(Event.SCROLL));
		}

		return __textEngine.scrollH;
	}

	@:noCompletion private function get_scrollV():Int
	{
		return __textEngine.scrollV;
	}

	@:noCompletion private function set_scrollV(value:Int):Int
	{
		__updateLayout();

		if (value > 0 && value != __textEngine.scrollV)
		{
			__dirty = true;
			__setRenderDirty();
			__textEngine.scrollV = value;
			dispatchEvent(new Event(Event.SCROLL));
		}

		return __textEngine.scrollV;
	}

	@:noCompletion private function get_selectable():Bool
	{
		return __textEngine.selectable;
	}

	@:noCompletion private function set_selectable(value:Bool):Bool
	{
		if (value != __textEngine.selectable && type == INPUT)
		{
			if (stage != null && stage.focus == this)
			{
				__startTextInput();
			}
			else if (!value)
			{
				__stopTextInput();
			}
		}

		return __textEngine.selectable = value;
	}

	@:noCompletion private function get_selectionBeginIndex():Int
	{
		return Std.int(Math.min(__caretIndex, __selectionIndex));
	}

	@:noCompletion private function get_selectionEndIndex():Int
	{
		return Std.int(Math.max(__caretIndex, __selectionIndex));
	}

	@:noCompletion private function get_sharpness():Float
	{
		return __textEngine.sharpness;
	}

	@:noCompletion private function set_sharpness(value:Float):Float
	{
		if (value != __textEngine.sharpness)
		{
			__dirty = true;
			__setRenderDirty();
		}

		return __textEngine.sharpness = value;
	}

	@:noCompletion private override function get_tabEnabled():Bool
	{
		return (__tabEnabled == null ? __textEngine.type == INPUT : __tabEnabled);
	}

	@:noCompletion private function get_text():String
	{
		return __text;
	}

	@:noCompletion private function set_text(value:String):String
	{
		if (__isHTML || __text != value)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}
		else
		{
			return value;
		}

		if (__textEngine.textFormatRanges.length > 1)
		{
			__textEngine.textFormatRanges.splice(1, __textEngine.textFormatRanges.length - 1);
		}

		var utfValue:UTF8String = value;
		var range = __textEngine.textFormatRanges[0];
		range.format = __textFormat;
		range.start = 0;
		range.end = utfValue.length;

		__isHTML = false;

		__updateText(value);
		__selectionIndex = __caretIndex = 0;

		return value;
	}

	@:noCompletion private function get_textColor():Int
	{
		return __textFormat.color;
	}

	@:noCompletion private function set_textColor(value:Int):Int
	{
		if (value != __textFormat.color)
		{
			__dirty = true;
			__setRenderDirty();
		}

		for (range in __textEngine.textFormatRanges)
		{
			range.format.color = value;
		}

		return __textFormat.color = value;
	}

	@:noCompletion private function get_textWidth():Float
	{
		__updateLayout();
		return __textEngine.textWidth;
	}

	@:noCompletion private function get_textHeight():Float
	{
		__updateLayout();
		return __textEngine.textHeight;
	}

	@:noCompletion private function get_type():TextFieldType
	{
		return __textEngine.type;
	}

	@:noCompletion private function set_type(value:TextFieldType):TextFieldType
	{
		if (value != __textEngine.type)
		{
			if (value == TextFieldType.INPUT)
			{
				addEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);

				this_onFocusIn(null);
				__textEngine.__useIntAdvances = true;
			}
			else
			{
				removeEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);

				__stopTextInput();
				__textEngine.__useIntAdvances = null;
			}

			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		return __textEngine.type = value;
	}

	override private function get_width():Float
	{
		__updateLayout();
		return __textEngine.width * Math.abs(__scaleX);
	}

	override private function set_width(value:Float):Float
	{
		if (value != __textEngine.width)
		{
			__setTransformDirty();
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();

			__textEngine.width = value;
		}

		return __textEngine.width * Math.abs(__scaleX);
	}

	@:noCompletion private function get_wordWrap():Bool
	{
		return __textEngine.wordWrap;
	}

	@:noCompletion private function set_wordWrap(value:Bool):Bool
	{
		if (value != __textEngine.wordWrap)
		{
			__dirty = true;
			__layoutDirty = true;
			__setRenderDirty();
		}

		return __textEngine.wordWrap = value;
	}

	@:noCompletion private override function get_x():Float
	{
		return __transform.tx + __offsetX;
	}

	@:noCompletion private override function set_x(value:Float):Float
	{
		if (value != __transform.tx + __offsetX) __setTransformDirty();
		return __transform.tx = value - __offsetX;
	}

	@:noCompletion private override function get_y():Float
	{
		return __transform.ty + __offsetY;
	}

	@:noCompletion private override function set_y(value:Float):Float
	{
		if (value != __transform.ty + __offsetY) __setTransformDirty();
		return __transform.ty = value - __offsetY;
	}

	// Event Handlers
	@:noCompletion private function stage_onMouseMove(event:MouseEvent):Void
	{
		if (stage == null) return;

		if (selectable && __selectionIndex >= 0)
		{
			__updateLayout();

			var position = __getPosition(mouseX + scrollH, mouseY);

			if (position != __caretIndex)
			{
				__caretIndex = position;

				var setDirty = true;

				#if (js && html5)
				if (DisplayObject.__supportDOM)
				{
					if (__renderedOnCanvasWhileOnDOM)
					{
						__forceCachedBitmapUpdate = true;
					}
					setDirty = false;
				}
				#end

				if (setDirty)
				{
					__dirty = true;
					__setRenderDirty();
				}
			}
		}
	}

	@:noCompletion private function stage_onMouseUp(event:MouseEvent):Void
	{
		if (stage == null) return;

		stage.removeEventListener(Event.ENTER_FRAME, this_onEnterFrame);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);

		if (stage.focus == this)
		{
			__getWorldTransform();
			__updateLayout();

			var upPos:Int = __getPosition(mouseX + scrollH, mouseY);
			var leftPos:Int;
			var rightPos:Int;

			leftPos = Std.int(Math.min(__selectionIndex, upPos));
			rightPos = Std.int(Math.max(__selectionIndex, upPos));

			__selectionIndex = leftPos;
			__caretIndex = rightPos;

			if (__inputEnabled)
			{
				this_onFocusIn(null);

				__stopCursorTimer();
				__startCursorTimer();

				#if (js && html5)
				if (DisplayObject.__supportDOM && __renderedOnCanvasWhileOnDOM)
				{
					__forceCachedBitmapUpdate = true;
				}
				#end
			}
		}
	}

	@:noCompletion private function this_onAddedToStage(event:Event):Void
	{
		this_onFocusIn(null);
	}

	@:noCompletion private function this_onEnterFrame(e:Event):Void
	{
		__updateMouseDrag();
		// can we use the render loop instead?
	}

	@:noCompletion private function this_onFocusIn(event:FocusEvent):Void
	{
		if (type == INPUT && stage != null && stage.focus == this)
		{
			__startTextInput();
		}
	}

	@:noCompletion private function this_onFocusOut(event:FocusEvent):Void
	{
		__stopCursorTimer();

		// TODO: Better system

		if (event.relatedObject == null || !(event.relatedObject is TextField))
		{
			__stopTextInput();
		}
		else
		{
			if (stage != null)
			{
				#if lime
				stage.window.onTextInput.remove(window_onTextInput);
				stage.window.onKeyDown.remove(window_onKeyDown);
				#end
			}

			__inputEnabled = false;
		}

		if (__selectionIndex != __caretIndex)
		{
			__selectionIndex = __caretIndex;
			__dirty = true;
			__setRenderDirty();
		}
	}

	@:noCompletion private function this_onKeyDown(event:KeyboardEvent):Void
	{
		#if (lime && !openfl_doc_gen)
		if (selectable && type != INPUT && event.keyCode == Keyboard.C && (event.commandKey || event.ctrlKey))
		{
			if (__caretIndex != __selectionIndex)
			{
				Clipboard.text = __text.substring(__caretIndex, __selectionIndex);
			}
		}
		#end
	}

	@:noCompletion private function this_onMouseDown(event:MouseEvent):Void
	{
		if (!selectable && type != INPUT) return;

		__updateLayout();

		__caretIndex = __getPosition(mouseX + scrollH, mouseY);
		__selectionIndex = __caretIndex;

		if (!DisplayObject.__supportDOM)
		{
			__dirty = true;
			__setRenderDirty();
		}
		#if !notextselectscroll
		// Todo: Add flag and implementation for flash scrolling behavior.
		stage.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
		#end
		stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
	}

	@:noCompletion private function this_onMouseWheel(event:MouseEvent):Void
	{
		if (mouseWheelEnabled)
		{
			scrollV -= event.delta;
		}
	}

	@:noCompletion private function this_onDoubleClick(event:MouseEvent):Void
	{
		if (selectable)
		{
			__updateLayout();

			var delimiters:Array<String> = ['\n', '.', '!', '?', ',', ' ', ';', ':', '(', ')', '-', '_', '/'];

			var txtStr:String = __text;
			var leftPos:Int = -1;
			var rightPos:Int = txtStr.length;
			var pos:Int = 0;
			var startPos:Int = Std.int(Math.max(__caretIndex, 1));
			if (txtStr.length > 0 && __caretIndex >= 0 && rightPos >= __caretIndex)
			{
				for (c in delimiters)
				{
					pos = txtStr.lastIndexOf(c, startPos - 1);
					if (pos > leftPos) leftPos = pos + 1;

					pos = txtStr.indexOf(c, startPos);
					if (pos < rightPos && pos != -1) rightPos = pos;
				}

				if (leftPos != rightPos)
				{
					setSelection(leftPos, rightPos);

					var setDirty:Bool = true;
					#if openfl_html5
					if (DisplayObject.__supportDOM)
					{
						if (__renderedOnCanvasWhileOnDOM)
						{
							__forceCachedBitmapUpdate = true;
						}
						setDirty = false;
					}
					#end
					if (setDirty)
					{
						__dirty = true;
						__setRenderDirty();
					}
				}
			}
		}
	}

	#if lime
	@:noCompletion private function window_onKeyDown(key:KeyCode, modifier:KeyModifier):Void
	{
		switch (key)
		{
			case RETURN, NUMPAD_ENTER:
				if (__textEngine.multiline)
				{
					var te = new TextEvent(TextEvent.TEXT_INPUT, true, true, "\n");

					dispatchEvent(te);

					if (!te.isDefaultPrevented())
					{
						__replaceSelectedText("\n", true);

						dispatchEvent(new Event(Event.CHANGE, true));
					}
				}
				else
				{
					__stopCursorTimer();
					__startCursorTimer();
				}

			case BACKSPACE:
				if (__selectionIndex == __caretIndex && __caretIndex > 0)
				{
					__selectionIndex = __caretIndex - 1;
				}

				if (__selectionIndex != __caretIndex)
				{
					replaceSelectedText("");
					__selectionIndex = __caretIndex;

					dispatchEvent(new Event(Event.CHANGE, true));
				}
				else
				{
					__stopCursorTimer();
					__startCursorTimer();
				}

			case DELETE:
				if (__selectionIndex == __caretIndex && __caretIndex < __text.length)
				{
					__selectionIndex = __caretIndex + 1;
				}

				if (__selectionIndex != __caretIndex)
				{
					replaceSelectedText("");
					__selectionIndex = __caretIndex;

					dispatchEvent(new Event(Event.CHANGE, true));
				}
				else
				{
					__stopCursorTimer();
					__startCursorTimer();
				}

			case LEFT if (selectable):
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					__caretBeginningOfPreviousLine();
				}
				else
				{
					__caretPreviousCharacter();
				}

				if (!modifier.shiftKey)
				{
					__selectionIndex = __caretIndex;
				}

				setSelection(__selectionIndex, __caretIndex);

			case RIGHT if (selectable):
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					__caretBeginningOfNextLine();
				}
				else
				{
					__caretNextCharacter();
				}

				if (!modifier.shiftKey)
				{
					__selectionIndex = __caretIndex;
				}

				setSelection(__selectionIndex, __caretIndex);

			case DOWN if (selectable):
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					__caretIndex = __text.length;
				}
				else
				{
					__caretNextLine();
				}

				if (!modifier.shiftKey)
				{
					__selectionIndex = __caretIndex;
				}

				setSelection(__selectionIndex, __caretIndex);

			case UP if (selectable):
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					__caretIndex = 0;
				}
				else
				{
					__caretPreviousLine();
				}

				if (!modifier.shiftKey)
				{
					__selectionIndex = __caretIndex;
				}

				setSelection(__selectionIndex, __caretIndex);

			case HOME if (selectable):
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					__caretIndex = 0;
				}
				else
				{
					__caretBeginningOfLine();
				}

				if (!modifier.shiftKey)
				{
					__selectionIndex = __caretIndex;
				}

				setSelection(__selectionIndex, __caretIndex);

			case END if (selectable):
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					__caretIndex = __text.length;
				}
				else
				{
					__caretEndOfLine();
				}

				if (!modifier.shiftKey)
				{
					__selectionIndex = __caretIndex;
				}

				setSelection(__selectionIndex, __caretIndex);

			case C:
				#if lime
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					if (__caretIndex != __selectionIndex)
					{
						Clipboard.text = __text.substring(__caretIndex, __selectionIndex);
					}
				}
				#end

			case X:
				#if lime
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					if (__caretIndex != __selectionIndex)
					{
						Clipboard.text = __text.substring(__caretIndex, __selectionIndex);

						replaceSelectedText("");
						dispatchEvent(new Event(Event.CHANGE, true));
					}
				}
				#end

			#if !js
			case V:
				#if lime
				if (#if mac modifier.metaKey #else modifier.ctrlKey #end)
				{
					if (Clipboard.text != null)
					{
						var te = new TextEvent(TextEvent.TEXT_INPUT, true, true, Clipboard.text);

						dispatchEvent(te);

						if (!te.isDefaultPrevented())
						{
							__replaceSelectedText(Clipboard.text, true);

							dispatchEvent(new Event(Event.CHANGE, true));
						}
					}
				}
				else
				{
					// TODO: does this need to occur?
					__textEngine.textFormatRanges[__textEngine.textFormatRanges.length - 1].end = __text.length;
				}
				#end
			#end

			case A if (selectable):
				if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
				{
					setSelection(0, __text.length);
				}

			default:
		}
	}
	#end

	@:noCompletion private function window_onTextInput(value:String):Void
	{
		__replaceSelectedText(value, true);

		// TODO: Dispatch change if at max chars?
		dispatchEvent(new Event(Event.CHANGE, true));
	}
}
#else
typedef TextField = flash.text.TextField;
#end
