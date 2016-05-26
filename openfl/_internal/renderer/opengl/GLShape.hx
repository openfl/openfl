package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.filters.ShaderFilter;
import openfl.geom.Matrix;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class GLShape {
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		var gl = renderSession.gl;
		
		if (graphics != null) {
			
			#if (js && html5)
			CanvasGraphics.render (graphics, renderSession);
			#elseif lime_cairo
			CairoGraphics.render (graphics, renderSession);
			#end
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null && graphics.__visible && bounds != null && bounds.width >= 1 && bounds.height >= 1) {
				
				var shader;
				
				if (shape.filters != null && Std.is (shape.filters[0], ShaderFilter)) {
					
					shader = cast (shape.filters[0], ShaderFilter).shader;
					
				} else {
					
					shader = renderSession.shaderManager.defaultShader;
					
				}
				
				renderSession.blendModeManager.setBlendMode (shape.blendMode);
				renderSession.shaderManager.setShader (shader);
				
				var renderer:GLRenderer = cast renderSession.renderer;
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.pushMask (shape.__mask);
					
				}
				
				var scrollRect = shape.scrollRect;
				
				if (scrollRect != null) {
					
					renderSession.maskManager.pushRect (scrollRect, shape.__worldTransform);
					
				}
				
				var transform = Matrix.__temp;
				transform.identity ();
				transform.tx = bounds.x;
				transform.ty = bounds.y;
				transform.concat (shape.__worldTransform);
				
				gl.uniform1f (shader.data.uAlpha.index, shape.__worldAlpha);
				gl.uniformMatrix4fv (shader.data.uMatrix.index, false, renderer.getMatrix (transform));
				
				gl.bindTexture (gl.TEXTURE_2D, graphics.__bitmap.getTexture (gl));
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				
				gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl));
				gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
				
				if (scrollRect != null) {
					
					renderSession.maskManager.popRect ();
					
				}
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.popMask ();
					
				}
				
			}
			
		}
		
	}
	
	
}