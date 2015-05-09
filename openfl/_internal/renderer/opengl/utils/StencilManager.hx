package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl._internal.renderer.opengl.shaders2.*;
import openfl._internal.renderer.opengl.shaders2.FillShader.FillUniform;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.geom.Matrix;
import openfl.display.Graphics;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.BitmapData)
@:access(openfl.geom.Matrix)

class StencilManager {
	
	
	public var count:Int;
	public var gl:GLRenderContext;
	public var reverse:Bool;
	public var stencilStack:Array<GLGraphicsData>;
	public var stencilMask:Int = 0;
	
	
	public function new (gl:GLRenderContext) {
		
		stencilStack = [];
		setContext (gl);
		reverse = true;
		count = 0;
		
	}
	
	public inline function prepareGraphics(fill:GLBucketData, renderSession:RenderSession, translationMatrix:Float32Array):Void {
		var shader = renderSession.shaderManager.fillShader;
		
		renderSession.shaderManager.setShader (shader);
		gl.uniformMatrix3fv (shader.getUniformLocation(FillUniform.TranslationMatrix), false, translationMatrix);
		gl.uniformMatrix3fv (shader.getUniformLocation(FillUniform.ProjectionMatrix), false, renderSession.projectionMatrix.toArray(true));
			
		fill.vertexArray.bind();
		shader.bindVertexArray(fill.vertexArray);
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, fill.indexBuffer);
	}
	
	public function pushBucket (bucket:GLBucket, renderSession:RenderSession, translationMatrix:Float32Array, ?isMask:Bool = false):Void {
		
		if(!isMask) {
			gl.enable(gl.STENCIL_TEST);
			gl.clear(gl.STENCIL_BUFFER_BIT);
			gl.stencilMask(0xFF);
			
			gl.colorMask(false, false, false, false);
			gl.stencilFunc(gl.NEVER, 0x01, 0xFF);
			gl.stencilOp(gl.INVERT, gl.KEEP, gl.KEEP);
		
			gl.clear(gl.STENCIL_BUFFER_BIT);
		}
		
		for (fill in bucket.fills) {
			if (fill.available) continue;
			prepareGraphics(fill, renderSession, translationMatrix);
			gl.drawElements (fill.drawMode, fill.glIndices.length, gl.UNSIGNED_SHORT, 0);
		}
		
		
		if(!isMask) {
			gl.colorMask(true, true, true, renderSession.renderer.transparent);
			gl.stencilOp(gl.KEEP, gl.KEEP, gl.KEEP);
			gl.stencilFunc(gl.EQUAL, 0xFF, 0xFF);
		}
	}
	
	public function popBucket (object:DisplayObject, bucket:GLBucket, renderSession:RenderSession):Void {
		gl.disable(gl.STENCIL_TEST);
	}
	
	public function pushMask(object:DisplayObject, renderSession:RenderSession) {
		
		var maskGraphics:Graphics = object.__maskGraphics;
		if (maskGraphics == null || maskGraphics.__commands.length <= 0) {
			return;
		}
		
		if (stencilMask == 0) {
			gl.enable(gl.STENCIL_TEST);
			gl.clear(gl.STENCIL_BUFFER_BIT);
		}
		
		stencilMask++;
		
		if (maskGraphics.__dirty) {
			GraphicsRenderer.updateGraphics(object, maskGraphics, renderSession.gl);
		}
		
		var func = stencilMask == 1 ? gl.NEVER : gl.EQUAL;
		var ref = stencilMask;
		var mask = 0xFF - stencilMask;
		
		gl.stencilMask(0xFF);
		gl.colorMask(false, false, false, false);
		gl.stencilFunc(func, ref, mask);
		gl.stencilOp(gl.REPLACE, gl.KEEP, gl.KEEP);
		
		// for each bucket in the object, draw it to the stencil buffer
		var glStack = maskGraphics.__glStack[GLRenderer.glContextId];
		var bucket:GLBucket;
		var translationMatrix:Matrix = object.__worldTransform;
		for (i in 0...glStack.buckets.length) {
			bucket = glStack.buckets[i];
			
			if (bucket.overrideMatrix != null) {
				translationMatrix = bucket.overrideMatrix;
			} else {
				translationMatrix = object.__worldTransform;
			}
			
			switch(bucket.mode) {
				case Fill, PatternFill:
					pushBucket(bucket, renderSession, translationMatrix.toArray(true), true);
				case _:
			}
		}
		
		
		gl.colorMask(true, true, true, renderSession.renderer.transparent);
		gl.stencilOp(gl.KEEP, gl.KEEP, gl.KEEP);
		gl.stencilFunc(gl.EQUAL, stencilMask, 0xFF);
	}
	
	public function popMask(object:DisplayObject, renderSession:RenderSession) {
		
		//var maskGraphics:Graphics = object.__maskGraphics;
		//if (maskGraphics == null || maskGraphics.__commands.length <= 0) {
			//return;
		//}
		
		stencilMask--;
		
		if (stencilMask <= 0) {
			gl.disable (gl.STENCIL_TEST);
			stencilMask = 0;
		}
	}
	
	public function bindGraphics (object:DisplayObject, glData:GLGraphicsData, renderSession:RenderSession):Void {
		
		/*var graphics = object.__graphics;
		
		var projection = renderSession.projection;
		var offset = renderSession.offset;

		if (glData.mode == RenderMode.STENCIL) {
			
			var shader = renderSession.shaderManager.complexPrimitiveShader;
			renderSession.shaderManager.setShader (shader);
			
			gl.uniformMatrix3fv (shader.translationMatrix, false, object.__worldTransform.toArray (true));
			
			gl.uniform2f (shader.projectionVector, projection.x, -projection.y);
			gl.uniform2f (shader.offsetVector, -offset.x, -offset.y);
			
			// TODO tintColor
			gl.uniform3fv (shader.tintColor, new Float32Array (GraphicsRenderer.hex2rgb (0xFFFFFF)));
			gl.uniform3fv (shader.color, new Float32Array (glData.tint));
			
			gl.uniform1f (shader.alpha, object.__worldAlpha * glData.alpha);
			
			gl.bindBuffer (gl.ARRAY_BUFFER, glData.dataBuffer);
			
			gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, 4 * 2, 0);
			
			gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, glData.indexBuffer);
			
		} else {
			
			var shader = renderSession.shaderManager.primitiveShader;
			renderSession.shaderManager.setShader (shader);
			
			gl.uniformMatrix3fv (shader.translationMatrix, false, object.__worldTransform.toArray (true));
			
			gl.uniform2f (shader.projectionVector, projection.x, -projection.y);
			gl.uniform2f (shader.offsetVector, -offset.x, -offset.y);
			
			// TODO tintColor
			gl.uniform3fv (shader.tintColor, new Float32Array (GraphicsRenderer.hex2rgb (0xFFFFFF)));
			
			gl.uniform1f (shader.alpha, object.__worldAlpha);
			
			gl.bindBuffer (gl.ARRAY_BUFFER, glData.dataBuffer);
			
			gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, 4 * 6, 0);
			gl.vertexAttribPointer (shader.colorAttribute, 4, gl.FLOAT, false,4 * 6, 2 * 4);
			
			gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, glData.indexBuffer);
			
		}*/
		
	}
	
	
	public function destroy ():Void {
		
		stencilStack = null;
		gl = null;
		
	}
	
	
	public function popStencil (object:DisplayObject, glData:GLGraphicsData, renderSession:RenderSession):Void {
		
		stencilStack.pop ();
		
		count--;
		
		if (stencilStack.length == 0) {
				
			gl.disable (gl.STENCIL_TEST);
			
		} else {
			
			var level = count;
			bindGraphics (object, glData, renderSession);
			
			gl.colorMask (false, false, false, false);
			
			if (glData.mode == RenderMode.STENCIL) {
				
				reverse = !reverse;
				
				if (reverse) {
					
					gl.stencilFunc (gl.EQUAL, 0xFF - (level + 1), 0xFF);
					gl.stencilOp (gl.KEEP, gl.KEEP, gl.INCR);
					
				} else {
					
					gl.stencilFunc (gl.EQUAL, level + 1, 0xFF);
					gl.stencilOp (gl.KEEP, gl.KEEP, gl.DECR);
					
				}
				
				gl.drawElements (gl.TRIANGLE_FAN, 4, gl.UNSIGNED_SHORT, (glData.indices.length - 4) * 2);
				
				gl.stencilFunc (gl.ALWAYS, 0, 0xFF);
				gl.stencilOp (gl.KEEP, gl.KEEP, gl.INVERT);
				
				gl.drawElements (gl.TRIANGLE_FAN, glData.indices.length - 4, gl.UNSIGNED_SHORT, 0);
				
				if (!reverse) {
					
					gl.stencilFunc (gl.EQUAL, 0xFF - (level), 0xFF);
					
				} else {
					
					gl.stencilFunc (gl.EQUAL, level, 0xFF);
					
				}
				
			} else {
				
				if (!reverse) {
					
					gl.stencilFunc (gl.EQUAL, 0xFF - (level + 1), 0xFF);
					gl.stencilOp (gl.KEEP, gl.KEEP, gl.INCR);
					
				} else {
					
					gl.stencilFunc (gl.EQUAL, level + 1, 0xFF);
					gl.stencilOp (gl.KEEP, gl.KEEP, gl.DECR);
					
				}
				
				gl.drawElements (gl.TRIANGLE_STRIP, glData.indices.length, gl.UNSIGNED_SHORT, 0);
				
				if (!reverse) {
					
					gl.stencilFunc (gl.EQUAL, 0xFF - (level), 0xFF);
					
				} else {
					
					gl.stencilFunc (gl.EQUAL, level, 0xFF);
					
				}
				
			}
			
			gl.colorMask (true, true, true, true);
			gl.stencilOp (gl.KEEP, gl.KEEP, gl.KEEP);
			
		}
		
	}
	
	
	public function pushStencil (object:DisplayObject, glData:GLGraphicsData, renderSession:RenderSession):Void {
		
		bindGraphics (object, glData, renderSession);

		if (stencilStack.length == 0) {
			
			gl.enable (gl.STENCIL_TEST);
			gl.clear (gl.STENCIL_BUFFER_BIT);
			reverse = true;
			count = 0;
			
		}

		stencilStack.push (glData);
		
		var level = count;
		
		//gl.colorMask (true, true, true, true);
		gl.colorMask (false, false, false, false);
		
		gl.stencilFunc (gl.ALWAYS, 0, 0xFF);
		gl.stencilOp (gl.KEEP, gl.KEEP, gl.INVERT);
		
		if (glData.mode == RenderMode.STENCIL) {
			
			gl.drawElements (gl.TRIANGLE_FAN, glData.indices.length - 4, gl.UNSIGNED_SHORT, 0);
			
			if (reverse) {
				
				gl.stencilFunc (gl.EQUAL, 0xFF - level, 0xFF);
				gl.stencilOp (gl.KEEP, gl.KEEP, gl.DECR);
				
			} else {
				
				gl.stencilFunc (gl.EQUAL, level, 0xFF);
				gl.stencilOp (gl.KEEP, gl.KEEP, gl.INCR);
				
			}
			
			gl.drawElements (gl.TRIANGLE_FAN, 4, gl.UNSIGNED_SHORT, (glData.indices.length - 4) * 2);
			
			if (reverse) {
				
				gl.stencilFunc (gl.EQUAL, 0xFF - (level + 1), 0xFF);
				
			} else {
				
				gl.stencilFunc (gl.EQUAL, level + 1, 0xFF);
				
			}
			
			reverse = !reverse;
			
		} else {
				
			if (!reverse) {
				
				gl.stencilFunc (gl.EQUAL, 0xFF - level, 0xFF);
				gl.stencilOp (gl.KEEP, gl.KEEP, gl.DECR);
				
			} else {
				
				gl.stencilFunc (gl.EQUAL, level, 0xFF);
				gl.stencilOp (gl.KEEP, gl.KEEP, gl.INCR);
				
			}
			
			gl.drawElements (gl.TRIANGLE_STRIP, glData.indices.length, gl.UNSIGNED_SHORT, 0);
			
			if (!reverse) {
				
				gl.stencilFunc (gl.EQUAL, 0xFF - (level + 1), 0xFF);
				
			} else {
				
				gl.stencilFunc (gl.EQUAL, level + 1, 0xFF);
				
			}
			
		}
		
		gl.colorMask (true, true, true, true);
		//gl.colorMask (false, false, false, false);
		gl.stencilOp (gl.KEEP, gl.KEEP, gl.KEEP);
		
		count++;
		
	}
	
	
	public function setContext (gl:GLRenderContext):Void {
		
		this.gl = gl;
		
	}
	
	
}