package openfl.text;

#if !flash
import openfl.events.EventDispatcher;
import openfl.text._internal.CSSParser;
import openfl.utils.Object;

/**
	The StyleSheet class lets you create a StyleSheet object that contains text formatting rules
	for font size, color, and other styles. You can then apply styles defined by a style sheet to
	a TextField object that contains HTML- or XML-formatted text. The text in the TextField object
	is automatically formatted according to the tag styles defined by the StyleSheet object. You
	can use text styles to define new formatting tags, redefine built-in HTML tags, or create style
	classes that you can apply to certain HTML tags.

	To apply styles to a TextField object, assign the StyleSheet object to a TextField object's
	`styleSheet` property.

	*Note:* A text field with a style sheet is not editable. In other words, a text field with the
	type property set to TextFieldType.INPUT applies the StyleSheet to the default text for the text
	field, but the content will no longer be editable by the user. Consider using the TextFormat
	class to assign styles to input text fields.

	Flash Player supports a subset of properties in the original CSS1 specification
	([https://www.w3.org/TR/REC-CSS1](www.w3.org/TR/REC-CSS1)). The following table shows the
	supported Cascading Style Sheet (CSS) properties and values, as well as their corresponding
	Haxe property names. (Each Haxe property name is derived from the corresponding
	CSS property name; if the name contains a hyphen, the hyphen is omitted and the subsequent
	character is capitalized.)

	| CSS property | Haxe property | Usage and supported values |
	| --- | --- | --- |
	| `color` | `color` | Only hexadecimal color values are supported. Named colors (such as blue) are not supported. Colors are written in the following format: `#FF0000`. |
	| `display` | `display` | Supported values are `inline`, `block`, and `none`. |
	| `font-family` | `fontFamily` | A comma-separated list of fonts to use, in descending order of desirability. Any font family name can be used. If you specify a generic font name, it is converted to an appropriate device font. The following font conversions are available: `mono` is converted to `_typewriter`, `sans-serif` is converted to `_sans`, and `serif` is converted to `_serif`. |
	| `font-size` | `fontSize` | Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent. |
	| `font-style` | `fontStyle` | Recognized values are `normal` and `italic`. |
	| `font-weight` | `fontWeight` | Recognized values are `normal` and `bold`. |
	| `kerning` | `kerning` | Recognized values are `true` and `false`. Kerning is supported for embedded fonts only. Certain fonts, such as Courier New, do not support kerning. The kerning property is only supported in SWF files created in Windows, not in SWF files created on the Macintosh. However, these SWF files can be played in non-Windows versions of Flash Player and the kerning still applies. |
	| `leading` | `leading` | The amount of space that is uniformly distributed between lines. The value specifies the number of pixels that are added after each line. A negative value condenses the space between lines. Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent. |
	| `letter-spacing` | `letterSpacing` | The amount of space that is uniformly distributed between characters. The value specifies the number of pixels that are added after each character. A negative value condenses the space between characters. Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent. |
	| `margin-left` | `marginLeft` | Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent. |
	| `text-align` | `textAlign` | Recognized values are `left`, `center`, `right`, and `justify`. |
	| `text-decoration` | `textDecoration` | Recognized values are `none` and `underline`. |
	| `text-indent` | `textIndent` | Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent. |
**/
class StyleSheet extends EventDispatcher /*implements Dynamic*/
{
	/**
		An array that contains the names (as strings) of all of the styles registered in this style sheet.
	**/
	public var styleNames(get, never):Array<String>;

	@:noCompletion private static var __supportedStyles:Array<String> = [
		"color", "display", "font-family", "font-size", "font-style", "font-weight", "kerning", "leading", "letter-spacing", "margin-left", "margin-right",
		"text-align", "text-decoration", "text-indent"
	];

	@:noCompletion private var __styleNames:Array<String>;
	@:noCompletion private var __styleNamesDirty:Bool;
	@:noCompletion private var __styles:Map<String, Object>;

	/**
		Creates a new StyleSheet object.
	**/
	public function new()
	{
		super();
		clear();
	}

	/**
		Removes all styles from the style sheet object.
	**/
	public function clear():Void
	{
		__styleNamesDirty = false;
		__styleNames = null;
		__styles = new Map();
	}

	/**
		Returns a copy of the style object associated with the style named `styleName`.
		If there is no style object associated with `styleName`, `null` is returned.

		@param styleName A string that specifies the name of the style to retrieve.
		@return An object.
	**/
	public function getStyle(styleName:String):Object
	{
		styleName = styleName.toLowerCase();
		if (__styles.exists(styleName))
		{
			return __styles.get(styleName);
		}
		else
		{
			return null;
		}
	}

	/**
		Parses the CSS in `CSSText` and loads the style sheet with it. If a style
		in `CSSText` is already in `styleSheet`, the properties in `styleSheet` are
		retained, and only the ones in `CSSText` are added or changed in `styleSheet`.

		To extend the native CSS parsing capability, you can override this method
		by creating a subclass of the StyleSheet class.

		@param CSSText The CSS text to parse (a string).
	**/
	public function parseCSS(CSSText:String):Void
	{
		var parser = new CSSParser(["silent" => true]);
		var ast = parser.parse(CSSText);
		if (ast != null)
		{
			var rules:Array<Map<String, Dynamic>> = cast ast.get("rules");
			for (rule in rules)
			{
				var styleName:String = rule.exists("selectors") ? rule.get("selectors") : null;
				if (styleName != null)
				{
					styleName = styleName.toLowerCase();
					if (!__styles.exists(styleName))
					{
						__styles.set(styleName, new Object());
						__styleNamesDirty = true;
					}

					var object = __styles.get(styleName);
					var declarations:Array<Map<String, String>> = rule.get("declarations");
					if (declarations != null)
					{
						for (declaration in declarations)
						{
							var property = declaration.get("property");
							var value = Std.string(declaration.get("value"));
							if (property != null)
							{
								switch (property)
								{
									case "font-family":
										object.fontFamily = StringTools.replace(value, "\"", "");
									case "font-size":
										object.fontSize = value;
									case "font-style":
										object.fontStyle = value;
									case "font-weight":
										object.fontWeight = value;
									case "letter-spacing":
										object.letterSpacing = value;
									case "margin-left":
										object.marginLeft = value;
									case "text-align":
										object.textAlign = value;
									case "text-decoration":
										object.textDecoration = value;
									case "text-indent":
										object.textIndent = value;
									default:
										Reflect.setField(object, property, value);
								}
							}
						}
					}
				}
			}
		}
	}

	/**
		Adds a new style with the specified name to the style sheet object. If
		the named style does not already exist in the style sheet, it is added.
		If the named style already exists in the style sheet, it is replaced.
		If the styleObject parameter is null, the named style is removed.

		Flash Player creates a copy of the style object that you pass to this method.

		For a list of supported styles, see the table in the description for the
		StyleSheet class.

		@param styleName A string that specifies the name of the style to add to the style sheet.
		@param styleObject An object that describes the style, or `null`.
	**/
	public function setStyle(styleName:String, styleObject:Object):Void
	{
		styleName = styleName.toLowerCase();
		if (styleObject == null)
		{
			if (__styles.exists(styleName))
			{
				__styles.remove(styleName);
			}
		}
		else
		{
			var object = new Object();
			for (field in Reflect.fields(styleObject))
			{
				Reflect.setField(object, field, Reflect.field(styleObject, field));
			}
			__styles.set(styleName, object);
		}
	}

	/**
		Extends the CSS parsing capability. Advanced developers can override this
		method by extending the StyleSheet class.

		@param formatObject An object that describes the style, containing style rules as properties of the object, or `null`.
		@return A TextFormat object containing the result of the mapping of CSS rules to text format properties.
	**/
	public function transform(formatObject:Object):TextFormat
	{
		var format = new TextFormat();
		__applyStyleObject(formatObject, format);
		return format;
	}

	@:noCompletion private function __applyStyle(styleName:String, textFormat:TextFormat):Void
	{
		styleName = styleName.toLowerCase();
		if (__styles.exists(styleName))
		{
			var style = __styles.get(styleName);
			__applyStyleObject(style, textFormat);
		}
	}

	@:noCompletion private function __applyStyleObject(styleObject:Object, textFormat:TextFormat):Void
	{
		if (styleObject != null)
		{
			var hex = ~/[0-9A-Fa-f]+/;
			var numeric = ~/[0-9]+/;
			if (styleObject.hasOwnProperty("color") && hex.match(styleObject.color))
			{
				textFormat.color = Std.parseInt("0x" + hex.matched(0));
			}
			// if (formatObject.hasOwnProperty("display"))
			// {
			// 	TODO in TextField
			// 	switch (formatObject.get("display"))
			// 	{
			// 		case "inline":
			// 		case "block":
			// 		case "none":
			// 	}
			// }
			if (styleObject.hasOwnProperty("fontFamily"))
			{
				textFormat.font = __parseFont(styleObject.fontFamily);
			}
			if (styleObject.hasOwnProperty("fontSize") && numeric.match(styleObject.fontSize))
			{
				textFormat.size = Std.parseInt(numeric.matched(0));
			}
			if (styleObject.hasOwnProperty("fontStyle"))
			{
				switch (styleObject.fontStyle)
				{
					case "normal":
						textFormat.italic = false;
					case "italic":
						textFormat.italic = true;
					default:
				}
			}
			if (styleObject.hasOwnProperty("fontWeight"))
			{
				switch (styleObject.fontWeight)
				{
					case "normal":
						textFormat.bold = false;
					case "bold":
						textFormat.bold = true;
					default:
				}
			}
			// if (formatObject.hasOwnProperty("kerning"))
			// {
			// }
			if (styleObject.hasOwnProperty("leading") && numeric.match(styleObject.leading))
			{
				textFormat.leading = Std.parseInt(numeric.matched(0));
			}
			if (styleObject.hasOwnProperty("letterSpacing") && numeric.match(styleObject.letterSpacing))
			{
				textFormat.letterSpacing = Std.parseFloat(numeric.matched(0));
			}
			if (styleObject.hasOwnProperty("marginLeft") && numeric.match(styleObject.marginLeft))
			{
				textFormat.leftMargin = Std.parseInt(numeric.matched(0));
			}
			if (styleObject.hasOwnProperty("marginRight") && numeric.match(styleObject.marginRight))
			{
				textFormat.rightMargin = Std.parseInt(numeric.matched(0));
			}
			if (styleObject.hasOwnProperty("textAlign"))
			{
				switch (styleObject.textAlign)
				{
					case "left":
						textFormat.align = TextFormatAlign.LEFT;
					case "right":
						textFormat.align = TextFormatAlign.RIGHT;
					case "center":
						textFormat.align = TextFormatAlign.CENTER;
					case "justify":
						textFormat.align = TextFormatAlign.JUSTIFY;
					default:
				}
			}
			if (styleObject.hasOwnProperty("textDecoration"))
			{
				switch (styleObject.textDecoration)
				{
					case "none":
						textFormat.underline = false;
					case "underline":
						textFormat.underline = true;
					default:
				}
			}
			if (styleObject.hasOwnProperty("textIndent") && numeric.match(styleObject.textIndent))
			{
				textFormat.blockIndent = Std.parseInt(numeric.matched(0));
			}
		}
	}

	@:noCompletion private function __parseFont(fontFamily:String):String
	{
		if (fontFamily == null) return null;
		if (fontFamily.indexOf(",") > -1) fontFamily = fontFamily.substr(0, fontFamily.indexOf(","));
		switch (fontFamily)
		{
			case "mono":
				return "_typewriter";
			case "sans-serif":
				return "_sans";
			case "serif":
				return "_serif";
			default:
				return fontFamily;
		}
	}

	// Get & Set Methods

	@:noCompletion private function get_styleNames():Array<String>
	{
		if (__styleNames == null || __styleNamesDirty)
		{
			__styleNames = [];
			for (style in __styles.keys())
			{
				__styleNames.push(style);
			}
			__styleNamesDirty = false;
		}
		return __styleNames;
	}
}
#else
typedef StyleSheet = flash.text.StyleSheet;
#end
