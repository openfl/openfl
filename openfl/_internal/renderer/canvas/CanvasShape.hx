package openfl._internal.renderer.canvas;


import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)


class CanvasShape {
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if js
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			//#if old
			CanvasGraphics.render (graphics, renderSession);
			//#else
			//CanvasGraphics.renderObjectGraphics (shape, renderSession);
			//#end
			
			if (graphics.__canvas != null) {
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.pushMask (shape.__mask);
					
				}
				
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
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.popMask ();
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}