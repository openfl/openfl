import TextField from "../../../text/TextField";
import TextFieldType from "../../../text/TextFieldType";
import TextFormatAlign from "../../../text/TextFormatAlign";
import * as internal from "../../utils/InternalAccess";
import TextEngine from "../../text/TextEngine";
import DOMRenderer from "./DOMRenderer";

export default class DOMTextField
{
	private static __regexColor: RegExp = /color=("#([^"]+)"|'#([^']+)')/i;
	private static __regexFace: RegExp = /face=("([^"]+)"|'([^']+)')/i;
	private static __regexFont: RegExp = /<font ([^>]+)>/gi;
	private static __regexCloseFont: RegExp = new RegExp("</font>", "gi");
	private static __regexSize: RegExp = /size=("([^"]+)"|'([^']+)')/i;

	public static clear(textField: TextField, renderer: DOMRenderer): void
	{
		if ((<internal.TextField><any>textField).__div != null)
		{
			renderer.element.removeChild((<internal.TextField><any>textField).__div);
			(<internal.TextField><any>textField).__div = null;
			(<internal.DisplayObject><any>textField).__renderData.style = null;
		}
	}

	public static measureText(textField: TextField): void
	{
		var textEngine = (<internal.TextField><any>textField).__textEngine;
		var div: HTMLElement = (<internal.TextField><any>textField).__div;

		if (div == null)
		{
			div = document.createElement("div");
			div.innerHTML = new RegExp("\n", "g").replace(textEngine.text, "<br>");
			div.style.setProperty("font", TextEngine.getFont((<internal.TextField><any>textField).__textFormat), null);
			div.style.setProperty("pointer-events", "none", null);
			div.style.position = "absolute";
			div.style.top = "110%"; // position off-screen!
			document.body.appendChild(div);
		}

		textEngine.__measuredWidth = div.clientWidth;

		// Now set the width so that the height is accurate as a
		// of the flow within the width bounds...

		if ((<internal.TextField><any>textField).__div == null)
		{
			div.style.width = String(textEngine.width - 4) + "px";
		}

		textEngine.__measuredHeight = div.clientHeight;

		if ((<internal.TextField><any>textField).__div == null)
		{
			document.body.removeChild(div);
		}
	}

	public static render(textField: TextField, renderer: DOMRenderer): void
	{
		var textEngine = (<internal.TextField><any>textField).__textEngine;

		if (textField.stage != null && (<internal.DisplayObject><any>textField).__worldVisible && (<internal.DisplayObject><any>textField).__renderable)
		{
			if ((<internal.TextField><any>textField).__dirty || (<internal.DisplayObject><any>textField).__renderTransformChanged || (<internal.TextField><any>textField).__div == null)
			{
				if (textEngine.text != "" || textEngine.background || textEngine.border || textEngine.type == TextFieldType.INPUT)
				{
					if ((<internal.TextField><any>textField).__div == null)
					{
						(<internal.TextField><any>textField).__div = document.createElement("div");
						renderer.__initializeElement(textField, (<internal.TextField><any>textField).__div);
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("outline", "none", null);

						(<internal.TextField><any>textField).__div.addEventListener("input", (event) =>
						{
							event.preventDefault();

							// TODO: Set caret index, and replace only selection

							if (textField.htmlText != (<internal.TextField><any>textField).__div.innerHTML)
							{
								textField.htmlText = (<internal.TextField><any>textField).__div.innerHTML;

								if ((<internal.TextField><any>textField).__displayAsPassword)
								{
									// TODO: Enable display as password
								}

								(<internal.TextField><any>textField).__dirty = false;
							}
						}, true);
					}

					if (!textEngine.wordWrap)
					{
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("white-space", "nowrap", null);
					}
					else
					{
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("word-wrap", "break-word", null);
					}

					(<internal.DisplayObject><any>textField).__renderData.style.setProperty("overflow", "hidden", null);

					if (textEngine.selectable)
					{
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("cursor", "text", null);
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("-webkit-user-select", "text", null);
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("-moz-user-select", "text", null);
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("-ms-user-select", "text", null);
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("-o-user-select", "text", null);
					}
					else
					{
						(<internal.DisplayObject><any>textField).__renderData.style.setProperty("cursor", "inherit", null);
					}

					var div = (<internal.TextField><any>textField).__div;
					div.contentEditable = String(textEngine.type == TextFieldType.INPUT);

					var style = (<internal.DisplayObject><any>textField).__renderData.style;

					// TODO: Handle ranges using span
					// TODO: Vertical align

					// (<internal.TextField><any>textField).__div.innerHTML = textEngine.text;

					if (textEngine.background)
					{
						style.setProperty("background-color", "#" + (textEngine.backgroundColor & 0xFFFFFF).toString(16), null);
					}
					else
					{
						style.removeProperty("background-color");
					}

					var w = textEngine.width;
					var h = textEngine.height;
					var scale: number = 1;
					var unscaledSize = (<internal.TextField><any>textField).__textFormat.size;
					var scaledSize: number = unscaledSize;

					var t = (<internal.DisplayObject><any>textField).__renderTransform;
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

						// #if openfl_half_round_font_sizes
						// var roundedFontSize = Math.fceil(scaledFontSize * 2) / 2;
						// if (roundedFontSize > scaledFontSize)
						// {
						// 	var adjustment = (scaledFontSize / roundedFontSize);
						// 	if (adjustment < 1 && (1 - adjustment) < 0.1)
						// 	{
						// 		t.a = 1;
						// 		t.d = 1;
						// 	}
						// 	else
						// 	{
						// 		scale *= adjustment;
						// 		t.a *= adjustment;
						// 		t.d *= adjustment;
						// 	}
						// }

						// scaledSize = roundedFontSize;
						// #end

						w = Math.ceil(w * scale);
						h = Math.ceil(h * scale);
					}

					(<internal.TextField><any>textField).__textFormat.size = scaledSize;

					var text = textEngine.text;
					var adjustment: number = 0;

					if (!(<internal.TextField><any>textField).__isHTML)
					{
						text = encodeURIComponent(text);
					}
					else
					{
						var matchText = text;
						while (this.__regexFont.match(matchText))
						{
							var fontText = this.__regexFont.matched(0);
							var style = "";

							if (this.__regexFace.match(fontText))
							{
								style += "font-family:'" + this.__getAttributeMatch(this.__regexFace) + "';";
							}

							if (this.__regexColor.match(fontText))
							{
								style += "color:#" + this.__getAttributeMatch(this.__regexColor) + ";";
							}

							if (this.__regexSize.match(fontText))
							{
								var sizeAttr = this.__getAttributeMatch(this.__regexSize);
								var firstChar = sizeAttr.charCodeAt(0);
								var size: number;
								adjustment = parseFloat(sizeAttr) * scale;
								if (firstChar == "+".charCodeAt(0) || firstChar == "-".charCodeAt(0))
								{
									size = scaledSize + adjustment;
								}
								else
								{
									size = adjustment;
								}

								style += "font-size:" + size + "px;";
							}

							text = text.replace(fontText, "<span style='" + style + "'>");

							matchText = this.__regexFont.matchedRight();
						}

						text = text.replace(this.__regexCloseFont, "</span>");
					}

					text = text.replace("<p ", "<p style='margin-top:0; margin-bottom:0;' ");

					var unscaledLeading = (<internal.TextField><any>textField).__textFormat.leading;
					(<internal.TextField><any>textField).__textFormat.leading += Math.floor(adjustment);

					(<internal.TextField><any>textField).__div.innerHTML = new RegExp("\r\n", "g").replace(text, "<br>");
					(<internal.TextField><any>textField).__div.innerHTML = new RegExp("\n", "g").replace((<internal.TextField><any>textField).__div.innerHTML, "<br>");
					(<internal.TextField><any>textField).__div.innerHTML = new RegExp("\r", "g").replace((<internal.TextField><any>textField).__div.innerHTML, "<br>");

					style.setProperty("font", TextEngine.getFont((<internal.TextField><any>textField).__textFormat), null);

					(<internal.TextField><any>textField).__textFormat.size = unscaledSize;
					(<internal.TextField><any>textField).__textFormat.leading = unscaledLeading;

					style.setProperty("top", "3px", null);

					if (textEngine.border)
					{
						style.setProperty("border", "solid 1px #" + (textEngine.borderColor & 0xFFFFFF).toString(16), null);
						(<internal.DisplayObject><any>textField).__renderTransform.translate(-1, -1);
						(<internal.DisplayObject><any>textField).__renderTransformChanged = true;
						(<internal.DisplayObject><any>textField).__transformDirty = true;
					}
					else if (style.border != "")
					{
						style.removeProperty("border");
						(<internal.DisplayObject><any>textField).__renderTransformChanged = true;
					}

					style.setProperty("color", "#" + ((<internal.TextField><any>textField).__textFormat.color & 0xFFFFFF).toString(16), null);

					style.setProperty("width", w + "px", null);
					style.setProperty("height", h + "px", null);

					switch ((<internal.TextField><any>textField).__textFormat.align)
					{
						case TextFormatAlign.CENTER:
							style.setProperty("text-align", "center", null);
							break;

						case TextFormatAlign.RIGHT:
							style.setProperty("text-align", "right", null);
							break;

						default:
							style.setProperty("text-align", "left", null);
							break;
					}

					(<internal.TextField><any>textField).__dirty = false;
				}
				else
				{
					if ((<internal.TextField><any>textField).__div != null)
					{
						renderer.element.removeChild((<internal.TextField><any>textField).__div);
						(<internal.TextField><any>textField).__div = null;
					}
				}
			}

			if ((<internal.TextField><any>textField).__div != null)
			{
				// force roundPixels = true for TextFields
				// Chrome shows blurry text if coordinates are fractional

				var old = (<internal.DisplayObjectRenderer><any>renderer).__roundPixels;
				(<internal.DisplayObjectRenderer><any>renderer).__roundPixels = true;

				renderer.__updateClip(textField);
				renderer.__applyStyle(textField, true, true, true);

				(<internal.DisplayObjectRenderer><any>renderer).__roundPixels = old;
			}
		}
		else
		{
			this.clear(textField, renderer);
		}
	}

	private static __getAttributeMatch(regex: RegExp): string
	{
		return regex.matched(2) != null ? regex.matched(2) : regex.matched(3);
	}
}
