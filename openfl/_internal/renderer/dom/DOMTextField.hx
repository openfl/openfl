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
			
			if (textField.__dirty || textField.__div == null) {
				
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
								textField.__dirty = false;
								
							}
							
						}, true);
						
					}
					
					if (textEngine.selectable) {
						
						textField.__style.setProperty ("cursor", "text", null);
						
					} else {
						
						textField.__style.setProperty ("cursor", "inherit", null);
						
					}
					
					untyped (textField.__div).contentEditable = (textEngine.type == INPUT);
					
					var style = textField.__style;
					
					// TODO: Handle ranges using span
					// TODO: Vertical align
					
					textField.__div.innerHTML = textEngine.text;
					
					if (textEngine.background) {
						
						style.setProperty ("background-color", "#" + StringTools.hex (textEngine.backgroundColor, 6), null);
						
					} else {
						
						style.removeProperty ("background-color");
						
					}
					
					if (textEngine.border) {
						
						style.setProperty ("border", "solid 1px #" + StringTools.hex (textEngine.borderColor, 6), null);
						
					} else {
						
						style.removeProperty ("border");
						
					}
					
					style.setProperty ("font", TextEngine.getFont (textField.__textFormat), null);
					style.setProperty ("color", "#" + StringTools.hex (textField.__textFormat.color, 6), null);
					
					if (textEngine.autoSize != TextFieldAutoSize.NONE) {
						
						style.setProperty ("width", "auto", null);
						
					} else {
						
						style.setProperty ("width", textEngine.width + "px", null);
						
					}
					
					style.setProperty ("height", textEngine.height + "px", null);
					
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
				
				// TODO: Enable scrollRect clipping
				
				DOMRenderer.applyStyle (textField, renderSession, true, true, false);
				
			}
			
		} else {
			
			if (textField.__div != null) {
				
				renderSession.element.removeChild (textField.__div);
				textField.__div = null;
				textField.__style = null;
				
			}
			
		}
		
		#end
		
	}
	
	
}