package openfl.text; #if (display || !flash)


/**
 * The TextFormat class represents character formatting information. Use the
 * TextFormat class to create specific text formatting for text fields. You
 * can apply text formatting to both static and dynamic text fields. The
 * properties of the TextFormat class apply to device and embedded fonts.
 * However, for embedded fonts, bold and italic text actually require specific
 * fonts. If you want to display bold or italic text with an embedded font,
 * you need to embed the bold and italic variations of that font.
 *
 *  You must use the constructor `new TextFormat()` to create a
 * TextFormat object before setting its properties. When you apply a
 * TextFormat object to a text field using the
 * `TextField.defaultTextFormat` property or the
 * `TextField.setTextFormat()` method, only its defined properties
 * are applied. Use the `TextField.defaultTextFormat` property to
 * apply formatting BEFORE you add text to the `TextField`, and the
 * `setTextFormat()` method to add formatting AFTER you add text to
 * the `TextField`. The TextFormat properties are `null`
 * by default because if you don't provide values for the properties, Flash
 * Player uses its own default formatting. The default formatting that Flash
 * Player uses for each property(if property's value is `null`) is
 * as follows:
 *
 * The default formatting for each property is also described in each
 * property description.
 */
extern class TextFormat {
	
	
	/**
	 * Indicates the alignment of the paragraph. Valid values are TextFormatAlign
	 * constants.
	 * 
	 * @default TextFormatAlign.LEFT
	 * @throws ArgumentError The `align` specified is not a member of
	 *                       flash.text.TextFormatAlign.
	 */
	public var align:TextFormatAlign;
	
	/**
	 * Indicates the block indentation in pixels. Block indentation is applied to
	 * an entire block of text; that is, to all lines of the text. In contrast,
	 * normal indentation(`TextFormat.indent`) affects only the first
	 * line of each paragraph. If this property is `null`, the
	 * TextFormat object does not specify block indentation(block indentation is
	 * 0).
	 */
	public var blockIndent:Null<Int>;
	
	/**
	 * Specifies whether the text is boldface. The default value is
	 * `null`, which means no boldface is used. If the value is
	 * `true`, then the text is boldface.
	 */
	public var bold:Null<Bool>;
	
	/**
	 * Indicates that the text is part of a bulleted list. In a bulleted list,
	 * each paragraph of text is indented. To the left of the first line of each
	 * paragraph, a bullet symbol is displayed. The default value is
	 * `null`, which means no bulleted list is used.
	 */
	public var bullet:Null<Bool>;
	
	/**
	 * Indicates the color of the text. A number containing three 8-bit RGB
	 * components; for example, 0xFF0000 is red, and 0x00FF00 is green. The
	 * default value is `null`, which means that Flash Player uses the
	 * color black(0x000000).
	 */
	public var color:Null<Int>;
	
	#if flash
	@:noCompletion @:dox(hide) public var display:flash.text.TextFormatDisplay;
	#end
	
	/**
	 * The name of the font for text in this text format, as a string. The
	 * default value is `null`, which means that Flash Player uses
	 * Times New Roman font for the text.
	 */
	public var font:String;
	
	/**
	 * Indicates the indentation from the left margin to the first character in
	 * the paragraph. The default value is `null`, which indicates
	 * that no indentation is used.
	 */
	public var indent:Null<Int>;
	
	/**
	 * Indicates whether text in this text format is italicized. The default
	 * value is `null`, which means no italics are used.
	 */
	public var italic:Null<Bool>;
	
	/**
	 * A Boolean value that indicates whether kerning is enabled
	 * (`true`) or disabled(`false`). Kerning adjusts the
	 * pixels between certain character pairs to improve readability, and should
	 * be used only when necessary, such as with headings in large fonts. Kerning
	 * is supported for embedded fonts only.
	 *
	 * Certain fonts such as Verdana and monospaced fonts, such as Courier
	 * New, do not support kerning.
	 *
	 * The default value is `null`, which means that kerning is not
	 * enabled.
	 */
	public var kerning:Null<Bool>;
	
	/**
	 * An integer representing the amount of vertical space(called
	 * _leading_) between lines. The default value is `null`,
	 * which indicates that the amount of leading used is 0.
	 */
	public var leading:Null<Int>;
	
	/**
	 * The left margin of the paragraph, in pixels. The default value is
	 * `null`, which indicates that the left margin is 0 pixels.
	 */
	public var leftMargin:Null<Int>;
	
	/**
	 * A number representing the amount of space that is uniformly distributed
	 * between all characters. The value specifies the number of pixels that are
	 * added to the advance after each character. The default value is
	 * `null`, which means that 0 pixels of letter spacing is used.
	 * You can use decimal values such as `1.75`.
	 */
	public var letterSpacing:Null<Float>;
	
	/**
	 * The right margin of the paragraph, in pixels. The default value is
	 * `null`, which indicates that the right margin is 0 pixels.
	 */
	public var rightMargin:Null<Int>;
	
	/**
	 * The size in pixels of text in this text format. The default value is
	 * `null`, which means that a size of 12 is used.
	 */
	public var size:Null<Int>;
	
	/**
	 * Specifies custom tab stops as an array of non-negative integers. Each tab
	 * stop is specified in pixels. If custom tab stops are not specified
	 * (`null`), the default tab stop is 4(average character width).
	 */
	public var tabStops:Array<Int>;
	
	/**
	 * Indicates the target window where the hyperlink is displayed. If the
	 * target window is an empty string, the text is displayed in the default
	 * target window `_self`. You can choose a custom name or one of
	 * the following four names: `_self` specifies the current frame
	 * in the current window, `_blank` specifies a new window,
	 * `_parent` specifies the parent of the current frame, and
	 * `_top` specifies the top-level frame in the current window. If
	 * the `TextFormat.url` property is an empty string or
	 * `null`, you can get or set this property, but the property will
	 * have no effect.
	 */
	public var target:String;
	
	/**
	 * Indicates whether the text that uses this text format is underlined
	 * (`true`) or not(`false`). This underlining is
	 * similar to that produced by the `<U>` tag, but the latter is
	 * not true underlining, because it does not skip descenders correctly. The
	 * default value is `null`, which indicates that underlining is
	 * not used.
	 */
	public var underline:Null<Bool>;
	
	/**
	 * Indicates the target URL for the text in this text format. If the
	 * `url` property is an empty string, the text does not have a
	 * hyperlink. The default value is `null`, which indicates that
	 * the text does not have a hyperlink.
	 *
	 * **Note:** The text with the assigned text format must be set with
	 * the `htmlText` property for the hyperlink to work.
	 */
	public var url:String;
	
	
	/**
	 * Creates a TextFormat object with the specified properties. You can then
	 * change the properties of the TextFormat object to change the formatting of
	 * text fields.
	 *
	 * Any parameter may be set to `null` to indicate that it is
	 * not defined. All of the parameters are optional; any omitted parameters
	 * are treated as `null`.
	 * 
	 * @param font        The name of a font for text as a string.
	 * @param size        An integer that indicates the size in pixels.
	 * @param color       The color of text using this text format. A number
	 *                    containing three 8-bit RGB components; for example,
	 *                    0xFF0000 is red, and 0x00FF00 is green.
	 * @param bold        A Boolean value that indicates whether the text is
	 *                    boldface.
	 * @param italic      A Boolean value that indicates whether the text is
	 *                    italicized.
	 * @param underline   A Boolean value that indicates whether the text is
	 *                    underlined.
	 * @param url         The URL to which the text in this text format
	 *                    hyperlinks. If `url` is an empty string, the
	 *                    text does not have a hyperlink.
	 * @param target      The target window where the hyperlink is displayed. If
	 *                    the target window is an empty string, the text is
	 *                    displayed in the default target window
	 *                    `_self`. If the `url` parameter
	 *                    is set to an empty string or to the value
	 *                    `null`, you can get or set this property,
	 *                    but the property will have no effect.
	 * @param align       The alignment of the paragraph, as a TextFormatAlign
	 *                    value.
	 * @param leftMargin  Indicates the left margin of the paragraph, in pixels.
	 * @param rightMargin Indicates the right margin of the paragraph, in pixels.
	 * @param indent      An integer that indicates the indentation from the left
	 *                    margin to the first character in the paragraph.
	 * @param leading     A number that indicates the amount of leading vertical
	 *                    space between lines.
	 */
	public function new (font:String = null, size:Null<Int> = null, color:Null<Int> = null, bold:Null<Bool> = null, italic:Null<Bool> = null, underline:Null<Bool> = null, url:String = null, target:String = null, align:TextFormatAlign = null, leftMargin:Null<Int> = null, rightMargin:Null<Int> = null, indent:Null<Int> = null, leading:Null<Int> = null);
	
	
	public function clone ():TextFormat;
	
	
}


#else
typedef TextFormat = flash.text.TextFormat;
#end