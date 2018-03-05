package openfl._internal.renderer.opengl;


import lime.graphics.opengl.WebGLContext;
import lime.math.color.ARGB;
import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Shader;
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

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLGraphics {
	
	
	private static var blankBitmapData = new BitmapData (1, 1, false, 0);
	private static var tempColorTransform = new ColorTransform (0, 0, 0, 1, 0, 0, 0, 0);
	
	
	private static function buildBuffer (graphics:Graphics, renderSession:RenderSession, parentTransform:Matrix, worldAlpha:Float):Void {
		
		var bufferLength = 0;
		var bufferPosition = 0;
		
		var data = new DrawCommandReader (graphics.__commands);
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var gl:WebGLContext = renderSession.gl;
		
		var tileRect = Rectangle.__pool.get ();
		var tileTransform = Matrix.__pool.get ();
		
		var bitmap = null;
		
		for (type in graphics.__commands.types) {
			
			switch (type) {
				
				case DRAW_QUADS:
					
					// TODO: Other fill types
					
					if (bitmap != null) {
						
						var c = data.readDrawQuads ();
						var rects = c.rects;
						var indices = c.indices;
						var transforms = c.transforms;
						
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
						bitmapWidth = bitmap.width;
						bitmapHeight = bitmap.height;
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
				
				case END_FILL:
					
					bitmap = null;
				
				case BEGIN_BITMAP_FILL:
					
					var c = data.readBeginBitmapFill ();
					bitmap = c.bitmap;
				
				case BEGIN_SHADER_FILL:
					
					var c = data.readBeginShaderFill ();
					var shaderBuffer = c.shaderBuffer;
					
					if (shaderBuffer == null || shaderBuffer.shader == null) {
						
						bitmap = null;
						
					} else {
						
						bitmap = c.shaderBuffer.shader.data.texture0.input;
						
					}
				
				default:
					
					data.skip (type);
				
			}
			
		}
		
		Rectangle.__pool.release (tileRect);
		Matrix.__pool.release (tileTransform);
		
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
			
			for (type in graphics.__commands.types) {
				
				switch (type) {
					
					case BEGIN_FILL, DRAW_RECT:
						
						// not compatible yet, but skip for now
						data.skip (type);
					
					case BEGIN_BITMAP_FILL, BEGIN_SHADER_FILL, END_FILL, MOVE_TO:
						
						// compatible
						data.skip (type);
					
					case DRAW_QUADS:
						
						hasDrawQuads = true;
						data.skip (type);
					
					default:
						
						data.destroy ();
						return false;
					
				}
				
			}
			
			return hasDrawQuads;
			
		}
		
	}
	
	
	public static function render (graphics:Graphics, renderSession:RenderSession, parentTransform:Matrix, worldAlpha:Float):Void {
		
		if (!isCompatible (graphics, parentTransform)) {
			
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
				var shaderManager:GLShaderManager = cast renderSession.shaderManager;
				var gl:WebGLContext = renderSession.gl;
				
				var matrix = Matrix.__pool.get ();
				
				var shaderBuffer = null;
				var bitmap = null;
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
							smooth = c.smooth;
							shaderBuffer = null;
							fill = null;
						
						case BEGIN_FILL:
							
							var c = data.readBeginFill ();
							var color = Std.int (c.color);
							var alpha = Std.int (c.alpha * 0xFF);
							
							fill = (color & 0xFFFFFF) | (alpha << 24);
						
						case BEGIN_SHADER_FILL:
							
							var c = data.readBeginShaderFill ();
							shaderBuffer = c.shaderBuffer;
							
							if (shaderBuffer == null || shaderBuffer.shader == null) {
								
								bitmap = null;
								
							} else {
								
								bitmap = shaderBuffer.shader.data.texture0.input;
								smooth = shaderBuffer.shader.data.texture0.smoothing;
								
							}
							
							fill = null;
						
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
								
								matrix.identity ();
								matrix.scale (width, height);
								matrix.tx = x;
								matrix.ty = y;
								matrix.concat (parentTransform);
								
								var shader = shaderManager.initGraphicsShader (null);
								shaderManager.setGraphicsShader (shader);
								shaderManager.applyMatrix (renderer.getMatrix (matrix));
								shaderManager.applyBitmapData (blankBitmapData, renderSession.allowSmoothing);
								shaderManager.applyAlpha (color.a / 0xFF);
								shaderManager.applyColorTransform (tempColorTransform);
								shaderManager.updateShader ();
								
								gl.bindBuffer (gl.ARRAY_BUFFER, blankBitmapData.getBuffer (cast gl));
								gl.vertexAttribPointer (shader.data.openfl_Position.index, 3, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 0);
								gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, 14 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
								gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
								
								#if gl_stats
									GLStats.incrementDrawCall (DrawCallContext.STAGE);
								#end
								
								shaderManager.clear ();
								
							}
						
						case DRAW_QUADS:
							
							if (bitmap != null) {
								
								var c = data.readDrawQuads ();
								var rects = c.rects;
								var indices = c.indices;
								var transforms = c.transforms;
								
								var hasIndices = (indices != null);
								var length = hasIndices ? indices.length : Math.floor (rects.length / 4);
								
								// matrix.copyFrom (graphics.__renderTransform);
								// matrix.concat (parentTransform);
								
								var uMatrix = renderer.getMatrix (parentTransform);
								var smoothing = (renderSession.allowSmoothing && smooth);
								var shader;
								
								if (shaderBuffer != null) {
									
									shader = shaderManager.initShaderBuffer (shaderBuffer);
									
									shaderManager.setShaderBuffer (shaderBuffer);
									shaderManager.applyMatrix (uMatrix);
									shaderManager.applyAlpha (1);
									shaderManager.applyColorTransform (null);
									shaderManager.updateShaderBuffer ();
									
								} else {
									
									shader = shaderManager.initGraphicsShader (null);
									shaderManager.setGraphicsShader (shader);
									shaderManager.applyMatrix (uMatrix);
									shaderManager.applyBitmapData (bitmap, smoothing);
									shaderManager.applyAlpha (graphics.__owner.__worldAlpha);
									shaderManager.applyColorTransform (graphics.__owner.__worldColorTransform);
									shaderManager.updateShader ();
									
								}
								
								if (graphics.__buffer == null || graphics.__bufferContext != gl) {
									
									graphics.__bufferContext = cast gl;
									graphics.__buffer = gl.createBuffer ();
									
								}
								
								gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__buffer);
								
								if (updatedBuffer) {
									
									gl.bufferData (gl.ARRAY_BUFFER, graphics.__bufferData, gl.DYNAMIC_DRAW);
									
								}
								
								gl.vertexAttribPointer (shader.data.openfl_Position.index, 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, bufferPosition * Float32Array.BYTES_PER_ELEMENT);
								gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, (bufferPosition + 2) * Float32Array.BYTES_PER_ELEMENT);
								
								gl.drawArrays (gl.TRIANGLES, 0, length * 6);
								bufferPosition += (4 * length * 6);
								
								#if gl_stats
									GLStats.incrementDrawCall (DrawCallContext.STAGE);
								#end
								
								shaderManager.clear ();
								
							}
						
						case END_FILL:
							
							bitmap = null;
							shaderBuffer = null;
							fill = null;
						
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
			buffer.set (graphics.__bufferData);
			graphics.__bufferData = buffer;
			
		}
		
		graphics.__bufferLength = length;
		
	}
	
	
}