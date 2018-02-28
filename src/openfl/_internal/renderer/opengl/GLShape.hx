package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectShader;
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
			
			GLGraphics.render (graphics, renderSession, shape.__renderTransform, shape.__worldAlpha);
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null && graphics.__visible) {
				
				var renderer:GLRenderer = cast renderSession.renderer;
				var shaderManager:GLShaderManager = cast renderSession.shaderManager;
				var gl = renderSession.gl;
				
				renderSession.blendModeManager.setBlendMode (shape.__worldBlendMode);
				renderSession.maskManager.pushObject (shape);
				renderSession.filterManager.pushObject (shape);
				
				var shader = shaderManager.initDisplayShader (shaderManager.defaultDisplayShader);
				shaderManager.setDisplayShader (shader);
				shaderManager.applyBitmapData (graphics.__bitmap, renderSession.allowSmoothing);
				shaderManager.applyMatrix (renderer.getMatrix (graphics.__worldTransform));
				shaderManager.applyAlpha (shape.__worldAlpha);
				shaderManager.applyColorTransform (shape.__worldColorTransform);
				shaderManager.updateShader ();
				
				gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl));
				gl.vertexAttribPointer (shader.data.openfl_Position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
				shaderManager.clear ();
				
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
				var shaderManager:GLShaderManager = cast renderSession.shaderManager;
				var gl = renderSession.gl;
				
				var shader = GLMaskManager.maskShader;
				//var shader = renderSession.shaderManager.initShader (shape.shader);
				shaderManager.setShader (shader);
				shaderManager.applyBitmapData (graphics.__bitmap, renderSession.allowSmoothing);
				shaderManager.applyMatrix (renderer.getMatrix (graphics.__worldTransform));
				shaderManager.updateShader ();
				
				gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl));
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
	
	
}