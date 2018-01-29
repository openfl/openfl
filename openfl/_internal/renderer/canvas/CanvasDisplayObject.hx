package openfl._internal.renderer.canvas;


import lime.math.color.ARGB;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;


@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class CanvasDisplayObject {

	public static inline function render (displayObject:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		var gBounds:Rectangle = null;

		if (displayObject.__graphics.__bounds != null && renderSession.renderer != null) {
			gBounds = displayObject.__graphics.__bounds.clone();
			if (gBounds.width == 0 || gBounds.height == 0) {
				gBounds = null;
			}
			else {
				gBounds.__transform(gBounds, displayObject.__worldTransform);
			}
		}

		// Bail on rendering if bounds are completely offscreen
		if (gBounds != null && !gBounds.intersects(renderSession.renderer.viewport)) {
			return;
		}
		
		if (displayObject.opaqueBackground != null && !displayObject.__cacheBitmapRender) {
			
			renderSession.blendModeManager.setBlendMode (displayObject.__worldBlendMode);
			renderSession.maskManager.pushObject (displayObject);
			
			var context = renderSession.context;
			var transform = displayObject.__renderTransform;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
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