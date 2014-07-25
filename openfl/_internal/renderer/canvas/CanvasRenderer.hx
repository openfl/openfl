package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.display.Shape;

@:access(openfl.display.Graphics)
@:access(openfl.display.Shape)


class CanvasRenderer {
	
	
	public static inline function renderShape (shape:Shape, renderSession:RenderSession):Void {
		
		#if js
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CanvasGraphics.render (graphics, renderSession);
			
			if (graphics.__canvas != null) {
				
				var context = renderSession.context;
				var scrollRect = shape.scrollRect;
				
				context.globalAlpha = shape.__worldAlpha;
				var transform = shape.__worldTransform;
				
				if (renderSession.roundPixels) {
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
					
				} else {
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
					
				}
				
				if (scrollRect == null) {
					
					context.drawImage (graphics.__canvas, graphics.__bounds.x, graphics.__bounds.y);
					
				} else {
					
					context.drawImage (graphics.__canvas, scrollRect.x - graphics.__bounds.x, scrollRect.y - graphics.__bounds.y, scrollRect.width, scrollRect.height, graphics.__bounds.x + scrollRect.x, graphics.__bounds.y + scrollRect.y, scrollRect.width, scrollRect.height);
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}