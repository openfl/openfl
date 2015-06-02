package openfl._internal.renderer.cairo;


import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class CairoShape {
	
	
	public static function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if lime_cairo
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CairoGraphics.render (graphics, renderSession);
			
			if (graphics.__cairo != null) {
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.pushMask (shape.__mask);
					
				}
				
				var cairo = renderSession.cairo;
				var scrollRect = shape.scrollRect;
				var transform = shape.__worldTransform;
				
				if (renderSession.roundPixels) {
					
					var matrix = transform.__toMatrix3 ();
					matrix.tx = Math.round (matrix.tx);
					matrix.ty = Math.round (matrix.ty);
					cairo.matrix = matrix;
					
				} else {
					
					cairo.matrix = transform.__toMatrix3 ();
					
				}
				
				cairo.setSourceSurface (graphics.__cairo.target, graphics.__bounds.x, graphics.__bounds.y);
				
				if (scrollRect != null) {
					
					cairo.pushGroup ();
					cairo.newPath ();
					cairo.rectangle (graphics.__bounds.x + scrollRect.x, graphics.__bounds.y + scrollRect.y, scrollRect.width, scrollRect.height);
					cairo.fill ();
					cairo.popGroupToSource ();
					
				}
				
				cairo.paintWithAlpha (shape.__worldAlpha);
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.popMask ();
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}