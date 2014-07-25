package openfl._internal.renderer.dom;


import openfl._internal.renderer.RenderSession;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;

#if js
import js.Browser;
#end

@:access(openfl.text.TextField)


class DOMTextField {
	
	
	public static inline function render (textField:TextField, renderSession:RenderSession):Void {
		
		#if js
		
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
					
					style.setProperty ("font", textField.__getFont (textField.__textFormat), null);
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