package openfl._internal.renderer.dom;


import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if (js && html5)
import js.Browser;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class DOMShape {
	
	
	public static function clear (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (shape.__canvas != null) {
			
			renderSession.element.removeChild (shape.__canvas);
			shape.__canvas = null;
			shape.__style = null;
			
		}
		#end
		
	}
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		var graphics = shape.__graphics;
		
		if (shape.stage != null && shape.__worldVisible && shape.__renderable && graphics != null) {
			
			CanvasGraphics.render (graphics, renderSession, shape.__renderTransform);
			
			if (graphics.__dirty || shape.__worldAlphaChanged || (shape.__canvas != graphics.__canvas)) {
				
				if (graphics.__canvas != null) {
					
					if (shape.__canvas != graphics.__canvas) {
						
						if (shape.__canvas != null) {
							
							renderSession.element.removeChild (shape.__canvas);
							
						}
						
						shape.__canvas = graphics.__canvas;
						shape.__context = graphics.__context;
						
						DOMRenderer.initializeElement (shape, shape.__canvas, renderSession);
						
					}
					
				} else {
					
					clear (shape, renderSession);
					
				}
				
			}
			
			if (shape.__canvas != null) {
				
				renderSession.maskManager.pushObject (shape);
				
				var cacheTransform = shape.__renderTransform;
				shape.__renderTransform = graphics.__worldTransform;
				
				if (graphics.__transformDirty) {
					
					graphics.__transformDirty = false;
					shape.__renderTransformChanged = true;
					
				}
				
				DOMRenderer.updateClip (shape, renderSession);
				DOMRenderer.applyStyle (shape, renderSession, true, true, true);
				
				shape.__renderTransform = cacheTransform;
				
				renderSession.maskManager.popObject (shape);
				
			}
			
		} else {
			
			clear (shape, renderSession);
			
		}
		#end
		
	}
	
	
}