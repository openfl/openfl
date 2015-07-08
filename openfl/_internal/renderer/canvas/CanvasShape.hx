package openfl._internal.renderer.canvas;


import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)


class CanvasShape {
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			//#if old
			CanvasGraphics.render (graphics, renderSession);
			//#else
			//CanvasGraphics.renderObjectGraphics (shape, renderSession);
			//#end
			
			if (graphics.__canvas != null) {
				
				var context = renderSession.context;
				var scrollRect = shape.scrollRect;
				
				context.globalAlpha = shape.__worldAlpha;
				var transform = shape.__renderMatrix;
				
				if (scrollRect != null) {
					
					renderSession.maskManager.pushRect (scrollRect, transform);
					
				}
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.pushMask (shape.__mask);
					
				}
				
				if (renderSession.roundPixels) {
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
					
				} else {
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
					
				}
				
				context.drawImage (graphics.__canvas, graphics.__bounds.x, graphics.__bounds.y);
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.popMask ();
					
				}
				
				if (scrollRect != null) {
					
					renderSession.maskManager.popRect ();
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}