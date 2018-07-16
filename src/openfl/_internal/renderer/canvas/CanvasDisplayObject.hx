package openfl._internal.renderer.canvas;


import lime.math.color.ARGB;
import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)


class CanvasDisplayObject {
	
	
	public static inline function render (displayObject:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;
		
		if (displayObject.opaqueBackground != null && !displayObject.__cacheBitmapRender && displayObject.width > 0 && displayObject.height > 0) {
			
			renderSession.blendModeManager.setBlendMode (displayObject.__worldBlendMode);
			renderSession.maskManager.pushObject (displayObject);
			
			var context = renderSession.context;
			var transform = displayObject.__renderTransform;
			var pixelRatio = renderSession.pixelRatio;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a * pixelRatio, transform.b, transform.c, transform.d * pixelRatio, Math.round (transform.tx * pixelRatio), Math.round (transform.ty * pixelRatio));
				
			} else {
				
				context.setTransform (transform.a * pixelRatio, transform.b, transform.c, transform.d * pixelRatio, transform.tx * pixelRatio, transform.ty * pixelRatio);
				
			}
			
			var color:ARGB = (displayObject.opaqueBackground:ARGB);
			context.fillStyle = 'rgb(${color.r},${color.g},${color.b})';
			context.fillRect (0, 0, displayObject.width, displayObject.height);
			
			renderSession.maskManager.popObject (displayObject);
			
		}
		
		if (displayObject.__graphics != null) {
			
			CanvasShape.render (displayObject, renderSession);
			
		}
		#end
		
	}
	
	
}