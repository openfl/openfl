package openfl.display;

// import openfl.display._internal.Context3DBuffer;
import openfl._internal.renderer.DisplayObjectRenderData;
import openfl._internal.renderer.DrawCommandBuffer;
import openfl._internal.renderer.DrawCommandReader;
import openfl._internal.renderer.ShaderBuffer;
import lime.utils.Float32Array;
import openfl._internal.utils.ObjectPool;
import lime.utils.UInt16Array;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display._DisplayObject;
import openfl.errors.ArgumentError;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
import openfl.Vector;
#if openfl_html5
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
// import openfl.display._internal.CanvasGraphics;
#else
import lime.graphics.cairo.Cairo;

// import openfl.display._internal.CairoGraphics;
#end
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
@:final class _Graphics
{
	public static var maxTextureHeight:Null<Int> = null;
	public static var maxTextureWidth:Null<Int> = null;

	public var __bitmap:BitmapData;
	public var __bounds:Rectangle;
	public var __commands:DrawCommandBuffer;
	public var __dirty(default, set):Bool = true;
	public var __hardwareDirty:Bool;
	public var __height:Int;
	public var __managed:Bool;
	public var __positionX:Float;
	public var __positionY:Float;
	public var __renderData:DisplayObjectRenderData;
	public var __renderTransform:Matrix;
	public var __shaderBufferPool:ObjectPool<ShaderBuffer>;
	public var __softwareDirty:Bool;
	public var __strokePadding:Float;
	public var __transformDirty:Bool;
	public var __usedShaderBuffers:List<ShaderBuffer>;
	public var __visible:Bool;
	// public var __cachedTexture:RenderTexture;
	public var __owner:DisplayObject;
	public var __width:Int;
	public var __worldTransform:Matrix;

	#if draft
	public var __drawPaths:Array<openfl._internal.renderer.opengl.utils.DrawPath>;
	public var __glStack:Array<openfl._internal.renderer.opengl.utils.GLStack> = [];
	#end

	public function new(owner:DisplayObject)
	{
		__owner = owner;

		__commands = new DrawCommandBuffer();
		__strokePadding = 0;
		__positionX = 0;
		__positionY = 0;
		__renderTransform = new Matrix();
		__usedShaderBuffers = new List<ShaderBuffer>();
		__worldTransform = new Matrix();
		__width = 0;
		__height = 0;

		__renderData = new DisplayObjectRenderData();
		__shaderBufferPool = new ObjectPool<ShaderBuffer>(function() return new ShaderBuffer());

		#if openfl_html5
		moveTo(0, 0);
		#end
	}

	public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void
	{
		__commands.beginBitmapFill(bitmap, matrix != null ? matrix.clone() : null, repeat, smooth);

		__visible = true;
	}

	public function beginFill(color:Int = 0, alpha:Float = 1):Void
	{
		__commands.beginFill(color & 0xFFFFFF, alpha);

		if (alpha > 0) __visible = true;
	}

	public function beginGradientFill(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null,
			spreadMethod:SpreadMethod = SpreadMethod.PAD, interpolationMethod:InterpolationMethod = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void
	{
		if (colors == null || colors.length == 0) return;

		if (alphas == null)
		{
			alphas = [];

			for (i in 0...colors.length)
			{
				alphas.push(1);
			}
		}

		if (ratios == null)
		{
			ratios = [];

			for (i in 0...colors.length)
			{
				ratios.push(Math.ceil((i / colors.length) * 255));
			}
		}

		if (alphas.length < colors.length || ratios.length < colors.length) return;

		__commands.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);

		for (alpha in alphas)
		{
			if (alpha > 0)
			{
				__visible = true;
				break;
			}
		}
	}

	public function beginShaderFill(shader:Shader, matrix:Matrix = null):Void
	{
		if (shader != null)
		{
			var shaderBuffer = __shaderBufferPool.get();
			__usedShaderBuffers.add(shaderBuffer);
			shaderBuffer.update(cast shader);

			__commands.beginShaderFill(shaderBuffer);
		}
	}

	public function clear():Void
	{
		for (shaderBuffer in __usedShaderBuffers)
		{
			__shaderBufferPool.release(shaderBuffer);
		}

		__usedShaderBuffers.clear();
		__commands.clear();
		__strokePadding = 0;

		if (__bounds != null)
		{
			__dirty = true;
			__transformDirty = true;
			__bounds = null;
			__owner._.__localBoundsDirty = true;
		}

		__visible = false;
		__positionX = 0;
		__positionY = 0;

		#if openfl_html5
		moveTo(0, 0);
		#end
	}

	public function copyFrom(sourceGraphics:Graphics):Void
	{
		__bounds = sourceGraphics._.__bounds != null ? sourceGraphics._.__bounds.clone() : null;
			(__owner._ : _DisplayObject).__localBoundsDirty = true;
		__commands = sourceGraphics._.__commands.copy();
		__dirty = true;
		__strokePadding = sourceGraphics._.__strokePadding;
		__positionX = sourceGraphics._.__positionX;
		__positionY = sourceGraphics._.__positionY;
		__transformDirty = true;
		__visible = sourceGraphics._.__visible;
	}

	public function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void
	{
		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding, __positionY + __strokePadding);

		var ix1, iy1, ix2, iy2;

		ix1 = anchorX;
		ix2 = anchorX;

		if (!(((controlX1 < anchorX && controlX1 > __positionX) || (controlX1 > anchorX && controlX1 < __positionX))
			&& ((controlX2 < anchorX && controlX2 > __positionX) || (controlX2 > anchorX && controlX2 < __positionX))))
		{
			var u = (2 * __positionX - 4 * controlX1 + 2 * controlX2);
			var v = (controlX1 - __positionX);
			var w = (-__positionX + 3 * controlX1 + anchorX - 3 * controlX2);

			var t1 = (-u + Math.sqrt(u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt(u * u - 4 * v * w)) / (2 * w);

			if (t1 > 0 && t1 < 1)
			{
				ix1 = __calculateBezierCubicPoint(t1, __positionX, controlX1, controlX2, anchorX);
			}

			if (t2 > 0 && t2 < 1)
			{
				ix2 = __calculateBezierCubicPoint(t2, __positionX, controlX1, controlX2, anchorX);
			}
		}

		iy1 = anchorY;
		iy2 = anchorY;

		if (!(((controlY1 < anchorY && controlY1 > __positionX) || (controlY1 > anchorY && controlY1 < __positionX))
			&& ((controlY2 < anchorY && controlY2 > __positionX) || (controlY2 > anchorY && controlY2 < __positionX))))
		{
			var u = (2 * __positionX - 4 * controlY1 + 2 * controlY2);
			var v = (controlY1 - __positionX);
			var w = (-__positionX + 3 * controlY1 + anchorY - 3 * controlY2);

			var t1 = (-u + Math.sqrt(u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt(u * u - 4 * v * w)) / (2 * w);

			if (t1 > 0 && t1 < 1)
			{
				iy1 = __calculateBezierCubicPoint(t1, __positionX, controlY1, controlY2, anchorY);
			}

			if (t2 > 0 && t2 < 1)
			{
				iy2 = __calculateBezierCubicPoint(t2, __positionX, controlY1, controlY2, anchorY);
			}
		}

		__inflateBounds(ix1 - __strokePadding, iy1 - __strokePadding);
		__inflateBounds(ix1 + __strokePadding, iy1 + __strokePadding);
		__inflateBounds(ix2 - __strokePadding, iy2 - __strokePadding);
		__inflateBounds(ix2 + __strokePadding, iy2 + __strokePadding);

		__positionX = anchorX;
		__positionY = anchorY;

		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding, __positionY + __strokePadding);

		__commands.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);

		__dirty = true;
	}

	public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void
	{
		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding, __positionY + __strokePadding);

		var ix, iy;

		if ((controlX < anchorX && controlX > __positionX) || (controlX > anchorX && controlX < __positionX))
		{
			ix = anchorX;
		}
		else
		{
			var tx = ((__positionX - controlX) / (__positionX - 2 * controlX + anchorX));
			ix = __calculateBezierQuadPoint(tx, __positionX, controlX, anchorX);
		}

		if ((controlY < anchorY && controlY > __positionY) || (controlY > anchorY && controlY < __positionY))
		{
			iy = anchorY;
		}
		else
		{
			var ty = ((__positionY - controlY) / (__positionY - (2 * controlY) + anchorY));
			iy = __calculateBezierQuadPoint(ty, __positionY, controlY, anchorY);
		}

		__inflateBounds(ix - __strokePadding, iy - __strokePadding);
		__inflateBounds(ix + __strokePadding, iy + __strokePadding);

		__positionX = anchorX;
		__positionY = anchorY;

		__commands.curveTo(controlX, controlY, anchorX, anchorY);

		__dirty = true;
	}

	public function drawCircle(x:Float, y:Float, radius:Float):Void
	{
		if (radius <= 0) return;

		__inflateBounds(x - radius - __strokePadding, y - radius - __strokePadding);
		__inflateBounds(x + radius + __strokePadding, y + radius + __strokePadding);

		__commands.drawCircle(x, y, radius);

		__dirty = true;
	}

	public function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (width <= 0 || height <= 0) return;

		__inflateBounds(x - __strokePadding, y - __strokePadding);
		__inflateBounds(x + width + __strokePadding, y + height + __strokePadding);

		__commands.drawEllipse(x, y, width, height);

		__dirty = true;
	}

	public function drawGraphicsData(graphicsData:Vector<IGraphicsData>):Void
	{
		var fill:GraphicsSolidFill;
		var bitmapFill:GraphicsBitmapFill;
		var gradientFill:GraphicsGradientFill;
		var shaderFill:GraphicsShaderFill;
		var stroke:GraphicsStroke;
		var path:GraphicsPath;
		var trianglePath:GraphicsTrianglePath;
		var quadPath:GraphicsQuadPath;

		for (graphics in graphicsData)
		{
			switch ((graphics._ : _IGraphicsData).__graphicsDataType)
			{
				case SOLID:
					fill = cast graphics;
					beginFill(fill.color, fill.alpha);

				case BITMAP:
					bitmapFill = cast graphics;
					beginBitmapFill(bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);

				case GRADIENT:
					gradientFill = cast graphics;
					beginGradientFill(gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix,
						gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);

				case SHADER:
					shaderFill = cast graphics;
					beginShaderFill(shaderFill.shader, shaderFill.matrix);

				case STROKE:
					stroke = cast graphics;

					if (stroke.fill != null)
					{
						var thickness:Null<Float> = stroke.thickness;

						if (Math.isNaN(thickness))
						{
							thickness = null;
						}

						switch ((stroke.fill._ : _IGraphicsFill).__graphicsFillType)
						{
							case SOLID_FILL:
								fill = cast stroke.fill;
								lineStyle(thickness, fill.color, fill.alpha, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints,
									stroke.miterLimit);

							case BITMAP_FILL:
								bitmapFill = cast stroke.fill;
								lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
								lineBitmapStyle(bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);

							case GRADIENT_FILL:
								gradientFill = cast stroke.fill;
								lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
								lineGradientStyle(gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix,
									gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);

							default:
						}
					}
					else
					{
						lineStyle();
					}

				case PATH:
					path = cast graphics;
					drawPath(path.commands, path.data, path.winding);

				case TRIANGLE_PATH:
					trianglePath = cast graphics;
					drawTriangles(trianglePath.vertices, trianglePath.indices, trianglePath.uvtData, trianglePath.culling);

				case END:
					endFill();

				case QUAD_PATH:
					quadPath = cast graphics;
					drawQuads(quadPath.rects, quadPath.indices, quadPath.transforms);
			}
		}
	}

	public function drawPath(commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding = GraphicsPathWinding.EVEN_ODD):Void
	{
		var dataIndex = 0;

		if (winding == GraphicsPathWinding.NON_ZERO) __commands.windingNonZero();

		for (command in commands)
		{
			switch (command)
			{
				case GraphicsPathCommand.MOVE_TO:
					moveTo(data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;

				case GraphicsPathCommand.LINE_TO:
					lineTo(data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;

				case GraphicsPathCommand.WIDE_MOVE_TO:
					moveTo(data[dataIndex + 2], data[dataIndex + 3]);
					break;
					dataIndex += 4;

				case GraphicsPathCommand.WIDE_LINE_TO:
					lineTo(data[dataIndex + 2], data[dataIndex + 3]);
					break;
					dataIndex += 4;

				case GraphicsPathCommand.CURVE_TO:
					curveTo(data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3]);
					dataIndex += 4;

				case GraphicsPathCommand.CUBIC_CURVE_TO:
					cubicCurveTo(data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3], data[dataIndex + 4], data[dataIndex + 5]);
					dataIndex += 6;

				default:
			}
		}

		// TODO: Reset to EVEN_ODD after current path is filled?
		// if (winding == GraphicsPathWinding.NON_ZERO) __commands.windingEvenOdd ();
	}

	public function drawQuads(rects:Vector<Float>, indices:Vector<Int> = null, transforms:Vector<Float> = null):Void
	{
		if (rects == null) return;

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

		var tileRect = _Rectangle.__pool.get();
		var tileTransform = _Matrix.__pool.get();

		var minX = Math.POSITIVE_INFINITY;
		var minY = Math.POSITIVE_INFINITY;
		var maxX = Math.NEGATIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;

		var ri, ti;

		for (i in 0...length)
		{
			ri = (hasIndices ? (indices[i] * 4) : i * 4);
			if (ri < 0) continue;
			tileRect.setTo(0, 0, rects[ri + 2], rects[ri + 3]);

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

			tileRect._.__transform(tileRect, tileTransform);

			if (minX > tileRect.x) minX = tileRect.x;
			if (minY > tileRect.y) minY = tileRect.y;
			if (maxX < tileRect.right) maxX = tileRect.right;
			if (maxY < tileRect.bottom) maxY = tileRect.bottom;
		}

		__inflateBounds(minX, minY);
		__inflateBounds(maxX, maxY);

		__commands.drawQuads(rects, indices, transforms);

		__dirty = true;
		__visible = true;

		_Rectangle.__pool.release(tileRect);
		_Matrix.__pool.release(tileTransform);
	}

	public function drawRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (width == 0 && height == 0) return;

		var xSign = width < 0 ? -1 : 1;
		var ySign = height < 0 ? -1 : 1;

		__inflateBounds(x - __strokePadding * xSign, y - __strokePadding * ySign);
		__inflateBounds(x + width + __strokePadding * xSign, y + height + __strokePadding * ySign);

		__commands.drawRect(x, y, width, height);

		__dirty = true;
	}

	public function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float> = null):Void
	{
		if (width == 0 && height == 0) return;

		var xSign = width < 0 ? -1 : 1;
		var ySign = height < 0 ? -1 : 1;

		__inflateBounds(x - __strokePadding * xSign, y - __strokePadding * ySign);
		__inflateBounds(x + width + __strokePadding * xSign, y + height + __strokePadding * ySign);

		__commands.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);

		__dirty = true;
	}

	public function drawRoundRectComplex(x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float,
			bottomRightRadius:Float):Void
	{
		if (width <= 0 || height <= 0) return;

		__inflateBounds(x - __strokePadding, y - __strokePadding);
		__inflateBounds(x + width + __strokePadding, y + height + __strokePadding);

		var xw = x + width;
		var yh = y + height;
		var minSize = width < height ? width * 2 : height * 2;
		topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
		topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
		bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
		bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;

		var anchor = (1 - Math.sin(45 * (Math.PI / 180)));
		var control = (1 - Math.tan(22.5 * (Math.PI / 180)));

		var a = bottomRightRadius * anchor;
		var s = bottomRightRadius * control;
		moveTo(xw, yh - bottomRightRadius);
		curveTo(xw, yh - s, xw - a, yh - a);
		curveTo(xw - s, yh, xw - bottomRightRadius, yh);

		a = bottomLeftRadius * anchor;
		s = bottomLeftRadius * control;
		lineTo(x + bottomLeftRadius, yh);
		curveTo(x + s, yh, x + a, yh - a);
		curveTo(x, yh - s, x, yh - bottomLeftRadius);

		a = topLeftRadius * anchor;
		s = topLeftRadius * control;
		lineTo(x, y + topLeftRadius);
		curveTo(x, y + s, x + a, y + a);
		curveTo(x + s, y, x + topLeftRadius, y);

		a = topRightRadius * anchor;
		s = topRightRadius * control;
		lineTo(xw - topRightRadius, y);
		curveTo(xw - s, y, xw - a, y + a);
		curveTo(xw, y + s, xw, y + topRightRadius);
		lineTo(xw, yh - bottomRightRadius);

		__dirty = true;
	}

	public function drawTriangles(vertices:Vector<Float>, indices:Vector<Int> = null, uvtData:Vector<Float> = null,
			culling:TriangleCulling = TriangleCulling.NONE):Void
	{
		if (vertices == null || vertices.length == 0) return;

		var vertLength = Std.int(vertices.length / 2);

		if (indices == null)
		{
			// TODO: Allow null indices

			if (vertLength % 3 != 0)
			{
				throw new ArgumentError("Not enough vertices to close a triangle.");
			}

			indices = new Vector<Int>();

			for (i in 0...vertLength)
			{
				indices.push(i);
			}
		}

		if (culling == null)
		{
			culling = NONE;
		}

		var x, y;
		var minX = Math.POSITIVE_INFINITY;
		var minY = Math.POSITIVE_INFINITY;
		var maxX = Math.NEGATIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;

		for (i in 0...vertLength)
		{
			x = vertices[i * 2];
			y = vertices[i * 2 + 1];

			if (minX > x) minX = x;
			if (minY > y) minY = y;
			if (maxX < x) maxX = x;
			if (maxY < y) maxY = y;
		}

		__inflateBounds(minX, minY);
		__inflateBounds(maxX, maxY);

		__commands.drawTriangles(vertices, indices, uvtData, culling);

		__dirty = true;
		__visible = true;
	}

	public function endFill():Void
	{
		__commands.endFill();
	}

	public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void
	{
		__commands.lineBitmapStyle(bitmap, matrix != null ? matrix.clone() : null, repeat, smooth);
	}

	public function lineGradientStyle(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null,
			spreadMethod:SpreadMethod = SpreadMethod.PAD, interpolationMethod:InterpolationMethod = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void
	{
		__commands.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
	}

	public function lineStyle(thickness:Null<Float> = null, color:Int = 0, alpha:Float = 1, pixelHinting:Bool = false,
			scaleMode:LineScaleMode = LineScaleMode.NORMAL, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3):Void
	{
		if (thickness != null)
		{
			if (joints == JointStyle.MITER)
			{
				if (thickness > __strokePadding) __strokePadding = thickness;
			}
			else
			{
				if (thickness / 2 > __strokePadding) __strokePadding = thickness / 2;
			}
		}

		__commands.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);

		if (thickness != null) __visible = true;
	}

	public function lineTo(x:Float, y:Float):Void
	{
		if (!Math.isFinite(x) || !Math.isFinite(y))
		{
			return;
		}

		// TODO: Should we consider the origin instead, instead of inflating in all directions?

		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding, __positionY + __strokePadding);

		__positionX = x;
		__positionY = y;

		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding * 2, __positionY + __strokePadding);

		__commands.lineTo(x, y);

		__dirty = true;
	}

	public function moveTo(x:Float, y:Float):Void
	{
		__positionX = x;
		__positionY = y;

		__commands.moveTo(x, y);
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:dox(hide) public function overrideBlendMode(blendMode:BlendMode):Void
	{
		if (blendMode == null) blendMode = NORMAL;
		__commands.overrideBlendMode(blendMode);
	}

	public function readGraphicsData(recurse:Bool = true):Vector<IGraphicsData>
	{
		var graphicsData = new Vector<IGraphicsData>();
		(__owner._ : _DisplayObject).__readGraphicsData(graphicsData, recurse);
		return graphicsData;
	}

	public function __calculateBezierCubicPoint(t:Float, p1:Float, p2:Float, p3:Float, p4:Float):Float
	{
		var iT = 1 - t;
		return p1 * (iT * iT * iT) + 3 * p2 * t * (iT * iT) + 3 * p3 * iT * (t * t) + p4 * (t * t * t);
	}

	public function __calculateBezierQuadPoint(t:Float, p1:Float, p2:Float, p3:Float):Float
	{
		var iT = 1 - t;
		return iT * iT * p1 + 2 * iT * t * p2 + t * t * p3;
	}

	public function __cleanup():Void
	{
		#if openfl_html5
		if (__bounds != null && __renderData.canvas != null)
		{
			__dirty = true;
			__transformDirty = true;
		}
		#else
		if (__bounds != null)
		{
			__dirty = true;
			__transformDirty = true;
		}
		#end

		__bitmap = null;
		__renderData.dispose();
	}

	public function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		if (__bounds == null) return;

		var bounds = _Rectangle._.__pool.get();
		__bounds._.__transform(bounds, matrix);
		rect._.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		_Rectangle._.__pool.release(bounds);
	}

	public function __hitTest(x:Float, y:Float, shapeFlag:Bool, matrix:Matrix):Bool
	{
		if (__bounds == null) return false;

		var px = matrix._.__transformInverseX(x, y);
		var py = matrix._.__transformInverseY(x, y);

		if (px > __bounds.x && py > __bounds.y && __bounds.contains(px, py))
		{
			if (shapeFlag)
			{
				#if openfl_html5
				// return CanvasGraphics.hitTest(this, px, py);
				#elseif openfl_cairo
				// return CairoGraphics.hitTest(this, px, py);
				#end
			}

			return true;
		}

		return false;
	}

	public function __inflateBounds(x:Float, y:Float):Void
	{
		if (__bounds == null)
		{
			__bounds = new Rectangle(x, y, 0, 0);
			__owner._._.__localBoundsDirty = true;
			__transformDirty = true;
		}
		else
		{
			if (x < __bounds.x)
			{
				__bounds.width += __bounds.x - x;
				__bounds.x = x;
				__owner._.__localBoundsDirty = true;
				__transformDirty = true;
			}

			if (y < __bounds.y)
			{
				__bounds.height += __bounds.y - y;
				__bounds.y = y;
				__owner._.__localBoundsDirty = true;
				__transformDirty = true;
			}

			if (x > __bounds.x + __bounds.width)
			{
				__owner._.__localBoundsDirty = true;
				__bounds.width = x - __bounds.x;
			}

			if (y > __bounds.y + __bounds.height)
			{
				__owner._.__localBoundsDirty = true;
				__bounds.height = y - __bounds.y;
			}
		}
	}

	public function __readGraphicsData(graphicsData:Vector<IGraphicsData>):Void
	{
		var data = new DrawCommandReader(__commands);
		var path = null, _path:_GraphicsPath = null, stroke;

		for (type in __commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO, CURVE_TO, LINE_TO, MOVE_TO, DRAW_CIRCLE, DRAW_ELLIPSE, DRAW_RECT, DRAW_ROUND_RECT:
					if (path == null)
					{
						path = new GraphicsPath();
					}

				default:
					if (path != null)
					{
						graphicsData.push(path);
						path = null;
					}
			}

			_path = path._;

			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					_path.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);

				case CURVE_TO:
					var c = data.readCurveTo();
					_path.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);

				case LINE_TO:
					var c = data.readLineTo();
					_path.lineTo(c.x, c.y);

				case MOVE_TO:
					var c = data.readMoveTo();
					_path.moveTo(c.x, c.y);

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					_path.__drawCircle(c.x, c.y, c.radius);

				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					_path.__drawEllipse(c.x, c.y, c.width, c.height);

				case DRAW_RECT:
					var c = data.readDrawRect();
					_path.__drawRect(c.x, c.y, c.width, c.height);

				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					_path.__drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight != null ? c.ellipseHeight : c.ellipseWidth);

				case LINE_GRADIENT_STYLE:
					// TODO

					var c = data.readLineGradientStyle();
				// stroke = new GraphicsStroke (c.thickness, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
				// stroke.fill = new GraphicsGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
				// graphicsData.push (stroke);

				case LINE_BITMAP_STYLE:
					// TODO

					var c = data.readLineBitmapStyle();
					path = null;
				// stroke = new GraphicsStroke (c.thickness, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
				// stroke.fill = new GraphicsBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth);
				// graphicsData.push (stroke);

				case LINE_STYLE:
					var c = data.readLineStyle();
					stroke = new GraphicsStroke(c.thickness, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
					stroke.fill = new GraphicsSolidFill(c.color, c.alpha);
					graphicsData.push(stroke);

				case END_FILL:
					data.readEndFill();
					graphicsData.push(new GraphicsEndFill());

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					graphicsData.push(new GraphicsBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth));

				case BEGIN_FILL:
					var c = data.readBeginFill();
					graphicsData.push(new GraphicsSolidFill(c.color, 1));

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();
					graphicsData.push(new GraphicsGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio));

				case BEGIN_SHADER_FILL:

				default:
					data.skip(type);
			}
		}

		if (path != null)
		{
			graphicsData.push(path);
		}
	}

	public function __update(displayMatrix:Matrix):Void
	{
		if (__bounds == null || __bounds.width <= 0 || __bounds.height <= 0) return;

		var parentTransform = (__owner._ : _DisplayObject).__renderTransform;
		var scaleX = 1.0, scaleY = 1.0;

		if (parentTransform != null)
		{
			if (parentTransform.b == 0)
			{
				scaleX = Math.abs(parentTransform.a);
			}
			else
			{
				scaleX = Math.sqrt(parentTransform.a * parentTransform.a + parentTransform.b * parentTransform.b);
			}

			if (parentTransform.c == 0)
			{
				scaleY = Math.abs(parentTransform.d);
			}
			else
			{
				scaleY = Math.sqrt(parentTransform.c * parentTransform.c + parentTransform.d * parentTransform.d);
			}
		}
		else
		{
			return;
		}

		if (displayMatrix != null)
		{
			if (displayMatrix.b == 0)
			{
				scaleX *= displayMatrix.a;
			}
			else
			{
				scaleX *= Math.sqrt(displayMatrix.a * displayMatrix.a + displayMatrix.b * displayMatrix.b);
			}

			if (displayMatrix.c == 0)
			{
				scaleY *= displayMatrix.d;
			}
			else
			{
				scaleY *= Math.sqrt(displayMatrix.c * displayMatrix.c + displayMatrix.d * displayMatrix.d);
			}
		}

		#if openfl_disable_graphics_upscaling
		if (scaleX > 1) scaleX = 1;
		if (scaleY > 1) scaleY = 1;
		#end

		var width = __bounds.width * scaleX;
		var height = __bounds.height * scaleY;

		if (width < 1 || height < 1)
		{
			if (__width >= 1 || __height >= 1) __dirty = true;
			__width = 0;
			__height = 0;
			return;
		}

		if (maxTextureWidth != null && width > maxTextureWidth)
		{
			width = maxTextureWidth;
			scaleX = maxTextureWidth / __bounds.width;
		}

		if (maxTextureWidth != null && height > maxTextureHeight)
		{
			height = maxTextureHeight;
			scaleY = maxTextureHeight / __bounds.height;
		}

		__renderTransform.a = width / __bounds.width;
		__renderTransform.d = height / __bounds.height;
		var inverseA = (1 / __renderTransform.a);
		var inverseD = (1 / __renderTransform.d);

		// Inlined & simplified `__worldTransform.concat (parentTransform)` below:
		__worldTransform.a = inverseA * parentTransform.a;
		__worldTransform.b = inverseA * parentTransform.b;
		__worldTransform.c = inverseD * parentTransform.c;
		__worldTransform.d = inverseD * parentTransform.d;

		var x = __bounds.x;
		var y = __bounds.y;
		var tx = x * parentTransform.a + y * parentTransform.c + parentTransform.tx;
		var ty = x * parentTransform.b + y * parentTransform.d + parentTransform.ty;

		// Floor the world position for crisp graphics rendering
		__worldTransform.tx = Math.ffloor(tx);
		__worldTransform.ty = Math.ffloor(ty);

		// Offset the rendering with the subpixel offset removed by Math.floor above
		__renderTransform.tx = __worldTransform._.__transformInverseX(tx, ty);
		__renderTransform.ty = __worldTransform._.__transformInverseY(tx, ty);

		// Calculate the size to contain the graphics and an extra subpixel
		// We used to add tx and ty from __renderTransform instead of 1.0
		// but it improves performance if we keep the size consistent when the
		// extra pixel isn't needed
		var newWidth = Math.ceil(width + 1.0);
		var newHeight = Math.ceil(height + 1.0);

		// Mark dirty if render size changed
		if (newWidth != __width || newHeight != __height)
		{
			#if !openfl_disable_graphics_upscaling
			__dirty = true;
			#end
		}

		__width = newWidth;
		__height = newHeight;
	}

	// Get & Set Methods
	public function set___dirty(value:Bool):Bool
	{
		if (value && __owner != null)
		{
			@:privateAccess __owner._.__setRenderDirty();
		}

		if (value)
		{
			__softwareDirty = true;
			__hardwareDirty = true;
		}

		return __dirty = value;
	}
}
