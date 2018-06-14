package openfl._internal.renderer.canvas;


import openfl.display.CanvasRenderer;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;

#if (js && html5)
import js.Browser;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class CanvasShape {
	
	
	public static inline function render (shape:DisplayObject, renderer:CanvasRenderer):Void {
		
		#if (js && html5)
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CanvasGraphics.render (graphics, renderer);
			
			var bounds = graphics.__bounds;
			var width = graphics.__width;
			var height = graphics.__height;
			
			if (graphics.__canvas != null) {
				
				var context = renderer.context;
				var scrollRect = shape.__scrollRect;
				
				if (width > 0 && height > 0 && (scrollRect == null || (scrollRect.width > 0 && scrollRect.height > 0))) {
					
					renderer.__setBlendMode (shape.__worldBlendMode);
					renderer.__pushMaskObject (shape);
					
					context.globalAlpha = shape.__worldAlpha;
					renderer.setTransform (graphics.__worldTransform, context);
					
					if (renderer.__isDOM) {
						
						var reverseScale = 1 / renderer.pixelRatio;
						context.scale (reverseScale, reverseScale);
						
					}
					
					context.drawImage (graphics.__canvas, 0, 0, width, height);
					
					renderer.__popMaskObject (shape);
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}