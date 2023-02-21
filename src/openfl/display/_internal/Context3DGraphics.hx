package openfl.display._internal;

import openfl.display._internal.CairoGraphics;
import openfl.display._internal.CanvasGraphics;
import openfl.display._internal.DrawCommandReader;
import openfl.utils._internal.Float32Array;
import openfl.utils._internal.UInt16Array;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.OpenGLRenderer;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
import lime.math.ARGB;
#end
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.Shader)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DGraphics
{
	private static var blankBitmapData = new BitmapData(1, 1, false, 0);
	private static var maskRender:Bool;
	private static var tempColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);

	private static function buildBuffer(graphics:Graphics, renderer:OpenGLRenderer):Void
	{
		var quadBufferPosition = 0;
		var triangleIndexBufferPosition = 0;
		var vertexBufferPosition = 0;
		var vertexBufferPositionUVT = 0;

		var data = new DrawCommandReader(graphics.__commands);

		var context = renderer.__context3D;

		var tileRect = Rectangle.__pool.get();
		var tileTransform = Matrix.__pool.get();

		var bitmap = null;

		for (type in graphics.__commands.types)
		{
			switch (type)
			{
				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					bitmap = c.bitmap;

				case BEGIN_FILL:
					bitmap = null;
					data.skip(type);

				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					var shaderBuffer = c.shaderBuffer;

					bitmap = null;

					if (shaderBuffer != null)
					{
						for (i in 0...shaderBuffer.inputCount)
						{
							if (shaderBuffer.inputRefs[i].name == "bitmap")
							{
								bitmap = shaderBuffer.inputs[i];
								break;
							}
						}
					}

				case DRAW_QUADS:
					// TODO: Other fill types

					if (bitmap != null)
					{
						var c = data.readDrawQuads();
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

						var length = hasIndices ? indices.length : Math.floor(rects.length / 4);
						if (length == 0) return;

						if (transforms != null)
						{
							if (transforms.length >= length * 6)
							{
								transformABCD = true;
								transformXY = true;
							}
							else if (transforms.length >= length * 4)
							{
								transformABCD = true;
							}
							else if (transforms.length >= length * 2)
							{
								transformXY = true;
							}
						}

						var dataPerVertex = 4;
						var stride = dataPerVertex * 4;

						if (graphics.__quadBuffer == null)
						{
							graphics.__quadBuffer = new Context3DBuffer(context, QUADS, length, dataPerVertex);
						}
						else
						{
							graphics.__quadBuffer.resize(quadBufferPosition + length, dataPerVertex);
						}

						var vertexOffset, alpha = 1.0, tileData, id;
						var bitmapWidth,
							bitmapHeight,
							tileWidth:Float,
							tileHeight:Float;
						var uvX, uvY, uvWidth, uvHeight;
						var x, y, x2, y2, x3, y3, x4, y4;
						var ri, ti;

						var vertexBufferData = graphics.__quadBuffer.vertexBufferData;

						#if openfl_power_of_two
						bitmapWidth = 1;
						bitmapHeight = 1;
						while (bitmapWidth < bitmap.width)
						{
							bitmapWidth <<= 1;
						}
						while (bitmapHeight < bitmap.height)
						{
							bitmapHeight <<= 1;
						}
						#else
						bitmapWidth = bitmap.width;
						bitmapHeight = bitmap.height;
						#end

						var sourceRect = bitmap.rect;

						for (i in 0...length)
						{
							vertexOffset = (quadBufferPosition + i) * stride;

							ri = (hasIndices ? (indices[i] * 4) : i * 4);
							if (ri < 0) continue;
							tileRect.setTo(rects[ri], rects[ri + 1], rects[ri + 2], rects[ri + 3]);

							tileWidth = tileRect.width;
							tileHeight = tileRect.height;

							if (tileWidth <= 0 || tileHeight <= 0)
							{
								continue;
							}

							if (transformABCD && transformXY)
							{
								ti = i * 6;
								tileTransform.setTo(transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], transforms[ti + 4],
									transforms[ti + 5]);
							}
							else if (transformABCD)
							{
								ti = i * 4;
								tileTransform.setTo(transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], tileRect.x, tileRect.y);
							}
							else if (transformXY)
							{
								ti = i * 2;
								tileTransform.tx = transforms[ti];
								tileTransform.ty = transforms[ti + 1];
							}
							else
							{
								tileTransform.tx = tileRect.x;
								tileTransform.ty = tileRect.y;
							}

							uvX = tileRect.x / bitmapWidth;
							uvY = tileRect.y / bitmapHeight;
							uvWidth = tileRect.right / bitmapWidth;
							uvHeight = tileRect.bottom / bitmapHeight;

							x = tileTransform.__transformX(0, 0);
							y = tileTransform.__transformY(0, 0);
							x2 = tileTransform.__transformX(tileWidth, 0);
							y2 = tileTransform.__transformY(tileWidth, 0);
							x3 = tileTransform.__transformX(0, tileHeight);
							y3 = tileTransform.__transformY(0, tileHeight);
							x4 = tileTransform.__transformX(tileWidth, tileHeight);
							y4 = tileTransform.__transformY(tileWidth, tileHeight);

							vertexBufferData[vertexOffset + 0] = x;
							vertexBufferData[vertexOffset + 1] = y;
							vertexBufferData[vertexOffset + 2] = uvX;
							vertexBufferData[vertexOffset + 3] = uvY;

							vertexBufferData[vertexOffset + dataPerVertex + 0] = x2;
							vertexBufferData[vertexOffset + dataPerVertex + 1] = y2;
							vertexBufferData[vertexOffset + dataPerVertex + 2] = uvWidth;
							vertexBufferData[vertexOffset + dataPerVertex + 3] = uvY;

							vertexBufferData[vertexOffset + (dataPerVertex * 2) + 0] = x3;
							vertexBufferData[vertexOffset + (dataPerVertex * 2) + 1] = y3;
							vertexBufferData[vertexOffset + (dataPerVertex * 2) + 2] = uvX;
							vertexBufferData[vertexOffset + (dataPerVertex * 2) + 3] = uvHeight;

							vertexBufferData[vertexOffset + (dataPerVertex * 3) + 0] = x4;
							vertexBufferData[vertexOffset + (dataPerVertex * 3) + 1] = y4;
							vertexBufferData[vertexOffset + (dataPerVertex * 3) + 2] = uvWidth;
							vertexBufferData[vertexOffset + (dataPerVertex * 3) + 3] = uvHeight;
						}

						quadBufferPosition += length;
					}

				case DRAW_TRIANGLES:
					var c = data.readDrawTriangles();
					var vertices = c.vertices;
					var indices = c.indices;
					var uvtData = c.uvtData;
					var culling = c.culling;

					var hasIndices = (indices != null);
					var numVertices = Math.floor(vertices.length / 2);
					var length = hasIndices ? indices.length : numVertices;

					var hasUVData = (uvtData != null);
					var hasUVTData = (hasUVData && uvtData.length >= (numVertices * 3));
					var vertLength = hasUVTData ? 4 : 2;
					var uvStride = hasUVTData ? 3 : 2;

					var dataPerVertex = vertLength + 2;
					var vertexOffset = hasUVTData ? vertexBufferPositionUVT : vertexBufferPosition;

					// TODO: Use index buffer for indexed render

					// if (hasIndices) resizeIndexBuffer (graphics, false, triangleIndexBufferPosition + length);
					resizeVertexBuffer(graphics, hasUVTData, vertexOffset + (length * dataPerVertex));

					// var indexBufferData = graphics.__triangleIndexBufferData;
					var vertexBufferData = hasUVTData ? graphics.__vertexBufferDataUVT : graphics.__vertexBufferData;
					var offset, vertOffset, uvOffset, t;

					for (i in 0...length)
					{
						offset = vertexOffset + (i * dataPerVertex);
						vertOffset = hasIndices ? indices[i] * 2 : i * 2;
						uvOffset = hasIndices ? indices[i] * uvStride : i * uvStride;

						// if (hasIndices) indexBufferData[triangleIndexBufferPosition + i] = indices[i];

						if (hasUVTData)
						{
							t = uvtData[uvOffset + 2];

							vertexBufferData[offset + 0] = vertices[vertOffset] / t;
							vertexBufferData[offset + 1] = vertices[vertOffset + 1] / t;
							vertexBufferData[offset + 2] = 0;
							vertexBufferData[offset + 3] = 1 / t;
						}
						else
						{
							vertexBufferData[offset + 0] = vertices[vertOffset];
							vertexBufferData[offset + 1] = vertices[vertOffset + 1];
						}

						vertexBufferData[offset + vertLength] = hasUVData ? uvtData[uvOffset] : 0;
						vertexBufferData[offset + vertLength + 1] = hasUVData ? uvtData[uvOffset + 1] : 0;
					}

					// if (hasIndices) triangleIndexBufferPosition += length;
					if (hasUVTData)
					{
						vertexBufferPositionUVT += length * dataPerVertex;
					}
					else
					{
						vertexBufferPosition += length * dataPerVertex;
					}

				case END_FILL:
					bitmap = null;

				default:
					data.skip(type);
			}
		}

		// TODO: Should we use static data specific to Context3DGraphics instead of each Graphics instance?

		if (quadBufferPosition > 0)
		{
			graphics.__quadBuffer.flushVertexBufferData();
		}

		if (triangleIndexBufferPosition > 0)
		{
			var buffer = graphics.__triangleIndexBuffer;

			if (buffer == null || triangleIndexBufferPosition > graphics.__triangleIndexBufferCount)
			{
				buffer = context.createIndexBuffer(triangleIndexBufferPosition, DYNAMIC_DRAW);
				graphics.__triangleIndexBuffer = buffer;
				graphics.__triangleIndexBufferCount = triangleIndexBufferPosition;
			}

			buffer.uploadFromTypedArray(graphics.__triangleIndexBufferData);
		}

		if (vertexBufferPosition > 0)
		{
			var buffer = graphics.__vertexBuffer;

			if (buffer == null || vertexBufferPosition > graphics.__vertexBufferCount)
			{
				buffer = context.createVertexBuffer(vertexBufferPosition, 4, DYNAMIC_DRAW);
				graphics.__vertexBuffer = buffer;
				graphics.__vertexBufferCount = vertexBufferPosition;
			}

			buffer.uploadFromTypedArray(graphics.__vertexBufferData);
		}

		if (vertexBufferPositionUVT > 0)
		{
			var buffer = graphics.__vertexBufferUVT;

			if (buffer == null || vertexBufferPositionUVT > graphics.__vertexBufferCountUVT)
			{
				buffer = context.createVertexBuffer(vertexBufferPositionUVT, 6, DYNAMIC_DRAW);
				graphics.__vertexBufferUVT = buffer;
				graphics.__vertexBufferCountUVT = vertexBufferPositionUVT;
			}

			buffer.uploadFromTypedArray(graphics.__vertexBufferDataUVT);
		}

		Rectangle.__pool.release(tileRect);
		Matrix.__pool.release(tileTransform);
	}

	private static function isCompatible(graphics:Graphics):Bool
	{
		#if (openfl_force_sw_graphics || force_sw_graphics)
		return false;
		#elseif (openfl_force_hw_graphics || force_hw_graphics)
		return true;
		#end

		if (graphics.__owner.__worldScale9Grid != null)
		{
			return false;
		}

		var data = new DrawCommandReader(graphics.__commands);
		var hasColorFill = false, hasBitmapFill = false, hasShaderFill = false;

		for (type in graphics.__commands.types)
		{
			switch (type)
			{
				case BEGIN_BITMAP_FILL:
					hasBitmapFill = true;
					hasColorFill = false;
					hasShaderFill = false;
					data.skip(type);

				case BEGIN_FILL:
					hasBitmapFill = false;
					hasColorFill = true;
					hasShaderFill = false;
					data.skip(type);

				case BEGIN_SHADER_FILL:
					hasBitmapFill = false;
					hasColorFill = false;
					hasShaderFill = true;
					data.skip(type);

				case DRAW_QUADS:
					if (hasBitmapFill || hasShaderFill)
					{
						data.skip(type);
					}
					else
					{
						data.destroy();
						return false;
					}

				case DRAW_RECT:
					if (hasColorFill)
					{
						data.skip(type);
					}
					else
					{
						data.destroy();
						return false;
					}

				case DRAW_TRIANGLES:
					if (hasBitmapFill || hasShaderFill)
					{
						data.skip(type);
					}
					else
					{
						data.destroy();
						return false;
					}

				case END_FILL:
					hasBitmapFill = false;
					hasColorFill = false;
					hasShaderFill = false;
					data.skip(type);

				case MOVE_TO:
					data.skip(type);

				case OVERRIDE_BLEND_MODE:
					data.skip(type);

				default:
					data.destroy();
					return false;
			}
		}

		data.destroy();
		return true;
	}

	public static function render(graphics:Graphics, renderer:OpenGLRenderer):Void
	{
		if (!graphics.__visible || graphics.__commands.length == 0) return;

		if ((graphics.__bitmap != null && !graphics.__dirty) || !isCompatible(graphics))
		{
			// if (graphics.__quadBuffer != null || graphics.__triangleIndexBuffer != null) {

			// TODO: Should this be kept?

			// graphics.__quadBuffer = null;
			// graphics.__triangleIndexBuffer = null;
			// graphics.__triangleIndexBufferData = null;
			// graphics.__vertexBuffer = null;
			// graphics.__vertexBufferData = null;
			// graphics.__vertexBufferDataUVT = null;
			// graphics.__vertexBufferUVT = null;

			// }

			renderer.__softwareRenderer.__pixelRatio = renderer.__pixelRatio;

			var cacheTransform = renderer.__softwareRenderer.__worldTransform;

			// TODO: Embed high-DPI graphics logic in the software renderer?
			// TODO: Unify the software renderer matrix behavior?
			if (graphics.__owner.__drawableType == TEXT_FIELD #if (openfl_disable_hdpi || openfl_disable_hdpi_graphics) || true #end)
			{
				renderer.__softwareRenderer.__worldTransform = Matrix.__identity;
			}
			else
			{
				renderer.__softwareRenderer.__worldTransform = renderer.__worldTransform;
			}

			#if (js && html5)
			CanvasGraphics.render(graphics, cast renderer.__softwareRenderer);
			#elseif lime_cairo
			CairoGraphics.render(graphics, cast renderer.__softwareRenderer);
			#end

			renderer.__softwareRenderer.__worldTransform = cacheTransform;
		}
		else
		{
			graphics.__bitmap = null;

			#if (openfl_disable_hdpi || openfl_disable_hdpi_graphics)
			var pixelRatio = 1;
			#else
			var pixelRatio = renderer.__pixelRatio;
			#end

			graphics.__update(renderer.__worldTransform, pixelRatio);

			var bounds = graphics.__bounds;

			var width = graphics.__width;
			var height = graphics.__height;

			if (bounds != null && width >= 1 && height >= 1)
			{
				if (graphics.__hardwareDirty
					|| (graphics.__quadBuffer == null && graphics.__vertexBuffer == null && graphics.__vertexBufferUVT == null))
				{
					buildBuffer(graphics, renderer);
				}

				var data = new DrawCommandReader(graphics.__commands);

				var context = renderer.__context3D;
				var gl = context.gl;

				var matrix = Matrix.__pool.get();

				var shaderBuffer = null;
				var bitmap = null;
				var repeat = false;
				var smooth = false;
				var fill:Null<Int> = null;

				var positionX = 0.0;
				var positionY = 0.0;

				var quadBufferPosition = 0;
				var shaderBufferOffset = 0;
				var triangleIndexBufferPosition = 0;
				var vertexBufferPosition = 0;
				var vertexBufferPositionUVT = 0;

				for (type in graphics.__commands.types)
				{
					switch (type)
					{
						case BEGIN_BITMAP_FILL:
							var c = data.readBeginBitmapFill();
							bitmap = c.bitmap;
							repeat = c.repeat;
							smooth = c.smooth;
							shaderBuffer = null;
							fill = null;

						case BEGIN_FILL:
							var c = data.readBeginFill();
							var color = Std.int(c.color);
							var alpha = Std.int(c.alpha * 0xFF);

							fill = (color & 0xFFFFFF) | (alpha << 24);
							shaderBuffer = null;
							bitmap = null;

						case BEGIN_SHADER_FILL:
							var c = data.readBeginShaderFill();
							shaderBuffer = c.shaderBuffer;
							shaderBufferOffset = 0;

							if (shaderBuffer == null || shaderBuffer.shader == null || shaderBuffer.shader.__bitmap == null)
							{
								bitmap = null;
							}
							else
							{
								bitmap = shaderBuffer.shader.__bitmap.input;
							}

							fill = null;

						case DRAW_QUADS:
							if (bitmap != null)
							{
								var c = data.readDrawQuads();
								var rects = c.rects;
								var indices = c.indices;
								var transforms = c.transforms;

								#if cpp
								var rects:Array<Float> = rects == null ? null : untyped (rects).__array;
								var indices:Array<Int> = indices == null ? null : untyped (indices).__array;
								var transforms:Array<Float> = transforms == null ? null : untyped (transforms).__array;
								#end

								var hasIndices = (indices != null);
								var length = hasIndices ? indices.length : Math.floor(rects.length / 4);

								var uMatrix = renderer.__getMatrix(graphics.__owner.__renderTransform, AUTO);
								var shader;

								if (shaderBuffer != null && !maskRender)
								{
									shader = renderer.__initShaderBuffer(shaderBuffer);

									renderer.__setShaderBuffer(shaderBuffer);
									renderer.applyMatrix(uMatrix);
									renderer.applyBitmapData(bitmap, false /* ignored */, repeat);
									renderer.applyAlpha(graphics.__owner.__worldAlpha);
									renderer.applyColorTransform(graphics.__owner.__worldColorTransform);
									// renderer.__updateShaderBuffer ();
								}
								else
								{
									shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
									renderer.setShader(shader);
									renderer.applyMatrix(uMatrix);
									renderer.applyBitmapData(bitmap, smooth, repeat);
									renderer.applyAlpha(graphics.__owner.__worldAlpha);
									renderer.applyColorTransform(graphics.__owner.__worldColorTransform);
									renderer.updateShader();
								}

								var end = quadBufferPosition + length;

								while (quadBufferPosition < end)
								{
									length = Std.int(Math.min(end - quadBufferPosition, context.__quadIndexBufferElements));
									if (length <= 0) break;

									if (shaderBuffer != null && !maskRender)
									{
										renderer.__updateShaderBuffer(shaderBufferOffset);
									}

									if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, graphics.__quadBuffer.vertexBuffer,
										quadBufferPosition * 16, FLOAT_2);
									if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index,
										graphics.__quadBuffer.vertexBuffer, (quadBufferPosition * 16) + 2, FLOAT_2);

									context.drawTriangles(context.__quadIndexBuffer, 0, length * 2);

									shaderBufferOffset += length * 4;
									quadBufferPosition += length;
								}

								#if gl_stats
								Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
								#end

								renderer.__clearShader();
							}

						case DRAW_RECT:
							if (fill != null)
							{
								var c = data.readDrawRect();
								var x = c.x;
								var y = c.y;
								var width = c.width;
								var height = c.height;

								#if lime
								var color:ARGB = (fill : ARGB);
								tempColorTransform.redOffset = color.r;
								tempColorTransform.greenOffset = color.g;
								tempColorTransform.blueOffset = color.b;
								#end
								tempColorTransform.__combine(graphics.__owner.__worldColorTransform);

								matrix.identity();
								matrix.scale(width, height);
								matrix.tx = x;
								matrix.ty = y;
								matrix.concat(graphics.__owner.__renderTransform);

								var shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
								renderer.setShader(shader);
								renderer.applyMatrix(renderer.__getMatrix(matrix, AUTO));
								renderer.applyBitmapData(blankBitmapData, true, repeat);
								#if lime
								renderer.applyAlpha((color.a / 0xFF) * graphics.__owner.__worldAlpha);
								#end
								renderer.applyColorTransform(tempColorTransform);
								renderer.updateShader();

								var vertexBuffer = blankBitmapData.getVertexBuffer(context);
								if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
								if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
								var indexBuffer = blankBitmapData.getIndexBuffer(context);
								context.drawTriangles(indexBuffer);

								shaderBufferOffset += 4;

								#if gl_stats
								Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
								#end

								renderer.__clearShader();
							}

						case DRAW_TRIANGLES:
							var c = data.readDrawTriangles();
							var vertices = c.vertices;
							var indices = c.indices;
							var uvtData = c.uvtData;
							var culling = c.culling;

							var hasIndices = (indices != null);
							var numVertices = Math.floor(vertices.length / 2);
							var length = hasIndices ? indices.length : numVertices;

							var hasUVData = (uvtData != null);
							var hasUVTData = (hasUVData && uvtData.length >= (numVertices * 3));
							var vertLength = hasUVTData ? 4 : 2;
							var uvStride = hasUVTData ? 3 : 2;

							var dataPerVertex = vertLength + 2;
							var vertexBuffer = hasUVTData ? graphics.__vertexBufferUVT : graphics.__vertexBuffer;
							var bufferPosition = hasUVTData ? vertexBufferPositionUVT : vertexBufferPosition;

							var uMatrix = renderer.__getMatrix(graphics.__owner.__renderTransform, AUTO);
							var shader;

							if (shaderBuffer != null && !maskRender)
							{
								shader = renderer.__initShaderBuffer(shaderBuffer);

								renderer.__setShaderBuffer(shaderBuffer);
								renderer.applyMatrix(uMatrix);
								renderer.applyBitmapData(bitmap, false, repeat);
								renderer.applyAlpha(1);
								renderer.applyColorTransform(null);
								renderer.__updateShaderBuffer(shaderBufferOffset);
							}
							else
							{
								shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
								renderer.setShader(shader);
								renderer.applyMatrix(uMatrix);
								renderer.applyBitmapData(bitmap, smooth, repeat);
								renderer.applyAlpha(graphics.__owner.__worldAlpha);
								renderer.applyColorTransform(graphics.__owner.__worldColorTransform);
								renderer.updateShader();
							}

							if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, bufferPosition,
								hasUVTData ? FLOAT_4 : FLOAT_2);
							if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer,
								bufferPosition + vertLength, FLOAT_2);

							switch (culling)
							{
								case POSITIVE:
									context.setCulling(FRONT);

								case NEGATIVE:
									context.setCulling(BACK);

								case NONE:
									context.setCulling(NONE);

								default:
							}

							// if (hasIndices) {

							// 	context.drawTriangles (graphics.__triangleIndexBuffer, triangleIndexBufferPosition, Math.floor (length / 3));
							// 	triangleIndexBufferPosition += length;

							// } else {

							context.__drawTriangles(0, length);

							// }

							shaderBufferOffset += length;
							if (hasUVTData)
							{
								vertexBufferPositionUVT += (dataPerVertex * length);
							}
							else
							{
								vertexBufferPosition += (dataPerVertex * length);
							}

							// This code is here because other draw calls are not aware (currently) of the culling type and just generally expect it to use
							// back face culling by default
							switch (culling)
							{
								case POSITIVE, NONE:
									context.setCulling(BACK);

								default:
							}

							#if gl_stats
							Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
							#end

							renderer.__clearShader();

						case END_FILL:
							bitmap = null;
							fill = null;
							shaderBuffer = null;
							data.skip(type);
							context.setCulling(NONE);

						case MOVE_TO:
							var c = data.readMoveTo();
							positionX = c.x;
							positionY = c.y;

						case OVERRIDE_BLEND_MODE:
							var c = data.readOverrideBlendMode();
							renderer.__setBlendMode(c.blendMode);

						default:
							data.skip(type);
					}
				}

				Matrix.__pool.release(matrix);
			}

			graphics.__hardwareDirty = false;
			graphics.__dirty = false;
		}
	}

	public static function renderMask(graphics:Graphics, renderer:OpenGLRenderer):Void
	{
		// TODO: Support invisible shapes

		maskRender = true;
		render(graphics, renderer);
		maskRender = false;
	}

	private static function resizeIndexBuffer(graphics:Graphics, isQuad:Bool, length:Int):Void
	{
		if (isQuad) return;

		var buffer = (isQuad ? null /*graphics.__quadIndexBufferData*/ : graphics.__triangleIndexBufferData);
		var position = 0, newBuffer = null;

		#if lime
		if (buffer == null)
		{
			newBuffer = new UInt16Array(length);
		}
		else if (length > buffer.length)
		{
			newBuffer = new UInt16Array(length);
			newBuffer.set(buffer);
			position = buffer.length;
		}
		#end

		if (newBuffer != null)
		{
			if (isQuad)
			{
				// var vertexIndex = Std.int (position * (4 / 6));

				// while (position < length) {

				// 	newBuffer[position] = vertexIndex;
				// 	newBuffer[position + 1] = vertexIndex + 1;
				// 	newBuffer[position + 2] = vertexIndex + 2;
				// 	newBuffer[position + 3] = vertexIndex + 2;
				// 	newBuffer[position + 4] = vertexIndex + 1;
				// 	newBuffer[position + 5] = vertexIndex + 3;
				// 	position += 6;
				// 	vertexIndex += 4;

				// }

				// graphics.__quadIndexBufferData = newBuffer;
			}
			else
			{
				graphics.__triangleIndexBufferData = newBuffer;
			}
		}
	}

	private static function resizeVertexBuffer(graphics:Graphics, hasUVTData:Bool, length:Int):Void
	{
		var buffer = (hasUVTData ? graphics.__vertexBufferDataUVT : graphics.__vertexBufferData);
		var newBuffer = null;

		#if lime
		if (buffer == null)
		{
			newBuffer = new Float32Array(length);
		}
		else if (length > buffer.length)
		{
			newBuffer = new Float32Array(length);
			newBuffer.set(buffer);
		}
		#end

		if (newBuffer != null)
		{
			hasUVTData ? graphics.__vertexBufferDataUVT = newBuffer : graphics.__vertexBufferData = newBuffer;
		}
	}
}
