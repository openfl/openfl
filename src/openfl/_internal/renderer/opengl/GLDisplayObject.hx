package openfl._internal.renderer.opengl;


import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
import openfl.geom.Rectangle;

#if (lime >= "7.0.0")
import lime.math.ARGB;
#else
import lime.math.color.ARGB;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLDisplayObject {
	
	
	public static inline function render (displayObject:DisplayObject, renderer:OpenGLRenderer):Void {
		
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;
		
		if (displayObject.opaqueBackground != null && !displayObject.__isCacheBitmapRender && displayObject.width > 0 && displayObject.height > 0) {
			
			renderer.__setBlendMode (displayObject.__worldBlendMode);
			renderer.__pushMaskObject (displayObject);
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl = renderer.__context;
			#end
			
			var rect = Rectangle.__pool.get ();
			rect.setTo (0, 0, displayObject.width, displayObject.height);
			renderer.__pushMaskRect (rect, displayObject.__renderTransform);
			
			var color:ARGB = (displayObject.opaqueBackground:ARGB);
			gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1);
			gl.clear (gl.COLOR_BUFFER_BIT);
			
			renderer.__popMaskRect ();
			renderer.__popMaskObject (displayObject);
			
			Rectangle.__pool.release (rect);
			
		}
		
		if (displayObject.__graphics != null) {
			
			GLShape.render (displayObject, renderer);
			
		}
		
	}
	
	
	public static inline function renderMask (displayObject:DisplayObject, renderer:OpenGLRenderer):Void {
		
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		
		if (displayObject.opaqueBackground != null && !displayObject.__isCacheBitmapRender && displayObject.width > 0 && displayObject.height > 0) {
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl = renderer.__context;
			#end
			
			// TODO
			
			// var rect = Rectangle.__pool.get ();
			// rect.setTo (0, 0, displayObject.width, displayObject.height);
			// renderer.__pushMaskRect (rect, displayObject.__renderTransform);
			
			// var color:ARGB = (displayObject.opaqueBackground:ARGB);
			// gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1);
			// gl.clear (gl.COLOR_BUFFER_BIT);
			
			// renderer.__popMaskRect ();
			// renderer.__popMaskObject (displayObject);
			
			// Rectangle.__pool.release (rect);
			
		}
		
		if (displayObject.__graphics != null) {
			
			GLShape.renderMask (displayObject, renderer);
			
		}
		
	}
	
	
}