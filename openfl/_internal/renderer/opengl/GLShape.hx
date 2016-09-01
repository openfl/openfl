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
			CanvasGraphics.render (graphics, renderSession, shape.__worldTransform);
			#elseif lime_cairo
			CairoGraphics.render (graphics, renderSession, shape.__worldTransform);
			#end
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null && graphics.__visible) {
				
				var shader;
				
				if (shape.__filters != null && Std.is (shape.__filters[0], ShaderFilter)) {
					
					shader = cast (shape.__filters[0], ShaderFilter).shader;
					
				} else {
					
					shader = renderSession.shaderManager.defaultShader;
					
				}
				
				renderSession.blendModeManager.setBlendMode (shape.blendMode);
				renderSession.shaderManager.setShader (shader);
				renderSession.maskManager.pushObject (shape);
				
				var renderer:GLRenderer = cast renderSession.renderer;
				
				gl.enableVertexAttribArray (shader.data.aAlpha.index);
				gl.uniformMatrix4fv (shader.data.uMatrix.index, false, renderer.getMatrix (graphics.__worldTransform));
				
				gl.bindTexture (gl.TEXTURE_2D, graphics.__bitmap.getTexture (gl));
				
				if (renderSession.allowSmoothing) {
					
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
					
				} else {
					
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
					
				}
				
				gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl, shape.__worldAlpha));
				gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
				
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
				
				renderSession.maskManager.popObject (shape);
				
			}
			
		}
		
	}
	
	
}