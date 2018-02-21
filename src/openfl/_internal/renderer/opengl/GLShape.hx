package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)


class GLShape {
	
	
	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			#if (js && html5)
			CanvasGraphics.render (graphics, renderSession, shape.__renderTransform);
			#elseif lime_cairo
			CairoGraphics.render (graphics, renderSession, shape.__renderTransform);
			#end
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null && graphics.__visible) {
				
				var renderer:GLRenderer = cast renderSession.renderer;
				var gl = renderSession.gl;
				
				renderSession.blendModeManager.setBlendMode (shape.__worldBlendMode);
				renderSession.maskManager.pushObject (shape);
				
				var shader = renderSession.filterManager.pushObject (shape);
				
				//var shader = renderSession.shaderManager.initShader (shape.shader);
				renderSession.shaderManager.setShader (shader);
				
				shader.data.uImage0.input = graphics.__bitmap;
				shader.data.uImage0.smoothing = renderSession.allowSmoothing;
				shader.data.uMatrix.value = renderer.getMatrix (graphics.__worldTransform);
				
				var useColorTransform = !shape.__worldColorTransform.__isDefault ();
				if (shader.data.uColorTransform.value == null) shader.data.uColorTransform.value = [];
				shader.data.uColorTransform.value[0] = useColorTransform;
				
				renderSession.shaderManager.updateShader (shader);
				
				gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl, shape.__worldAlpha, shape.__worldColorTransform));
				
				gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
				
				if (true || useColorTransform) {
					
					gl.vertexAttribPointer (shader.data.aColorMultipliers0.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 6 * Float32Array.BYTES_PER_ELEMENT);
					gl.vertexAttribPointer (shader.data.aColorMultipliers1.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 10 * Float32Array.BYTES_PER_ELEMENT);
					gl.vertexAttribPointer (shader.data.aColorMultipliers2.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 14 * Float32Array.BYTES_PER_ELEMENT);
					gl.vertexAttribPointer (shader.data.aColorMultipliers3.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 18 * Float32Array.BYTES_PER_ELEMENT);
					gl.vertexAttribPointer (shader.data.aColorOffsets.index, 4, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 22 * Float32Array.BYTES_PER_ELEMENT);
					
				}
				
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
				renderSession.filterManager.popObject (shape);
				renderSession.maskManager.popObject (shape);
				
			}
			
		}
		
	}
	
	
	public static inline function renderMask (shape:DisplayObject, renderSession:RenderSession):Void {
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			// TODO: Support invisible shapes
			
			#if (js && html5)
			CanvasGraphics.render (graphics, renderSession, shape.__renderTransform);
			#elseif lime_cairo
			CairoGraphics.render (graphics, renderSession, shape.__renderTransform);
			#end
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null) {
				
				var renderer:GLRenderer = cast renderSession.renderer;
				var gl = renderSession.gl;
				
				var shader = GLMaskManager.maskShader;
				
				//var shader = renderSession.shaderManager.initShader (shape.shader);
				renderSession.shaderManager.setShader (shader);
				
				shader.data.uImage0.input = graphics.__bitmap;
				shader.data.uImage0.smoothing = renderSession.allowSmoothing;
				shader.data.uMatrix.value = renderer.getMatrix (graphics.__worldTransform);
				
				renderSession.shaderManager.updateShader (shader);
				
				gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl, shape.__worldAlpha, shape.__worldColorTransform));
				
				gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
			}
			
		}
		
	}
	
	
}