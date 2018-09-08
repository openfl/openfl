package openfl._internal.renderer.dom;


import lime.math.ARGB;
import openfl.display.DisplayObject;
import openfl.display.DOMRenderer;

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)


class DOMDisplayObject {
	
	
	public static function clear (displayObject:DisplayObject, renderer:DOMRenderer):Void {
		
		#if (js && html5)
		DOMShape.clear (displayObject, renderer);
		#end
		
	}
	
	
	public static inline function render (displayObject:DisplayObject, renderer:DOMRenderer):Void {
		
		#if (js && html5)
		
		//if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		//if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;
		
		if (displayObject.opaqueBackground != null && !displayObject.__isCacheBitmapRender && displayObject.width > 0 && displayObject.height > 0) {
			
			//renderer.__pushMaskObject (displayObject);
			
			// TODO: opaqueBackground using DIV element
			
			//renderer.__popMaskObject (displayObject);
			
		}
		
		DOMShape.render (displayObject, renderer);
		#end
		
	}
	
	
}