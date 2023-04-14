package openfl.display._internal;

#if flash
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.GraphicsBitmapFill;
import openfl.display.GraphicsEndFill;
import openfl.display.GraphicsGradientFill;
import openfl.display.GraphicsPath;
import openfl.display.GraphicsQuadPath;
import openfl.display.GraphicsShaderFill;
import openfl.display.GraphicsSolidFill;
import openfl.display.GraphicsStroke;
import openfl.display.GraphicsTrianglePath;
import openfl.display.IGraphicsData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.Dictionary;
import openfl.Vector;

@:access(flash.display.Graphics)
@SuppressWarnings("checkstyle:FieldDocComment")
class FlashGraphics
{
	public static var bitmapFill:Dictionary<Graphics, BitmapData> = new Dictionary(true);
	private static var tileRect:Rectangle = new Rectangle();
	private static var tileTransform:Matrix = new Matrix();

	public static function drawGraphicsData(graphics:Graphics, graphicsData:Vector<IGraphicsData>):Void
	{
		var hasQuadPath = false;

		if (graphicsData != null)
		{
			for (data in graphicsData)
			{
				if ((data is GraphicsQuadPath))
				{
					hasQuadPath = true;
					break;
				}
			}
		}

		if (hasQuadPath)
		{
			var fill:GraphicsSolidFill;
			var bitmapFill:GraphicsBitmapFill;
			var gradientFill:GraphicsGradientFill;
			var shaderFill:GraphicsShaderFill;
			var stroke:GraphicsStroke;
			var path:GraphicsPath;
			var trianglePath:GraphicsTrianglePath;
			var quadPath:GraphicsQuadPath;

			for (data in graphicsData)
			{
				if ((data is GraphicsSolidFill))
				{
					fill = cast data;
					graphics.beginFill(fill.color, fill.alpha);
				}
				else if ((data is GraphicsBitmapFill))
				{
					bitmapFill = cast data;
					graphics.beginBitmapFill(bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);
				}
				else if ((data is GraphicsGradientFill))
				{
					gradientFill = cast data;
					graphics.beginGradientFill(gradientFill.type, cast gradientFill.colors, cast gradientFill.alphas, cast gradientFill.ratios,
						gradientFill.matrix, gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);
				}
				else if ((data is GraphicsShaderFill))
				{
					shaderFill = cast data;
					graphics.beginShaderFill(shaderFill.shader, shaderFill.matrix);
				}
				else if ((data is GraphicsStroke))
				{
					stroke = cast data;

					if (stroke.fill != null)
					{
						var thickness:Null<Float> = stroke.thickness;

						if (Math.isNaN(thickness))
						{
							thickness = null;
						}

						if ((stroke.fill is GraphicsSolidFill))
						{
							fill = cast stroke.fill;
							graphics.lineStyle(thickness, fill.color, fill.alpha, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints,
								stroke.miterLimit);
						}
						else if ((stroke.fill is GraphicsBitmapFill))
						{
							bitmapFill = cast stroke.fill;
							graphics.lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
							graphics.lineBitmapStyle(bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);
						}
						else if ((stroke.fill is GraphicsGradientFill))
						{
							gradientFill = cast stroke.fill;
							graphics.lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
							graphics.lineGradientStyle(gradientFill.type, cast gradientFill.colors, cast gradientFill.alphas, cast gradientFill.ratios,
								gradientFill.matrix, gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);
						}
						else if ((stroke.fill is GraphicsShaderFill))
						{
							shaderFill = cast stroke.fill;
							graphics.lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
							graphics.lineShaderStyle(shaderFill.shader, shaderFill.matrix);
						}
					}
					else
					{
						graphics.lineStyle();
					}
				}
				else if ((data is GraphicsPath))
				{
					path = cast data;
					graphics.drawPath(path.commands, path.data, path.winding);
				}
				else if ((data is GraphicsTrianglePath))
				{
					trianglePath = cast data;
					graphics.drawTriangles(trianglePath.vertices, trianglePath.indices, trianglePath.uvtData, trianglePath.culling);
				}
				else if ((data is GraphicsEndFill))
				{
					graphics.endFill();
				}
				else if ((data is GraphicsQuadPath))
				{
					quadPath = cast data;
					graphics.drawQuads(quadPath.rects, quadPath.indices, quadPath.transforms);
				}
			}
		}
		else
		{
			graphics.__drawGraphicsData(graphicsData);
		}
	}

	public static function drawQuads(graphics:Graphics, rects:Vector<Float>, indices:Vector<Int>, transforms:Vector<Float>):Void
	{
		var lastBitmapFill = bitmapFill.get(graphics);

		if (rects == null || rects.length == 0) return;

		var sourceRect = (lastBitmapFill != null) ? lastBitmapFill.rect : null;
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

		var ri, ti;

		var vertices = new Vector<Float>(length * 8);
		var vIndices = new Vector<Int>(length * 6);
		var uvtData = new Vector<Float>(length * 8);
		var offset4 = 0;
		var offset6 = 0;
		var offset8 = 0;

		var x, y, tw, th, t0, t1, t2, t3;
		var uvX = 0.0, uvY = 0.0, uvWidth = 1.0, uvHeight = 1.0;

		for (i in 0...length)
		{
			ri = (hasIndices ? (indices[i] * 4) : i * 4);
			if (ri < 0) continue;
			tileRect.setTo(rects[ri], rects[ri + 1], rects[ri + 2], rects[ri + 3]);

			if (tileRect.width <= 0 || tileRect.height <= 0)
			{
				continue;
			}

			if (transformABCD && transformXY)
			{
				ti = i * 6;
				tileTransform.setTo(transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], transforms[ti + 4], transforms[ti + 5]);
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

			tw = tileRect.width;
			th = tileRect.height;
			t0 = tileTransform.a;
			t1 = tileTransform.b;
			t2 = tileTransform.c;
			t3 = tileTransform.d;
			x = tileTransform.tx;
			y = tileTransform.ty;

			// Code for tile point offset

			// ox = tilePoint.x * tw;
			// oy = tilePoint.y * th;
			// ox_ = ox * t0 + oy * t2;

			// oy = ox * t1 + oy * t3;
			// x -= ox_;
			// y -= oy;

			vertices[offset8] = x;
			vertices[offset8 + 1] = y;
			vertices[offset8 + 2] = x + tw * t0;
			vertices[offset8 + 3] = y + tw * t1;
			vertices[offset8 + 4] = x + th * t2;
			vertices[offset8 + 5] = y + th * t3;
			vertices[offset8 + 6] = x + tw * t0 + th * t2;
			vertices[offset8 + 7] = y + tw * t1 + th * t3;

			vIndices[offset6] = 0 + offset4;
			vIndices[offset6 + 1] = vIndices[offset6 + 3] = 1 + offset4;
			vIndices[offset6 + 2] = vIndices[offset6 + 5] = 2 + offset4;
			vIndices[offset6 + 4] = 3 + offset4;

			if (sourceRect != null)
			{
				uvX = tileRect.x / sourceRect.width;
				uvY = tileRect.y / sourceRect.height;
				uvWidth = tileRect.right / sourceRect.width;
				uvHeight = tileRect.bottom / sourceRect.height;

				uvtData[offset8] = uvtData[offset8 + 4] = uvX;
				uvtData[offset8 + 1] = uvtData[offset8 + 3] = uvY;
				uvtData[offset8 + 2] = uvtData[offset8 + 6] = uvWidth;
				uvtData[offset8 + 5] = uvtData[offset8 + 7] = uvHeight;
			}

			offset4 += 4;
			offset6 += 6;
			offset8 += 8;
		}

		if (sourceRect != null)
		{
			graphics.drawTriangles(vertices, vIndices, uvtData);
		}
		else
		{
			graphics.drawTriangles(vertices, vIndices);
		}
	}
}
#end
