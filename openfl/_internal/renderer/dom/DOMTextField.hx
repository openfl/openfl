package openfl._internal.renderer.dom;


import openfl._internal.renderer.RenderSession;
import openfl._internal.text.TextEngine;
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
	
	
	public static function measureText (textEngine:TextEngine):Void {
		
	 	#if (js && html5)
	 	
		var div:Element = textEngine.__div;
		
		if (div == null) {
			
			div = cast Browser.document.createElement ("div");
			div.innerHTML = new EReg ("\n", "g").replace (textEngine.text, "<br>");
			div.style.setProperty ("font", getFont (textEngine.__textFormat), null);
			div.style.setProperty ("pointer-events", "none", null);
			div.style.position = "absolute";
			div.style.top = "110%"; // position off-screen!
			Browser.document.body.appendChild (div);
			
		}
		
		textEngine.__measuredWidth = div.clientWidth;
		
		// Now set the width so that the height is accurate as a
		// function of the flow within the width bounds...
		
		if (textEngine.__div == null) {
			
			div.style.width = Std.string (textEngine.width - 4) + "px";
			
		}
		
		textEngine.__measuredHeight = div.clientHeight;
		
		if (textEngine.__div == null) {
			
			Browser.document.body.removeChild (div);
			
		}
		
		#end
		
	}
	
	
	public static inline function render (textEngine:TextEngine, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		if (textEngine.textField.stage != null && textEngine.textField.__worldVisible && textEngine.textField.__renderable) {
			
			if (textEngine.__dirty || textEngine.__div == null) {
				
				if (textEngine.text != "" || textEngine.background || textEngine.border) {
					
					if (textEngine.__div == null) {
						
						textEngine.__div = cast Browser.document.createElement ("div");
						DOMRenderer.initializeElement (textEngine.textField, textEngine.__div, renderSession);
						textEngine.textField.__style.setProperty ("cursor", "inherit", null);
						
					}
					
					var style = textEngine.textField.__style;
					
					// TODO: Handle ranges using span
					// TODO: Vertical align
					
					textEngine.__div.innerHTML = textEngine.text;
					
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
					
					style.setProperty ("font", getFont (textEngine.__textFormat), null);
					style.setProperty ("color", "#" + StringTools.hex (textEngine.__textFormat.color, 6), null);
					
					if (textEngine.autoSize != TextFieldAutoSize.NONE) {
						
						style.setProperty ("width", "auto", null);
						
					} else {
						
						style.setProperty ("width", textEngine.width + "px", null);
						
					}
					
					style.setProperty ("height", textEngine.height + "px", null);
					
					switch (textEngine.__textFormat.align) {
						
						case TextFormatAlign.CENTER:
							
							style.setProperty ("text-align", "center", null);
						
						case TextFormatAlign.RIGHT:
							
							style.setProperty ("text-align", "right", null);
						
						default:
							
							style.setProperty ("text-align", "left", null);
						
					}
					
					textEngine.__dirty = false;
					
				} else {
					
					if (textEngine.__div != null) {
						
						renderSession.element.removeChild (textEngine.__div);
						textEngine.__div = null;
						
					}
					
				}
				
			}
			
			if (textEngine.__div != null) {
				
				// TODO: Enable scrollRect clipping
				
				DOMRenderer.applyStyle (textEngine.textField, renderSession, true, true, false);
				
			}
			
		} else {
			
			if (textEngine.__div != null) {
				
				renderSession.element.removeChild (textEngine.__div);
				textEngine.__div = null;
				textEngine.textField.__style = null;
				
			}
			
		}
		
		#end
		
	}
	
	
}