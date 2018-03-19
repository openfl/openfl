package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl.display.OpenGLRenderer;
import openfl.media.Video;
import openfl.net.NetStream;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.geom.ColorTransform)
@:access(openfl.media.Video)
@:access(openfl.net.NetStream)


class GLVideo {
	
	
	public static function render (video:Video, renderer:OpenGLRenderer):Void {
		
		#if (js && html5)
		if (!video.__renderable || video.__worldAlpha <= 0 || video.__stream == null) return;
		
		if (video.__stream.__video != null) {
			
			var gl = renderer.gl;
			
			renderer.__setBlendMode (video.__worldBlendMode);
			renderer.__pushMaskObject (video);
			// renderer.filterManager.pushObject (video);
			
			var shader = renderer.__initDisplayShader (video.__worldRenderShader);
			renderer.setDisplayShader (shader);
			renderer.applyBitmapData (null, renderer.__allowSmoothing);
			//shader.uImage0.input = bitmap.__bitmapData;
			//shader.uImage0.smoothing = renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled);
			renderer.applyMatrix (renderer.__getMatrix (video.__renderTransform));
			renderer.applyAlpha (video.__worldAlpha);
			renderer.applyColorTransform (video.__worldColorTransform);
			renderer.updateShader ();
			
			gl.bindTexture (gl.TEXTURE_2D, video.__getTexture (gl));
			
			if (video.smoothing) {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				
			} else {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
				
			}
			
			gl.bindBuffer (gl.ARRAY_BUFFER, video.__getBuffer (gl));
			gl.vertexAttribPointer (shader.openfl_Position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.openfl_TexCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderer.__clearShader ();
			
			// renderer.filterManager.popObject (video);
			renderer.__popMaskObject (video);
			
		}
		#end
		
	}
	
	
	public static function renderMask (video:Video, renderer:OpenGLRenderer):Void {
		
		#if (js && html5)
		if (video.__stream == null) return;
		
		if (video.__stream.__video != null) {
			
			var gl = renderer.gl;
			
			var shader = renderer.__maskShader;
			renderer.setDisplayShader (shader);
			renderer.applyBitmapData (GLMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix (renderer.__getMatrix (video.__renderTransform));
			renderer.updateShader ();
			
			gl.bindBuffer (gl.ARRAY_BUFFER, video.__getBuffer (gl));
			
			gl.vertexAttribPointer (shader.openfl_Position.index, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.openfl_TexCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderer.__clearShader ();
			
		}
		#end
		
	}
	
	
}