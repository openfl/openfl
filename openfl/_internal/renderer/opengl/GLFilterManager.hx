package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl._internal.renderer.AbstractFilterManager;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shader;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.Vector;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.renderer.opengl.GLRenderer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.filters.BitmapFilter)
@:keep


class GLFilterManager extends AbstractFilterManager {
	
	
	private var filterDepth:Int;
	private var gl:GLRenderContext;
	private var matrix:Matrix;
	private var renderer:GLRenderer;
	
	
	public function new (renderer:GLRenderer, renderSession:RenderSession) {
		
		super (renderSession);
		
		this.renderer = renderer;
		this.gl = renderSession.gl;
		
		filterDepth = 0;
		matrix = new Matrix ();
		
	}
	
	
	public override function pushObject (object:DisplayObject):Shader {
		
		return renderSession.shaderManager.defaultShader;
		
		// TODO: Support one-pass filters?
		
		if (object.__filters != null && object.__filters.length > 0) {
			
			if (Std.is (object.__filters[0], GlowFilter) && Std.is (object, TextField)) {
				
				// Hack, force outline
				return renderSession.shaderManager.defaultShader;
				
			}
			
			if (object.__filters.length == 1 && object.__filters[0].__numShaderPasses == 0) {
				
				renderer.getRenderTarget (false);
				return object.__filters[0].__initShader (renderSession, 0);
				
			} else {
				
				renderer.getRenderTarget (true);
				
			}
			
			filterDepth++;
			
		}
		
		return renderSession.shaderManager.defaultShader;
		
	}
	
	
	public override function popObject (object:DisplayObject):Void {
		
		return;
		
		// TEMPORARILY DISABLED
		
		if (object.__filters != null && object.__filters.length > 0) {
			
			if (Std.is (object.__filters[0], GlowFilter) && Std.is (object, TextField)) {
				
				// Hack, force outline
				return;
				
			}
			
			var numPasses:Int = 0;
			
			if (object.__filters.length > 1 || object.__filters[0].__numShaderPasses > 0) {
				
				numPasses = object.__filters.length;
				
				for (filter in object.__filters) {
					
					numPasses += (filter.__numShaderPasses > 0) ? (filter.__numShaderPasses - 1) : 0;
					
				}
				
			}
			
			if (numPasses > 0) {
				
				// if (filter.__cacheObject) {
					
				// 	currentTarget = renderer.currentRenderTarget;
				// 	renderer.getCacheObject ();
					
				// 	renderPass (currentTarget, renderSession.shaderManager.defaultShader);
					
				// }
				
				var currentTarget, shader;
				
				for (filter in object.__filters) {
					
					// TODO: Handle mixture of software-only filters
					
					for (i in 0...filter.__numShaderPasses) {
						
						currentTarget = renderer.currentRenderTarget;
						renderer.getRenderTarget(true);
						shader = filter.__initShader(renderSession, i);
						
						renderPass (currentTarget, shader);
						
					}
					
					// TODO: Properly handle filter-within-filter rendering
					
					filterDepth--;
					currentTarget = renderer.currentRenderTarget;
					renderer.getRenderTarget (filterDepth > 0);
					
					renderPass (currentTarget, renderSession.shaderManager.defaultShader);
					
				}
				
			} else {
				
				filterDepth--;
				
			}
			
		}
		
	}
	
	
	private function renderPass (target:BitmapData, shader:Shader):Void {
		
		if (target == null || shader == null) return;
		
		shader.data.uImage0.input = target;
		shader.data.uImage0.smoothing = renderSession.allowSmoothing && (renderSession.upscaled);
		shader.data.uMatrix.value = renderer.getMatrix (matrix);
		
		if (shader.data.uColorTransform != null) {
			if (shader.data.uColorTransform.value == null) shader.data.uColorTransform.value = [];
			shader.data.uColorTransform.value[0] = false;
		}
		
		renderSession.shaderManager.setShader (shader);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, target.getBuffer (gl, 1, null));
		
		gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 26 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
		
		#if gl_stats
			GLStats.incrementDrawCall (DrawCallContext.STAGE);
		#end
		
	}
	
	
}