package openfl._internal.renderer.kha;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

import openfl._internal.renderer.kha.KhaRenderer;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)


class KhaBitmap {
	

	public static function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid) {
			#if (kha && !macro)
			var image = @:privateAccess bitmap.__bitmapData.__khaImage;

			var renderer: KhaRenderer = cast renderSession.renderer;

			renderSession.blendModeManager.setBlendMode (bitmap.__worldBlendMode);
			renderSession.maskManager.pushObject (bitmap);
			
			renderSession.filterManager.pushObject (bitmap);
			
			var g = KhaRenderer.framebuffer.g4;

			var shader = renderSession.shaderManager.initShader (bitmap.shader);
			renderSession.shaderManager.setShader (shader);

			var pipeline = @:privateAccess shader.__pipeline;

			var uImage0 = pipeline.getTextureUnit ("uImage0");
			g.setTexture (uImage0, image);
			// shader.data.uImage0.smoothing = renderSession.allowSmoothing && (bitmap.smoothing || renderSession.upscaled);
			var uMatrix = pipeline.getConstantLocation ("uMatrix");
			g.setMatrix (uMatrix, KhaUtils.convertMatrix (renderer.getMatrix (bitmap.__renderTransform)));

			var useColorTransform = !bitmap.__worldColorTransform.__isDefault ();
			var uColorTransform = pipeline.getConstantLocation ("uColorTransform");
			g.setBool (uColorTransform, useColorTransform);

			renderSession.shaderManager.updateShader (shader);

			g.setIndexBuffer (bitmap.__bitmapData.getIndexBufferKha ());
			g.setVertexBuffer (bitmap.__bitmapData.getVertexBufferKha (bitmap.__worldAlpha, bitmap.__worldColorTransform));
			
			g.drawIndexedVertices (0, 6);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderSession.filterManager.popObject (bitmap);
			renderSession.maskManager.popObject (bitmap);
			#end
		}
		
	}
	
	
	public static function renderMask (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		/*if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			var gl = renderSession.gl;
			
			var shader = GLMaskManager.maskShader;
			renderSession.shaderManager.setShader (shader);
			
			shader.data.uImage0.input = bitmap.__bitmapData;
			shader.data.uImage0.smoothing = renderSession.allowSmoothing && (bitmap.smoothing || renderSession.upscaled);
			shader.data.uMatrix.value = renderer.getMatrix (bitmap.__renderTransform);
			
			renderSession.shaderManager.updateShader (shader);
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.__bitmapData.getBuffer (gl, bitmap.__worldAlpha, bitmap.__worldColorTransform));
			
			gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
		}*/
		
	}
	
	
}