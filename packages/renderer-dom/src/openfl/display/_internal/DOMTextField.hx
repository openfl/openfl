package openfl.display._internal;

#if openfl_html5
import js.html.Element;
import js.Browser;
import openfl.text._internal.TextEngine;
import openfl.text.TextField;
import openfl.text._TextField;
import openfl.text.TextFormatAlign;

@:access(openfl.display._internal)
@:access(openfl.text._internal.TextEngine)
@:access(openfl.text.TextField)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMTextField
{
	public static var __regexColor:EReg = ~/color=("#([^"]+)"|'#([^']+)')/i;
	public static var __regexFace:EReg = ~/face=("([^"]+)"|'([^']+)')/i;
	public static var __regexFont:EReg = ~/<font ([^>]+)>/gi;
	public static var __regexCloseFont:EReg = new EReg("</font>", "gi");
	public static var __regexSize:EReg = ~/size=("([^"]+)"|'([^']+)')/i;

	public static function clear(textField:TextField, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if ((textField._ : _TextField).__div != null)
		{
			renderer.element.removeChild((textField._ : _TextField).__div);
			(textField._ : _TextField).__div = null;
			(textField._ : _TextField).__renderData.style = null;
		}
		#end
	}

	public static function measureText(textField:TextField):Void
	{
		#if openfl_html5
		var textEngine = (textField._ : _TextField).__textEngine;
		var div:Element = (textField._ : _TextField).__div;

		if (div == null)
		{
			div = cast Browser.document.createElement("div");
			div.innerHTML = new EReg("\n", "g").replace(textEngine.text, "<br>");
			div.style.setProperty("font", TextEngine.getFont((textField._ : _TextField).__textFormat), null);
			div.style.setProperty("pointer-events", "none", null);
			div.style.position = "absolute";
			div.style.top = "110%"; // position off-screen!
			Browser.document.body.appendChild(div);
		}

		textEngine.__measuredWidth = div.clientWidth;

		// Now set the width so that the height is accurate as a
		// function of the flow within the width bounds...

		if ((textField._ : _TextField).__div == null)
		{
			div.style.width = Std.string(textEngine.width - 4) + "px";
		}

		textEngine.__measuredHeight = div.clientHeight;

		if ((textField._ : _TextField).__div == null)
		{
			Browser.document.body.removeChild(div);
		}
		#end
	}

	public static inline function render(textField:TextField, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		var textEngine = (textField._ : _TextField).__textEngine;

		if (textField.stage != null && (textField._ : _TextField).__worldVisible && (textField._ : _TextField).__renderable)
		{
			if ((textField._ : _TextField).__dirty
				|| (textField._ : _TextField).__renderTransformChanged || (textField._ : _TextField).__div == null)
			{
				if (textEngine.text != "" || textEngine.background || textEngine.border || textEngine.type == INPUT)
				{
					if ((textField._ : _TextField).__div == null)
					{
						(textField._ : _TextField).__div = cast Browser.document.createElement("div");
						(renderer._ : _DOMRenderer).__initializeElement(textField, (textField._ : _TextField).__div);
						(textField._ : _TextField).__renderData.style.setProperty("outline", "none", null);

						(textField._ : _TextField).__div.addEventListener("input", function(event)
						{
							event.preventDefault();

							// TODO: Set caret index, and replace only selection

							if (textField.htmlText != (textField._ : _TextField).__div.innerHTML)
							{
								textField.htmlText = (textField._ : _TextField).__div.innerHTML;

								if ((textField._ : _TextField).__displayAsPassword)
								{
									// TODO: Enable display as password
								}

									(textField._ : _TextField).__dirty = false;
							}
						}, true);
					}

					if (!textEngine.wordWrap)
					{
						(textField._ : _TextField).__renderData.style.setProperty("white-space", "nowrap", null);
					}
					else
					{
						(textField._ : _TextField).__renderData.style.setProperty("word-wrap", "break-word", null);
					}

						(textField._ : _TextField).__renderData.style.setProperty("overflow", "hidden", null);

					if (textEngine.selectable)
					{
						(textField._ : _TextField).__renderData.style.setProperty("cursor", "text", null);
						(textField._ : _TextField).__renderData.style.setProperty("-webkit-user-select", "text", null);
						(textField._ : _TextField).__renderData.style.setProperty("-moz-user-select", "text", null);
						(textField._ : _TextField).__renderData.style.setProperty("-ms-user-select", "text", null);
						(textField._ : _TextField).__renderData.style.setProperty("-o-user-select", "text", null);
					}
					else
					{
						(textField._ : _TextField).__renderData.style.setProperty("cursor", "inherit", null);
					}

					var div = untyped (textField._ : _TextField).__div;
					div.contentEditable = (textEngine.type == INPUT);

					var style = (textField._ : _TextField).__renderData.style;

					// TODO: Handle ranges using span
					// TODO: Vertical align

					// (textField._ : _TextField).__div.innerHTML = textEngine.text;

					if (textEngine.background)
					{
						style.setProperty("background-color", "#" + StringTools.hex(textEngine.backgroundColor & 0xFFFFFF, 6), null);
					}
					else
					{
						style.removeProperty("background-color");
					}

					var w = textEngine.width;
					var h = textEngine.height;
					var scale:Float = 1;
					var unscaledSize = (textField._ : _TextField).__textFormat.size;
					var scaledSize:Float = unscaledSize;

					var t = (textField._ : _TextField).__renderTransform;
					if (t.a != 1.0 || t.d != 1.0)
					{
						if (t.a == t.d)
						{
							scale = t.a;
							t.a = t.d = 1.0;
						}
						else if (t.a > t.d)
						{
							scale = t.a;
							t.d /= t.a;
							t.a = 1.0;
						}
						else
						{
							scale = t.d;
							t.a /= t.d;
							t.d = 1.0;
						}
						scaledSize *= scale;

						#if openfl_half_round_font_sizes
						var roundedFontSize = Math.fceil(scaledFontSize * 2) / 2;
						if (roundedFontSize > scaledFontSize)
						{
							var adjustment = (scaledFontSize / roundedFontSize);
							if (adjustment < 1 && (1 - adjustment) < 0.1)
							{
								t.a = 1;
								t.d = 1;
							}
							else
							{
								scale *= adjustment;
								t.a *= adjustment;
								t.d *= adjustment;
							}
						}

						scaledSize = roundedFontSize;
						#end

						w = Math.ceil(w * scale);
						h = Math.ceil(h * scale);
					}

					untyped (textField._ : _TextField).__textFormat.size = scaledSize;

					var text = textEngine.text;
					var adjustment:Float = 0;

					if (!(textField._ : _TextField).__isHTML)
					{
						text = StringTools.htmlEscape(text);
					}
					else
					{
						var matchText = text;
						while (__regexFont.match(matchText))
						{
							var fontText = __regexFont.matched(0);
							var style = "";

							if (__regexFace.match(fontText))
							{
								style += "font-family:'" + __getAttributeMatch(__regexFace) + "';";
							}

							if (__regexColor.match(fontText))
							{
								style += "color:#" + __getAttributeMatch(__regexColor) + ";";
							}

							if (__regexSize.match(fontText))
							{
								var sizeAttr = __getAttributeMatch(__regexSize);
								var firstChar = sizeAttr.charCodeAt(0);
								var size:Float;
								adjustment = Std.parseFloat(sizeAttr) * scale;
								if (firstChar == "+".code || firstChar == "-".code)
								{
									size = scaledSize + adjustment;
								}
								else
								{
									size = adjustment;
								}

								style += "font-size:" + size + "px;";
							}

							text = StringTools.replace(text, fontText, "<span style='" + style + "'>");

							matchText = __regexFont.matchedRight();
						}

						text = __regexCloseFont.replace(text, "</span>");
					}

					text = StringTools.replace(text, "<p ", "<p style='margin-top:0; margin-bottom:0;' ");

					var unscaledLeading = (textField._ : _TextField).__textFormat.leading;
					(textField._ : _TextField).__textFormat.leading += Std.int(adjustment);

					(textField._ : _TextField).__div.innerHTML = new EReg("\r\n", "g").replace(text, "<br>");
						(textField._ : _TextField).__div.innerHTML = new EReg("\n", "g").replace((textField._ : _TextField).__div.innerHTML, "<br>");
							(textField._ : _TextField).__div.innerHTML = new EReg("\r", "g").replace((textField._ : _TextField).__div.innerHTML, "<br>");

					style.setProperty("font", TextEngine.getFont((textField._ : _TextField).__textFormat), null);

					(textField._ : _TextField).__textFormat.size = unscaledSize;
					(textField._ : _TextField).__textFormat.leading = unscaledLeading;

					style.setProperty("top", "3px", null);

					if (textEngine.border)
					{
						style.setProperty("border", "solid 1px #" + StringTools.hex(textEngine.borderColor & 0xFFFFFF, 6), null);
						(textField._ : _TextField).__renderTransform.translate(-1, -1);
						(textField._ : _TextField).__renderTransformChanged = true;
						(textField._ : _TextField).__transformDirty = true;
					}
					else if (style.border != "")
					{
						style.removeProperty("border");
						(textField._ : _TextField).__renderTransformChanged = true;
					}

					style.setProperty("color", "#" + StringTools.hex((textField._ : _TextField).__textFormat.color & 0xFFFFFF, 6), null);

					style.setProperty("width", w + "px", null);
					style.setProperty("height", h + "px", null);

					switch ((textField._ : _TextField).__textFormat.align)
					{
						case TextFormatAlign.CENTER:
							style.setProperty("text-align", "center", null);

						case TextFormatAlign.RIGHT:
							style.setProperty("text-align", "right", null);

						default:
							style.setProperty("text-align", "left", null);
					}

					(textField._ : _TextField).__dirty = false;
				}
				else
				{
					if ((textField._ : _TextField).__div != null)
					{
						renderer.element.removeChild((textField._ : _TextField).__div);
						(textField._ : _TextField).__div = null;
					}
				}
			}

			if ((textField._ : _TextField).__div != null)
			{
				// force roundPixels = true for TextFields
				// Chrome shows blurry text if coordinates are fractional

				var old = (renderer._ : _DOMRenderer).__roundPixels;
				(renderer._ : _DOMRenderer).__roundPixels = true;

				(renderer._ : _DOMRenderer).__updateClip(textField);
				(renderer._ : _DOMRenderer).__applyStyle(textField, true, true, true);

				(renderer._ : _DOMRenderer).__roundPixels = old;
			}
		}
		else
		{
			clear(textField, renderer);
		}
		#end
	}

	public static function __getAttributeMatch(regex:EReg):String
	{
		return regex.matched(2) != null ? regex.matched(2) : regex.matched(3);
	}
}
#end
