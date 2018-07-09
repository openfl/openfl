package openfl._internal.renderer.opengl;


#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end
import openfl.display.BitmapData;
import haxe.io.Float32Array;
import openfl.display.Shader;
import openfl.display.DisplayObject;
import lime.graphics.GLRenderContext;


/**
*  GLVAORenderHelper is a helper class facilitating a GL rendering using VertexArrayObjects. Since VertexArrayObjects are 
*  supported in Webgl2 and as an extension in Webgl1, in case they are not supported there is a fallback mechanism 
*  using usual non-VertexArrayObjects GL rendering.
**/
@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.geom.ColorTransform)
@:access(openfl.display.Shader)


class GLVAORenderHelper {
	
	
	private static inline function __enableVertexAttribArray (gl:GLRenderContext, shader: Shader):Void {
		
		gl.enableVertexAttribArray (shader.data.aPosition.index);
		gl.enableVertexAttribArray (shader.data.aTexCoord.index);
		gl.enableVertexAttribArray (shader.data.aAlpha.index);
		gl.enableVertexAttribArray (shader.data.aColorMultipliers0.index);
		gl.enableVertexAttribArray (shader.data.aColorMultipliers1.index);
		gl.enableVertexAttribArray (shader.data.aColorMultipliers2.index);
		gl.enableVertexAttribArray (shader.data.aColorMultipliers3.index);
		gl.enableVertexAttribArray (shader.data.aColorOffsets.index);
		
	}
	
	
	public static inline function renderDO (displayObject:DisplayObject, renderSession:RenderSession, shader:Shader, bitmapData: BitmapData):Bool {
		
		var gl = renderSession.gl;
		var vaoContext = renderSession.vaoContext;
		
		if (vaoContext != null) {
			
			shader.__skipEnableVertexAttribArray = true;
			renderSession.shaderManager.updateShader (shader);
			shader.__skipEnableVertexAttribArray = false;
			
			var vaoDirty: Bool = bitmapData.__vaoContext != vaoContext || bitmapData.__vao == null;
			if (vaoDirty) {
				
				bitmapData.__vaoContext = vaoContext;
				bitmapData.__vao = vaoContext.createVertexArray ();
				
			}
			
			vaoContext.bindVertexArray (bitmapData.__vao);
			if (vaoDirty || bitmapData.isBufferDirty (gl, displayObject.__worldAlpha, displayObject.__worldColorTransform)) {
				
				__enableVertexAttribArray (gl, shader);
				bitmapData.getBuffer (gl, displayObject.__worldAlpha, displayObject.__worldColorTransform);
				__setVertexAttribPointer (gl, shader);
				
			} 
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderSession.filterManager.popObject (displayObject);
			renderSession.maskManager.popObject (displayObject);
			
			vaoContext.bindVertexArray (null);
			
			return true;
		}
		
		return false;
		
	}
	
	public static inline function renderMask (displayObject:DisplayObject, renderSession:RenderSession, shader:Shader, bitmapData: BitmapData):Bool {
		
		var gl = renderSession.gl;
		var vaoContext = renderSession.vaoContext;
		
		if (vaoContext != null) {
			
			shader.__skipEnableVertexAttribArray = true;
			renderSession.shaderManager.updateShader (shader);
			shader.__skipEnableVertexAttribArray = false;
			
			var vaoDirty: Bool = bitmapData.__vaoContext != vaoContext || bitmapData.__vaoMask == null;
			if (vaoDirty) {
				
				bitmapData.__vaoContext = vaoContext;
				bitmapData.__vaoMask = vaoContext.createVertexArray ();
				
			}
			
			vaoContext.bindVertexArray (bitmapData.__vaoMask);
			if (vaoDirty || bitmapData.isBufferDirty (gl, displayObject.__worldAlpha, displayObject.__worldColorTransform)) {
				
				gl.enableVertexAttribArray (shader.data.aPosition.index);
				gl.enableVertexAttribArray (shader.data.aTexCoord.index);
				
				bitmapData.getBuffer (gl, displayObject.__worldAlpha, displayObject.__worldColorTransform);
				
				gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				
			} 
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			vaoContext.bindVertexArray (null);
			
			return true;
			
		} 
		
		return false;
		
	}
	
	
	private static inline function __setVertexAttribPointer (gl:GLRenderContext, shader: Shader):Void {
		
		gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);		
		gl.vertexAttribPointer (shader.data.aColorMultipliers0.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 6 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aColorMultipliers1.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 10 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aColorMultipliers2.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 14 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aColorMultipliers3.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 18 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aColorOffsets.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 22 * Float32Array.BYTES_PER_ELEMENT);
		
	}
	
	
}
