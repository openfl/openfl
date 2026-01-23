package openfl.display._internal;

#if !flash
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
	private static var tempVerticesVector:Vector<Float> = new Vector<Float>();
	private static var tempScale9VerticesVector:Vector<Float> = new Vector<Float>();
	private static var tempIndicesVector:Vector<Int> = new Vector<Int>();
	private static var tempUvtVector:Vector<Float> = new Vector<Float>();
	private static var scaleX:Float;
	private static var scaleY:Float;

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

		var bitmap:BitmapData = null;
		var bitmapMatrix:Matrix = null;

		inline function buildDrawTrianglesBuffer(vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling):Void
		{
			if (bitmap != null && uvtData == null)
			{
				uvtData = tempUvtVector;
				graphics.__generateUV(vertices, bitmap.width, bitmap.height, bitmapMatrix, uvtData);
			}

			var hasIndices = (indices != null);
			var numVertices = Math.floor(vertices.length / 2);
			var length = hasIndices ? indices.length : numVertices;

			var hasUVData = (uvtData != null);
			var hasUVTData = (hasUVData && uvtData.length >= (numVertices * 3));
			var vertLength = hasUVTData ? 4 : 2;
			var uvStride = hasUVTData ? 3 : 2;
			var dataPerVertex = vertLength + 2;
			var vertexOffset = hasUVTData ? vertexBufferPositionUVT : vertexBufferPosition;

			var offset:Int;
			var vertOffset:Int;
			var uvOffset:Int;
			var t:Float;

			if (graphics.__useScale9Grid)
			{
				tempScale9VerticesVector.length = vertices.length;
				var minX = graphics.__boundsExStroke.x;
				var minY = graphics.__boundsExStroke.y;
				var scaledMinX = graphics.__getScale9GridPositionX(minX);
				var scaledMinY = graphics.__getScale9GridPositionY(minY);
				var x:Float, y:Float, scaledX:Float, scaledY:Float;

				for (i in 0...length)
				{
					offset = vertexOffset + (i * dataPerVertex);
					vertOffset = hasIndices ? indices[i] * 2 : i * 2;
					uvOffset = hasIndices ? indices[i] * uvStride : i * uvStride;

					x = vertices[vertOffset];
					y = vertices[vertOffset + 1];
					scaledX = graphics.__getScale9GridPositionX(x);
					scaledY = graphics.__getScale9GridPositionY(y);

					tempScale9VerticesVector[vertOffset] = (scaledX - scaledMinX) / graphics.__owner.scaleX + minX;
					tempScale9VerticesVector[vertOffset + 1] = (scaledY - scaledMinY) / graphics.__owner.scaleY + minY;
				}
				vertices = tempScale9VerticesVector;
			}

			// TODO: Use index buffer for indexed render
			// if (hasIndices) resizeIndexBuffer (graphics, false, triangleIndexBufferPosition + length);
			resizeVertexBuffer(graphics, hasUVTData, vertexOffset + (length * dataPerVertex));

			var vertexBufferData = hasUVTData ? graphics.__vertexBufferDataUVT : graphics.__vertexBufferData;

			// var indexBufferData = graphics.__triangleIndexBufferData;

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
		}

		for (type in graphics.__commands.types)
		{
			switch (type)
			{
				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					bitmap = c.bitmap;
					bitmapMatrix = c.matrix;

				case BEGIN_GRADIENT_FILL:
					bitmap = null;
					bitmapMatrix = null;
					data.skip(type);

				case BEGIN_FILL:
					bitmap = null;
					bitmapMatrix = null;
					data.skip(type);

				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					var shaderBuffer = c.shaderBuffer;

					bitmap = null;
					bitmapMatrix = c.matrix;

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

					var vertexOffset:Int;
					var bitmapWidth:Int;
					var bitmapHeight:Int;
					var tileWidth:Float;
					var tileHeight:Float;
					var uvX:Float;
					var uvY:Float;
					var uvWidth:Float;
					var uvHeight:Float;
					var x:Float;
					var y:Float;
					var x2:Float;
					var y2:Float;
					var x3:Float;
					var y3:Float;
					var x4:Float;
					var y4:Float;
					var ri:Int;
					var ti:Int;

					var vertexBufferData = graphics.__quadBuffer.vertexBufferData;

					bitmapWidth = 1;
					bitmapHeight = 1;
					if (bitmap != null)
					{
						#if openfl_power_of_two
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
					}

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
							// this overrides / ignores tileRect.x & tileRect.y
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

				case DRAW_TRIANGLES:
					var c = data.readDrawTriangles();
					var vertices = c.vertices;
					var indices = c.indices;
					var uvtData = c.uvtData;
					var culling = c.culling;
					buildDrawTrianglesBuffer(vertices, indices, uvtData, culling);

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					var x = c.x;
					var y = c.y;
					var radius = c.radius;

					PolygonFunctions.buildEllipseVerticesAndIndices(x - radius, y - radius, radius, radius, scaleX, scaleY, tempVerticesVector,
						tempIndicesVector);
					buildDrawTrianglesBuffer(tempVerticesVector, tempIndicesVector, null, NONE);

				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					var x = c.x;
					var y = c.y;
					var radiusX = c.width / 2.0;
					var radiusY = c.height / 2.0;

					PolygonFunctions.buildEllipseVerticesAndIndices(x, y, radiusX, radiusY, scaleX, scaleY, tempVerticesVector, tempIndicesVector);
					buildDrawTrianglesBuffer(tempVerticesVector, tempIndicesVector, null, NONE);

				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					var x = c.x;
					var y = c.y;
					var width = c.width;
					var height = c.height;
					var radiusX = c.ellipseWidth / 2.0;
					var radiusY = (c.ellipseHeight != null ? c.ellipseHeight : c.ellipseWidth) / 2.0;

					PolygonFunctions.buildRoundRectVerticesAndIndices(x, y, width, height, radiusX, radiusY, scaleX, scaleY, tempVerticesVector,
						tempIndicesVector);
					buildDrawTrianglesBuffer(tempVerticesVector, tempIndicesVector, null, NONE);

				case DRAW_RECT:
					var c = data.readDrawRect();

					tempVerticesVector.length = 8;
					tempVerticesVector[0] = c.x;
					tempVerticesVector[1] = c.y;
					tempVerticesVector[2] = c.x + c.width;
					tempVerticesVector[3] = c.y;
					tempVerticesVector[4] = c.x;
					tempVerticesVector[5] = c.y + c.height;
					tempVerticesVector[6] = c.x + c.width;
					tempVerticesVector[7] = c.y + c.height;
					tempIndicesVector.length = 6;
					tempIndicesVector[0] = 0;
					tempIndicesVector[1] = 1;
					tempIndicesVector[2] = 2;
					tempIndicesVector[3] = 1;
					tempIndicesVector[4] = 2;
					tempIndicesVector[5] = 3;

					buildDrawTrianglesBuffer(tempVerticesVector, tempIndicesVector, null, NONE);

				case END_FILL:
					bitmap = null;
					bitmapMatrix = null;

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

	public static function render(graphics:Graphics, renderer:OpenGLRenderer):Void
	{
		if (!graphics.__visible || graphics.__commands.length == 0) return;

		if ((graphics.__bitmap != null && !graphics.__dirty) || !graphics.__isHardwareCompatible)
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

			var matrix = graphics.__owner.__worldTransform;
			scaleX = Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b);
			scaleY = Math.sqrt(matrix.c * matrix.c + matrix.d * matrix.d);

			if (!bounds.isEmpty() && width >= 1 && height >= 1)
			{
				if (graphics.__hardwareDirty
					|| (graphics.__quadBuffer == null && graphics.__vertexBuffer == null && graphics.__vertexBufferUVT == null))
				{
					buildBuffer(graphics, renderer);
				}

				var data = new DrawCommandReader(graphics.__commands);

				var context = renderer.__context3D;
				var gl = context.gl;

				var shaderBuffer:ShaderBuffer = null;
				var bitmap:BitmapData = null;
				var bitmapMatrix:Matrix = null;
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

				inline function renderDrawTriangles(verticesLength:Int, indicesLength:Int, uvDataLength:Int, culling:TriangleCulling):Void
				{
					if (bitmap != null && uvDataLength == 0)
					{
						uvDataLength = verticesLength;
					}

					if (bitmap != null || (uvDataLength == 0 && fill != null))
					{
						var numVertices = Math.floor(verticesLength / 2);
						var length = indicesLength > 0 ? indicesLength : numVertices;

						var hasUVTData = uvDataLength >= (numVertices * 3);
						var vertLength = hasUVTData ? 4 : 2;
						var uvStride = hasUVTData ? 3 : 2;

						var dataPerVertex = vertLength + 2;
						var vertexBuffer = hasUVTData ? graphics.__vertexBufferUVT : graphics.__vertexBuffer;
						var bufferPosition = hasUVTData ? vertexBufferPositionUVT : vertexBufferPosition;

						var uMatrix = renderer.__getMatrix(graphics.__owner.__renderTransform, AUTO);
						var shader:Shader;

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
						else if (bitmap != null)
						{
							shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
							renderer.setShader(shader);
							renderer.applyMatrix(uMatrix);
							renderer.applyBitmapData(bitmap, smooth, repeat);
							renderer.applyAlpha(graphics.__owner.__worldAlpha);
							renderer.applyColorTransform(graphics.__owner.__worldColorTransform);
							renderer.updateShader();
						}
						else
						{
							shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
							renderer.setShader(shader);
							renderer.applyMatrix(uMatrix);
							renderer.applyBitmapData(blankBitmapData, true, repeat);
							#if lime
							var color:ARGB = (fill : ARGB);
							tempColorTransform.redOffset = color.r;
							tempColorTransform.greenOffset = color.g;
							tempColorTransform.blueOffset = color.b;
							tempColorTransform.__combine(graphics.__owner.__worldColorTransform);
							renderer.applyAlpha((color.a / 0xFF) * graphics.__owner.__worldAlpha);
							renderer.applyColorTransform(tempColorTransform);
							#else
							renderer.applyAlpha(graphics.__owner.__worldAlpha);
							renderer.applyColorTransform(graphics.__owner.__worldColorTransform);
							#end
							renderer.updateShader();
						}

						if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, bufferPosition,
							hasUVTData ? FLOAT_4 : FLOAT_2);
						if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, bufferPosition + vertLength,
							FLOAT_2);

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

						context.__drawTriangles(0, length);

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
					}
				}

				for (type in graphics.__commands.types)
				{
					switch (type)
					{
						case BEGIN_BITMAP_FILL:
							var c = data.readBeginBitmapFill();
							bitmap = c.bitmap;
							bitmapMatrix = c.matrix;
							repeat = c.repeat;
							smooth = c.smooth;
							shaderBuffer = null;
							fill = null;

						case BEGIN_GRADIENT_FILL:
							// not implemented yet, but we don't want to keep
							// the previous fill either.
							data.skip(type);

							fill = 0x00000000;
							shaderBuffer = null;
							bitmap = null;
							bitmapMatrix = null;

						case BEGIN_FILL:
							var c = data.readBeginFill();
							var color = Std.int(c.color);
							var alpha = Std.int(c.alpha * 0xFF);

							fill = (color & 0xFFFFFF) | (alpha << 24);
							shaderBuffer = null;
							bitmap = null;
							bitmapMatrix = null;

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
							bitmapMatrix = c.matrix;

						case DRAW_QUADS:
							if (bitmap != null || fill != null)
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
								var shader:Shader;

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
								else if (bitmap != null)
								{
									shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
									renderer.setShader(shader);
									renderer.applyMatrix(uMatrix);
									renderer.applyBitmapData(bitmap, smooth, repeat);
									renderer.applyAlpha(graphics.__owner.__worldAlpha);
									renderer.applyColorTransform(graphics.__owner.__worldColorTransform);
									renderer.updateShader();
								}
								else
								{
									shader = maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
									renderer.setShader(shader);
									renderer.applyMatrix(uMatrix);
									renderer.applyBitmapData(blankBitmapData, true, repeat);
									#if lime
									var color:ARGB = (fill : ARGB);
									tempColorTransform.redOffset = color.r;
									tempColorTransform.greenOffset = color.g;
									tempColorTransform.blueOffset = color.b;
									tempColorTransform.__combine(graphics.__owner.__worldColorTransform);
									renderer.applyAlpha((color.a / 0xFF) * graphics.__owner.__worldAlpha);
									renderer.applyColorTransform(tempColorTransform);
									#else
									renderer.applyAlpha(graphics.__owner.__worldAlpha);
									renderer.applyColorTransform(graphics.__owner.__worldColorTransform);
									#end
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
						case DRAW_CIRCLE:
							var c = data.readDrawCircle();

							if (bitmap != null || fill != null)
							{
								var numVertices = PolygonFunctions.getEllipseNumVertices(c.radius, c.radius);
								renderDrawTriangles(numVertices * 2, (numVertices - 2) * 3, 0, NONE);
							}

						case DRAW_ELLIPSE:
							var c = data.readDrawEllipse();

							if (bitmap != null || fill != null)
							{
								var radiusX = c.width / 2.0;
								var radiusY = c.height / 2.0;

								var numVertices = PolygonFunctions.getEllipseNumVertices(radiusX * scaleX, radiusY * scaleY);
								renderDrawTriangles(numVertices * 2, (numVertices - 2) * 3, 0, NONE);
							}

						case DRAW_ROUND_RECT:
							var c = data.readDrawRoundRect();

							if (bitmap != null || fill != null)
							{
								var radiusX = c.ellipseWidth / 2.0;
								var radiusY = (c.ellipseHeight != null ? c.ellipseHeight : c.ellipseWidth) / 2.0;

								var numVertices = PolygonFunctions.getRoundRectNumVertices(radiusX * scaleX, radiusY * scaleY);
								renderDrawTriangles(numVertices * 2, (numVertices - 2) * 3, 0, NONE);
							}

						case DRAW_RECT:
							var c = data.readDrawRect();

							if (bitmap != null || fill != null)
							{
								renderDrawTriangles(8, 6, 0, NONE);
							}

						case DRAW_TRIANGLES:
							var c = data.readDrawTriangles();

							if (bitmap != null || fill != null)
							{
								var vertices = c.vertices;
								var indices = c.indices;
								var uvtData = c.uvtData;
								var culling = c.culling;

								renderDrawTriangles(vertices.length, indices != null ? indices.length : 0, uvtData != null ? uvtData.length : 0, culling);
							}

						case END_FILL:
							bitmap = null;
							bitmapMatrix = null;
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
			}

			graphics.__dirty = false;
		}
		graphics.__hardwareDirty = false;
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
		var newBuffer:Float32Array = null;

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

	private static function toScale9Position(pos:Float, scale9Start:Float, scale9Center:Float, unscaledSize:Float, scale:Float):Float
	{
		if (scale <= 0.0)
		{
			// doesn't render if scaled with negative value
			return 0.0;
		}
		var scale9End = unscaledSize - scale9Center - scale9Start;
		var size = unscaledSize * scale;
		var center = size - scale9Start - scale9End;
		if (pos <= scale9Start)
		{
			// start region
			if (center < 0.0)
			{
				return pos * (scale9Start + scale9End + center) / (scale9Start + scale9End);
			}
			return pos;
		}
		if (pos >= (scale9Start + scale9Center))
		{
			// end region
			if (center < 0.0)
			{
				return (scale9Start + (pos - scale9Start - scale9Center)) * (scale9Start + scale9End + center) / (scale9Start + scale9End);
			}
			return scale9Start + center + (pos - scale9Start - scale9Center);
		}
		// center region
		if (center < 0.0)
		{
			return scale9Start * (scale9Start + scale9End + center) / (scale9Start + scale9End);
		}
		return scale9Start + center * (pos - scale9Start) / scale9Center;
	}
}

// =============================================================================
//
//  PolygonFunctions derived from Starling Framework
//  Copyright Gamua GmbH. All Rights Reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// =============================================================================

@:dox(hide) private class PolygonFunctions
{
	public static inline function getEllipseNumVertices(radiusX:Float, radiusY:Float):Int
	{
		var numVertices = Std.int(Math.PI * (Math.abs(radiusX) + Math.abs(radiusY)) / 4.0);
		numVertices = (numVertices < 6) ? 6 : (numVertices > 1024) ? 1024 : numVertices;
		return numVertices;
	}

	public static function buildEllipseVerticesAndIndices(x:Float, y:Float, radiusX:Float, radiusY:Float, scaleX:Float, scaleY:Float, vertices:Vector<Float>,
			indices:Vector<Int>):Void
	{
		var numVertices = getEllipseNumVertices(radiusX * scaleX, radiusY * scaleY);

		var angleDelta:Float = 2.0 * Math.PI / numVertices;
		var angle:Float = 0.0;

		vertices.length = numVertices * 2;
		for (i in 0...numVertices)
		{
			vertices[i * 2] = Math.cos(angle) * radiusX + x + radiusX;
			vertices[i * 2 + 1] = Math.sin(angle) * radiusY + y + radiusY;
			angle += angleDelta;
		}

		indices.length = (numVertices - 2) * 3;
		var from:Int = 0;
		var to:Int = numVertices - 2;
		for (i in from...to)
		{
			indices[i * 3] = 0;
			indices[i * 3 + 1] = i + 1;
			indices[i * 3 + 2] = i + 2;
		}
	}

	public static inline function getRoundRectNumVertices(radiusX:Float, radiusY:Float):Int
	{
		var numVerticesPerCorner = Std.int(Math.PI * (Math.abs(radiusX) + Math.abs(radiusY)) / 4.0);
		numVerticesPerCorner = (numVerticesPerCorner < 3) ? 3 : (numVerticesPerCorner > 256) ? 256 : numVerticesPerCorner;
		return numVerticesPerCorner * 4;
	}

	public static function buildRoundRectVerticesAndIndices(x:Float, y:Float, width:Float, height:Float, radiusX:Float, radiusY:Float, scaleX:Float,
			scaleY:Float, vertices:Vector<Float>, indices:Vector<Int>):Void
	{
		var numVertices = getRoundRectNumVertices(radiusX * scaleX, radiusY * scaleY);
		var verticesPerCorner = Std.int(numVertices / 4);

		var angleDelta:Float = (Math.PI / 2.0) / (verticesPerCorner - 1);
		var angle:Float = 0.0;
		var offsetX:Float = width - radiusX - radiusX;
		var offsetY:Float = height - radiusY - radiusY;
		var horizontal = true;

		vertices.length = numVertices * 2;
		var j = 0;
		var len = verticesPerCorner;
		for (i in 0...4)
		{
			while (j < len)
			{
				vertices[j * 2] = offsetX + Math.cos(angle) * radiusX + x + radiusX;
				vertices[j * 2 + 1] = offsetY + Math.sin(angle) * radiusY + y + radiusY;
				angle += angleDelta;
				j++;
			}
			angle -= angleDelta;
			if (horizontal)
			{
				if (offsetX == 0.0)
				{
					offsetX = width - radiusX - radiusX;
				}
				else
				{
					offsetX = 0.0;
				}
			}
			else
			{
				if (offsetY == 0.0)
				{
					offsetY = height - radiusY - radiusY;
				}
				else
				{
					offsetY = 0.0;
				}
			}
			horizontal = !horizontal;
			len += verticesPerCorner;
		}

		indices.length = (numVertices - 2) * 3;
		var from:Int = 0;
		var to:Int = numVertices - 2;
		for (i in from...to)
		{
			indices[i * 3] = 0;
			indices[i * 3 + 1] = i + 1;
			indices[i * 3 + 2] = i + 2;
		}
	}
}
#end
