package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectShader;
import openfl.display.OpenGLRenderer;
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
	
	
	public static inline function render (shape:DisplayObject, renderer:OpenGLRenderer):Void {
		
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			GLGraphics.render (graphics, renderer, shape.__renderTransform, shape.__worldAlpha);
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null && graphics.__visible) {
				
				var gl = renderer.gl;
				
				renderer.__setBlendMode (shape.__worldBlendMode);
				renderer.__pushMaskObject (shape);
				// renderer.filterManager.pushObject (shape);
				
				var shader = renderer.__initDisplayShader (shape.__worldRenderShader);
				renderer.setDisplayShader (shader);
				renderer.applyBitmapData (graphics.__bitmap, renderer.__allowSmoothing);
				renderer.applyMatrix (renderer.__getMatrix (graphics.__worldTransform));
				renderer.applyAlpha (shape.__worldAlpha);
				renderer.applyColorTransform (shape.__worldColorTransform);
				renderer.updateShader ();
				
				gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl));
				gl.vertexAttribPointer (shader.data.openfl_Position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
				renderer.__clearShader ();
				
				// renderer.filterManager.popObject (shape);
				renderer.__popMaskObject (shape);
				
			}
			
		}
		
	}
	
	
	public static inline function renderMask (shape:DisplayObject, renderer:OpenGLRenderer):Void {
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			// TODO: Support invisible shapes
			
			#if (js && html5)
			CanvasGraphics.render (graphics, cast renderer.__softwareRenderer, shape.__renderTransform);
			#elseif lime_cairo
			CairoGraphics.render (graphics, cast renderer.__softwareRenderer, shape.__renderTransform);
			#end
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null) {
				
				var gl = renderer.gl;
				
				var shader = renderer.__maskShader;
				renderer.setShader (shader);
				renderer.applyBitmapData (graphics.__bitmap, renderer.__allowSmoothing);
				renderer.applyMatrix (renderer.__getMatrix (graphics.__worldTransform));
				renderer.updateShader ();
				
				gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl));
				gl.vertexAttribPointer (shader.data.openfl_Position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
				renderer.__clearShader ();
				
			}
			
		}
		
	}
	
	
}