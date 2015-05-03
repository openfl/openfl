package openfl._internal.renderer.cairo;


import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)


class CairoShape {
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CairoGraphics.render (graphics, renderSession);
			
			if (graphics.__cairo != null) {
				
				//if (shape.__mask != null) {
					//
					//renderSession.maskManager.pushMask (shape.__mask);
					//
				//}
				
				var cairo = renderSession.cairo;
				var scrollRect = shape.scrollRect;
				
				//context.globalAlpha = shape.__worldAlpha;
				var transform = shape.__worldTransform;
				//
				//if (renderSession.roundPixels) {
					//
					//context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
					//
				//} else {
					//
					//context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
					//
				//}
				
				cairo.transform (@:privateAccess (shape.__worldTransform).__toMatrix3 ());
				cairo.setSourceSurface (graphics.__cairo.target, graphics.__bounds.x, graphics.__bounds.y);
				cairo.paint ();
				
				//
				//if (scrollRect == null) {
					//
					//context.drawImage (graphics.__canvas, graphics.__bounds.x, graphics.__bounds.y);
					//
				//} else {
					//
					//context.drawImage (graphics.__canvas, scrollRect.x - graphics.__bounds.x, scrollRect.y - graphics.__bounds.y, scrollRect.width, scrollRect.height, graphics.__bounds.x + scrollRect.x, graphics.__bounds.y + scrollRect.y, scrollRect.width, scrollRect.height);
					//
				//}
				//
				//if (shape.__mask != null) {
					//
					//renderSession.maskManager.popMask ();
					//
				//}
				
			}
			
		}
		
	}
	
	
}