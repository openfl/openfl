import DrawCommandReader from "../../../_internal/renderer/DrawCommandReader";
import DrawCommandType from "../../../_internal/renderer/DrawCommandType";
import * as internal from "../../../_internal/utils/InternalAccess";
import BitmapData from "../../../display/BitmapData";
import Graphics from "../../../display/Graphics";
import PixelSnapping from "../../../display/PixelSnapping";
import Shader from "../../../display/Shader";
import TriangleCulling from "../../../display/TriangleCulling";
import Context3DBufferUsage from "../../../display3D/Context3DBufferUsage";
import Context3DTriangleFace from "../../../display3D/Context3DTriangleFace";
import Context3DVertexBufferFormat from "../../../display3D/Context3DVertexBufferFormat";
import ColorTransform from "../../../geom/ColorTransform";
import Matrix from "../../../geom/Matrix";
import Rectangle from "../../../geom/Rectangle";
// import openfl._internal.backend.lime_standalone.ARGB;
import CanvasGraphics from "../canvas/CanvasGraphics";
import CanvasRenderer from "../canvas/CanvasRenderer";
import ARGB from "../../graphics/ARGB";
import { default as Context3DBuffer, Context3DElementType } from "./Context3DBuffer";
import Context3DRenderer from "./Context3DRenderer";

export default class Context3DGraphics
{
	public static blankBitmapData = new BitmapData(1, 1, false, 0);
	public static maskRender: boolean;
	public static tempColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);

	public static buildBuffer(graphics: Graphics, renderer: Context3DRenderer): void
	{
		var quadBufferPosition = 0;
		var triangleIndexBufferPosition = 0;
		var vertexBufferPosition = 0;
		var vertexBufferPositionUVT = 0;

		var data = new DrawCommandReader((<internal.Graphics><any>graphics).__commands);

		var context = renderer.context3D;

		var tileRect = (<internal.Rectangle><any>Rectangle).__pool.get();
		var tileTransform = (<internal.Matrix><any>Matrix).__pool.get();

		var bitmap = null;

		for (let type of (<internal.Graphics><any>graphics).__commands.types)
		{
			switch (type)
			{
				case DrawCommandType.BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					bitmap = c.bitmap;
					break;

				case DrawCommandType.BEGIN_FILL:
					bitmap = null;
					data.skip(type);
					break;

				case DrawCommandType.BEGIN_SHADER_FILL:
					var c2 = data.readBeginShaderFill();
					var shaderBuffer = c2.shaderBuffer;

					bitmap = null;

					if (shaderBuffer != null)
					{
						for (let i = 0; i < shaderBuffer.inputCount; i++)
						{
							if (shaderBuffer.inputRefs[i].name == "bitmap")
							{
								bitmap = shaderBuffer.inputs[i];
								break;
							}
						}
					}
					break;

				case DrawCommandType.DRAW_QUADS:
					// TODO: Other fill types

					if (bitmap != null)
					{
						var c3 = data.readDrawQuads();
						var rects = c3.rects;
						var indices = c3.indices;
						var transforms = c3.transforms;

						// #if cpp
						// var rects: Array<Float> = rects == null ? null : untyped(rects).__array;
						// var indices: Array<Int> = indices == null ? null : untyped(indices).__array;
						// var transforms: Array<Float> = transforms == null ? null : untyped(transforms).__array;
						// #end

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

						if ((<internal.Graphics><any>graphics).__renderData.quadBuffer == null)
						{
							(<internal.Graphics><any>graphics).__renderData.quadBuffer = new Context3DBuffer(context, Context3DElementType.QUADS, length, dataPerVertex);
						}
						else
						{
							(<internal.Graphics><any>graphics).__renderData.quadBuffer.resize(quadBufferPosition + length, dataPerVertex);
						}

						var vertexOffset: number, alpha = 1.0, tileData, id;
						var bitmapWidth,
							bitmapHeight,
							tileWidth: number,
							tileHeight: number;
						var uvX, uvY, uvWidth, uvHeight;
						var x, y, x2, y2, x3, y3, x4, y4;
						var ri, ti;

						var vertexBufferData = (<internal.Graphics><any>graphics).__renderData.quadBuffer.vertexBufferData;

						// #if openfl_power_of_two
						// bitmapWidth = 1;
						// bitmapHeight = 1;
						// while (bitmapWidth < bitmap.width)
						// {
						// 	bitmapWidth <<= 1;
						// }
						// while (bitmapHeight < bitmap.height)
						// {
						// 	bitmapHeight <<= 1;
						// }
						// #else
						bitmapWidth = bitmap.width;
						bitmapHeight = bitmap.height;
						// #end

						var sourceRect = bitmap.rect;

						for (let i = 0; i < length; i++)
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

							x = (<internal.Matrix><any>tileTransform).__transformX(0, 0);
							y = (<internal.Matrix><any>tileTransform).__transformY(0, 0);
							x2 = (<internal.Matrix><any>tileTransform).__transformX(tileWidth, 0);
							y2 = (<internal.Matrix><any>tileTransform).__transformY(tileWidth, 0);
							x3 = (<internal.Matrix><any>tileTransform).__transformX(0, tileHeight);
							y3 = (<internal.Matrix><any>tileTransform).__transformY(0, tileHeight);
							x4 = (<internal.Matrix><any>tileTransform).__transformX(tileWidth, tileHeight);
							y4 = (<internal.Matrix><any>tileTransform).__transformY(tileWidth, tileHeight);

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
					break;

				case DrawCommandType.DRAW_TRIANGLES:
					var c4 = data.readDrawTriangles();
					var vertices = c4.vertices;
					var indices = c4.indices;
					var uvtData = c4.uvtData;
					var culling = c4.culling;

					var hasIndices = (indices != null);
					var numVertices = Math.floor(vertices.length / 2);
					var length = hasIndices ? indices.length : numVertices;

					var hasUVData = (uvtData != null);
					var hasUVTData = (hasUVData && uvtData.length >= (numVertices * 3));
					var vertLength = hasUVTData ? 4 : 2;
					var uvStride = hasUVTData ? 3 : 2;

					var dataPerVertex = vertLength + 2;
					var vertexOffset: number = hasUVTData ? vertexBufferPositionUVT : vertexBufferPosition;

					// TODO: Use index buffer for indexed render

					// if (hasIndices) resizeIndexBuffer (graphics, false, triangleIndexBufferPosition + length);
					this.resizeVertexBuffer(graphics, hasUVTData, vertexOffset + (length * dataPerVertex));

					// indexBufferData = (<internal.Graphics><any>graphics).__triangleIndexBufferData;
					var vertexBufferData = hasUVTData ? (<internal.Graphics><any>graphics).__renderData.vertexBufferDataUVT : (<internal.Graphics><any>graphics).__renderData.vertexBufferData;
					var offset, vertOffset, uvOffset, t;

					var uScale = bitmap.width / bitmap.__renderData.textureWidth;
					var vScale = bitmap.height / bitmap.__renderData.textureHeight;

					for (let i = 0; i < length; i++)
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

						// #if openfl_power_of_two
						// vertexBufferData[offset + vertLength] = hasUVData ? uvtData[uvOffset] * uScale : 0;
						// vertexBufferData[offset + vertLength + 1] = hasUVData ? uvtData[uvOffset + 1] * vScale : 0;
						// #else
						vertexBufferData[offset + vertLength] = hasUVData ? uvtData[uvOffset] : 0;
						vertexBufferData[offset + vertLength + 1] = hasUVData ? uvtData[uvOffset + 1] : 0;
						// #end
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
					break;

				case DrawCommandType.END_FILL:
					bitmap = null;
					break;

				default:
					data.skip(type);
			}
		}

		// TODO: Should we use static data specific to Context3DGraphics instead of each Graphics instance?

		if (quadBufferPosition > 0)
		{
			(<internal.Graphics><any>graphics).__renderData.quadBuffer.flushVertexBufferData();
		}

		if (triangleIndexBufferPosition > 0)
		{
			var buffer = (<internal.Graphics><any>graphics).__renderData.triangleIndexBuffer;

			if (buffer == null || triangleIndexBufferPosition > (<internal.Graphics><any>graphics).__renderData.triangleIndexBufferCount)
			{
				buffer = context.createIndexBuffer(triangleIndexBufferPosition, Context3DBufferUsage.DYNAMIC_DRAW);
				(<internal.Graphics><any>graphics).__renderData.triangleIndexBuffer = buffer;
				(<internal.Graphics><any>graphics).__renderData.triangleIndexBufferCount = triangleIndexBufferPosition;
			}

			buffer.uploadFromTypedArray((<internal.Graphics><any>graphics).__renderData.triangleIndexBufferData);
		}

		if (vertexBufferPosition > 0)
		{
			var vertexBuffer = (<internal.Graphics><any>graphics).__renderData.vertexBuffer;

			if (vertexBuffer == null || vertexBufferPosition > (<internal.Graphics><any>graphics).__renderData.vertexBufferCount)
			{
				vertexBuffer = context.createVertexBuffer(vertexBufferPosition, 4, Context3DBufferUsage.DYNAMIC_DRAW);
				(<internal.Graphics><any>graphics).__renderData.vertexBuffer = vertexBuffer;
				(<internal.Graphics><any>graphics).__renderData.vertexBufferCount = vertexBufferPosition;
			}

			vertexBuffer.uploadFromTypedArray((<internal.Graphics><any>graphics).__renderData.vertexBufferData);
		}

		if (vertexBufferPositionUVT > 0)
		{
			var vertexBuffer = (<internal.Graphics><any>graphics).__renderData.vertexBufferUVT;

			if (vertexBuffer == null || vertexBufferPositionUVT > (<internal.Graphics><any>graphics).__renderData.vertexBufferCountUVT)
			{
				vertexBuffer = context.createVertexBuffer(vertexBufferPositionUVT, 6, Context3DBufferUsage.DYNAMIC_DRAW);
				(<internal.Graphics><any>graphics).__renderData.vertexBufferUVT = vertexBuffer;
				(<internal.Graphics><any>graphics).__renderData.vertexBufferCountUVT = vertexBufferPositionUVT;
			}

			vertexBuffer.uploadFromTypedArray((<internal.Graphics><any>graphics).__renderData.vertexBufferDataUVT);
		}

		(<internal.Rectangle><any>Rectangle).__pool.release(tileRect);
		(<internal.Matrix><any>Matrix).__pool.release(tileTransform);
	}

	public static isCompatible(graphics: Graphics): boolean
	{
		// #if(openfl_force_sw_graphics || force_sw_graphics)
		// return false;
		// #elseif(openfl_force_hw_graphics || force_hw_graphics)
		// return true;
		// #end

		if ((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldScale9Grid != null)
		{
			return false;
		}

		var data = new DrawCommandReader((<internal.Graphics><any>graphics).__commands);
		var hasColorFill = false, hasBitmapFill = false, hasShaderFill = false;

		for (let type of (<internal.Graphics><any>graphics).__commands.types)
		{
			switch (type)
			{
				case DrawCommandType.BEGIN_BITMAP_FILL:
					hasBitmapFill = true;
					hasColorFill = false;
					hasShaderFill = false;
					data.skip(type);
					break;

				case DrawCommandType.BEGIN_FILL:
					hasBitmapFill = false;
					hasColorFill = true;
					hasShaderFill = false;
					data.skip(type);
					break;

				case DrawCommandType.BEGIN_SHADER_FILL:
					hasBitmapFill = false;
					hasColorFill = false;
					hasShaderFill = true;
					data.skip(type);
					break;

				case DrawCommandType.DRAW_QUADS:
					if (hasBitmapFill || hasShaderFill)
					{
						data.skip(type);
					}
					else
					{
						data.destroy();
						return false;
					}
					break;

				case DrawCommandType.DRAW_RECT:
					if (hasColorFill)
					{
						data.skip(type);
					}
					else
					{
						data.destroy();
						return false;
					}
					break;

				case DrawCommandType.DRAW_TRIANGLES:
					if (hasBitmapFill || hasShaderFill)
					{
						data.skip(type);
					}
					else
					{
						data.destroy();
						return false;
					}
					break;

				case DrawCommandType.END_FILL:
					hasBitmapFill = false;
					hasColorFill = false;
					hasShaderFill = false;
					data.skip(type);
					break;

				case DrawCommandType.MOVE_TO:
					data.skip(type);
					break;

				case DrawCommandType.OVERRIDE_BLEND_MODE:
					data.skip(type);
					break;

				default:
					data.destroy();
					return false;
			}
		}

		data.destroy();
		return true;
	}

	public static render(graphics: Graphics, renderer: Context3DRenderer): void
	{
		if (!(<internal.Graphics><any>graphics).__visible || (<internal.Graphics><any>graphics).__commands.length == 0) return;

		if (((<internal.Graphics><any>graphics).__bitmap != null && !(<internal.Graphics><any>graphics).__dirty) /*#if!hwgraphics || !isCompatible(graphics) #end*/)
		{
			// if ((<internal.Graphics><any>graphics).__renderData.quadBuffer != null || (<internal.Graphics><any>graphics).__triangleIndexBuffer != null) {

			// TODO: Should this be kept?

			// (<internal.Graphics><any>graphics).__renderData.quadBuffer = null;
			// (<internal.Graphics><any>graphics).__triangleIndexBuffer = null;
			// (<internal.Graphics><any>graphics).__triangleIndexBufferData = null;
			// (<internal.Graphics><any>graphics).__renderData.vertexBuffer = null;
			// (<internal.Graphics><any>graphics).__renderData.vertexBufferData = null;
			// (<internal.Graphics><any>graphics).__renderData.vertexBufferDataUVT = null;
			// (<internal.Graphics><any>graphics).__renderData.vertexBufferUVT = null;

			// }

			var cacheTransform = (<internal.DisplayObjectRenderer><any>renderer.__softwareRenderer).__worldTransform;
			(<internal.DisplayObjectRenderer><any>renderer.__softwareRenderer).__worldTransform = (<internal.DisplayObjectRenderer><any>renderer).__worldTransform;

			CanvasGraphics.render(graphics, renderer.__softwareRenderer as CanvasRenderer);

			(<internal.DisplayObjectRenderer><any>renderer.__softwareRenderer).__worldTransform = cacheTransform;
		}
		else
		{
			// 		#if hwgraphics
			// if (!isCompatible(graphics))
			// {
			// 	openfl._internal.renderer.opengl.utils.GraphicsRenderer.render(graphics, renderer);
			// 	(<internal.Graphics><any>graphics).__hardwareDirty = false;
			// 	(<internal.Graphics><any>graphics).__dirty = false;
			// 	return;
			// }
			// 		#end

			(<internal.Graphics><any>graphics).__bitmap = null;
			(<internal.Graphics><any>graphics).__update((<internal.DisplayObjectRenderer><any>renderer).__worldTransform);

			var bounds = (<internal.Graphics><any>graphics).__bounds;

			var width = (<internal.Graphics><any>graphics).__width;
			var height = (<internal.Graphics><any>graphics).__height;

			if (bounds != null && width >= 1 && height >= 1)
			{
				if ((<internal.Graphics><any>graphics).__hardwareDirty
					|| ((<internal.Graphics><any>graphics).__renderData.quadBuffer == null
						&& (<internal.Graphics><any>graphics).__renderData.vertexBuffer == null
						&& (<internal.Graphics><any>graphics).__renderData.vertexBufferUVT == null))
				{
					this.buildBuffer(graphics, renderer);
				}

				var data = new DrawCommandReader((<internal.Graphics><any>graphics).__commands);

				var context = renderer.context3D;

				var matrix = (<internal.Matrix><any>Matrix).__pool.get();

				var shaderBuffer = null;
				var bitmap = null;
				var repeat = false;
				var smooth = false;
				var fill: null | number = null;

				var positionX = 0.0;
				var positionY = 0.0;

				var quadBufferPosition = 0;
				var shaderBufferOffset = 0;
				var triangleIndexBufferPosition = 0;
				var vertexBufferPosition = 0;
				var vertexBufferPositionUVT = 0;

				// 		#if!disable_batcher
				// if ((<internal.Graphics><any>graphics).__commands.length > 0)
				// {
				// 	renderer.batcher.flush();
				// }
				// 		#end

				for (let type of (<internal.Graphics><any>graphics).__commands.types)
				{
					switch (type)
					{
						case DrawCommandType.BEGIN_BITMAP_FILL:
							var c = data.readBeginBitmapFill();
							bitmap = c.bitmap;
							repeat = c.repeat;
							smooth = c.smooth;
							shaderBuffer = null;
							fill = null;
							break;

						case DrawCommandType.BEGIN_FILL:
							var c2 = data.readBeginFill();
							var color = Math.floor(c2.color);
							var alpha = Math.floor(c2.alpha * 0xFF);

							fill = (color & 0xFFFFFF) | (alpha << 24);
							shaderBuffer = null;
							bitmap = null;
							break;

						case DrawCommandType.BEGIN_SHADER_FILL:
							var c3 = data.readBeginShaderFill();
							shaderBuffer = c3.shaderBuffer;
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
							break;

						case DrawCommandType.DRAW_QUADS:
							if (bitmap != null)
							{
								var c4 = data.readDrawQuads();
								var rects = c4.rects;
								var indices = c4.indices;
								var transforms = c4.transforms;

								// #if cpp
								// var rects: Array<Float> = rects == null ? null : untyped(rects).__array;
								// var indices: Array<Int> = indices == null ? null : untyped(indices).__array;
								// var transforms: Array<Float> = transforms == null ? null : untyped(transforms).__array;
								// #end

								var hasIndices = (indices != null);
								var length = hasIndices ? indices.length : Math.floor(rects.length / 4);

								var uMatrix = renderer.__getMatrix((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__renderTransform, PixelSnapping.AUTO);
								var shader;

								if (shaderBuffer != null && !this.maskRender)
								{
									shader = renderer.__initShaderBuffer(shaderBuffer);

									renderer.__setShaderBuffer(shaderBuffer);
									renderer.applyMatrix(uMatrix);
									renderer.applyBitmapData(bitmap, false /* ignored */, repeat);
									renderer.applyAlpha(renderer.__getAlpha((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldAlpha));
									renderer.applyColorTransform((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldColorTransform);
									// renderer.__updateShaderBuffer ();
								}
								else
								{
									shader = this.maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
									renderer.setShader(shader);
									renderer.applyMatrix(uMatrix);
									renderer.applyBitmapData(bitmap, smooth, repeat);
									renderer.applyAlpha(renderer.__getAlpha((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldAlpha));
									renderer.applyColorTransform((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldColorTransform);
									renderer.updateShader();
								}

								var end = quadBufferPosition + length;

								while (quadBufferPosition < end)
								{
									length = Math.floor(Math.min(end - quadBufferPosition, (<internal.Context3D><any>context).__quadIndexBufferElements));
									if (length <= 0) break;

									if (shaderBuffer != null && !this.maskRender)
									{
										renderer.__updateShaderBuffer(shaderBufferOffset);
									}

									if (shader.__position != null) context.setVertexBufferAt(shader.__position.index,
										(<internal.Graphics><any>graphics).__renderData.quadBuffer.vertexBuffer, quadBufferPosition * 16, Context3DVertexBufferFormat.FLOAT_2);
									if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index,
										(<internal.Graphics><any>graphics).__renderData.quadBuffer.vertexBuffer, (quadBufferPosition * 16) + 2, Context3DVertexBufferFormat.FLOAT_2);

									context.drawTriangles((<internal.Context3D><any>context).__quadIndexBuffer, 0, length * 2);

									shaderBufferOffset += length * 4;
									quadBufferPosition += length;
								}

								renderer.__clearShader();
							}
							break;

						case DrawCommandType.DRAW_RECT:
							if (fill != null)
							{
								var c5 = data.readDrawRect();
								var x = c5.x;
								var y = c5.y;
								var width = c5.width;
								var height = c5.height;

								var color = new ARGB(fill);
								this.tempColorTransform.redOffset = color.r;
								this.tempColorTransform.greenOffset = color.g;
								this.tempColorTransform.blueOffset = color.b;
								(<internal.ColorTransform><any>this.tempColorTransform).__combine((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldColorTransform);

								matrix.identity();
								matrix.scale(width, height);
								matrix.tx = x;
								matrix.ty = y;
								matrix.concat((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__renderTransform);

								var shader: Shader = this.maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
								renderer.setShader(shader);
								renderer.applyMatrix(renderer.__getMatrix(matrix, PixelSnapping.AUTO));
								renderer.applyBitmapData(this.blankBitmapData, true, repeat);
								renderer.applyAlpha(renderer.__getAlpha((color.a / 0xFF) * (<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldAlpha));
								renderer.applyColorTransform(this.tempColorTransform);
								renderer.updateShader();

								var vertexBuffer = this.blankBitmapData.getVertexBuffer(context);
								if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
								if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
								var indexBuffer = this.blankBitmapData.getIndexBuffer(context);
								context.drawTriangles(indexBuffer);

								shaderBufferOffset += 4;

								// #if gl_stats
								// Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
								// #end

								renderer.__clearShader();
							}
							break;

						case DrawCommandType.DRAW_TRIANGLES:
							var c6 = data.readDrawTriangles();
							var vertices = c6.vertices;
							var indices = c6.indices;
							var uvtData = c6.uvtData;
							var culling = c6.culling;

							var hasIndices = (indices != null);
							var numVertices = Math.floor(vertices.length / 2);
							var length = hasIndices ? indices.length : numVertices;

							var hasUVData = (uvtData != null);
							var hasUVTData = (hasUVData && uvtData.length >= (numVertices * 3));
							var vertLength = hasUVTData ? 4 : 2;
							var uvStride = hasUVTData ? 3 : 2;

							var dataPerVertex = vertLength + 2;
							var vertexBuffer = hasUVTData ? (<internal.Graphics><any>graphics).__renderData.vertexBufferUVT : (<internal.Graphics><any>graphics).__renderData.vertexBuffer;
							var bufferPosition = hasUVTData ? vertexBufferPositionUVT : vertexBufferPosition;

							var uMatrix = renderer.__getMatrix((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__renderTransform, PixelSnapping.AUTO);
							var shader;

							if (shaderBuffer != null && !this.maskRender)
							{
								shader = renderer.__initShaderBuffer(shaderBuffer);

								renderer.__setShaderBuffer(shaderBuffer);
								renderer.applyMatrix(uMatrix);
								renderer.applyBitmapData(bitmap, false, repeat);
								renderer.applyAlpha(renderer.__getAlpha(1));
								renderer.applyColorTransform(null);
								renderer.__updateShaderBuffer(shaderBufferOffset);
							}
							else
							{
								shader = this.maskRender ? renderer.__maskShader : renderer.__initGraphicsShader(null);
								renderer.setShader(shader);
								renderer.applyMatrix(uMatrix);
								renderer.applyBitmapData(bitmap, smooth, repeat);
								renderer.applyAlpha(renderer.__getAlpha((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldAlpha));
								renderer.applyColorTransform((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldColorTransform);
								renderer.updateShader();
							}

							if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, bufferPosition,
								hasUVTData ? Context3DVertexBufferFormat.FLOAT_4 : Context3DVertexBufferFormat.FLOAT_2);
							if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer,
								bufferPosition + vertLength, Context3DVertexBufferFormat.FLOAT_2);

							switch (culling)
							{
								case TriangleCulling.POSITIVE:
									context.setCulling(Context3DTriangleFace.FRONT);

								case TriangleCulling.NEGATIVE:
									context.setCulling(Context3DTriangleFace.BACK);

								case TriangleCulling.NONE:
									context.setCulling(Context3DTriangleFace.NONE);

								default:
							}

							// if (hasIndices) {

							// 	context.drawTriangles ((<internal.Graphics><any>graphics).__triangleIndexBuffer, triangleIndexBufferPosition, Math.floor (length / 3));
							// 	triangleIndexBufferPosition += length;

							// } else {

							(<internal.Context3D><any>context).___drawTriangles(0, length);

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
								case TriangleCulling.POSITIVE:
								case TriangleCulling.NONE:
									context.setCulling(Context3DTriangleFace.BACK);

								default:
							}

							renderer.__clearShader();

						case DrawCommandType.END_FILL:
							bitmap = null;
							fill = null;
							shaderBuffer = null;
							data.skip(type);
							break;

						case DrawCommandType.MOVE_TO:
							var c7 = data.readMoveTo();
							positionX = c7.x;
							positionY = c7.y;
							break;

						case DrawCommandType.OVERRIDE_BLEND_MODE:
							var c8 = data.readOverrideBlendMode();
							renderer.__setBlendMode(c8.blendMode);
							break;

						default:
							data.skip(type);
					}
				}

				(<internal.Matrix><any>Matrix).__pool.release(matrix);
			}

			(<internal.Graphics><any>graphics).__hardwareDirty = false;
			(<internal.Graphics><any>graphics).__dirty = false;
		}
	}

	public static renderMask(graphics: Graphics, renderer: Context3DRenderer): void
	{
		// TODO: Support invisible shapes

		this.maskRender = true;
		this.render(graphics, renderer);
		this.maskRender = false;
	}

	public static resizeIndexBuffer(graphics: Graphics, isQuad: boolean, length: number): void
	{
		if (isQuad) return;

		var buffer = (isQuad ? null /*(<internal.Graphics><any>graphics).__quadIndexBufferData*/ : (<internal.Graphics><any>graphics).__renderData.triangleIndexBufferData);
		var position = 0, newBuffer = null;

		if (buffer == null)
		{
			newBuffer = new Uint16Array(length);
		}
		else if (length > buffer.length)
		{
			newBuffer = new Uint16Array(length);
			newBuffer.set(buffer);
			position = buffer.length;
		}

		if (newBuffer != null)
		{
			if (isQuad)
			{
				// vertexIndex = Std.int (position * (4 / 6));

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

				// (<internal.Graphics><any>graphics).__quadIndexBufferData = newBuffer;
			}
			else
			{
				(<internal.Graphics><any>graphics).__renderData.triangleIndexBufferData = newBuffer;
			}
		}
	}

	public static resizeVertexBuffer(graphics: Graphics, hasUVTData: boolean, length: number): void
	{
		var buffer = (hasUVTData ? (<internal.Graphics><any>graphics).__renderData.vertexBufferDataUVT : (<internal.Graphics><any>graphics).__renderData.vertexBufferData);
		var newBuffer = null;

		if (buffer == null)
		{
			newBuffer = new Float32Array(length);
		}
		else if (length > buffer.length)
		{
			newBuffer = new Float32Array(length);
			newBuffer.set(buffer);
		}

		if (newBuffer != null)
		{
			hasUVTData ? (<internal.Graphics><any>graphics).__renderData.vertexBufferDataUVT = newBuffer : (<internal.Graphics><any>graphics).__renderData.vertexBufferData = newBuffer;
		}
	}
}
