package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

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
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			var shaderManager:GLShaderManager = cast renderSession.shaderManager;
			var gl = renderSession.gl;
			
			renderSession.blendModeManager.setBlendMode (bitmap.__worldBlendMode);
			renderSession.maskManager.pushObject (bitmap);
			renderSession.filterManager.pushObject (bitmap);
			
			var shader = shaderManager.initDisplayShader (bitmap.shader);
			shaderManager.setDisplayShader (shader);
			shaderManager.applyBitmapData (bitmap.__bitmapData, renderSession.allowSmoothing && (bitmap.smoothing || renderSession.upscaled));
			shaderManager.applyMatrix (renderer.getMatrix (bitmap.__renderTransform));
			shaderManager.applyAlpha (bitmap.__worldAlpha);
			shaderManager.applyColorTransform (bitmap.__worldColorTransform);
			shaderManager.updateShader ();
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.__bitmapData.getBuffer (gl));
			gl.vertexAttribPointer (shader.data.openfl_Position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			shaderManager.clear ();
			
			renderSession.filterManager.popObject (bitmap);
			renderSession.maskManager.popObject (bitmap);
			
		}
		
	}
	
	
	public static function renderMask (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			var shaderManager:GLShaderManager = cast renderSession.shaderManager;
			var gl = renderSession.gl;
			
			var shader = GLMaskManager.maskShader;
			shaderManager.setDisplayShader (shader);
			shaderManager.applyBitmapData (bitmap.__bitmapData, renderSession.allowSmoothing && (bitmap.smoothing || renderSession.upscaled));
			shaderManager.applyMatrix (renderer.getMatrix (bitmap.__renderTransform));
			shaderManager.updateShader ();
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.__bitmapData.getBuffer (gl));
			gl.vertexAttribPointer (shader.data.openfl_Position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			shaderManager.clear ();
			
		}
		
	}
	
	
}