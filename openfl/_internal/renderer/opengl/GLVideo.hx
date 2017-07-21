package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.media.Video;
import openfl.net.NetStream;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)


class GLVideo {
	
	
	public static function render (video:Video, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!video.__renderable || video.__worldAlpha <= 0 || video.__stream == null) return;
		
		if (video.__stream.__video != null) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			var gl = renderSession.gl;
			
			renderSession.blendModeManager.setBlendMode (video.__worldBlendMode);
			renderSession.maskManager.pushObject (video);
			
			var shader = renderSession.filterManager.pushObject (video);
			
			//shader.data.uImage0.input = bitmap.bitmapData;
			//shader.data.uImage0.smoothing = renderSession.allowSmoothing && (bitmap.smoothing || renderSession.upscaled);
			shader.data.uMatrix.value = renderer.getMatrix (video.__renderTransform);
			
			renderSession.shaderManager.setShader (shader);
			
			gl.bindTexture (gl.TEXTURE_2D, video.__getTexture (gl));
			
			if (video.smoothing) {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				
			} else {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
				
			}
			
			gl.bindBuffer (gl.ARRAY_BUFFER, video.__getBuffer (gl, video.__worldAlpha));
			gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			renderSession.filterManager.popObject (video);
			renderSession.maskManager.popObject (video);
			
		}
		#end
		
	}
	
	
}