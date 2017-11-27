package openfl._internal.renderer.canvas;


import lime.math.color.ARGB;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;


@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class CanvasDisplayObject {

	public static inline function render (displayObject:DisplayObject, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		// Bail on rendering if bounds are completely offscreen
		var gBounds:Rectangle = displayObject.__graphics.__bounds;
		var rX : Float = gBounds == null ? Math.NaN : displayObject.__worldTransform.tx + gBounds.x;
		var rY : Float = gBounds == null ? Math.NaN : displayObject.__worldTransform.ty + gBounds.y;
		if ((!Math.isNaN(rX) && !Math.isNaN(rY)) && (rX < 0 && (rX * -1) > gBounds.width) || (rY < 0 && (rY * -1) > gBounds.height) || (renderSession.renderer != null && (rX > renderSession.renderer.width || rY > renderSession.renderer.height)) )
		{
			return;
		}
		
		if (displayObject.opaqueBackground != null && !displayObject.__cacheBitmapRender && displayObject.width > 0 && displayObject.height > 0) {
			
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