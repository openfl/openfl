package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)


class GLBitmap {
	
	
	public static function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		if (bitmap.bitmapData != null && bitmap.bitmapData.__isValid) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			var gl = renderSession.gl;
			
			renderSession.blendModeManager.setBlendMode (bitmap.__worldBlendMode);
			renderSession.maskManager.pushObject (bitmap);
			
			renderSession.filterManager.pushObject (bitmap);
			
			var shader = renderSession.shaderManager.initShader (bitmap.shader);
			renderSession.shaderManager.setShader (shader);
			
			shader.data.uImage0.input = bitmap.bitmapData;
			shader.data.uImage0.smoothing = renderSession.allowSmoothing && (bitmap.smoothing || renderSession.upscaled);
			shader.data.uMatrix.value = renderer.getMatrix (bitmap.__renderTransform);
			
			var useColorTransform = !bitmap.__worldColorTransform.__isDefault ();
			if (shader.data.uColorTransform.value == null) shader.data.uColorTransform.value = [];
			shader.data.uColorTransform.value[0] = useColorTransform;
			
			renderSession.shaderManager.updateShader (shader);
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.bitmapData.getBuffer (gl, bitmap.__worldAlpha, bitmap.__worldColorTransform));
			
			gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
			
			if (true || useColorTransform) {
				
				gl.vertexAttribPointer (shader.data.aColorMultipliers.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 6 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aColorMultipliers.index + 1, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 10 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aColorMultipliers.index + 2, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 14 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aColorMultipliers.index + 3, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 18 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aColorOffsets.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 22 * Float32Array.BYTES_PER_ELEMENT);
				
			}
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			renderSession.filterManager.popObject (bitmap);
			renderSession.maskManager.popObject (bitmap);
			
		}
		
	}
	
	
}