package openfl._internal.renderer.dom;


import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;

#if (js && html5)
import js.Browser;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)


class DOMShape {
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		var graphics = shape.__graphics;
		
		if (shape.stage != null && shape.__worldVisible && shape.__renderable && graphics != null) {
			
			if (graphics.__dirty || shape.__worldAlphaChanged || (shape.__canvas == null && graphics.__canvas != null)) {
				
				if (graphics.__drawTilesMode) {
					var m = shape.__worldTransform.clone();
					var p = m.deltaTransformPoint(new openfl.geom.Point(m.tx, m.ty));
					m.translate(-p.x, -p.y);
					m.invert();
					
					p = m.transformPoint(new openfl.geom.Point(graphics.__bounds.width, graphics.__bounds.height));
					graphics.__bounds.width = p.x;
					graphics.__bounds.height = p.y;
					
					graphics.__bounds.x -= shape.__worldTransform.tx;
					graphics.__bounds.y -= shape.__worldTransform.ty;
					graphics.__drawTilesMode = false;
				}
				
				//#if old
				CanvasGraphics.render (graphics, renderSession);
				//#else
				//CanvasGraphics.renderObjectGraphics (shape, renderSession);
				//#end
				
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
				
				if (shape.__worldTransformChanged || graphics.__transformDirty) {
					
					graphics.__transformDirty = false;
					
					var transform = new Matrix ();
					transform.translate (graphics.__bounds.x, graphics.__bounds.y);
					transform = transform.mult (shape.__worldTransform);
					
					shape.__style.setProperty (renderSession.transformProperty, transform.to3DString (renderSession.roundPixels), null);
					
				}
				
				DOMRenderer.applyStyle (shape, renderSession, false, false, true);
				
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
