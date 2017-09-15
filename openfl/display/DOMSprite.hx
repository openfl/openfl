package openfl.display;


#if !flash
import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.RenderSession;
#end

import openfl.display.Sprite;
import openfl.display.Stage;

#if (js && html5)
import js.html.Element;
#end


@:replacementPlanned class DOMSprite extends Sprite {
	
	
	private var __active:Bool;
	private var __element:#if (js && html5) Element #else Dynamic #end;
	
	
	public function new (element:#if (js && html5) Element #else Dynamic #end) {
		
		super ();
		
		__element = element;
		
	}
	
	
	#if !flash
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (stage != null && __worldVisible && __renderable) {
			
			if (!__active) {
				
				DOMRenderer.initializeElement (this, __element, renderSession);
				__active = true;
				
			}
			
			DOMRenderer.updateClip (this, renderSession);
			DOMRenderer.applyStyle (this, renderSession, true, true, true);
			
		} else {
			
			if (__active) {
				
				renderSession.element.removeChild (__element);
				__active = false;
				
			}
			
		}
		
		super.__renderDOM (renderSession);
		#end
		
	}
	#end
	
	
}