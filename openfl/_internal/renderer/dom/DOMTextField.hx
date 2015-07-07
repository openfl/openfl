package openfl._internal.renderer.dom;


import openfl._internal.renderer.RenderSession;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

#if (js && html5)
import js.html.Element;
import js.Browser;
#end

@:access(openfl.text.TextField)


class DOMTextField {
	
	
	public static function getFont (format:TextFormat):String {
		
		var font = format.italic ? "italic " : "normal ";
		font += "normal ";
		font += format.bold ? "bold " : "normal ";
		font += format.size + "px";
		font += "/" + (format.size + format.leading + 6) + "px ";
		
		font += "" + switch (format.font) {
			
			case "_sans": "sans-serif";
			case "_serif": "serif";
			case "_typewriter": "monospace";
			default: "'" + format.font + "'";
			
		}
		
		return font;
		
	}
	
	
	public static function measureText (textField:TextField):Void {
		
	 	#if (js && html5)
	 	
		var div:Element = textField.__div;
		
		if (div == null) {
			
			div = cast Browser.document.createElement ("div");
			div.innerHTML = new EReg ("\n", "g").replace (textField.__text, "<br>");
			div.style.setProperty ("font", getFont (textField.__textFormat), null);
			div.style.setProperty ("pointer-events", "none", null);
			div.style.position = "absolute";
			div.style.top = "110%"; // position off-screen!
			Browser.document.body.appendChild (div);
			
		}
		
		textField.__measuredWidth = div.clientWidth;
		
		// Now set the width so that the height is accurate as a
		// function of the flow within the width bounds...
		
		if (textField.__div == null) {
			
			div.style.width = Std.string (textField.__width - 4) + "px";
			
		}
		
		textField.__measuredHeight = div.clientHeight;
		
		if (textField.__div == null) {
			
			Browser.document.body.removeChild (div);
			
		}
		
		#end
		
	}
	
	
	public static inline function render (textField:TextField, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		if (textField.stage != null && textField.__worldVisible && textField.__renderable) {
			
			if (textField.__dirty || textField.__div == null) {
				
				if (textField.__text != "" || textField.background || textField.border) {
					
					if (textField.__div == null) {
						
						textField.__div = cast Browser.document.createElement ("div");
						DOMRenderer.initializeElement (textField, textField.__div, renderSession);
						textField.__style.setProperty ("cursor", "inherit", null);
						
					}
					
					var style = textField.__style;
					
					// TODO: Handle ranges using span
					// TODO: Vertical align
					
					textField.__div.innerHTML = textField.__text;
					
					if (textField.background) {
						
						style.setProperty ("background-color", "#" + StringTools.hex (textField.backgroundColor, 6), null);
						
					} else {
						
						style.removeProperty ("background-color");
						
					}
					
					if (textField.border) {
						
						style.setProperty ("border", "solid 1px #" + StringTools.hex (textField.borderColor, 6), null);
						
					} else {
						
						style.removeProperty ("border");
						
					}
					
					style.setProperty ("font", getFont (textField.__textFormat), null);
					style.setProperty ("color", "#" + StringTools.hex (textField.__textFormat.color, 6), null);
					
					if (textField.autoSize != TextFieldAutoSize.NONE) {
						
						style.setProperty ("width", "auto", null);
						
					} else {
						
						style.setProperty ("width", textField.__width + "px", null);
						
					}
					
					style.setProperty ("height", textField.__height + "px", null);
					
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