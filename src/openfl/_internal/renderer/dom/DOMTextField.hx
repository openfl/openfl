package openfl._internal.renderer.dom;


import openfl._internal.renderer.RenderSession;
import openfl._internal.text.TextEngine;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

#if (js && html5)
import js.html.Element;
import js.Browser;
#end

@:access(openfl._internal.text.TextEngine)
@:access(openfl.text.TextField)


class DOMTextField {
	
	
	private static var __regexColor = ~/color=("#([^"]+)"|'#([^']+)')/i;
	private static var __regexFace = ~/face=("([^"]+)"|'([^']+)')/i;
	private static var __regexFont = ~/<font ([^>]+)>/gi;
	private static var __regexCloseFont = new EReg("</font>", "gi");
	private static var __regexSize = ~/size=("([^"]+)"|'([^']+)')/i;
	
	
	public static function clear (textField:TextField, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (textField.__div != null) {
			
			renderSession.element.removeChild (textField.__div);
			textField.__div = null;
			textField.__style = null;
			
		}
		#end
		
	}
	
	
	public static function measureText (textField:TextField):Void {
		
	 	#if (js && html5)
	 	
		var textEngine = textField.__textEngine;
		var div:Element = textField.__div;
		
		if (div == null) {
			
			div = cast Browser.document.createElement ("div");
			div.innerHTML = new EReg ("\n", "g").replace (textEngine.text, "<br>");
			div.style.setProperty ("font", TextEngine.getFont (textField.__textFormat), null);
			div.style.setProperty ("pointer-events", "none", null);
			div.style.position = "absolute";
			div.style.top = "110%"; // position off-screen!
			Browser.document.body.appendChild (div);
			
		}
		
		textEngine.__measuredWidth = div.clientWidth;
		
		// Now set the width so that the height is accurate as a
		// function of the flow within the width bounds...
		
		if (textField.__div == null) {
			
			div.style.width = Std.string (textEngine.width - 4) + "px";
			
		}
		
		textEngine.__measuredHeight = div.clientHeight;
		
		if (textField.__div == null) {
			
			Browser.document.body.removeChild (div);
			
		}
		
		#end
		
	}
	
	
	public static inline function render (textField:TextField, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		var textEngine = textField.__textEngine;
		
		if (textField.stage != null && textField.__worldVisible && textField.__renderable) {
			
			if (textField.__dirty || textField.__renderTransformChanged || textField.__div == null) {
				
				if (textEngine.text != "" || textEngine.background || textEngine.border || textEngine.type == INPUT) {
					
					if (textField.__div == null) {
						
						textField.__div = cast Browser.document.createElement ("div");
						DOMRenderer.initializeElement (textField, textField.__div, renderSession);
						textField.__style.setProperty ("outline", "none", null);
						
						textField.__div.addEventListener ("input", function (event) {
							
							event.preventDefault ();
							
							// TODO: Set caret index, and replace only selection
							
							if (textField.htmlText != textField.__div.innerHTML) {
								
								textField.htmlText = textField.__div.innerHTML;
								
								if (textField.__displayAsPassword) {
									
									// TODO: Enable display as password
									
								}
								
								textField.__dirty = false;
								
							}
							
						}, true);
						
					}
					
					if (!textEngine.wordWrap) {
						
						textField.__style.setProperty ("white-space", "nowrap", null);
						
					} else {
						
						textField.__style.setProperty ("word-wrap", "break-word", null);
						
					}
					
					textField.__style.setProperty ("overflow", "hidden", null);
					
					if (textEngine.selectable) {
						
						textField.__style.setProperty ("cursor", "text", null);
						textField.__style.setProperty ("-webkit-user-select", "text", null);
						textField.__style.setProperty ("-moz-user-select", "text", null);
						textField.__style.setProperty ("-ms-user-select", "text", null);
						textField.__style.setProperty ("-o-user-select", "text", null);
						
					} else {
						
						textField.__style.setProperty ("cursor", "inherit", null);
						
					}
					
					untyped (textField.__div).contentEditable = (textEngine.type == INPUT);
					
					var style = textField.__style;
					
					// TODO: Handle ranges using span
					// TODO: Vertical align
					
					//textField.__div.innerHTML = textEngine.text;
					
					if (textEngine.background) {
						
						style.setProperty ("background-color", "#" + StringTools.hex (textEngine.backgroundColor & 0xFFFFFF, 6), null);
						
					} else {
						
						style.removeProperty ("background-color");
						
					}
					
					var w = textEngine.width;
					var h = textEngine.height;
					var scale:Float = 1;
					var unscaledSize = textField.__textFormat.size;
					var scaledSize:Float = unscaledSize;
					
					var t = textField.__renderTransform;
					if (t.a != 1.0 || t.d != 1.0) {
						
						if (t.a == t.d) {
							scale = t.a;
							t.a = t.d = 1.0;
						} else if (t.a > t.d) {
							scale = t.a;
							t.d /= t.a;
							t.a = 1.0;
						} else {
							scale = t.d;
							t.a /= t.d;
							t.d = 1.0;
						}
						scaledSize *= scale;
						
					#if openfl_half_round_font_sizes
						
						var roundedFontSize = Math.fceil(scaledFontSize * 2) / 2;
						if (roundedFontSize > scaledFontSize) {
							
							var adjustment = (scaledFontSize / roundedFontSize);
							if (adjustment < 1 && (1 - adjustment) < 0.1) {
								t.a = 1;
								t.d = 1;
							} else {
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
					
					untyped textField.__textFormat.size = scaledSize;
					
					var text = textEngine.text;
					var adjustment:Float = 0;
					
					if (!textField.__isHTML) {
						
						text = StringTools.htmlEscape (text);
						
					} else {
						
						var matchText = text;
						while (__regexFont.match (matchText)) {
							
							var fontText = __regexFont.matched(0);
							var style = "";
							
							if (__regexFace.match (fontText)) {
								
								style += "font-family:'" +  __getAttributeMatch (__regexFace) + "';";
								
							}
							
							if (__regexColor.match (fontText)) {
								
								style += "color:#" +  __getAttributeMatch (__regexColor) + ";";
								
							}
							
							if (__regexSize.match (fontText)) {
								
								var sizeAttr = __getAttributeMatch (__regexSize);
								var firstChar = sizeAttr.charCodeAt (0);
								var size:Float;
								adjustment = Std.parseFloat (sizeAttr) * scale;
								if (firstChar == "+".code || firstChar == "-".code) {
									
									size = scaledSize + adjustment;
									
								} else {
									
									size = adjustment;
									
								}
								
								style += "font-size:" + size + "px;";
								
							}
							
							text = StringTools.replace( text, fontText, "<span style='" + style + "'>" );
							
							matchText = __regexFont.matchedRight();
						}
						
						text = __regexCloseFont.replace( text, "</span>" );
						
					}
					
					text = StringTools.replace( text, "<p ", "<p style='margin-top:0; margin-bottom:0;' " );
					
					var unscaledLeading = textField.__textFormat.leading;
					textField.__textFormat.leading += Std.int( adjustment );
					
					textField.__div.innerHTML = new EReg ("\r\n", "g").replace (text, "<br>");
					textField.__div.innerHTML = new EReg ("\n", "g").replace (textField.__div.innerHTML, "<br>");
					textField.__div.innerHTML = new EReg ("\r", "g").replace (textField.__div.innerHTML, "<br>");
					
					style.setProperty ("font", TextEngine.getFont (textField.__textFormat), null);
					
					textField.__textFormat.size = unscaledSize;
					textField.__textFormat.leading = unscaledLeading;
					
					style.setProperty ("top", "3px", null);
					
					if (textEngine.border) {
						
						style.setProperty ("border", "solid 1px #" + StringTools.hex (textEngine.borderColor & 0xFFFFFF, 6), null);
						textField.__renderTransform.translate (-1, -1);
						textField.__renderTransformChanged = true;
						textField.__transformDirty = true;
						
					} else if (style.border != "") {
						
						style.removeProperty ("border");
						textField.__renderTransformChanged = true;
						
					}
					
					style.setProperty ("color", "#" + StringTools.hex (textField.__textFormat.color & 0xFFFFFF, 6), null);
					
					style.setProperty ("width",  w + "px", null);
					style.setProperty ("height", h + "px", null);
					
					switch (textField.__textFormat.align) {
						
						case TextFormatAlign.CENTER:
							
							style.setProperty ("text-align", "center", null);
						
						case TextFormatAlign.RIGHT:
							
							style.setProperty ("text-align", "right", null);
						
						default:
							
							style.setProperty ("text-align", "left", null);
						
					}
					
					textField.__dirty = false;
					
				} else {
					
					if (textField.__div != null) {
						
						renderSession.element.removeChild (textField.__div);
						textField.__div = null;
						
					}
					
				}
				
			}
			
			if (textField.__div != null) {
				
				// force roundPixels = true for TextFields
				// Chrome shows blurry text if coordinates are fractional
				
				var old = renderSession.roundPixels;
				renderSession.roundPixels = true;
				
				DOMRenderer.updateClip (textField, renderSession);
				DOMRenderer.applyStyle (textField, renderSession, true, true, true);
				
				renderSession.roundPixels = old;
				
			}
			
		} else {
			
			clear (textField, renderSession);
			
		}
		
		#end
		
	}
	
	
	private static function __getAttributeMatch (regex:EReg):String {
		
		return regex.matched (2) != null ? regex.matched (2) : regex.matched (3);
		
	}
	
	
}