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
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		var graphics = shape.__graphics;
		
		if (shape.stage != null && shape.__worldVisible && shape.__renderable && graphics != null) {
			
			CanvasGraphics.render (graphics, renderSession, shape.__renderTransform);
			
			if (graphics.__dirty || shape.__worldAlphaChanged || (shape.__canvas == null && graphics.__canvas != null)) {
				
				if (graphics.__canvas != null) {
					
					if (shape.__canvas == null) {
						
						shape.__canvas = cast Browser.document.createElement ("canvas");
						shape.__context = shape.__canvas.getContext ("2d");
						DOMRenderer.initializeElement (shape, shape.__canvas, renderSession);
						
					}
					
					shape.__canvas.width = graphics.__canvas.width;
					shape.__canvas.height = graphics.__canvas.height;
					
					shape.__context.globalAlpha = shape.__worldAlpha;
					shape.__context.drawImage (graphics.__canvas, 0, 0);
					
				} else {
					
					if (shape.__canvas != null) {
						
						renderSession.element.removeChild (shape.__canvas);
						shape.__canvas = null;
						shape.__style = null;
						
					}
					
				}
				
			}
			
			if (shape.__canvas != null) {
				
				renderSession.maskManager.pushObject (shape);
				
				if (shape.__renderTransformChanged || graphics.__transformDirty) {
					
					graphics.__transformDirty = false;
					shape.__style.setProperty (renderSession.transformProperty, graphics.__worldTransform.to3DString (renderSession.roundPixels), null);
					
				}
				
				var domMaskManager:DOMMaskManager = cast renderSession.maskManager;
				var currentClipRect = domMaskManager.currentClipRect;
				
				if (currentClipRect == null) {
					
					shape.__style.removeProperty ("clip");
					
				} else {
					
					var clip = Rectangle.__temp;
					var matrix = Matrix.__temp;
					
					matrix.copyFrom (graphics.__worldTransform);
					matrix.invert ();
					
					currentClipRect.__transform (clip, matrix);
					
					shape.__style.setProperty ("clip", "rect(" + clip.y + "px, " + clip.right + "px, " + clip.bottom + "px, " + clip.x + "px)", null);
					
				}
				
				DOMRenderer.applyStyle (shape, renderSession, false, false, false);
				
				renderSession.maskManager.popObject (shape);
				
			}
			
		} else {
			
			if (shape.__canvas != null) {
				
				renderSession.element.removeChild (shape.__canvas);
				shape.__canvas = null;
				shape.__style = null;
				
			}
			
		}
		#end
		
	}
	
	
}