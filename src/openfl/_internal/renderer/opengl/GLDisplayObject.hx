package openfl._internal.renderer.opengl;


import lime.math.color.ARGB;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLDisplayObject {
	
	
	public static inline function render (displayObject:DisplayObject, renderSession:RenderSession):Void {
		
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;
		
		if (displayObject.opaqueBackground != null && !displayObject.__cacheBitmapRender && displayObject.width > 0 && displayObject.height > 0) {
			
			renderSession.blendModeManager.setBlendMode (displayObject.__worldBlendMode);
			renderSession.maskManager.pushObject (displayObject);
			
			var gl = renderSession.gl;
			
			var rect = Rectangle.__pool.get ();
			rect.setTo (0, 0, displayObject.width, displayObject.height);
			renderSession.maskManager.pushRect (rect, displayObject.__renderTransform);
			
			var color:ARGB = (displayObject.opaqueBackground:ARGB);
			gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1);
			gl.clear (gl.COLOR_BUFFER_BIT);
			
			renderSession.maskManager.popRect ();
			renderSession.maskManager.popObject (displayObject);
			
			Rectangle.__pool.release (rect);
			
		}
		
		if (displayObject.__graphics != null) {
			
			GLShape.render (displayObject, renderSession);
			
		}
		
	}
	
	
	public static inline function renderMask (displayObject:DisplayObject, renderSession:RenderSession):Void {
		
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		
		if (displayObject.opaqueBackground != null && !displayObject.__cacheBitmapRender && displayObject.width > 0 && displayObject.height > 0) {
			
			var gl = renderSession.gl;
			
			// TODO
			
			// var rect = Rectangle.__pool.get ();
			// rect.setTo (0, 0, displayObject.width, displayObject.height);
			// renderSession.maskManager.pushRect (rect, displayObject.__renderTransform);
			
			// var color:ARGB = (displayObject.opaqueBackground:ARGB);
			// gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1);
			// gl.clear (gl.COLOR_BUFFER_BIT);
			
			// renderSession.maskManager.popRect ();
			// renderSession.maskManager.popObject (displayObject);
			
			// Rectangle.__pool.release (rect);
			
		}
		
		if (displayObject.__graphics != null) {
			
			GLShape.renderMask (displayObject, renderSession);
			
		}
		
	}
	
	
}