package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.filters.ShaderFilter;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Stage)


class GLBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		var gl = renderSession.gl;
		
		if (bitmap.bitmapData != null && bitmap.bitmapData.__isValid) {
			
			var shader;
			
			if (bitmap.filters != null && Std.is (bitmap.filters[0], ShaderFilter)) {
				
				shader = cast (bitmap.filters[0], ShaderFilter).shader;
				
			} else {
				
				shader = renderSession.shaderManager.defaultShader;
				
			}
			
			renderSession.blendModeManager.setBlendMode (bitmap.blendMode);
			renderSession.shaderManager.setShader (shader);
			
			var renderer:GLRenderer = cast renderSession.renderer;
			
			if (bitmap.__mask != null) {
				
				renderSession.maskManager.pushMask (bitmap.__mask);
				
			}
			
			var scrollRect = bitmap.scrollRect;
			
			if (scrollRect != null) {
				
				renderSession.maskManager.pushRect (scrollRect, bitmap.__worldTransform);
				
			}
			
			gl.uniform1f (shader.data.uAlpha.index, bitmap.__worldAlpha);
			gl.uniformMatrix4fv (shader.data.uMatrix.index, false, renderer.getMatrix (bitmap.__worldTransform));
			
			gl.bindTexture (gl.TEXTURE_2D, bitmap.bitmapData.getTexture (gl));
			
			if (bitmap.smoothing || bitmap.stage.__displayMatrix.a != 1 || bitmap.stage.__displayMatrix.d != 1) {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				
			} else {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
				
			}
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.bitmapData.getBuffer (gl));
			gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			if (scrollRect != null) {
				
				renderSession.maskManager.popRect ();
				
			}
			
			if (bitmap.__mask != null) {
				
				renderSession.maskManager.popMask ();
				
			}
			
		}
		
	}
	
	
}