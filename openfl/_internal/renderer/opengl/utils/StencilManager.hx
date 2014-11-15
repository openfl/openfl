package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl._internal.renderer.opengl.shaders.AbstractShader;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.display.Graphics;
import openfl.display.DisplayObject;
import openfl.geom.Point;

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)

class StencilManager {
	
	
	public var count:Int;
	public var gl:GLRenderContext;
	public var maskStack:Array<Dynamic>;
	public var reverse:Bool;
	public var stencilStack:Array<GLGraphicsData>;
	
	public var bucketStack:Array<GLBucket>;
	
	
	public function new (gl:GLRenderContext) {
		
		stencilStack = [];
		bucketStack = [];
		setContext (gl);
		reverse = true;
		count = 0;
		
	}
	
	public inline function prepareGraphics(bucketData:GLBucketData, renderSession:RenderSession, projection:Point, translationMatrix:Float32Array):Void {
		var offset = renderSession.offset;
		var shader = renderSession.shaderManager.fillShader;
		
		renderSession.shaderManager.setShader (shader);
		gl.uniformMatrix3fv (shader.translationMatrix, false, translationMatrix);
		gl.uniform2f (shader.projectionVector, projection.x, -projection.y);
		gl.uniform2f (shader.offsetVector, -offset.x, -offset.y);
			
		gl.bindBuffer (gl.ARRAY_BUFFER, bucketData.vertsBuffer);
		gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, 4 * 2, 0);
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, bucketData.indexBuffer);
	}
	
	public function pushBucket (bucket:GLBucket, renderSession:RenderSession, projection:Point, translationMatrix:Float32Array):Void {
		
		if (bucketStack.length == 0) {
			gl.enable(gl.STENCIL_TEST);
			gl.clear(gl.STENCIL_BUFFER_BIT);
			gl.stencilMask(0xFF);
		}
		
		bucketStack.push(bucket);
		
		gl.colorMask(false, false, false, false);
		gl.stencilFunc(gl.NEVER, 0x01, 0xFF);
		gl.stencilOp(gl.INVERT, gl.KEEP, gl.KEEP);
		
		
		gl.clear(gl.STENCIL_BUFFER_BIT);
		
		for (bucketData in bucket.data) {
			if (bucketData.destroyed) continue;
			prepareGraphics(bucketData, renderSession, projection, translationMatrix);
			gl.drawElements (bucketData.drawMode, bucketData.glIndices.length, gl.UNSIGNED_SHORT, 0);
		}
		
		gl.colorMask(true, true, true, true);
		gl.stencilOp(gl.KEEP, gl.KEEP, gl.KEEP);
		gl.stencilFunc(gl.EQUAL, 0xFF, 0xFF);
	}
	
	public function popBucket (object:DisplayObject, bucket:GLBucket, renderSession:RenderSession):Void {
		bucketStack.pop();
		if (bucketStack.length == 0) {
			gl.disable(gl.STENCIL_TEST);
		}
	}
	
	public function bindGraphics (object:DisplayObject, glData:GLGraphicsData, renderSession:RenderSession):Void {
		
		var graphics = object.__graphics;
		
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
			
		}
		
	}
	
	
	public function destroy ():Void {
		
		stencilStack = null;
		bucketStack = null;
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