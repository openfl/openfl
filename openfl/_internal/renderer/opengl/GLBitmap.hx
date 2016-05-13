package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class GLBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		var gl = renderSession.gl;
		
		if (bitmap.bitmapData != null && bitmap.bitmapData.__isValid) {
			
			var shader:GLShader = cast renderSession.shaderManager.defaultShader;
			
			renderSession.blendModeManager.setBlendMode (bitmap.blendMode);
			renderSession.shaderManager.setShader (shader);
			
			var renderer:GLRenderer = cast renderSession.renderer;
			
			if (bitmap.__mask != null) {
				
				renderSession.maskManager.pushMask (bitmap.__mask);
				
			}
			
			var scrollRect = bitmap.scrollRect;
			
			if (scrollRect != null) {
				
				renderSession.maskManager.pushRect (scrollRect, bitmap.__renderTransform);
				
			}
			
			gl.uniform1f (shader.uniforms.get ("uAlpha"), bitmap.__worldAlpha);
			gl.uniformMatrix4fv (shader.uniforms.get ("uMatrix"), false, renderer.getMatrix (bitmap.__renderTransform));
			
			gl.bindTexture (gl.TEXTURE_2D, bitmap.bitmapData.getTexture (gl));
			
			// TODO: Add state management for this?
			
			if (bitmap.smoothing) {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				
			} else {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
				
			}
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.bitmapData.getBuffer (gl));
			gl.vertexAttribPointer (shader.attributes.get ("aPosition"), 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.attributes.get ("aTexCoord"), 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			
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