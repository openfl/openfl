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

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Shader)
@:access(openfl.geom.ColorTransform)
@:access(openfl.media.Video)
@:access(openfl.net.NetStream)


class GLVideo {
	
	
	private static var __textureSizeValue = [ 0, 0. ];
	
	
	public static function render (video:Video, renderer:OpenGLRenderer):Void {
		
		#if (js && html5)
		if (!video.__renderable || video.__worldAlpha <= 0 || video.__stream == null) return;
		
		if (video.__stream.__video != null) {
			
			var context = renderer.__context3D;
			var gl = context.gl;
			
			renderer.__setBlendMode (video.__worldBlendMode);
			renderer.__pushMaskObject (video);
			// renderer.filterManager.pushObject (video);
			
			var shader = renderer.__initDisplayShader (cast video.__worldShader);
			renderer.setShader (shader);
			
			// TODO: Support ShaderInput<Video>
			renderer.applyBitmapData (null, renderer.__allowSmoothing, false);
			context.__bindGLTexture2D (video.__getTexture (context));
			
			//shader.uImage0.input = bitmap.__bitmapData;
			//shader.uImage0.smoothing = renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled);
			renderer.applyMatrix (renderer.__getMatrix (video.__renderTransform));
			renderer.applyAlpha (video.__worldAlpha);
			renderer.applyColorTransform (video.__worldColorTransform);
			
			if (shader.__textureSize != null) {
				
				__textureSizeValue[0] = (video.__stream != null) ? video.__stream.__video.width : 0;
				__textureSizeValue[1] = (video.__stream != null) ? video.__stream.__video.height : 0;
				shader.__textureSize.value = __textureSizeValue;
				
			}
			
			renderer.updateShader ();
			
			if (video.smoothing) {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				
			} else {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
				
			}
			
			context.__bindGLArrayBuffer (video.__getBuffer (context));
			if (shader.__position != null) gl.vertexAttribPointer (shader.__position.index, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
			if (shader.__textureCoord != null) gl.vertexAttribPointer (shader.__textureCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			
			// TODO: Use context.drawTriangles
			context.__flushGL ();
			
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
			
			var context = renderer.__context3D;
			var gl = context.gl;
			
			var shader = renderer.__maskShader;
			renderer.setShader (shader);
			renderer.applyBitmapData (GLMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix (renderer.__getMatrix (video.__renderTransform));
			renderer.updateShader ();
			
			context.__bindGLArrayBuffer (video.__getBuffer (context));
			
			gl.vertexAttribPointer (shader.__position.index, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.__textureCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			
			// TODO: Use context.drawTriangles
			context.__flushGL ();
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
			GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderer.__clearShader ();
			
		}
		#end
		
	}
	
	
}