import HTMLParser from "../_internal/formats/html/HTMLParser";
import DisplayObjectType from "../_internal/renderer/DisplayObjectType";
import TextEngine from "../_internal/text/TextEngine";
import TextFormatRange from "../_internal/text/TextFormatRange";
import TextLayoutGroup from "../_internal/text/TextLayoutGroup";
import * as internal from "../_internal/utils/InternalAccess";
import Clipboard from "../desktop/Clipboard";
import ClipboardFormats from "../desktop/ClipboardFormats";
import DisplayObject from "../display/DisplayObject";
import Graphics from "../display/Graphics";
import InteractiveObject from "../display/InteractiveObject";
import RangeError from "../errors/RangeError";
import Event from "../events/Event";
import EventPhase from "../events/EventPhase";
import FocusEvent from "../events/FocusEvent";
import KeyboardEvent from "../events/KeyboardEvent";
import MouseEvent from "../events/MouseEvent";
import TextEvent from "../events/TextEvent";
import Matrix from "../geom/Matrix";
import Rectangle from "../geom/Rectangle";
import URLRequest from "../net/URLRequest";
import AntiAliasType from "../text/AntiAliasType";
import GridFitType from "../text/GridFitType";
import TextFieldAutoSize from "../text/TextFieldAutoSize";
import TextFieldType from "../text/TextFieldType";
import TextFormat from "../text/TextFormat";
import TextFormatAlign from "../text/TextFormatAlign";
import TextLineMetrics from "../text/TextLineMetrics";
import Keyboard from "../ui/Keyboard";
import MouseCursor from "../ui/MouseCursor";
import Lib from "../Lib";

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
export default class TextField extends InteractiveObject
{
	protected static __defaultTextFormat: TextFormat;
	protected static __missingFontWarning: Map<string, boolean> = new Map();

	/**
		When set to `true` and the text field is not in focus, Flash Player
		highlights the selection in the text field in gray. When set to
		`false` and the text field is not in focus, Flash Player does not
		highlight the selection in the text field.

		@default false
	**/
	// alwaysShowSelection  : boolean;

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
	// condenseWhite  : boolean;

	// selectedText(default,never) : string;

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
	// styleSheet : StyleSheet;

	/**
		The interaction mode property, Default value is
		TextInteractionMode.NORMAL. On mobile platforms, the normal mode
		implies that the text can be scrolled but not selected. One can switch
		to the selectable mode through the in-built context menu on the text
		field. On Desktop, the normal mode implies that the text is in
		scrollable as well as selection mode.
	**/
	// @:require(flash11) textInteractionMode(default,never) : TextInteractionMode;

	/**
		The thickness of the glyph edges in this text field. This property
		applies only when `openfl.text.AntiAliasType` is set to
		`openfl.text.AntiAliasType.ADVANCED`.
		The range for `thickness` is a number from -200 to 200. If you attempt
		to set `thickness` to a value outside that range, the property is set
		to the nearest value in the range (either -200 or 200).

		@default 0
	**/
	// thickness  : number;

	/**
		Specifies whether to copy and paste the text formatting along with the
		text. When set to `true`, Flash Player copies and pastes formatting
		(such as alignment, bold, and italics) when you copy and paste between
		text fields. Both the origin and destination text fields for the copy
		and paste procedure must have `useRichTextClipboard` set to `true`.
		The default value is `false`.
	**/
	// useRichTextClipboard  : boolean;

	protected __bounds: Rectangle;
	protected __caretIndex: number;
	protected __cursorTimerID: number;
	protected __dirty: boolean;
	protected __displayAsPassword: boolean;
	protected __domRender: boolean;
	protected __inputEnabled: boolean;
	protected __isHTML: boolean;
	protected __layoutDirty: boolean;
	protected __mouseWheelEnabled: boolean;
	protected __offsetX: number;
	protected __offsetY: number;
	protected __selectionIndex: number;
	protected __showCursor: boolean;
	protected __text: string;
	protected __htmlText: string;
	protected __textEngine: TextEngine;
	protected __textFormat: TextFormat;
	protected __div: HTMLDivElement;
	protected __renderedOnCanvasWhileOnDOM: boolean = false;
	protected __rawHtmlText: string;
	protected __forceCachedBitmapUpdate: boolean = false;

	/**
		Creates a new TextField instance. After you create the TextField instance,
		call the `addChild()` or `addChildAt()` method of
		the parent DisplayObjectContainer object to add the TextField instance to
		the display list.

		The default size for a text field is 100 x 100 pixels.
	**/
	public constructor()
	{
		super();

		this.__type = DisplayObjectType.TEXTFIELD;

		this.__caretIndex = -1;
		this.__cursorTimerID = 0;
		this.__displayAsPassword = false;
		this.__graphics = new (<internal.Graphics><any>Graphics)(this);
		this.__textEngine = new TextEngine(this);
		this.__layoutDirty = true;
		this.__offsetX = 0;
		this.__offsetY = 0;
		this.__mouseWheelEnabled = true;
		this.__text = "";

		this.doubleClickEnabled = true;

		if (TextField.__defaultTextFormat == null)
		{
			TextField.__defaultTextFormat = new TextFormat("Times New Roman", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			TextField.__defaultTextFormat.blockIndent = 0;
			TextField.__defaultTextFormat.bullet = false;
			TextField.__defaultTextFormat.letterSpacing = 0;
			TextField.__defaultTextFormat.kerning = false;
		}

		this.__textFormat = TextField.__defaultTextFormat.clone();
		this.__textEngine.textFormatRanges.push(new TextFormatRange(this.__textFormat, 0, 0));

		// __backend = new TextFieldBackend(this);

		this.addEventListener(MouseEvent.MOUSE_DOWN, this.this_onMouseDown);
		this.addEventListener(FocusEvent.FOCUS_IN, this.this_onFocusIn);
		this.addEventListener(FocusEvent.FOCUS_OUT, this.this_onFocusOut);
		this.addEventListener(KeyboardEvent.KEY_DOWN, this.this_onKeyDown);
		this.addEventListener(MouseEvent.MOUSE_WHEEL, this.this_onMouseWheel);

		this.addEventListener(MouseEvent.DOUBLE_CLICK, this.this_onDoubleClick);
	}

	/**
		Appends the string specified by the `newText` parameter to the
		end of the text of the text field. This method is more efficient than an
		addition assignment(`+=`) on a `text` property
		(such as `someTextField.text += moreText`), particularly for a
		text field that contains a significant amount of content.

		@param newText The string to append to the existing text.
	**/
	public appendText(text: string): void
	{
		if (text == null || text == "") return;

		this.__dirty = true;
		this.__layoutDirty = true;
		this.__setRenderDirty();

		this.__updateText(this.__text + text);

		this.__textEngine.textFormatRanges[this.__textEngine.textFormatRanges.length - 1].end = this.__text.length;

		this.__updateScrollV();
		this.__updateScrollH();
	}

	// copyRichText() : string;

	/**
		Returns a rectangle that is the bounding box of the character.

		@param charIndex The zero-based index value for the character (for
						 example, the first position is 0, the second position is
						 1, and so on).
		@return A rectangle with `x` and `y` minimum and
				maximum values defining the bounding box of the character.
	**/
	public getCharBoundaries(charIndex: number): Rectangle
	{
		if (charIndex < 0 || charIndex > this.__text.length - 1) return null;

		var rect = new Rectangle();

		if (this.__getCharBoundaries(charIndex, rect))
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
	public getCharIndexAtPoint(x: number, y: number): number
	{
		if (x <= 2 || x > this.width + 4 || y <= 0 || y > this.height + 4) return -1;

		this.__updateLayout();

		x += this.scrollH;

		for (let i = 0; i < this.scrollV; i++)
		{
			y += this.__textEngine.lineHeights[i];
		}

		for (let group of this.__textEngine.layoutGroups)
		{
			if (y >= group.offsetY && y <= group.offsetY + group.height)
			{
				if (x >= group.offsetX && x <= group.offsetX + group.width)
				{
					var advance = 0.0;

					for (let i = 0; i < group.positions.length; i++)
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
	public getFirstCharInParagraph(charIndex: number): number
	{
		if (charIndex < 0 || charIndex > this.text.length) return -1;

		var index = this.__textEngine.getLineBreakIndex();
		var startIndex = 0;

		while (index > -1)
		{
			if (index < charIndex)
			{
				startIndex = index + 1;
			}
			else if (index >= charIndex)
			{
				break;
			}

			index = this.__textEngine.getLineBreakIndex(index + 1);
		}

		return startIndex;
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
	// getImageReference(id : string) : openfl.display.DisplayObject;

	/**
		Returns the zero-based index value of the line at the point specified by
		the `x` and `y` parameters.

		@param x The _x_ coordinate of the line.
		@param y The _y_ coordinate of the line.
		@return The zero-based index value of the line(for example, the first
				line is 0, the second line is 1, and so on). Returns -1 if the
				point is not over any line.
	**/
	public getLineIndexAtPoint(x: number, y: number): number
	{
		this.__updateLayout();

		if (x <= 2 || x > this.width + 4 || y <= 0 || y > this.height + 4) return -1;

		for (let i = 0; i < this.scrollV - 1; i++)
		{
			y += this.__textEngine.lineHeights[i];
		}

		for (let group of this.__textEngine.layoutGroups)
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
	public getLineIndexOfChar(charIndex: number): number
	{
		if (charIndex < 0 || charIndex > this.__text.length) return -1;

		this.__updateLayout();

		for (let group of this.__textEngine.layoutGroups)
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
	public getLineLength(lineIndex: number): number
	{
		this.__updateLayout();

		if (lineIndex < 0 || lineIndex > this.__textEngine.numLines - 1) return 0;

		var startIndex = -1;
		var endIndex = -1;

		for (let group of this.__textEngine.layoutGroups)
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

		if (endIndex == -1) endIndex = this.__text.length;
		return endIndex - startIndex;
	}

	/**
		Returns metrics information about a given text line.

		@param lineIndex The line number for which you want metrics information.
		@return A TextLineMetrics object.
		@throws RangeError The line number specified is out of range.
	**/
	public getLineMetrics(lineIndex: number): TextLineMetrics
	{
		this.__updateLayout();

		var ascender = this.__textEngine.lineAscents[lineIndex];
		var descender = this.__textEngine.lineDescents[lineIndex];
		var leading = this.__textEngine.lineLeadings[lineIndex];
		var lineHeight = this.__textEngine.lineHeights[lineIndex];
		var lineWidth = this.__textEngine.lineWidths[lineIndex];

		// TODO: Handle START and END based on language (don't assume LTR)

		var margin = 2;

		switch (this.__textFormat.align)
		{
			case TextFormatAlign.RIGHT:
			case TextFormatAlign.END:
				margin = (this.__textEngine.width - lineWidth) - 2;
				break;

			case TextFormatAlign.CENTER:
				margin = (this.__textEngine.width - lineWidth) / 2;
				break;
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
	public getLineOffset(lineIndex: number): number
	{
		this.__updateLayout();

		if (lineIndex < 0 || lineIndex > this.__textEngine.numLines - 1) return -1;

		for (let group of this.__textEngine.layoutGroups)
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
	public getLineText(lineIndex: number): string
	{
		this.__updateLayout();

		if (lineIndex < 0 || lineIndex > this.__textEngine.numLines - 1) return null;

		var startIndex = -1;
		var endIndex = -1;

		for (let group of this.__textEngine.layoutGroups)
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

		if (endIndex == -1) endIndex = this.__text.length;

		return this.__textEngine.text.substring(startIndex, endIndex);
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
	public getParagraphLength(charIndex: number): number
	{
		if (charIndex < 0 || charIndex > this.text.length) return -1;

		var startIndex = this.getFirstCharInParagraph(charIndex);

		if (charIndex >= this.text.length) return this.text.length - startIndex + 1;

		var endIndex = this.__textEngine.getLineBreakIndex(charIndex) + 1;

		if (endIndex == 0) endIndex = this.__text.length;
		return endIndex - startIndex;
	}

	// getRawText() : string;

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
	public getTextFormat(beginIndex: number = -1, endIndex: number = -1): TextFormat
	{
		var format = null;

		if (beginIndex >= this.text.length || beginIndex < -1 || endIndex > this.text.length || endIndex < -1)
			throw new RangeError("The supplied index is out of bounds");

		if (beginIndex == -1) beginIndex = 0;
		if (endIndex == -1) endIndex = this.text.length;

		if (beginIndex >= endIndex) return new TextFormat();

		for (let group of this.__textEngine.textFormatRanges)
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
	// @:require(flash10) static isFontCompatible(fontName : string, fontStyle : string)  : boolean;

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
	public replaceSelectedText(value: string): void
	{
		this.__replaceSelectedText(value, false);
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
	public replaceText(beginIndex: number, endIndex: number, newText: string): void
	{
		this.__replaceText(beginIndex, endIndex, newText, false);
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
	public setSelection(beginIndex: number, endIndex: number): void
	{
		this.__selectionIndex = beginIndex;
		this.__caretIndex = endIndex;

		this.__updateScrollV();

		this.__stopCursorTimer();
		this.__startCursorTimer();
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
	public setTextFormat(format: TextFormat, beginIndex: number = 0, endIndex: number = 0): void
	{
		var max = this.text.length;
		var range;

		if (beginIndex < 0) beginIndex = 0;
		if (endIndex < 0) endIndex = 0;

		if (endIndex == 0)
		{
			if (beginIndex == 0)
			{
				endIndex = max;
			}
			else
			{
				endIndex = beginIndex + 1;
			}
		}

		if (endIndex < beginIndex) return;

		if (beginIndex == 0 && endIndex >= max)
		{
			// set text format for the whole textfield
			(<internal.TextFormat><any>this.__textFormat).__merge(format);

			for (let i = 0; i < this.__textEngine.textFormatRanges.length; i++)
			{
				range = this.__textEngine.textFormatRanges[i];
				range.format.__merge(format);
			}
		}
		else
		{
			var index = 0;
			var newRange;

			while (index < this.__textEngine.textFormatRanges.length)
			{
				range = this.__textEngine.textFormatRanges[index];

				if (range.start == beginIndex && range.end == endIndex)
				{
					// set format range matches an existing range exactly
					range.format.__merge(format);
					break;
				}
				else if (range.start >= beginIndex && range.end <= endIndex)
				{
					// set format range completely encompasses this existing range
					range.format.__merge(format);
				}
				else if (range.start >= beginIndex && range.start < endIndex && range.end > beginIndex)
				{
					// set format range is within the first part of the range
					newRange = new TextFormatRange(range.format.clone(), range.start, endIndex);
					newRange.format.__merge(format);
					this.__textEngine.textFormatRanges.insertAt(index, newRange);
					range.start = endIndex;
					index++;
				}
				else if (range.start < beginIndex && range.end > beginIndex && range.end >= endIndex)
				{
					// set format range is within the second part of the range
					newRange = new TextFormatRange(range.format.clone(), beginIndex, range.end);
					newRange.format.__merge(format);
					this.__textEngine.textFormatRanges.insertAt(index + 1, newRange);
					range.end = beginIndex;
					index++;
				}

				index++;
				// TODO: Remove duplicates?
			}
		}

		this.__dirty = true;
		this.__layoutDirty = true;
		this.__setRenderDirty();
	}

	protected __allowMouseFocus(): boolean
	{
		return this.__textEngine.type == TextFieldType.INPUT || this.tabEnabled || this.selectable;
	}

	protected __caretBeginningOfLine(): void
	{
		if (this.__selectionIndex == this.__caretIndex || this.__caretIndex < this.__selectionIndex)
		{
			this.__caretIndex = this.getLineOffset(this.getLineIndexOfChar(this.__caretIndex));
		}
		else
		{
			this.__selectionIndex = this.getLineOffset(this.getLineIndexOfChar(this.__selectionIndex));
		}
	}

	protected __caretEndOfLine(): void
	{
		var lineIndex;

		if (this.__selectionIndex == this.__caretIndex)
		{
			lineIndex = this.getLineIndexOfChar(this.__caretIndex);
		}
		else
		{
			lineIndex = this.getLineIndexOfChar(Math.max(this.__caretIndex, this.__selectionIndex));
		}

		if (lineIndex < this.__textEngine.numLines - 1)
		{
			this.__caretIndex = this.getLineOffset(lineIndex + 1) - 1;
		}
		else
		{
			this.__caretIndex = this.__text.length;
		}
	}

	protected __caretNextCharacter(): void
	{
		if (this.__caretIndex < this.__text.length)
		{
			this.__caretIndex++;
		}
	}

	protected __caretNextLine(lineIndex: null | number = null, caretIndex: null | number = null): void
	{
		if (lineIndex == null)
		{
			lineIndex = this.getLineIndexOfChar(this.__caretIndex);
		}

		if (lineIndex < this.__textEngine.numLines - 1)
		{
			if (caretIndex == null)
			{
				caretIndex = this.__caretIndex;
			}

			this.__caretIndex = this.__getCharIndexOnDifferentLine(caretIndex, lineIndex + 1);
		}
		else
		{
			this.__caretIndex = this.__text.length;
		}
	}

	protected __caretPreviousCharacter(): void
	{
		if (this.__caretIndex > 0)
		{
			this.__caretIndex--;
		}
	}

	protected __caretPreviousLine(lineIndex: null | number = null, caretIndex: null | number = null): void
	{
		if (lineIndex == null)
		{
			lineIndex = this.getLineIndexOfChar(this.__caretIndex);
		}

		if (lineIndex > 0)
		{
			if (caretIndex == null)
			{
				caretIndex = this.__caretIndex;
			}

			this.__caretIndex = this.__getCharIndexOnDifferentLine(caretIndex, lineIndex - 1);
		}
		else
		{
			this.__caretIndex = 0;
		}
	}

	protected __disableInput(): void
	{
		if (this.__inputEnabled && this.stage != null)
		{
			// this.__backend.disableInput();

			this.__inputEnabled = false;
			this.__stopCursorTimer();
		}
	}

	protected __dispatch(event: Event): boolean
	{
		if (event.eventPhase == EventPhase.AT_TARGET && event.type == MouseEvent.MOUSE_UP)
		{
			var group = this.__getGroup(this.mouseX, this.mouseY, true);

			if (group != null)
			{
				var url = group.format.url;

				if (url != null && url != "")
				{
					if (url.startsWith("event:"))
					{
						this.dispatchEvent(new TextEvent(TextEvent.LINK, false, false, url.substr(6)));
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

	protected __enableInput(): void
	{
		if (this.stage != null)
		{
			// this.__backend.enableInput();

			if (!this.__inputEnabled)
			{
				this.__inputEnabled = true;
				this.__startCursorTimer();
			}
		}
	}

	protected __getAdvance(position): number
	{
		return position;
	}

	protected __getBounds(rect: Rectangle, matrix: Matrix): void
	{
		this.__updateLayout();

		var bounds = (<internal.Rectangle><any>Rectangle).__pool.get();
		bounds.copyFrom(this.__textEngine.bounds);

		matrix.tx += this.__offsetX;
		matrix.ty += this.__offsetY;

		(<internal.Rectangle><any>bounds).__transform(bounds, matrix);

		(<internal.Rectangle><any>rect).__expand(bounds.x, bounds.y, bounds.width, bounds.height);

		(<internal.Rectangle><any>Rectangle).__pool.release(bounds);
	}

	protected __getCharBoundaries(charIndex: number, rect: Rectangle): boolean
	{
		if (charIndex < 0 || charIndex > this.__text.length - 1) return false;

		this.__updateLayout();

		for (let group of this.__textEngine.layoutGroups)
		{
			if (charIndex >= group.startIndex && charIndex < group.endIndex)
			{
				try
				{
					var x = group.offsetX;

					for (let i = 0; i < (charIndex - group.startIndex); i++)
					{
						x += group.getAdvance(i);
					}

					// TODO: Is this actually right for combining characters?
					var lastPosition = group.getAdvance(charIndex - group.startIndex);

					rect.setTo(x, group.offsetY, lastPosition, group.ascent + group.descent);
					return true;
				}
				catch (e) { }
			}
		}

		return false;
	}

	protected __getCharIndexOnDifferentLine(charIndex: number, lineIndex: number): number
	{
		if (charIndex < 0 || charIndex > this.__text.length) return -1;
		if (lineIndex < 0 || lineIndex > this.__textEngine.numLines - 1) return -1;

		var x: null | number = null, y: null | number = null;

		for (let group of this.__textEngine.layoutGroups)
		{
			if (charIndex >= group.startIndex && charIndex <= group.endIndex)
			{
				x = group.offsetX;

				for (let i = 0; i < (charIndex - group.startIndex); i++)
				{
					x += group.getAdvance(i);
				}

				if (y != null) return this.__getPosition(x, y);
			}

			if (group.lineIndex == lineIndex)
			{
				y = group.offsetY + group.height / 2;

				for (let i = 0; i < this.scrollV - 1; i++)
				{
					y -= this.__textEngine.lineHeights[i];
				}

				if (x != null) return this.__getPosition(x, y);
			}
		}

		return -1;
	}

	protected __getCursor(): MouseCursor
	{
		var group = this.__getGroup(this.mouseX, this.mouseY, true);

		if (group != null && group.format.url != "")
		{
			return MouseCursor.BUTTON;
		}
		else if (this.__textEngine.selectable)
		{
			return MouseCursor.IBEAM;
		}

		return null;
	}

	protected __getGroup(x: number, y: number, precise = false): TextLayoutGroup
	{
		this.__updateLayout();

		x += this.scrollH;

		for (let i = 0; i < this.scrollV - 1; i++)
		{
			y += this.__textEngine.lineHeights[i];
		}

		if (!precise && y > this.__textEngine.textHeight) y = this.__textEngine.textHeight;

		var firstGroup = true;
		var group, nextGroup;

		for (let i = 0; i < this.__textEngine.layoutGroups.length; i++)
		{
			group = this.__textEngine.layoutGroups[i];

			if (i < this.__textEngine.layoutGroups.length - 1)
			{
				nextGroup = this.__textEngine.layoutGroups[i + 1];
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

	protected __getPosition(x: number, y: number): number
	{
		var group = this.__getGroup(x, y);

		if (group == null)
		{
			return this.__text.length;
		}

		var advance = 0.0;

		for (let i = 0; i < group.positions.length; i++)
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

	protected __getRenderBounds(rect: Rectangle, matrix: Matrix): void
	{
		if (this.__scrollRect == null)
		{
			this.__updateLayout();

			var bounds = (<internal.Rectangle><any>Rectangle).__pool.get();
			bounds.copyFrom(this.__textEngine.bounds);

			// matrix.tx += this.__offsetX;
			// matrix.ty += this.__offsetY;

			(<internal.Rectangle><any>bounds).__transform(bounds, matrix);

			(<internal.Rectangle><any>rect).__expand(bounds.x, bounds.y, bounds.width, bounds.height);

			(<internal.Rectangle><any>Rectangle).__pool.release(bounds);
		}
		else
		{
			super.__getRenderBounds(rect, matrix);
		}
	}

	protected __hitTest(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean,
		hitObject: DisplayObject): boolean
	{
		if (!hitObject.visible || this.__isMask || (interactiveOnly && !this.mouseEnabled)) return false;
		if (this.mask != null && !(<internal.DisplayObject><any>this.mask).__hitTestMask(x, y)) return false;

		this.__getRenderTransform();
		this.__updateLayout();

		var px = (<internal.Matrix><any>this.__renderTransform).__transformInverseX(x, y);
		var py = (<internal.Matrix><any>this.__renderTransform).__transformInverseY(x, y);

		if (this.__textEngine.bounds.contains(px, py))
		{
			if (stack != null)
			{
				stack.push(hitObject);
			}

			return true;
		}

		return false;
	}

	protected __hitTestMask(x: number, y: number): boolean
	{
		this.__getRenderTransform();
		this.__updateLayout();

		var px = (<internal.Matrix><any>this.__renderTransform).__transformInverseX(x, y);
		var py = (<internal.Matrix><any>this.__renderTransform).__transformInverseY(x, y);

		if (this.__textEngine.bounds.contains(px, py))
		{
			return true;
		}

		return false;
	}

	protected __replaceSelectedText(value: string, restrict: boolean = true): void
	{
		if (value == null) value = "";
		if (value == "" && this.__selectionIndex == this.__caretIndex) return;

		var startIndex = this.__caretIndex < this.__selectionIndex ? this.__caretIndex : this.__selectionIndex;
		var endIndex = this.__caretIndex > this.__selectionIndex ? this.__caretIndex : this.__selectionIndex;

		if (startIndex == endIndex && this.__textEngine.maxChars > 0 && this.__text.length == this.__textEngine.maxChars) return;

		if (startIndex > this.__text.length) startIndex = this.__text.length;
		if (endIndex > this.__text.length) endIndex = this.__text.length;
		if (endIndex < startIndex)
		{
			var cache = endIndex;
			endIndex = startIndex;
			startIndex = cache;
		}
		if (startIndex < 0) startIndex = 0;

		this.__replaceText(startIndex, endIndex, value, restrict);

		var i = startIndex + value.length;
		if (i > this.__text.length) i = this.__text.length;

		this.setSelection(i, i);

		// TODO: Solution where this is not run twice (run inside replaceText above)
		this.__updateScrollH();
	}

	protected __replaceText(beginIndex: number, endIndex: number, newText: string, restrict: boolean): void
	{
		if (endIndex < beginIndex || beginIndex < 0 || endIndex > this.__text.length || newText == null) return;

		if (restrict)
		{
			newText = this.__textEngine.restrictText(newText);

			if (this.__textEngine.maxChars > 0)
			{
				var removeLength = (endIndex - beginIndex);
				var maxLength = this.__textEngine.maxChars - this.__text.length + removeLength;

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

		this.__updateText(this.__text.substring(0, beginIndex) + newText + this.__text.substring(endIndex));
		if (endIndex > this.__text.length) endIndex = this.__text.length;

		var offset = newText.length - (endIndex - beginIndex);

		var i = 0;
		var range;

		while (i < this.__textEngine.textFormatRanges.length)
		{
			range = this.__textEngine.textFormatRanges[i];

			if (beginIndex == endIndex)
			{
				if (range.end < beginIndex)
				{
					// do nothing, range is completely before insertion point
				}
				else if (range.start > endIndex)
				{
					// shift range, range is after insertion point
					range.start += offset;
					range.end += offset;
				}
				else
				{
					if (range.start < range.end && range.end == beginIndex && i < this.__textEngine.textFormatRanges.length - 1)
					{
						// do nothing, insertion point is between two ranges, so it belongs to the next range
						// unless there are no more ranges after this one (inserting at the end of the text)
					}
					else
					{
						// add to range, insertion point is within range
						range.end += offset;
					}
				}
			}
			else
			{
				if (range.end < beginIndex)
				{
					// do nothing, range is before selection
				}
				else if (range.start >= endIndex)
				{
					// shift range, range is completely after selection
					range.start += offset;
					range.end += offset;
				}
				else if (range.start >= beginIndex && range.end <= endIndex)
				{
					// delete range, range is encompassed by selection
					if (this.__textEngine.textFormatRanges.length > 1)
					{
						this.__textEngine.textFormatRanges.splice(i, 1);
					}
					else
					{
						// don't delete if it's the last range though, just modify properties
						range.start = 0;
						range.end = newText.length;
					}
				}
				else if (range.start <= beginIndex)
				{
					if (range.end < endIndex)
					{
						// modify range, range ends before the selection ends
						range.end = beginIndex;
					}
					else
					{
						// modify range, range ends where or after the selection ends
						range.end += offset;
					}
				}
				else
				{
					// modify range, selection begins before the range
					// for deletion: entire range shifts leftward
					// for addition: added text gains the format of endIndex
					range.start = beginIndex;
					range.end += offset;
				}
			}

			i++;
		}

		this.__updateScrollV();
		this.__updateScrollH();

		this.__dirty = true;
		this.__layoutDirty = true;
		this.__setRenderDirty();
	}

	protected __startCursorTimer(): void
	{
		this.__cursorTimerID = window.setTimeout(this.__startCursorTimer, 600);
		this.__showCursor = !this.__showCursor;
		this.__dirty = true;
		this.__setRenderDirty();
	}

	protected __startTextInput(): void
	{
		if (this.__caretIndex < 0)
		{
			this.__caretIndex = this.__text.length;
			this.__selectionIndex = this.__caretIndex;
		}

		var enableInput = ((<internal.DisplayObject><any>DisplayObject).__supportDOM ? this.__renderedOnCanvasWhileOnDOM : true);

		if (enableInput)
		{
			this.__enableInput();
		}
	}

	protected __stopCursorTimer(): void
	{
		if (this.__cursorTimerID != 0)
		{
			window.clearTimeout(this.__cursorTimerID);
			this.__cursorTimerID = 0;
		}

		if (this.__showCursor)
		{
			this.__showCursor = false;
			this.__dirty = true;
			this.__setRenderDirty();
		}
	}

	protected __stopTextInput(): void
	{
		var disableInput = ((<internal.DisplayObject><any>DisplayObject).__supportDOM ? this.__renderedOnCanvasWhileOnDOM : true);

		if (disableInput)
		{
			this.__disableInput();
		}
	}

	protected __update(transformOnly: boolean, updateChildren: boolean): void
	{
		var transformDirty = this.__transformDirty;

		this.__updateSingle(transformOnly, updateChildren);

		if (transformDirty)
		{
			(<internal.Matrix><any>this.__renderTransform).__translateTransformed(this.__offsetX, this.__offsetY);
		}
	}

	protected __updateLayout(): void
	{
		if (this.__layoutDirty)
		{
			var cacheWidth = this.__textEngine.width;
			this.__textEngine.update();

			if (this.__textEngine.autoSize != TextFieldAutoSize.NONE)
			{
				if (this.__textEngine.width != cacheWidth)
				{
					switch (this.__textEngine.autoSize)
					{
						case TextFieldAutoSize.RIGHT:
							this.x += cacheWidth - this.__textEngine.width;
							break;

						case TextFieldAutoSize.CENTER:
							this.x += (cacheWidth - this.__textEngine.width) / 2;
							break;

						default:
					}
				}

				this.__textEngine.getBounds();
			}

			this.__layoutDirty = false;
		}
	}

	protected __updateScrollH(): void
	{
		if (!this.multiline && this.type == TextFieldType.INPUT)
		{
			this.__layoutDirty = true;
			this.__updateLayout();

			var offsetX = this.__textEngine.textWidth - this.__textEngine.width + 4;

			if (offsetX > 0)
			{
				// TODO: Handle __selectionIndex on drag select?
				// TODO: Update scrollH by one character width at a time when able

				if (this.__caretIndex >= this.text.length)
				{
					this.scrollH = Math.ceil(offsetX);
				}
				else
				{
					var caret = (<internal.Rectangle><any>Rectangle).__pool.get();
					this.__getCharBoundaries(this.__caretIndex, caret);

					if (caret.x < this.scrollH)
					{
						this.scrollH = Math.floor(caret.x - 2);
					}
					else if (caret.x > this.scrollH + this.__textEngine.width)
					{
						this.scrollH = Math.ceil(caret.x - this.__textEngine.width - 2);
					}

					(<internal.Rectangle><any>Rectangle).__pool.release(caret);
				}
			}
			else
			{
				this.scrollH = 0;
			}
		}
	}

	protected __updateScrollV(): void
	{
		this.__layoutDirty = true;
		this.__updateLayout();

		var lineIndex = this.getLineIndexOfChar(this.__caretIndex);

		if (lineIndex == -1 && this.__caretIndex > 0)
		{
			// new paragraph
			lineIndex = this.getLineIndexOfChar(this.__caretIndex - 1) + 1;
		}

		if (lineIndex + 1 < this.scrollV)
		{
			this.scrollV = lineIndex + 1;
		}
		else if (lineIndex + 1 > this.bottomScrollV)
		{
			var i = lineIndex, tempHeight = 0.0;

			while (i >= 0)
			{
				if (tempHeight + this.__textEngine.lineHeights[i] <= this.height - 4)
				{
					tempHeight += this.__textEngine.lineHeights[i];
					i--;
				}
				else
					break;
			}

			this.scrollV = i + 2;
		}
		else
		{
			// TODO: can this be avoided? this doesn't need to hit the setter each time, just a couple times
			this.scrollV = this.scrollV;
		}
	}

	protected __updateText(value: string): void
	{
		if ((<internal.DisplayObject><any>DisplayObject).__supportDOM && this.__renderedOnCanvasWhileOnDOM)
		{
			this.__forceCachedBitmapUpdate = this.__text != value;
		}

		// applies maxChars and restrict on text

		this.__textEngine.text = value;
		this.__text = this.__textEngine.text;

		if (this.__text.length < this.__caretIndex)
		{
			this.__selectionIndex = this.__caretIndex = this.__text.length;
		}

		if (!this.__displayAsPassword || (<internal.DisplayObject><any>DisplayObject).__supportDOM && !this.__renderedOnCanvasWhileOnDOM)
		{
			this.__textEngine.text = this.__text;
		}
		else
		{
			var length = this.text.length;
			var mask = "";

			for (let i = 0; i < length; i++)
			{
				mask += "*";
			}

			this.__textEngine.text = mask;
		}
	}

	// Getters & Setters

	/**
		The type of anti-aliasing used for this text field. Use
		`openfl.text.AntiAliasType` constants for this property. You can
		control this setting only if the font is embedded(with the
		`embedFonts` property set to `true`). The default
		setting is `openfl.text.AntiAliasType.NORMAL`.

		To set values for this property, use the following string values:
	**/
	public get antiAliasType(): AntiAliasType
	{
		return this.__textEngine.antiAliasType;
	}

	public set antiAliasType(value: AntiAliasType)
	{
		if (value != this.__textEngine.antiAliasType)
		{
			// __dirty = true;
		}

		this.__textEngine.antiAliasType = value;
	}

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
	public get autoSize(): TextFieldAutoSize
	{
		return this.__textEngine.autoSize;
	}

	public set autoSize(value: TextFieldAutoSize)
	{
		if (value != this.__textEngine.autoSize)
		{
			this.__dirty = true;
			this.__layoutDirty = true;
			this.__setRenderDirty();
		}

		this.__textEngine.autoSize = value;
	}

	/**
		Specifies whether the text field has a background fill. If
		`true`, the text field has a background fill. If
		`false`, the text field has no background fill. Use the
		`backgroundColor` property to set the background color of a
		text field.

		@default false
	**/
	public get background(): boolean
	{
		return this.__textEngine.background;
	}

	public set background(value: boolean)
	{
		if (value != this.__textEngine.background)
		{
			this.__dirty = true;
			this.__setRenderDirty();
		}

		this.__textEngine.background = value;
	}

	/**
		The color of the text field background. The default value is
		`0xFFFFFF`(white). This property can be retrieved or set, even
		if there currently is no background, but the color is visible only if the
		text field has the `background` property set to
		`true`.
	**/
	public get backgroundColor(): number
	{
		return this.__textEngine.backgroundColor;
	}

	public set backgroundColor(value: number)
	{
		if (value != this.__textEngine.backgroundColor)
		{
			this.__dirty = true;
			this.__setRenderDirty();
		}

		this.__textEngine.backgroundColor = value;
	}

	/**
		Specifies whether the text field has a border. If `true`, the
		text field has a border. If `false`, the text field has no
		border. Use the `borderColor` property to set the border color.

		@default false
	**/
	public get border(): boolean
	{
		return this.__textEngine.border;
	}

	public set border(value: boolean)
	{
		if (value != this.__textEngine.border)
		{
			this.__dirty = true;
			this.__setRenderDirty();
		}

		this.__textEngine.border = value;
	}

	/**
		The color of the text field border. The default value is
		`0x000000`(black). This property can be retrieved or set, even
		if there currently is no border, but the color is visible only if the text
		field has the `border` property set to `true`.
	**/
	public get borderColor(): number
	{
		return this.__textEngine.borderColor;
	}

	public set borderColor(value: number)
	{
		if (value != this.__textEngine.borderColor)
		{
			this.__dirty = true;
			this.__setRenderDirty();
		}

		this.__textEngine.borderColor = value;
	}

	/**
		An integer(1-based index) that indicates the bottommost line that is
		currently visible in the specified text field. Think of the text field as
		a window onto a block of text. The `scrollV` property is the
		1-based index of the topmost visible line in the window.

		All the text between the lines indicated by `scrollV` and
		`bottomScrollV` is currently visible in the text field.
	**/
	public get bottomScrollV(): number
	{
		this.__updateLayout();

		return this.__textEngine.bottomScrollV;
	}

	/**
		The index of the insertion point(caret) position. If no insertion point
		is displayed, the value is the position the insertion point would be if
		you restored focus to the field(typically where the insertion point last
		was, or 0 if the field has not had focus).

		Selection span indexes are zero-based(for example, the first position
		is 0, the second position is 1, and so on).
	**/
	public get caretIndex(): number
	{
		return this.__caretIndex;
	}

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
		my_txt.text = "Flash Macintosh version"; my_fmt:TextFormat = new
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
	public get defaultTextFormat(): TextFormat
	{
		return this.__textFormat.clone();
	}

	public set defaultTextFormat(value: TextFormat)
	{
		(<internal.TextFormat><any>this.__textFormat).__merge(value);

		this.__layoutDirty = true;
		this.__dirty = true;
		this.__setRenderDirty();
	}

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
	public get displayAsPassword(): boolean
	{
		return this.__displayAsPassword;
	}

	public set displayAsPassword(value: boolean)
	{
		if (value != this.__displayAsPassword)
		{
			this.__dirty = true;
			this.__layoutDirty = true;
			this.__setRenderDirty();

			this.__displayAsPassword = value;
			this.__updateText(this.__text);
		}
	}

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
	public get embedFonts(): boolean
	{
		return this.__textEngine.embedFonts;
	}

	public set embedFonts(value: boolean)
	{
		// if (value != this.__textEngine.embedFonts) {
		//
		// __dirty = true;
		// __layoutDirty = true;
		//
		// }

		this.__textEngine.embedFonts = value;
	}

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
	public get gridFitType(): GridFitType
	{
		return this.__textEngine.gridFitType;
	}

	public set gridFitType(value: GridFitType)
	{
		// if (value != this.__textEngine.gridFitType) {
		//
		// __dirty = true;
		// __layoutDirty = true;
		//
		// }

		this.__textEngine.gridFitType = value;
	}

	public get height(): number
	{
		this.__updateLayout();
		return this.__textEngine.height * Math.abs(this.scaleY);
	}

	public set height(value: number)
	{
		if (value != this.__textEngine.height)
		{
			this.__setTransformDirty();
			this.__setParentRenderDirty();
			this.__setRenderDirty();
			this.__dirty = true;
			this.__layoutDirty = true;

			this.__textEngine.height = value;
		}

		this.__textEngine.height * Math.abs(this.scaleY);
	}

	/**
		Contains the HTML representation of the text field contents.
		Flash Player supports the following HTML tags:

		| Tag |  Description  |
		| --- | --- |
		| Anchor tag | The `<a>` tag creates a hypertext link and supports the following attributes:<ul><li>`target`: Specifies the name of the target window where you load the page. Options include `_self`, `_blank`, `_parent`, and `_top`. The `_self` option specifies the current frame in the current window, `_blank` specifies a new window, `_parent` specifies the parent of the current frame, and `_top` specifies the top-level frame in the current window.</li><li>`href`: Specifies a URL or an ActionScript `link` event.The URL can be either absolute or relative to the location of the SWF file that is loading the page. An example of an absolute reference to a URL is `http://www.adobe.com`; an example of a relative reference is `/index.html`. Absolute URLs must be prefixed with http://; otherwise, Flash Player or AIR treats them as relative URLs. You can use the `link` event to cause the link to execute an ActionScript in a SWF file instead of opening a URL. To specify a `link` event, use the event scheme instead of the http scheme in your `href` attribute. An example is `href="event:myText"` instead of `href="http://myURL"`; when the user clicks a hypertext link that contains the event scheme, the text field dispatches a `link` TextEvent with its `text` property set to "`myText`". You can then create an ActionScript that executes whenever the link TextEvent is dispatched. You can also define `a:link`, `a:hover`, and `a:active` styles for anchor tags by using style sheets.</li></ul> |
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
	public get htmlText(): string
	{
		return this.__isHTML ? this.__rawHtmlText : this.__text;
	}

	public set htmlText(value: string)
	{
		if (!this.__isHTML || this.__text != value)
		{
			this.__dirty = true;
			this.__layoutDirty = true;
			this.__setRenderDirty();
		}

		this.__isHTML = true;
		this.__rawHtmlText = value;

		value = HTMLParser.parse(value, this.__textFormat, this.__textEngine.textFormatRanges);

		if ((<internal.DisplayObject><any>DisplayObject).__supportDOM)
		{
			if (this.__textEngine.textFormatRanges.length > 1)
			{
				this.__textEngine.textFormatRanges.splice(1, this.__textEngine.textFormatRanges.length - 1);
			}

			var range = this.__textEngine.textFormatRanges[0];
			range.format = this.__textFormat;
			range.start = 0;

			if (this.__renderedOnCanvasWhileOnDOM)
			{
				range.end = value.length;
				this.__updateText(value);
			}
			else
			{
				range.end = this.__rawHtmlText.length;
				this.__updateText(this.__rawHtmlText);
			}
		}
		else
		{
			this.__updateText(value);
		}

		this.__updateScrollV();
	}

	/**
		The number of characters in a text field. A character such as tab
		(`\t`) counts as one character.
	**/
	public get length(): number
	{
		if (this.__text != null)
		{
			return this.__text.length;
		}

		return 0;
	}

	/**
		The maximum number of characters that the text field can contain, as
		entered by a user. A script can insert more text than
		`maxChars` allows; the `maxChars` property indicates
		only how much text a user can enter. If the value of this property is
		`0`, a user can enter an unlimited amount of text.

		@default 0
	**/
	public get maxChars(): number
	{
		return this.__textEngine.maxChars;
	}

	public set maxChars(value: number)
	{
		if (value != this.__textEngine.maxChars)
		{
			this.__textEngine.maxChars = value;

			this.__dirty = true;
			this.__layoutDirty = true;
			this.__setRenderDirty();
		}
	}

	/**
		The maximum value of `scrollH`.
	**/
	public get maxScrollH(): number
	{
		this.__updateLayout();

		return this.__textEngine.maxScrollH;
	}

	/**
		The maximum value of `scrollV`.
	**/
	public get maxScrollV(): number
	{
		this.__updateLayout();

		return this.__textEngine.maxScrollV;
	}

	/**
		A Boolean value that indicates whether Flash Player automatically scrolls
		multiline text fields when the user clicks a text field and rolls the mouse wheel.
		By default, this value is `true`. This property is useful if you want to prevent
		mouse wheel scrolling of text fields, or implement your own text field scrolling.
	**/
	public get mouseWheelEnabled(): boolean
	{
		return this.__mouseWheelEnabled;
	}

	public set mouseWheelEnabled(value: boolean)
	{
		this.__mouseWheelEnabled = value;
	}

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
	public get multiline(): boolean
	{
		return this.__textEngine.multiline;
	}

	public set multiline(value: boolean)
	{
		if (value != this.__textEngine.multiline)
		{
			this.__dirty = true;
			this.__layoutDirty = true;
			this.__updateText(this.__text);
			// __updateScrollV();
			this.__updateScrollH();
			this.__setRenderDirty();
		}

		this.__textEngine.multiline = value;
	}

	/**
		Defines the number of text lines in a multiline text field. If
		`wordWrap` property is set to `true`, the number of
		lines increases when text wraps.
	**/
	public get numLines(): number
	{
		this.__updateLayout();

		return this.__textEngine.numLines;
	}

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
	public get restrict(): string
	{
		return this.__textEngine.restrict;
	}

	public set restrict(value: string)
	{
		if (this.__textEngine.restrict != value)
		{
			this.__textEngine.restrict = value;
			this.__updateText(this.__text);
		}
	}

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
	public get scrollH(): number
	{
		return this.__textEngine.scrollH;
	}

	public set scrollH(value: number)
	{
		this.__updateLayout();

		if (value > this.__textEngine.maxScrollH) value = this.__textEngine.maxScrollH;
		if (value < 0) value = 0;

		if (value != this.__textEngine.scrollH)
		{
			this.__dirty = true;
			this.__setRenderDirty();
			this.__textEngine.scrollH = value;
			this.dispatchEvent(new Event(Event.SCROLL));
		}
	}

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
	public get scrollV(): number
	{
		return this.__textEngine.scrollV;
	}

	public set scrollV(value: number)
	{
		this.__updateLayout();

		if (value > 0 && value != this.__textEngine.scrollV)
		{
			this.__dirty = true;
			this.__setRenderDirty();
			this.__textEngine.scrollV = value;
			this.dispatchEvent(new Event(Event.SCROLL));
		}
	}

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
	public get selectable(): boolean
	{
		return this.__textEngine.selectable;
	}

	public set selectable(value: boolean)
	{
		if (value != this.__textEngine.selectable && this.type == TextFieldType.INPUT)
		{
			if (this.stage != null && this.stage.focus == this)
			{
				this.__startTextInput();
			}
			else if (!value)
			{
				this.__stopTextInput();
			}
		}

		this.__textEngine.selectable = value;
	}

	/**
		The zero-based character index value of the first character in the current
		selection. For example, the first character is 0, the second character is
		1, and so on. If no text is selected, this property is the value of
		`caretIndex`.
	**/
	public get selectionBeginIndex(): number
	{
		return Math.min(this.__caretIndex, this.__selectionIndex);
	}

	/**
		The zero-based character index value of the last character in the current
		selection. For example, the first character is 0, the second character is
		1, and so on. If no text is selected, this property is the value of
		`caretIndex`.
	**/
	public get selectionEndIndex(): number
	{
		return Math.max(this.__caretIndex, this.__selectionIndex);
	}

	/**
		The sharpness of the glyph edges in this text field. This property applies
		only if the `openfl.text.AntiAliasType` property of the text
		field is set to `openfl.text.AntiAliasType.ADVANCED`. The range
		for `sharpness` is a number from -400 to 400. If you attempt to
		set `sharpness` to a value outside that range, Flash sets the
		property to the nearest value in the range(either -400 or 400).

		@default 0
	**/
	public get sharpness(): number
	{
		return this.__textEngine.sharpness;
	}

	public set sharpness(value: number)
	{
		if (value != this.__textEngine.sharpness)
		{
			this.__dirty = true;
			this.__setRenderDirty();
		}

		this.__textEngine.sharpness = value;
	}

	public get tabEnabled(): boolean
	{
		return (this.__tabEnabled == null ? this.__textEngine.type == TextFieldType.INPUT : this.__tabEnabled);
	}

	public set tabEnabled(value: boolean)
	{
		super.tabEnabled = value;
	}

	/**
		A string that is the current text in the text field. Lines are separated
		by the carriage return character(`'\r'`, ASCII 13). This
		property contains unformatted text in the text field, without HTML tags.

		To get the text in HTML form, use the `htmlText`
		property.
	**/
	public get text(): string
	{
		return this.__text;
	}

	public set text(value: string)
	{
		if (this.__isHTML || this.__text != value)
		{
			this.__dirty = true;
			this.__layoutDirty = true;
			this.__setRenderDirty();
		}
		else
		{
			return;
		}

		if (this.__textEngine.textFormatRanges.length > 1)
		{
			this.__textEngine.textFormatRanges.splice(1, this.__textEngine.textFormatRanges.length - 1);
		}

		var range = this.__textEngine.textFormatRanges[0];
		range.format = this.__textFormat;
		range.start = 0;
		range.end = value.length;

		this.__isHTML = false;

		this.__updateText(value);
		this.__updateScrollV();
	}

	/**
		The color of the text in a text field, in hexadecimal format. The
		hexadecimal color system uses six digits to represent color values. Each
		digit has 16 possible values or characters. The characters range from 0-9
		and then A-F. For example, black is `0x000000`; white is
		`0xFFFFFF`.

		@default 0(0x000000)
	**/
	public get textColor(): number
	{
		return this.__textFormat.color;
	}

	public set textColor(value: number)
	{
		if (value != this.__textFormat.color)
		{
			this.__dirty = true;
			this.__setRenderDirty();
		}

		for (let range of this.__textEngine.textFormatRanges)
		{
			range.format.color = value;
		}

		this.__textFormat.color = value;
	}

	/**
		The height of the text in pixels.
	**/
	public get textHeight(): number
	{
		this.__updateLayout();
		return this.__textEngine.textHeight;
	}

	/**
		The width of the text in pixels.
	**/
	public get textWidth(): number
	{
		this.__updateLayout();
		return this.__textEngine.textWidth;
	}

	/**
		The type of the text field. Either one of the following TextFieldType
		constants: `TextFieldType.DYNAMIC`, which specifies a dynamic
		text field, which a user cannot edit, or `TextFieldType.INPUT`,
		which specifies an input text field, which a user can edit.

		@default dynamic
		@throws ArgumentError The `type` specified is not a member of
							  openfl.text.TextFieldType.
	**/
	public get type(): TextFieldType
	{
		return this.__textEngine.type;
	}

	public set type(value: TextFieldType)
	{
		if (value != this.__textEngine.type)
		{
			if (value == TextFieldType.INPUT)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, this.this_onAddedToStage);

				this.this_onFocusIn(null);
				this.__textEngine.__useIntAdvances = true;
			}
			else
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, this.this_onAddedToStage);

				this.__stopTextInput();
				this.__textEngine.__useIntAdvances = null;
			}

			this.__dirty = true;
			this.__layoutDirty = true;
			this.__setRenderDirty();
		}

		this.__textEngine.type = value;
	}

	public get width(): number
	{
		this.__updateLayout();
		return this.__textEngine.width * Math.abs(this.__scaleX);
	}

	public set width(value: number)
	{
		if (value != this.__textEngine.width)
		{
			this.__setTransformDirty();
			this.__setParentRenderDirty();
			this.__setRenderDirty();
			this.__dirty = true;
			this.__layoutDirty = true;

			this.__textEngine.width = value;
		}

		this.__textEngine.width * Math.abs(this.__scaleX);
	}

	/**
		A Boolean value that indicates whether the text field has word wrap. If
		the value of `wordWrap` is `true`, the text field
		has word wrap; if the value is `false`, the text field does not
		have word wrap. The default value is `false`.
	**/
	public get wordWrap(): boolean
	{
		return this.__textEngine.wordWrap;
	}

	public set wordWrap(value: boolean)
	{
		if (value != this.__textEngine.wordWrap)
		{
			this.__dirty = true;
			this.__layoutDirty = true;
			this.__setRenderDirty();
		}

		this.__textEngine.wordWrap = value;
	}

	public get x(): number
	{
		return this.__transform.tx + this.__offsetX;
	}

	public set x(value: number)
	{
		if (value != this.__transform.tx + this.__offsetX)
		{
			this.__setTransformDirty();
			this.__setParentRenderDirty();
		}

		this.__transform.tx = value - this.__offsetX;
	}

	public get y(): number
	{
		return this.__transform.ty + this.__offsetY;
	}

	public set y(value: number)
	{
		if (value != this.__transform.ty + this.__offsetY)
		{
			this.__setTransformDirty();
			this.__setParentRenderDirty();
		}

		this.__transform.ty = value - this.__offsetY;
	}

	// Event Handlers

	protected stage_onMouseMove(event: MouseEvent): void
	{
		if (this.stage == null) return;

		if (this.selectable && this.__selectionIndex >= 0)
		{
			this.__updateLayout();

			var position = this.__getPosition(this.mouseX + this.scrollH, this.mouseY);

			if (position != this.__caretIndex)
			{
				this.__caretIndex = position;

				var setDirty = true;

				if ((<internal.DisplayObject><any>DisplayObject).__supportDOM)
				{
					if (this.__renderedOnCanvasWhileOnDOM)
					{
						this.__forceCachedBitmapUpdate = true;
					}
					setDirty = false;
				}

				if (setDirty)
				{
					this.__dirty = true;
					this.__setRenderDirty();
				}
			}
		}
	}

	protected stage_onMouseUp(event: MouseEvent): void
	{
		if (this.stage == null) return;

		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_onMouseMove);
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_onMouseUp);

		if (this.stage.focus == this)
		{
			this.__getWorldTransform();
			this.__updateLayout();

			var upPos: number = this.__getPosition(this.mouseX + this.scrollH, this.mouseY);
			var leftPos: number;
			var rightPos: number;

			leftPos = Math.round(Math.min(this.__selectionIndex, upPos));
			rightPos = Math.round(Math.max(this.__selectionIndex, upPos));

			this.__selectionIndex = leftPos;
			this.__caretIndex = rightPos;

			if (this.__inputEnabled)
			{
				this.this_onFocusIn(null);

				this.__stopCursorTimer();
				this.__startCursorTimer();

				if ((<internal.DisplayObject><any>DisplayObject).__supportDOM && this.__renderedOnCanvasWhileOnDOM)
				{
					this.__forceCachedBitmapUpdate = true;
				}
			}
		}
	}

	protected this_onAddedToStage(event: Event): void
	{
		this.this_onFocusIn(null);
	}

	protected this_onFocusIn(event: FocusEvent): void
	{
		if (this.type == TextFieldType.INPUT && this.stage != null && this.stage.focus == this)
		{
			this.__startTextInput();
		}
	}

	protected this_onFocusOut(event: FocusEvent): void
	{
		this.__stopCursorTimer();

		// TODO: Better system

		if (event.relatedObject == null || !(event.relatedObject instanceof TextField))
		{
			this.__stopTextInput();
		}
		else
		{
			if (this.stage != null)
			{
				// this.__backend.stopInput();
			}

			this.__inputEnabled = false;
		}

		if (this.__selectionIndex != this.__caretIndex)
		{
			this.__selectionIndex = this.__caretIndex;
			this.__dirty = true;
			this.__setRenderDirty();
		}
	}

	protected this_onKeyDown(event: KeyboardEvent): void
	{
		if (this.type == TextFieldType.INPUT)
		{
			switch (event.keyCode)
			{
				case Keyboard.ENTER, Keyboard.NUMPAD_ENTER:
					if (this.__textEngine.multiline)
					{
						var te = new TextEvent(TextEvent.TEXT_INPUT, true, true, "\n");

						this.dispatchEvent(te);

						if (!te.isDefaultPrevented())
						{
							this.__replaceSelectedText("\n", true);

							this.dispatchEvent(new Event(Event.CHANGE, true));
						}
					}
					break;

				case Keyboard.BACKSPACE:
					if (this.__selectionIndex == this.__caretIndex && this.__caretIndex > 0)
					{
						this.__selectionIndex = this.__caretIndex - 1;
					}

					if (this.__selectionIndex != this.__caretIndex)
					{
						this.replaceSelectedText("");
						this.__selectionIndex = this.__caretIndex;

						this.dispatchEvent(new Event(Event.CHANGE, true));
					}
					break;

				case Keyboard.DELETE:
					if (this.__selectionIndex == this.__caretIndex && this.__caretIndex < this.__text.length)
					{
						this.__selectionIndex = this.__caretIndex + 1;
					}

					if (this.__selectionIndex != this.__caretIndex)
					{
						this.replaceSelectedText("");
						this.__selectionIndex = this.__caretIndex;

						this.dispatchEvent(new Event(Event.CHANGE, true));
					}
					break;

				case Keyboard.LEFT:
					if (this.selectable)
					{
						if (event.commandKey)
						{
							this.__caretBeginningOfLine();

							if (!event.shiftKey)
							{
								this.__selectionIndex = this.__caretIndex;
							}
						}
						else if (event.shiftKey)
						{
							this.__caretPreviousCharacter();
						}
						else
						{
							if (this.__selectionIndex == this.__caretIndex)
							{
								this.__caretPreviousCharacter();
							}
							else
							{
								this.__caretIndex = Math.min(this.__caretIndex, this.__selectionIndex);
							}

							this.__selectionIndex = this.__caretIndex;
						}

						this.__updateScrollH();
						this.__updateScrollV();
						this.__stopCursorTimer();
						this.__startCursorTimer();
					}
					break;

				case Keyboard.RIGHT:
					if (this.selectable)
					{
						if (event.commandKey)
						{
							this.__caretEndOfLine();

							if (!event.shiftKey)
							{
								this.__selectionIndex = this.__caretIndex;
							}
						}
						else if (event.shiftKey)
						{
							this.__caretNextCharacter();
						}
						else
						{
							if (this.__selectionIndex == this.__caretIndex)
							{
								this.__caretNextCharacter();
							}
							else
							{
								this.__caretIndex = Math.max(this.__caretIndex, this.__selectionIndex);
							}

							this.__selectionIndex = this.__caretIndex;
						}

						this.__updateScrollH();
						this.__updateScrollV();

						this.__stopCursorTimer();
						this.__startCursorTimer();
					}
					break;

				case Keyboard.DOWN:
					if (this.selectable)
					{
						if (!this.__textEngine.multiline) return;

						if (event.shiftKey)
						{
							this.__caretNextLine();
						}
						else
						{
							if (this.__selectionIndex == this.__caretIndex)
							{
								this.__caretNextLine();
							}
							else
							{
								var lineIndex = this.getLineIndexOfChar(Math.max(this.__caretIndex, this.__selectionIndex));
								this.__caretNextLine(lineIndex, Math.min(this.__caretIndex, this.__selectionIndex));
							}

							this.__selectionIndex = this.__caretIndex;
						}

						this.__updateScrollV();

						this.__stopCursorTimer();
						this.__startCursorTimer();
					}
					break;

				case Keyboard.UP:
					if (this.selectable)
					{
						if (!this.__textEngine.multiline) return;

						if (event.shiftKey)
						{
							this.__caretPreviousLine();
						}
						else
						{
							if (this.__selectionIndex == this.__caretIndex)
							{
								this.__caretPreviousLine();
							}
							else
							{
								var lineIndex = this.getLineIndexOfChar(Math.min(this.__caretIndex, this.__selectionIndex));
								this.__caretPreviousLine(lineIndex, Math.min(this.__caretIndex, this.__selectionIndex));
							}

							this.__selectionIndex = this.__caretIndex;
						}

						this.__updateScrollV();

						this.__stopCursorTimer();
						this.__startCursorTimer();
					}
					break;

				case Keyboard.HOME:
					if (this.selectable)
					{
						this.__caretBeginningOfLine();
						this.__stopCursorTimer();
						this.__startCursorTimer();
					}
					break;

				case Keyboard.END:
					if (this.selectable)
					{
						this.__caretEndOfLine();
						this.__stopCursorTimer();
						this.__startCursorTimer();
					}
					break;

				case Keyboard.C:
					if (event.ctrlKey)
					{
						if (this.__caretIndex != this.__selectionIndex)
						{
							Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.__text.substring(this.__caretIndex, this.__selectionIndex));
						}
					}
					break;

				case Keyboard.X:
					if (event.ctrlKey)
					{
						if (this.__caretIndex != this.__selectionIndex)
						{
							Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.__text.substring(this.__caretIndex, this.__selectionIndex));

							this.replaceSelectedText("");
							this.dispatchEvent(new Event(Event.CHANGE, true));
						}
					}
					break;

				case Keyboard.A:
					if (this.selectable)
					{
						if (event.ctrlKey)
						{
							this.__caretIndex = this.__text.length;
							this.__selectionIndex = 0;
						}
					}
					break;

				default:
			}
		}
		else if (this.selectable && event.keyCode == Keyboard.C && (event.commandKey || event.ctrlKey))
		{
			if (this.__caretIndex != this.__selectionIndex)
			{
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.__text.substring(this.__caretIndex, this.__selectionIndex));
			}
		}
	}

	protected this_onMouseDown(event: MouseEvent): void
	{
		if (!this.selectable && this.type != TextFieldType.INPUT) return;

		this.__updateLayout();

		this.__caretIndex = this.__getPosition(this.mouseX + this.scrollH, this.mouseY);
		this.__selectionIndex = this.__caretIndex;

		if (!(<internal.DisplayObject><any>DisplayObject).__supportDOM)
		{
			this.__dirty = true;
			this.__setRenderDirty();
		}

		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_onMouseMove);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_onMouseUp);
	}

	protected this_onMouseWheel(event: MouseEvent): void
	{
		if (this.mouseWheelEnabled)
		{
			this.scrollV -= event.delta;
		}
	}

	protected this_onDoubleClick(event: MouseEvent): void
	{
		if (this.selectable)
		{
			this.__updateLayout();

			var delimiters: Array<string> = ['\n', '.', '!', '?', ',', ' ', ';', ':', '(', ')', '-', '_', '/'];

			var txtStr: string = this.__text;
			var leftPos: number = -1;
			var rightPos: number = txtStr.length;
			var pos: number = 0;
			var startPos: number = Math.max(this.__caretIndex, 1);
			if (txtStr.length > 0 && this.__caretIndex >= 0 && rightPos >= this.__caretIndex)
			{
				for (let c of delimiters)
				{
					pos = txtStr.lastIndexOf(c, startPos - 1);
					if (pos > leftPos) leftPos = pos + 1;

					pos = txtStr.indexOf(c, startPos);
					if (pos < rightPos && pos != -1) rightPos = pos;
				}

				if (leftPos != rightPos)
				{
					this.setSelection(leftPos, rightPos);

					var setDirty: boolean = true;
					if ((<internal.DisplayObject><any>DisplayObject).__supportDOM)
					{
						if (this.__renderedOnCanvasWhileOnDOM)
						{
							this.__forceCachedBitmapUpdate = true;
						}
						setDirty = false;
					}

					if (setDirty)
					{
						this.__dirty = true;
						this.__setRenderDirty();
					}
				}
			}
		}
	}
}
