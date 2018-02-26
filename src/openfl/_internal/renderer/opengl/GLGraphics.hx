package openfl._internal.renderer.opengl;


import lime.graphics.opengl.WebGLContext;
import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl.display.Graphics;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLGraphics {
	
	
	private static var tempColorTransform = new ColorTransform ();
	
	
	private static function buildBuffer (graphics:Graphics, renderSession:RenderSession, parentTransform:Matrix, worldAlpha:Float):Void {
		
		var bufferLength = 0;
		var bufferPosition = 0;
		
		var data = new DrawCommandReader (graphics.__commands);
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var gl:WebGLContext = renderSession.gl;
		
		var rect = Rectangle.__pool.get ();
		var matrix = Matrix.__pool.get ();
		
		var bitmap = null;
		
		for (type in graphics.__commands.types) {
			
			switch (type) {
				
				case DRAW_QUADS:
					
					if (bitmap != null) {
						
						var c = data.readDrawQuads ();
						var matrices = c.matrices;
						var sourceRects = c.sourceRects;
						var rectIndices = c.rectIndices;
						var attributes = null; //c.attributes;
						var attributeOptions = 0; //c.attributeOptions;
						
						var hasRects = (sourceRects != null);
						var hasIDs = (hasRects && rectIndices != null);
						var hasAttributes = (attributes != null);
						var hasAlpha = false;
						var hasColorTransform = false;
						var alphaOffset = 0;
						var colorTransformOffset = 0;
						
						var dataLength = 4;
						var attributeLength = 0;
						
						// if (hasAttributes && attributeOptions & VertexAttribute.ALPHA > 0) {
							
						// 	hasAlpha = true;
						// 	colorTransformOffset++;
						// 	attributeLength++;
						// 	dataLength++;
							
						// }
						
						// if (hasAttributes && attributeOptions & VertexAttribute.COLOR_TRANSFORM > 0) {
							
						// 	hasColorTransform = true;
						// 	attributeLength += 8;
						// 	dataLength += 8;
							
						// }
						
						var length = Math.floor (matrices.length / 6);
						var stride = dataLength * 6;
						var bufferLength = length * stride;
						
						resizeBuffer (graphics, bufferPosition + (length * stride));
						
						var tileMatrix, tileColorTransform, tileRect = null;
						
						var offset = bufferPosition;
						var alpha = 1.0, tileData, id;
						var bitmapWidth, bitmapHeight, tileWidth:Float, tileHeight:Float;
						var uvX, uvY, uvWidth, uvHeight;
						var x, y, x2, y2, x3, y3, x4, y4;
						var redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier;
						var redOffset, greenOffset, blueOffset, alphaOffset;
						var rectOffset, matrixOffset, ctOffset;
						
						var __bufferData = graphics.__bufferData;
						// var colorTransform = graphics.__worldColorTransform;
						bitmapWidth = bitmap.width;
						bitmapHeight = bitmap.height;
						var sourceRect = bitmap.rect;
						
						var __skipTile = function (i, offset:Int):Void {
							
							for (i in 0...6) {
								
								__bufferData[offset + (dataLength * i) + 4] = 0;
								
							}
							
						}
						
						for (i in 0...length) {
							
							offset = bufferPosition + (i * stride);
							
							if (hasAlpha) {
								
								alpha = attributes[i * attributeLength] * worldAlpha;
								
								if (alpha <= 0) {
									
									__skipTile (i, offset);
									continue;
									
								}
								
							}
							
							if (hasRects) {
								
								if (hasIDs && rectIndices[i] == -1) {
									
									__skipTile (i, offset);
									continue;
									
								}
								
								rectOffset = hasIDs ? rectIndices[i] : i * 4;
								rect.setTo (sourceRects[rectOffset], sourceRects[rectOffset + 1], sourceRects[rectOffset + 2], sourceRects[rectOffset + 3]);
								tileRect = rect;
								
							} else {
								
								tileRect = sourceRect;
								
							}
							
							tileWidth = tileRect.width;
							tileHeight = tileRect.height;
							
							if (tileWidth <= 0 || tileHeight <= 0) {
								
								__skipTile (i, offset);
								continue;
								
							}
							
							uvX = tileRect.x / bitmapWidth;
							uvY = tileRect.y / bitmapHeight;
							uvWidth = tileRect.right / bitmapWidth;
							uvHeight = tileRect.bottom / bitmapHeight;
							
							matrixOffset = i * 6;
							matrix.setTo (matrices[matrixOffset], matrices[matrixOffset + 1], matrices[matrixOffset + 2], matrices[matrixOffset + 3], matrices[matrixOffset + 4], matrices[matrixOffset + 5]);
							tileMatrix = matrix;
							
							x = tileMatrix.__transformX (0, 0);
							y = tileMatrix.__transformY (0, 0);
							x2 = tileMatrix.__transformX (tileWidth, 0);
							y2 = tileMatrix.__transformY (tileWidth, 0);
							x3 = tileMatrix.__transformX (0, tileHeight);
							y3 = tileMatrix.__transformY (0, tileHeight);
							x4 = tileMatrix.__transformX (tileWidth, tileHeight);
							y4 = tileMatrix.__transformY (tileWidth, tileHeight);
							
							__bufferData[offset + 0] = x;
							__bufferData[offset + 1] = y;
							__bufferData[offset + 2] = uvX;
							__bufferData[offset + 3] = uvY;
							
							__bufferData[offset + dataLength + 0] = x2;
							__bufferData[offset + dataLength + 1] = y2;
							__bufferData[offset + dataLength + 2] = uvWidth;
							__bufferData[offset + dataLength + 3] = uvY;
							
							__bufferData[offset + (dataLength * 2) + 0] = x3;
							__bufferData[offset + (dataLength * 2) + 1] = y3;
							__bufferData[offset + (dataLength * 2) + 2] = uvX;
							__bufferData[offset + (dataLength * 2) + 3] = uvHeight;
							
							__bufferData[offset + (dataLength * 3) + 0] = x3;
							__bufferData[offset + (dataLength * 3) + 1] = y3;
							__bufferData[offset + (dataLength * 3) + 2] = uvX;
							__bufferData[offset + (dataLength * 3) + 3] = uvHeight;
							
							__bufferData[offset + (dataLength * 4) + 0] = x2;
							__bufferData[offset + (dataLength * 4) + 1] = y2;
							__bufferData[offset + (dataLength * 4) + 2] = uvWidth;
							__bufferData[offset + (dataLength * 4) + 3] = uvY;
							
							__bufferData[offset + (dataLength * 5) + 0] = x4;
							__bufferData[offset + (dataLength * 5) + 1] = y4;
							__bufferData[offset + (dataLength * 5) + 2] = uvWidth;
							__bufferData[offset + (dataLength * 5) + 3] = uvHeight;
							
							if (hasAlpha) {
								
								for (j in 0...6) {
									
									__bufferData[offset + (dataLength * j) + 4] = alpha;
									
								}
								
							}
							
							if (hasColorTransform) {
								
								ctOffset = i * attributeLength + colorTransformOffset;
								tempColorTransform.redMultiplier = attributes[ctOffset];
								tempColorTransform.greenMultiplier = attributes[ctOffset + 1];
								tempColorTransform.blueMultiplier = attributes[ctOffset + 2];
								tempColorTransform.alphaMultiplier = attributes[ctOffset + 3];
								tempColorTransform.redOffset = attributes[ctOffset + 4];
								tempColorTransform.greenOffset = attributes[ctOffset + 5];
								tempColorTransform.blueOffset = attributes[ctOffset + 6];
								tempColorTransform.alphaOffset = attributes[ctOffset + 7];
								// tempColorTransform.__combine (colorTransform);
								
								redMultiplier = tempColorTransform.redMultiplier;
								greenMultiplier = tempColorTransform.greenMultiplier;
								blueMultiplier = tempColorTransform.blueMultiplier;
								alphaMultiplier = tempColorTransform.alphaMultiplier;
								redOffset = tempColorTransform.redOffset;
								greenOffset = tempColorTransform.greenOffset;
								blueOffset = tempColorTransform.blueOffset;
								alphaOffset = tempColorTransform.alphaOffset;
								
								ctOffset = 4 + colorTransformOffset;
								
								for (j in 0...6) {
									
									// 4 x 4 matrix
									__bufferData[offset + (dataLength * j) + ctOffset] = redMultiplier;
									__bufferData[offset + (dataLength * j) + ctOffset + 1] = greenMultiplier;
									__bufferData[offset + (dataLength * j) + ctOffset + 2] = blueMultiplier;
									__bufferData[offset + (dataLength * j) + ctOffset + 3] = alphaMultiplier;
									
									__bufferData[offset + (dataLength * j) + ctOffset + 4] = redOffset / 255;
									__bufferData[offset + (dataLength * j) + ctOffset + 5] = greenOffset / 255;
									__bufferData[offset + (dataLength * j) + ctOffset + 6] = blueOffset / 255;
									__bufferData[offset + (dataLength * j) + ctOffset + 7] = alphaOffset / 255;
									
								}
								
							}
							
						}
						
						bufferPosition += length * stride;
						
					}
				
				case END_FILL:
					
					bitmap = null;
				
				case BEGIN_BITMAP_FILL:
					
					var c = data.readBeginBitmapFill ();
					bitmap = c.bitmap;
				
				case BEGIN_SHADER_FILL:
					
					var c = data.readBeginShaderFill ();
					bitmap = c.shader.data.uImage0.input;
				
				default:
					
					data.skip (type);
				
			}
			
		}
		
		Rectangle.__pool.release (rect);
		Matrix.__pool.release (matrix);
		
	}
	
	
	private static function isCompatible (graphics:Graphics, parentTransform:Matrix):Bool {
		
		#if force_sw_graphics
		return false;
		#end
		
		if (!graphics.__visible || graphics.__commands.length == 0) {
			
			return false;
			
		} else {
			
			var data = new DrawCommandReader (graphics.__commands);
			var bitmap = null;
			var hasDrawQuads = false;
			trace ("hi");
			trace (graphics.__commands.types);
			for (type in graphics.__commands.types) {
				
				switch (type) {
					
					case BEGIN_FILL, DRAW_RECT:
						
						// not compatible yet, but skip for now
						data.skip (type);
					
					case BEGIN_BITMAP_FILL, BEGIN_SHADER_FILL, END_FILL, MOVE_TO:
						
						// compatible
						data.skip (type);
					
					case DRAW_QUADS:
						trace ("SDLFKJ");
						hasDrawQuads = true;
						data.skip (type);
					
					default:
						trace (type);
						data.destroy ();
						return false;
					
				}
				
			}
			
			return hasDrawQuads;
			
		}
		
	}
	
	
	public static function render (graphics:Graphics, renderSession:RenderSession, parentTransform:Matrix, worldAlpha:Float):Void {
		trace ("1");
		if (!isCompatible (graphics, parentTransform)) {
			trace ("2");
			if (graphics.__buffer != null) {
				
				graphics.__bufferData = null;
				graphics.__buffer = null;
				
			}
			
			#if (js && html5)
			CanvasGraphics.render (graphics, renderSession, parentTransform);
			#elseif lime_cairo
			CairoGraphics.render (graphics, renderSession, parentTransform);
			#end
			
		} else {
			trace ("3");
			graphics.__update ();
			
			var bounds = graphics.__bounds;
			
			var width = graphics.__width;
			var height = graphics.__height;
			
			if (bounds != null && width >= 1 && height >= 1) {
				
				var updatedBuffer = false;
				
				if (graphics.__dirty || graphics.__bufferData == null) {
					
					buildBuffer (graphics, renderSession, parentTransform, worldAlpha);
					updatedBuffer = true;
					
				}
				
				var data = new DrawCommandReader (graphics.__commands);
				
				var renderer:GLRenderer = cast renderSession.renderer;
				var gl:WebGLContext = renderSession.gl;
				
				// var matrix = Matrix.__pool.get ();
				
				var shader = null;
				var bitmap = null;
				var smooth = false;
				
				var positionX = 0.0;
				var positionY = 0.0;
				
				var bufferPosition = 0;
				
				for (type in graphics.__commands.types) {
					
					switch (type) {
						
						case BEGIN_BITMAP_FILL:
							
							var c = data.readBeginBitmapFill ();
							bitmap = c.bitmap;
							smooth = c.smooth;
						
						case BEGIN_SHADER_FILL:
							
							var c = data.readBeginShaderFill ();
							shader = c.shader;
							bitmap = shader.data.uImage0.input;
							smooth = shader.data.uImage0.smoothing;
						
						case DRAW_QUADS:
							
							if (bitmap != null) {
								trace ("draw");
								var c = data.readDrawQuads ();
								var matrices = c.matrices;
								// var sourceRects = c.sourceRects;
								// var rectIDs = c.rectIDs;
								var attributes = null; //c.attributes;
								var attributeOptions = 0; //c.attributeOptions;
								
								// matrix.copyFrom (graphics.__renderTransform);
								// matrix.concat (parentTransform);
								
								var uMatrix = renderer.getMatrix (parentTransform);
								var smoothing = (renderSession.allowSmoothing && smooth);
								
								var useAlpha = false; //(attributes != null && attributeOptions & VertexAttribute.ALPHA > 0);
								var useColorTransform = false; ///(attributes != null && attributeOptions & VertexAttribute.COLOR_TRANSFORM > 0);
								
								var shader = renderSession.shaderManager.initShader (renderSession.shaderManager.defaultShader);
								renderSession.shaderManager.setShader (shader);
								
								shader.data.uMatrix.value = uMatrix;
								shader.data.uImage0.input = bitmap;
								shader.data.uImage0.smoothing = smoothing;
								
								if (shader.data.uUseColorTransform.value == null) shader.data.uUseColorTransform.value = [];
								shader.data.uUseColorTransform.value[0] = useColorTransform;
								
								renderSession.shaderManager.updateShader ();
								
								if (graphics.__buffer == null || graphics.__bufferContext != gl) {
									
									graphics.__bufferContext = cast gl;
									graphics.__buffer = gl.createBuffer ();
									
								}
								
								gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__buffer);
								
								if (updatedBuffer) {
									
									gl.bufferData (gl.ARRAY_BUFFER, graphics.__bufferData, gl.DYNAMIC_DRAW);
									
								}
								
								var attribSize = 4;
								
								if (useAlpha) {
									
									attribSize++;
									
								}
								
								if (useColorTransform) {
									
									attribSize += 20;
									
								}
								
								gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, attribSize * Float32Array.BYTES_PER_ELEMENT, 0);
								gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, attribSize * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
								
								if (useAlpha) {
									
									gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, attribSize * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
									
								} else {
									
									gl.disableVertexAttribArray (shader.data.aAlpha.index);
									gl.vertexAttrib1f (shader.data.aAlpha.index, 1);
									
								}
								
								if (useColorTransform) {
									
									gl.vertexAttribPointer (shader.data.aColorMultipliers.index, 4, gl.FLOAT, false, attribSize * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
									gl.vertexAttribPointer (shader.data.aColorOffsets.index, 4, gl.FLOAT, false, attribSize * Float32Array.BYTES_PER_ELEMENT, 9 * Float32Array.BYTES_PER_ELEMENT);
									
								} else {
									
									gl.disableVertexAttribArray (shader.data.aColorMultipliers.index);
									gl.vertexAttrib4f (shader.data.aColorMultipliers.index, 1, 1, 1, 1);
									gl.disableVertexAttribArray (shader.data.aColorOffsets.index);
									gl.vertexAttrib4f (shader.data.aColorOffsets.index, 0, 0, 0, 0);
									
								}
								
								var length = Math.floor (matrices.length / 6);
								gl.drawArrays (gl.TRIANGLES, bufferPosition, length * 6);
								bufferPosition += length * 6;
								
								#if gl_stats
									GLStats.incrementDrawCall (DrawCallContext.STAGE);
								#end
								
							}
						
						// case DRAW_RECT:
							
						// 	var c = data.readDrawRect ();
							
						// 	if (bitmap != null) {
								
						// 		gl.enableVertexAttribArray (shader.data.aAlpha.index);
						// 		gl.uniformMatrix4fv (shader.data.uMatrix.index, 1, false, renderer.getMatrix (parentTransform));
								
						// 		gl.uniform1i (shader.data.uUseColorTransform.index, 0);
								
						// 		gl.bindTexture (gl.TEXTURE_2D, bitmap.getTexture (gl));
								
						// 		//if (renderSession.allowSmoothing && (smooth || renderSession.upscaled)) {
									
						// 			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
						// 			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
									
						// 		//} else {
						// 			//
						// 			//gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
						// 			//gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
						// 			//
						// 		//}
								
						// 		gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.getBuffer (gl, worldAlpha, null));
								
						// 		gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
						// 		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
						// 		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
								
						// 		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
								
						// 		#if gl_stats
						// 			GLStats.incrementDrawCall (DrawCallContext.STAGE);
						// 		#end
								
						// 	}
						
						case END_FILL:
							
							bitmap = null;
						
						case MOVE_TO:
							
							var c = data.readMoveTo ();
							positionX = c.x;
							positionY = c.y;
						
						default:
							
							data.skip (type);
						
					}
					
				}
				
				// Matrix.__pool.release (matrix);
				
			}
			
			graphics.__dirty = false;
			
		}
		
	}
	
	
	public static function renderMask (graphics:Graphics, renderSession:RenderSession, parentTransform:Matrix, worldAlpha:Float):Void {
		
		// TODO: Support invisible shapes
		
		#if (js && html5)
		CanvasGraphics.render (graphics, renderSession, parentTransform);
		#elseif lime_cairo
		CairoGraphics.render (graphics, renderSession, parentTransform);
		#end
		
	}
	
	
	private static function resizeBuffer (graphics:Graphics, length:Int):Void {
		
		if (graphics.__bufferData == null) {
			
			graphics.__bufferData = new Float32Array (length);
			
		} else if (length > graphics.__bufferData.length) {
			
			var buffer = new Float32Array (length);
			
			if (graphics.__bufferData != null) {
				
				buffer.set (graphics.__bufferData);
				
			}
			
			graphics.__bufferData = buffer;
			
		}
		
		graphics.__bufferLength = length;
		
	}
	
	
}