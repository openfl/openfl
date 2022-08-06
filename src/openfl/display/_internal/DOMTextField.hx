package openfl.display._internal;

import openfl.text._internal.HTMLParser;
import openfl.text._internal.TextEngine;
import openfl.display.DOMRenderer;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import openfl.events.TextEvent;
#if (js && html5)
import js.html.Element;
import js.Browser;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.text._internal.TextEngine)
@:access(openfl.text.TextField)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMTextField
{
	private static var __regexColor:EReg = ~/color=("#([^"]+)"|'#([^']+)')/i;
	private static var __regexFace:EReg = ~/face=("([^"]+)"|'([^']+)')/i;
	private static var __regexFont:EReg = ~/<font ([^>]+)>/gi;
	private static var __regexCloseFont:EReg = new EReg("</font>", "gi");
	private static var __regexSize:EReg = ~/size=("([^"]+)"|'([^']+)')/i;

	public static function clear(textField:TextField, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		DOMDisplayObject.clear(textField, renderer);

		if (textField.__div != null)
		{
			renderer.element.removeChild(textField.__div);
			textField.__div = null;
			textField.__style = null;
		}
		#end
	}

	public static function measureText(textField:TextField):Void
	{
		#if (js && html5)
		var textEngine = textField.__textEngine;
		var div:Element = textField.__div;

		if (div == null)
		{
			div = cast Browser.document.createElement("div");
			div.innerHTML = new EReg("\n", "g").replace(textEngine.text, "<br>");
			div.style.setProperty("font", TextEngine.getFont(textField.__textFormat), null);
			div.style.setProperty("pointer-events", "none", null);
			div.style.position = "absolute";
			div.style.top = "110%"; // position off-screen!
			Browser.document.body.appendChild(div);
		}

		textEngine.__measuredWidth = div.clientWidth;

		// Now set the width so that the height is accurate as a
		// function of the flow within the width bounds...

		if (textField.__div == null)
		{
			div.style.width = Std.string(textEngine.width - 4) + "px";
		}

		textEngine.__measuredHeight = div.clientHeight;

		if (textField.__div == null)
		{
			Browser.document.body.removeChild(div);
		}
		#end
	}

	public static inline function render(textField:TextField, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		var textEngine = textField.__textEngine;

		if (textField.stage != null && textField.__worldVisible && textField.__renderable)
		{
			if (textField.__dirty || textField.__renderTransformChanged || textField.__div == null)
			{
				if (textEngine.text != "" || textEngine.background || textEngine.border || textEngine.type == INPUT)
				{
					textField.__updateLayout();

					if (textField.__div == null)
					{
						textField.__div = cast Browser.document.createElement("div");
						renderer.__initializeElement(textField, textField.__div);
						textField.__style.setProperty("outline", "none", null);

						textField.__div.addEventListener("input", function(event)
						{
							event.preventDefault();

							// TODO: Set caret index, and replace only selection

							if (textField.htmlText != textField.__div.innerHTML)
							{
								textField.htmlText = textField.__div.innerHTML;

								if (textField.__displayAsPassword)
								{
									// TODO: Enable display as password
								}

								textField.__dirty = false;

								textField.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, false, false, textField.htmlText));
							}
						}, true);
					}

					if (!textEngine.wordWrap)
					{
						textField.__style.setProperty("white-space", "nowrap", null);
					}
					else
					{
						textField.__style.setProperty("word-wrap", "break-word", null);
					}

					textField.__style.setProperty("overflow", "hidden", null);

					if (textEngine.selectable)
					{
						textField.__style.setProperty("cursor", "text", null);
						textField.__style.setProperty("-webkit-user-select", "text", null);
						textField.__style.setProperty("-moz-user-select", "text", null);
						textField.__style.setProperty("-ms-user-select", "text", null);
						textField.__style.setProperty("-o-user-select", "text", null);
					}
					else
					{
						textField.__style.setProperty("cursor", "inherit", null);
					}

					var div = untyped textField.__div;
					div.contentEditable = (textEngine.type == INPUT);

					var style = textField.__style;

					// TODO: Handle ranges using span
					// TODO: Vertical align

					// textField.__div.innerHTML = textEngine.text;

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
					// var unscaledSize = textField.__textFormat.size;
					// var scaledSize:Float = unscaledSize;

					// var t = textField.__renderTransform;
					// if (t.a != 1.0 || t.d != 1.0)
					// {
					// 	if (t.a == t.d)
					// 	{
					// 		scale = t.a;
					// 		t.a = t.d = 1.0;
					// 	}
					// 	else if (t.a > t.d)
					// 	{
					// 		scale = t.a;
					// 		t.d /= t.a;
					// 		t.a = 1.0;
					// 	}
					// 	else
					// 	{
					// 		scale = t.d;
					// 		t.a /= t.d;
					// 		t.d = 1.0;
					// 	}
					// 	scaledSize *= scale;

					// 	#if openfl_half_round_font_sizes
					// 	var roundedFontSize = Math.fceil(scaledFontSize * 2) / 2;
					// 	if (roundedFontSize > scaledFontSize)
					// 	{
					// 		var adjustment = (scaledFontSize / roundedFontSize);
					// 		if (adjustment < 1 && (1 - adjustment) < 0.1)
					// 		{
					// 			t.a = 1;
					// 			t.d = 1;
					// 		}
					// 		else
					// 		{
					// 			scale *= adjustment;
					// 			t.a *= adjustment;
					// 			t.d *= adjustment;
					// 		}
					// 	}

					// 	scaledSize = roundedFontSize;
					// 	#end

					// 	w = Math.ceil(w * scale);
					// 	h = Math.ceil(h * scale);
					// }

					// untyped textField.__textFormat.size = scaledSize;

					var text = "";
					// var adjustment:Float = 0;

					if (textField.__isHTML)
					{
						textField.__updateText(HTMLParser.parse(textField.__text, textField.multiline, textField.__styleSheet, textField.__textFormat,
							textField.__textEngine.textFormatRanges));
					}

					var useTextBounds = !(textEngine.background || textEngine.border);
					var bounds = useTextBounds ? textEngine.textBounds : textEngine.bounds;

					var scrollX = -textField.scrollH;
					var scrollY = 0.0;

					for (group in textEngine.layoutGroups)
					{
						if (group.lineIndex < textField.scrollV - 1) continue;
						if (group.lineIndex > textEngine.bottomScrollV - 1) break;

						text += "<div style=\"";

						if (group.format.font != null)
						{
							text += "font: " + TextEngine.getFont(group.format) + "; ";
						}

						// if (group.format.size != null)
						// {
						// 	var size:Float = group.format.size;
						// 	var adjustment = size * scale;
						// 	if (size < 0)
						// 	{
						// 		size = scaledSize + adjustment;
						// 	}
						// 	else
						// 	{
						// 		size = adjustment;
						// 	}

						// 	text += "font-size: " + size + "px; ";
						// }

						if (group.format.color != null)
						{
							text += "color: #" + StringTools.hex(group.format.color & 0xFFFFFF, 6) + "; ";
						}

						// if (group.format.bold == true)
						// {
						// 	text += "font-weight: bold; ";
						// }

						// if (group.format.italic == true)
						// {
						// 	text += "font-style: italic; ";
						// }

						if (group.format.underline == true)
						{
							text += "text-decoration: underline; ";
						}

						if (group.format.align != null)
						{
							switch (group.format.align)
							{
								case TextFormatAlign.CENTER:
									text += "text-align: center; ";

								case TextFormatAlign.RIGHT:
									text += "text-align: right; ";

								case TextFormatAlign.JUSTIFY:
									text += "text-align: justify; ";

								default:
									text += "text-align: left; ";
							}
						}

						if (group.format.leftMargin != null)
						{
							text += "padding-left: " + (group.format.leftMargin * scale) + "px; ";
						}

						if (group.format.rightMargin != null)
						{
							text += "padding-right: " + (group.format.rightMargin * scale) + "px; ";
						}

						if (group.format.indent != null)
						{
							text += "text-indent: " + (group.format.indent * scale) + "px; ";
						}

						if (group.format.leading != null)
						{
							// TODO: Convert to line-height and line-trim
							// Going from half-leading on the web to proper leading
						}

						// var x = group.offsetX + scrollX - bounds.x;
						// var y = group.offsetY + group.ascent + scrollY - bounds.y;
						var x = group.offsetX + scrollX;
						var y = group.offsetY + scrollY + 3;

						text += "left: " + x + "px; top: " + y + "px; vertical-align: top; position: absolute;\">";

						if (group.format.url != null && group.format.url != "")
						{
							var anchorStyle = "text-decoration: underline; ";
							if (group.format.color != null)
							{
								anchorStyle += "color: #" + StringTools.hex(group.format.color & 0xFFFFFF, 6) + "; ";
							}
							text += "<a style='" + anchorStyle + "' href='" + group.format.url + "' target='" + group.format.target + "'>";
						}

						if (!textField.__isHTML)
						{
							text += StringTools.replace(StringTools.htmlEscape(textEngine.text.substring(group.startIndex, group.endIndex)), " ", "&nbsp;");
						}
						else
						{
							text += StringTools.replace(textEngine.text.substring(group.startIndex, group.endIndex), " ", "&nbsp;");
						}

						if (group.format.url != null && group.format.url != "")
						{
							text += "</a>";
						}

						text += "</div>";
					}

					if (textEngine.border)
					{
						style.setProperty("border", "solid 1px #" + StringTools.hex(textEngine.borderColor & 0xFFFFFF, 6), null);
						textField.__renderTransform.translate(-1, -1);
						textField.__renderTransformChanged = true;
						textField.__transformDirty = true;
					}
					else if (style.border != "")
					{
						style.removeProperty("border");
						textField.__renderTransformChanged = true;
					}

					style.setProperty("width", w + "px", null);
					style.setProperty("height", h + "px", null);

					textField.__div.innerHTML = text;

					// textField.__div.innerHTML = new EReg("\r\n", "g").replace(text, "<br>");
					// textField.__div.innerHTML = new EReg("\n", "g").replace(textField.__div.innerHTML, "<br>");
					// textField.__div.innerHTML = new EReg("\r", "g").replace(textField.__div.innerHTML, "<br>");

					textField.__dirty = false;
				}
				else
				{
					if (textField.__div != null)
					{
						renderer.element.removeChild(textField.__div);
						textField.__div = null;
					}
				}
			}

			if (textField.__div != null)
			{
				// force roundPixels = true for TextFields
				// Chrome shows blurry text if coordinates are fractional

				var old = renderer.__roundPixels;
				renderer.__roundPixels = true;

				renderer.__updateClip(textField);
				renderer.__applyStyle(textField, true, true, true);

				renderer.__roundPixels = old;
			}
		}
		else
		{
			clear(textField, renderer);
		}
		#end
	}

	public static function renderDrawable(textField:TextField, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		textField.__domRender = true;
		renderer.__updateCacheBitmap(textField, textField.__forceCachedBitmapUpdate || /*!__worldColorTransform.__isDefault ()*/ false);
		textField.__forceCachedBitmapUpdate = false;
		textField.__domRender = false;

		if (textField.__cacheBitmap != null && !textField.__isCacheBitmapRender)
		{
			renderer.__renderDrawableClear(textField);
			textField.__cacheBitmap.stage = textField.stage;

			DOMBitmap.render(textField.__cacheBitmap, renderer);
		}
		else
		{
			if (textField.__renderedOnCanvasWhileOnDOM)
			{
				textField.__renderedOnCanvasWhileOnDOM = false;

				if (textField.__isHTML && textField.__htmlText != null)
				{
					textField.__updateText(textField.__htmlText);
					textField.__dirty = true;
					textField.__layoutDirty = true;
					textField.__setRenderDirty();
				}
			}

			DOMTextField.render(textField, renderer);
		}

		renderer.__renderEvent(textField);
		#end
	}

	public static function renderDrawableClear(textField:TextField, renderer:DOMRenderer):Void
	{
		DOMTextField.clear(textField, renderer);
	}

	private static function __getAttributeMatch(regex:EReg):String
	{
		return regex.matched(2) != null ? regex.matched(2) : regex.matched(3);
	}
}
