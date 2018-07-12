package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.OpenGLRenderer;
import openfl.display.Shader;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if (lime >= "7.0.0")
import lime.math.ARGB;
#else
import lime.graphics.opengl.WebGLContext;
import lime.math.color.ARGB;
#end

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.Shader)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLGraphics {
	
	
	private static var blankBitmapData = new BitmapData (1, 1, false, 0);
	private static var maskRender:Bool;
	private static var tempColorTransform = new ColorTransform (0, 0, 0, 1, 0, 0, 0, 0);
	
	
	private static function buildBuffer (graphics:Graphics, renderer:OpenGLRenderer):Void {
		
		var bufferLength = 0;
		var bufferPosition = 0;
		
		var data = new DrawCommandReader (graphics.__commands);
		
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl:WebGLContext = renderer.__context;
		#end
		
		var tileRect = Rectangle.__pool.get ();
		var tileTransform = Matrix.__pool.get ();
		
		var bitmap = null;
		
		for (type in graphics.__commands.types) {
			
			switch (type) {
				
				case BEGIN_BITMAP_FILL:
					
					var c = data.readBeginBitmapFill ();
					bitmap = c.bitmap;
				
				case BEGIN_FILL:
					
					bitmap = null;
					data.skip (type);
				
				case BEGIN_SHADER_FILL:
					
					var c = data.readBeginShaderFill ();
					var shaderBuffer = c.shaderBuffer;
					
					if (shaderBuffer == null || shaderBuffer.shader == null || shaderBuffer.shader.__bitmap == null) {
						
						bitmap = null;
						
					} else {
						
						bitmap = c.shaderBuffer.shader.__bitmap.input;
						
					}
				
				case DRAW_QUADS:
					
					// TODO: Other fill types
					
					if (bitmap != null) {
						
						var c = data.readDrawQuads ();
						var rects = c.rects;
						var indices = c.indices;
						var transforms = c.transforms;
						
						#if cpp
						var rects:Array<Float> = rects == null ? null : untyped (rects).__array;
						var indices:Array<Int> = indices == null ? null : untyped (indices).__array;
						var transforms:Array<Float> = transforms == null ? null : untyped (transforms).__array;
						#end
						
						var hasIndices = (indices != null);
						var transformABCD = false, transformXY = false;
						
						var length = hasIndices ? indices.length : Math.floor (rects.length / 4);
						if (length == 0) return;
						
						if (transforms != null) {
							
							if (transforms.length >= length * 6) {
								
								transformABCD = true;
								transformXY = true;
								
							} else if (transforms.length >= length * 4) {
								
								transformABCD = true;
								
							} else if (transforms.length >= length * 2) {
								
								transformXY = true;
								
							}
							
						}
						
						var dataLength = 4;
						var stride = dataLength * 6;
						var bufferLength = length * stride;
						
						resizeBuffer (graphics, bufferPosition + (length * stride));
						
						var offset = bufferPosition;
						var alpha = 1.0, tileData, id;
						var bitmapWidth, bitmapHeight, tileWidth:Float, tileHeight:Float;
						var uvX, uvY, uvWidth, uvHeight;
						var x, y, x2, y2, x3, y3, x4, y4;
						var ri, ti;
						
						var __bufferData = graphics.__bufferData;
						
						#if openfl_power_of_two
						bitmapWidth = 1;
						bitmapHeight = 1;
						while (bitmapWidth < bitmap.width) {
							
							bitmapWidth <<= 1;
							
						}
						while (bitmapHeight < bitmap.height) {
							
							bitmapHeight <<= 1;
							
						}
						#else
						bitmapWidth = bitmap.width;
						bitmapHeight = bitmap.height;
						#end
						
						var sourceRect = bitmap.rect;
						
						for (i in 0...length) {
							
							offset = bufferPosition + (i * stride);
							
							ri = (hasIndices ? (indices[i] * 4) : i * 4);
							if (ri < 0) continue;
							tileRect.setTo (rects[ri], rects[ri + 1], rects[ri + 2], rects[ri + 3]);
							
							tileWidth = tileRect.width;
							tileHeight = tileRect.height;
							
							if (tileWidth <= 0 || tileHeight <= 0) {
								
								continue;
								
							}
							
							if (transformABCD && transformXY) {
								
								ti = i * 6;
								tileTransform.setTo (transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], transforms[ti + 4], transforms[ti + 5]);
								
							} else if (transformABCD) {
								
								ti = i * 4;
								tileTransform.setTo (transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], tileRect.x, tileRect.y);
								
							} else if (transformXY) {
								
								ti = i * 2;
								tileTransform.tx = transforms[ti];
								tileTransform.ty = transforms[ti + 1];
								
							} else {
								
								tileTransform.tx = tileRect.x;
								tileTransform.ty = tileRect.y;
								
							}
							
							uvX = tileRect.x / bitmapWidth;
							uvY = tileRect.y / bitmapHeight;
							uvWidth = tileRect.right / bitmapWidth;
							uvHeight = tileRect.bottom / bitmapHeight;
							
							x = tileTransform.__transformX (0, 0);
							y = tileTransform.__transformY (0, 0);
							x2 = tileTransform.__transformX (tileWidth, 0);
							y2 = tileTransform.__transformY (tileWidth, 0);
							x3 = tileTransform.__transformX (0, tileHeight);
							y3 = tileTransform.__transformY (0, tileHeight);
							x4 = tileTransform.__transformX (tileWidth, tileHeight);
							y4 = tileTransform.__transformY (tileWidth, tileHeight);
							
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
							
						}
						
						bufferPosition += length * stride;
						
					}
				
				case DRAW_TRIANGLES:
					
					var c = data.readDrawTriangles ();
					var vertices = c.vertices;
					var indices = c.indices;
					var uvtData = c.uvtData;
					var culling = c.culling;
					
					var hasIndices = (indices != null);
					var numVertices = Math.floor (vertices.length / 2);
					var length = hasIndices ? indices.length : numVertices;
					
					var hasUVData = (uvtData != null);
					var hasUVTData = (hasUVData && uvtData.length >= (numVertices * 3));
					var vertLength = hasUVTData ? 4 : 2;
					var uvStride = hasUVTData ? 3 : 2;
					
					var stride = vertLength + 2;
					var offset = bufferPosition;
					
					resizeBuffer (graphics, bufferPosition + (length * stride));
					
					var __bufferData = graphics.__bufferData;
					var vertOffset, uvOffset, t;
					
					// TODO: Use an index buffer
					
					for (i in 0...length) {
						
						offset = bufferPosition + (i * stride);
						vertOffset = hasIndices ? indices[i] * 2 : i * 2;
						uvOffset = hasIndices ? indices[i] * uvStride : i * uvStride;
						
						if (hasUVTData) {
							
							t = uvtData[uvOffset + 2];
							
							__bufferData[offset + 0] = vertices[vertOffset] / t;
							__bufferData[offset + 1] = vertices[vertOffset + 1] / t;
							__bufferData[offset + 2] = 0;
							__bufferData[offset + 3] = 1 / t;
							
						} else {
							
							__bufferData[offset + 0] = vertices[vertOffset];
							__bufferData[offset + 1] = vertices[vertOffset + 1];
							
						}
						
						__bufferData[offset + vertLength] = hasUVData ? uvtData[uvOffset] : 0;
						__bufferData[offset + vertLength + 1] = hasUVData ? uvtData[uvOffset + 1] : 0;
						
					}
					
					bufferPosition += length * stride;
				
				case END_FILL:
					
					bitmap = null;
				
				default:
					
					data.skip (type);
				
			}
			
		}
		
		Rectangle.__pool.release (tileRect);
		Matrix.__pool.release (tileTransform);
		
	}
	
	
	private static function isCompatible (graphics:Graphics):Bool {
		
		#if force_sw_graphics
		return false;
		#elseif force_hw_graphics
		return true;
		#end
		
		var data = new DrawCommandReader (graphics.__commands);
		var hasColorFill = false, hasBitmapFill = false, hasShaderFill = false;
		
		for (type in graphics.__commands.types) {
			
			switch (type) {
				
				case BEGIN_BITMAP_FILL:
					
					hasBitmapFill = true;
					hasColorFill = false;
					hasShaderFill = false;
					data.skip (type);
				
				case BEGIN_FILL:
					
					hasBitmapFill = false;
					hasColorFill = true;
					hasShaderFill = false;
					data.skip (type);
				
				case BEGIN_SHADER_FILL:
					
					hasBitmapFill = false;
					hasColorFill = false;
					hasShaderFill = true;
					data.skip (type);
				
				case DRAW_QUADS:
					
					if (hasBitmapFill || hasShaderFill) {
						
						data.skip (type);
						
					} else {
						
						data.destroy ();
						return false;
						
					}
				
				case DRAW_RECT:
					
					if (hasColorFill) {
						
						data.skip (type);
						
					} else {
						
						data.destroy ();
						return false;
						
					}
				
				case DRAW_TRIANGLES:
					
					if (hasBitmapFill || hasShaderFill) {
						
						data.skip (type);
						
					} else {
						
						data.destroy ();
						return false;
						
					}
				
				case END_FILL:
					
					hasBitmapFill = false;
					hasColorFill = false;
					hasShaderFill = false;
					data.skip (type);
				
				case MOVE_TO:
					
					data.skip (type);
				
				default:
					
					data.destroy ();
					return false;
				
			}
			
		}
		
		data.destroy ();
		return true;
		
	}
	
	
	public static function render (graphics:Graphics, renderer:OpenGLRenderer):Void {
		
		if (!graphics.__visible || graphics.__commands.length == 0) return;
		
		if ((graphics.__bitmap != null && !graphics.__dirty) || !isCompatible (graphics)) {
			
			if (graphics.__buffer != null) {
				
				graphics.__bufferData = null;
				graphics.__buffer = null;
				
			}
			
			var cacheTransform = renderer.__softwareRenderer.__worldTransform;
			renderer.__softwareRenderer.__worldTransform = renderer.__worldTransform;
			
			#if (js && html5)
			CanvasGraphics.render (graphics, cast renderer.__softwareRenderer);
			#elseif lime_cairo
			CairoGraphics.render (graphics, cast renderer.__softwareRenderer);
			#end
			
			renderer.__softwareRenderer.__worldTransform = cacheTransform;
			
		} else {
			
			graphics.__bitmap = null;
			graphics.__update (renderer.__worldTransform);
			
			var bounds = graphics.__bounds;
			
			var width = graphics.__width;
			var height = graphics.__height;
			
			if (bounds != null && width >= 1 && height >= 1) {
				
				var updatedBuffer = false;
				
				if (graphics.__dirty || graphics.__bufferData == null) {
					
					buildBuffer (graphics, renderer);
					updatedBuffer = true;
					
				}
				
				var data = new DrawCommandReader (graphics.__commands);
				
				#if (lime >= "7.0.0")
				var gl = renderer.__context.webgl;
				#else
				var gl:WebGLContext = renderer.__context;
				#end
				
				var matrix = Matrix.__pool.get ();
				
				var shaderBuffer = null;
				var bitmap = null;
				var repeat = true;
				var smooth = false;
				var fill:Null<Int> = null;
				
				var positionX = 0.0;
				var positionY = 0.0;
				
				var bufferPosition = 0;
				
				for (type in graphics.__commands.types) {
					
					switch (type) {
						
						case BEGIN_BITMAP_FILL:
							
							var c = data.readBeginBitmapFill ();
							bitmap = c.bitmap;
							repeat = c.repeat;
							smooth = c.smooth;
							shaderBuffer = null;
							fill = null;
						
						case BEGIN_FILL:
							
							var c = data.readBeginFill ();
							var color = Std.int (c.color);
							var alpha = Std.int (c.alpha * 0xFF);
							
							fill = (color & 0xFFFFFF) | (alpha << 24);
							shaderBuffer = null;
							bitmap = null;
						
						case BEGIN_SHADER_FILL:
							
							var c = data.readBeginShaderFill ();
							shaderBuffer = c.shaderBuffer;
							
							if (shaderBuffer == null || shaderBuffer.shader == null || shaderBuffer.shader.__bitmap == null) {
								
								bitmap = null;
								
							} else {
								
								bitmap = shaderBuffer.shader.__bitmap.input;
								
							}
							
							fill = null;
						
						case DRAW_QUADS:
							
							if (bitmap != null) {
								
								var c = data.readDrawQuads ();
								var rects = c.rects;
								var indices = c.indices;
								var transforms = c.transforms;
								
								#if cpp
								var rects:Array<Float> = rects == null ? null : untyped (rects).__array;
								var indices:Array<Int> = indices == null ? null : untyped (indices).__array;
								var transforms:Array<Float> = transforms == null ? null : untyped (transforms).__array;
								#end
								
								var hasIndices = (indices != null);
								var length = hasIndices ? indices.length : Math.floor (rects.length / 4);
								
								var uMatrix = renderer.__getMatrix (graphics.__owner.__renderTransform);
								var shader;
								
								if (shaderBuffer != null && !maskRender) {
									
									shader = renderer.__initShaderBuffer (shaderBuffer);
									
									renderer.__setShaderBuffer (shaderBuffer);
									renderer.applyMatrix (uMatrix);
									renderer.applyBitmapData (bitmap, false, false);
									renderer.applyAlpha (graphics.__owner.__worldAlpha);
									renderer.applyColorTransform (graphics.__owner.__worldColorTransform);
									renderer.__updateShaderBuffer ();
									
								} else {
									
									shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader (null);
									renderer.setShader (shader);
									renderer.applyMatrix (uMatrix);
									renderer.applyBitmapData (bitmap, renderer.__allowSmoothing && smooth, repeat);
									renderer.applyAlpha (graphics.__owner.__worldAlpha);
									renderer.applyColorTransform (graphics.__owner.__worldColorTransform);
									renderer.updateShader ();
									
								}
								
								if (graphics.__buffer == null || graphics.__bufferContext != renderer.__context) {
									
									graphics.__bufferContext = renderer.__context;
									graphics.__buffer = gl.createBuffer ();
									
								}
								
								gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__buffer);
								
								if (updatedBuffer) {
									
									gl.bufferData (gl.ARRAY_BUFFER, graphics.__bufferData, gl.DYNAMIC_DRAW);
									
								}
								
								if (shader.__position != null) gl.vertexAttribPointer (shader.__position.index, 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, bufferPosition * Float32Array.BYTES_PER_ELEMENT);
								if (shader.__textureCoord != null) gl.vertexAttribPointer (shader.__textureCoord.index, 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, (bufferPosition + 2) * Float32Array.BYTES_PER_ELEMENT);
								
								gl.drawArrays (gl.TRIANGLES, 0, length * 6);
								bufferPosition += (4 * length * 6);
								
								#if gl_stats
									GLStats.incrementDrawCall (DrawCallContext.STAGE);
								#end
								
								renderer.__clearShader ();
								
							}
						
						case DRAW_RECT:
							
							if (fill != null) {
								
								var c = data.readDrawRect ();
								var x = c.x;
								var y = c.y;
								var width = c.width;
								var height = c.height;
								
								var color:ARGB = (fill:ARGB);
								tempColorTransform.redOffset = color.r;
								tempColorTransform.greenOffset = color.g;
								tempColorTransform.blueOffset = color.b;
								tempColorTransform.__combine (graphics.__owner.__worldColorTransform);
								
								matrix.identity ();
								matrix.scale (width, height);
								matrix.tx = x;
								matrix.ty = y;
								matrix.concat (graphics.__owner.__renderTransform);
								
								var shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader (null);
								renderer.setShader (shader);
								renderer.applyMatrix (renderer.__getMatrix (matrix));
								renderer.applyBitmapData (blankBitmapData, renderer.__allowSmoothing, true);
								renderer.applyAlpha ((color.a / 0xFF) * graphics.__owner.__worldAlpha);
								renderer.applyColorTransform (tempColorTransform);
								renderer.updateShader ();
								
								gl.bindBuffer (gl.ARRAY_BUFFER, blankBitmapData.getBuffer (renderer.__context));
								if (shader.__position != null) gl.vertexAttribPointer (shader.__position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
								if (shader.__textureCoord != null) gl.vertexAttribPointer (shader.__textureCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
								gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
								
								#if gl_stats
									GLStats.incrementDrawCall (DrawCallContext.STAGE);
								#end
								
								renderer.__clearShader ();
								
							}
						
						case DRAW_TRIANGLES:
							
							var c = data.readDrawTriangles ();
							var vertices = c.vertices;
							var indices = c.indices;
							var uvtData = c.uvtData;
							var culling = c.culling;
							
							var hasIndices = (indices != null);
							var numVertices = Math.floor (vertices.length / 2);
							var length = hasIndices ? indices.length : numVertices;
							
							var hasUVData = (uvtData != null);
							var hasUVTData = (hasUVData && uvtData.length >= (numVertices * 3));
							var vertLength = hasUVTData ? 4 : 2;
							var uvStride = hasUVTData ? 3 : 2;
							
							var stride = vertLength + 2;
							
							var uMatrix = renderer.__getMatrix (graphics.__owner.__renderTransform);
							var shader;
							
							if (shaderBuffer != null && !maskRender) {
								
								shader = renderer.__initShaderBuffer (shaderBuffer);
								
								renderer.__setShaderBuffer (shaderBuffer);
								renderer.applyMatrix (uMatrix);
								renderer.applyBitmapData (bitmap, false, false);
								renderer.applyAlpha (1);
								renderer.applyColorTransform (null);
								renderer.__updateShaderBuffer ();
								
							} else {
								
								shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader (null);
								renderer.setShader (shader);
								renderer.applyMatrix (uMatrix);
								renderer.applyBitmapData (bitmap, renderer.__allowSmoothing && smooth, repeat);
								renderer.applyAlpha (graphics.__owner.__worldAlpha);
								renderer.applyColorTransform (graphics.__owner.__worldColorTransform);
								renderer.updateShader ();
								
							}
							
							if (graphics.__buffer == null || graphics.__bufferContext != renderer.__context) {
								
								graphics.__bufferContext = renderer.__context;
								graphics.__buffer = gl.createBuffer ();
								
							}
							
							gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__buffer);
							
							if (updatedBuffer) {
								
								gl.bufferData (gl.ARRAY_BUFFER, graphics.__bufferData, gl.DYNAMIC_DRAW);
								
							}
							
							if (shader.__position != null) gl.vertexAttribPointer (shader.__position.index, vertLength, gl.FLOAT, false, stride * Float32Array.BYTES_PER_ELEMENT, bufferPosition * Float32Array.BYTES_PER_ELEMENT);
							if (shader.__textureCoord != null) gl.vertexAttribPointer (shader.__textureCoord.index, 2, gl.FLOAT, false, stride * Float32Array.BYTES_PER_ELEMENT, (bufferPosition + vertLength) * Float32Array.BYTES_PER_ELEMENT);
							
							switch (culling) {
								
								case POSITIVE:
									
									gl.enable (gl.CULL_FACE);
									gl.cullFace (gl.FRONT);
								
								case NEGATIVE:
									
									gl.enable (gl.CULL_FACE);
									gl.cullFace (gl.BACK);
								
								default:
								
							}
							
							gl.drawArrays (gl.TRIANGLES, 0, length);
							bufferPosition += (stride * length);
							
							if (culling != NONE) {
								
								gl.disable (gl.CULL_FACE);
								gl.cullFace (gl.BACK);
								
							}
							
							#if gl_stats
								GLStats.incrementDrawCall (DrawCallContext.STAGE);
							#end
							
							renderer.__clearShader ();
						
						case END_FILL:
							
							bitmap = null;
							fill = null;
							shaderBuffer = null;
							data.skip (type);
						
						case MOVE_TO:
							
							var c = data.readMoveTo ();
							positionX = c.x;
							positionY = c.y;
						
						default:
							
							data.skip (type);
						
					}
					
				}
				
				Matrix.__pool.release (matrix);
				
			}
			
			graphics.__dirty = false;
			
		}
		
	}
	
	
	public static function renderMask (graphics:Graphics, renderer:OpenGLRenderer):Void {
		
		// TODO: Support invisible shapes
		
		maskRender = true;
		render (graphics, renderer);
		maskRender = false;
		
	}
	
	
	private static function resizeBuffer (graphics:Graphics, length:Int):Void {
		
		if (graphics.__bufferData == null) {
			
			graphics.__bufferData = new Float32Array (length);
			
		} else if (length > graphics.__bufferData.length) {
			
			var buffer = new Float32Array (length);
			buffer.set (graphics.__bufferData);
			graphics.__bufferData = buffer;
			
		}
		
		graphics.__bufferLength = length;
		
	}
	
	
}