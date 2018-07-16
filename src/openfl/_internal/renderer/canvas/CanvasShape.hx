package openfl._internal.renderer.canvas;


import openfl.display.DisplayObject;
import openfl.geom.Matrix;

#if (js && html5)
import js.Browser;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class CanvasShape {
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CanvasGraphics.render (graphics, renderSession, shape.__renderTransform);
			
			var bounds = graphics.__bounds;
			var width = graphics.__width;
			var height = graphics.__height;
			
			if (graphics.__canvas != null) {
				
				var context = renderSession.context;
				var scrollRect = shape.__scrollRect;
				
				if (width > 0 && height > 0 && (scrollRect == null || (scrollRect.width > 0 && scrollRect.height > 0))) {
					
					renderSession.blendModeManager.setBlendMode (shape.__worldBlendMode);
					renderSession.maskManager.pushObject (shape);
					
					context.globalAlpha = shape.__worldAlpha;
					
					var transform = graphics.__worldTransform;
					var pixelRatio = renderSession.pixelRatio;
					var scale = 1; // As opposed of CanvasBitmap, canvases have the same pixelRatio as display, therefore we don't need to scale them and so scale is always 1
					
					if (renderSession.roundPixels) {
						
						context.setTransform (transform.a * scale, transform.b, transform.c, transform.d * scale, Math.round (transform.tx * pixelRatio), Math.round (transform.ty * pixelRatio));
						
					} else {
						
						context.setTransform (transform.a * scale, transform.b, transform.c, transform.d * scale, transform.tx * pixelRatio, transform.ty * pixelRatio);
						
					}
					
					
					context.drawImage (graphics.__canvas, 0, 0);
					
					renderSession.maskManager.popObject (shape);
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}