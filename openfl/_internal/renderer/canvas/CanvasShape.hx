package openfl._internal.renderer.canvas;


import openfl.display.DisplayObject;
import openfl.geom.Matrix;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class CanvasShape {
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CanvasGraphics.render (graphics, renderSession, shape.__worldTransform);
			
			var bounds = graphics.__bounds;
			var width = graphics.__width;
			var height = graphics.__height;
			
			if (graphics.__canvas != null) {
				
				var context = renderSession.context;
				var scrollRect = shape.scrollRect;
				
				if (width > 0 && height > 0 && (scrollRect == null || (scrollRect.width > 0 && scrollRect.height > 0))) {
					
					renderSession.maskManager.pushObject (shape);
					
					context.globalAlpha = shape.__worldAlpha;
					
					var transform = graphics.__worldTransform;
					
					if (renderSession.roundPixels) {
						
						context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
						
					} else {
						
						context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
						
					}
					
					context.drawImage (graphics.__canvas, graphics.__bounds.x, graphics.__bounds.y);
					
					renderSession.maskManager.popObject (shape);
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}