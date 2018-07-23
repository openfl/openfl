package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.OpenGLRenderer;

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
@:access(openfl.display.Shader)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)


class GLBitmap {
	
	
	public static function render (bitmap:Bitmap, renderer:OpenGLRenderer):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid) {
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl = renderer.__context;
			#end
			
			renderer.__setBlendMode (bitmap.__worldBlendMode);
			renderer.__pushMaskObject (bitmap);
			// renderer.filterManager.pushObject (bitmap);
			
			var shader = renderer.__initDisplayShader (cast bitmap.__worldShader);
			renderer.setShader (shader);
			renderer.applyBitmapData (bitmap.__bitmapData, renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled));
			renderer.applyMatrix (renderer.__getMatrix (bitmap.__renderTransform));
			renderer.applyAlpha (bitmap.__worldAlpha);
			renderer.applyColorTransform (bitmap.__worldColorTransform);
			renderer.updateShader ();
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.__bitmapData.getBuffer (renderer.__context));
			if (shader.__position != null) gl.vertexAttribPointer (shader.__position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
			if (shader.__textureCoord != null) gl.vertexAttribPointer (shader.__textureCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
			GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderer.__clearShader ();
			
			// renderer.filterManager.popObject (bitmap);
			renderer.__popMaskObject (bitmap);
			
		}
		
	}
	
	
	public static function renderMask (bitmap:Bitmap, renderer:OpenGLRenderer):Void {
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid) {
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl = renderer.__context;
			#end
			
			var shader = renderer.__maskShader;
			renderer.setShader (shader);
			renderer.applyBitmapData (GLMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix (renderer.__getMatrix (bitmap.__renderTransform));
			renderer.updateShader ();
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.__bitmapData.getBuffer (renderer.__context));
			gl.vertexAttribPointer (shader.__position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.__textureCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
			GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderer.__clearShader ();
			
		}
		
	}
	
	
}