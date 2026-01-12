package openfl.display._internal;

#if !flash
import haxe.ds.IntMap;
import openfl.Vector;
import openfl.display.BitmapData;
import openfl.display.CairoRenderer;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.InterpolationMethod;
import openfl.display.SpreadMethod;
import openfl.display._internal.DrawCommandBuffer;
import openfl.display._internal.DrawCommandReader;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoExtend;
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoImageSurface;
import lime.graphics.cairo.CairoPattern;
import lime.math.Matrix3;
import lime.math.Vector2;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class CairoGraphics
{
	#if lime_cairo
	private static inline var SIN45:Float = 0.70710678118654752440084436210485;
	private static inline var TAN22:Float = 0.4142135623730950488016887242097;
	private static inline var GRADIENT_TRANSFORM_THRESHOLD:Float = 0.0001;
	private static inline var KAPPA:Float = 0.5522848;
	private static var allowSmoothing:Bool;
	private static var cairo:Cairo;
	private static var graphics:Graphics;
	private static var hitTesting:Bool;
	private static var hitTestResult:Bool;
	private static var hitTestPoint:Point = new Point();
	private static var masking:Bool;
	private static var inPath:Bool;
	private static var pathStart:Point;
	private static var pathPosition:Point;
	private static var closePath:Bool;
	private static var stroke:Bool;
	private static var hasStroke:Bool;
	private static var hasFill:Bool;
	private static var fillBitmap:BitmapData;
	private static var strokeBitmap:BitmapData;
	private static var fillPattern:CairoPattern;
	private static var strokePattern:CairoPattern;
	private static var fillMatrix:Matrix = new Matrix();
	private static var strokeMatrix:Matrix = new Matrix();
	private static var fillCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var fillStart:Point = new Point();
	private static var fillPosition:Point = new Point();
	private static var strokeStart:Point = new Point();
	private static var strokePosition:Point = new Point();
	private static var worldAlpha:Float;
	private static var tempMatrix = new Matrix();
	private static var tempMatrix3 = new Matrix3();

	private static function paintStroke():Void
	{
		if (strokePattern == null || masking)
		{
			return;
		}
		if (hitTesting)
		{
			#if debug_hitTest cairo.strokePreserve(); #end
			hitTestResult = cairo.inStroke(hitTestPoint.x, hitTestPoint.y);
			return;
		}
		if (strokePattern != null)
		{
			applyPatternMatrix(strokePattern, strokeMatrix, strokeCommands);
		}

		cairo.strokePreserve();
	}

	private static function paintFill():Void
	{
		if (fillPattern == null || masking)
		{
			return;
		}
		if (hitTesting)
		{
			#if debug_hitTest cairo.fillPreserve(); #end
			hitTestResult = cairo.inFill(hitTestPoint.x, hitTestPoint.y);
			return;
		}

		applyPatternMatrix(fillPattern, fillMatrix, fillCommands);

		cairo.fillPreserve();
	}

	private static function createImagePattern(fillBitmap:BitmapData, bitmapRepeat:Bool, smooth:Bool):CairoPattern
	{
		var pattern = CairoPattern.createForSurface(fillBitmap.getSurface());
		pattern.filter = (smooth && allowSmoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;

		if (bitmapRepeat)
		{
			pattern.extend = CairoExtend.REPEAT;
		}
		else
		{
			// when flash doesn't repeat the image, it extends the pixels on the
			// edges to fill the remaining space, which is equivalent to the
			// CairoExtend.PAD option.
			pattern.extend = CairoExtend.PAD;
		}

		return pattern;
	}

	private static function createGradientPattern(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix,
			spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float):CairoPattern
	{
		var pattern:CairoPattern = null;
		matrix = matrix != null ? matrix : Matrix.__identity;
		var transformed = false;
		if (type == GradientType.RADIAL)
		{
			transformed = stroke ? false : Math.abs(matrix.a - matrix.d) > GRADIENT_TRANSFORM_THRESHOLD
				|| Math.abs(matrix.b + matrix.c) > GRADIENT_TRANSFORM_THRESHOLD;
		}
		else
		{
			var dot = matrix.a * matrix.c + matrix.b * matrix.d;
			transformed = stroke ? false : Math.abs(dot) > GRADIENT_TRANSFORM_THRESHOLD;
		}

		var transform = transformed ? Matrix.__identity : matrix;

		switch (type)
		{
			case RADIAL:
				focalPointRatio = focalPointRatio > 1.0 ? 1.0 : focalPointRatio < -1.0 ? -1.0 : focalPointRatio;
				var fcx = transform.__transformX(819.2 * focalPointRatio, 0);
				var fcy = transform.__transformY(819.2 * focalPointRatio, 0);
				var cx = transform.__transformX(0, 0);
				var cy = transform.__transformY(0, 0);
				var ex = transform.__transformX(819.2, 0);
				var ey = transform.__transformY(819.2, 0);

				if (graphics.__useScale9Grid)
				{
					fcx = graphics.__getScale9GridPositionX(fcx);
					fcy = graphics.__getScale9GridPositionY(fcy);
					cx = graphics.__getScale9GridPositionX(cx);
					cy = graphics.__getScale9GridPositionY(cy);
					ex = graphics.__getScale9GridPositionX(ex);
					ey = graphics.__getScale9GridPositionY(ey);
				}

				var dx = ex - cx;
				var dy = ey - cy;
				var radius = Math.sqrt(dx * dx + dy * dy);
				pattern = CairoPattern.createRadial(fcx, fcy, 0.0, cx, cy, radius);

			case LINEAR:
				var fcx = transform.__transformX(-819.2, 0);
				var fcy = transform.__transformY(-819.2, 0);
				var cx = transform.__transformX(819.2, 0);
				var cy = transform.__transformY(819.2, 0);

				if (graphics.__useScale9Grid)
				{
					fcx = graphics.__getScale9GridPositionX(fcx);
					fcy = graphics.__getScale9GridPositionY(fcy);
					cx = graphics.__getScale9GridPositionX(cx);
					cy = graphics.__getScale9GridPositionY(cy);
				}

				pattern = CairoPattern.createLinear(fcx, fcy, cx, cy);
		}

		var rgb:Int, alpha:Float, r:Float, g:Float, b:Float, ratio:Float;

		for (i in 0...colors.length)
		{
			rgb = colors[i];
			alpha = alphas[i];
			r = ((rgb & 0xFF0000) >>> 16) / 0xFF;
			g = ((rgb & 0x00FF00) >>> 8) / 0xFF;
			b = (rgb & 0x0000FF) / 0xFF;

			ratio = ratios[i] / 0xFF;
			if (ratio < 0) ratio = 0;
			else if (ratio > 1) ratio = 1;

			pattern.addColorStopRGBA(ratio, r, g, b, alpha);
		}

		if (stroke)
		{
			strokeMatrix.copyFrom(transformed ? matrix : Matrix.__identity);
		}
		else
		{
			fillMatrix.copyFrom(transformed ? matrix : Matrix.__identity);
		}

		return pattern;
	}

	private static function drawCircle(x:Float, y:Float, radius:Float):Void
	{
		if (graphics.__useScale9Grid)
		{
			var scaledLeft = graphics.__getScale9GridPositionX(x - radius);
			var scaledTop = graphics.__getScale9GridPositionY(y - radius);
			var scaledRight = graphics.__getScale9GridPositionX(x + radius);
			var scaledBottom = graphics.__getScale9GridPositionY(y + radius);

			x = scaledLeft;
			y = scaledTop;
			var width = scaledRight - scaledLeft;
			var height = scaledBottom - scaledTop;

			if (width != 0.0 || height != 0.0)
			{
				var ox = (width / 2) * KAPPA; // control point offset horizontal
				var oy = (height / 2) * KAPPA; // control point offset vertical
				var xe = x + width; // x-end
				var ye = y + height; // y-end
				var xm = x + width / 2; // x-middle
				var ym = y + height / 2; // y-middle

				cairo.moveTo(xe, ym);
				cairo.curveTo(xe, ym + oy, xm + ox, ye, xm, ye);
				cairo.curveTo(xm - ox, ye, x, ym + oy, x, ym);
				cairo.curveTo(x, ym - oy, xm - ox, y, xm, y);
				cairo.curveTo(xm + ox, y, xe, ym - oy, xe, ym);
				cairo.closePath();
				pathStart.setTo(xe, ym);
				pathPosition.setTo(xe, ym);
			}
		}
		else if (radius != 0.0)
		{
			// flash doesn't draw the circle if the radius is zero
			cairo.moveTo(x + radius, y);
			cairo.arc(x, y, radius, 0, Math.PI * 2);
			pathStart.setTo(x + radius, y);
			pathPosition.setTo(x + radius, y);
		}
	}

	private static function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (graphics.__useScale9Grid)
		{
			var scaledLeft = graphics.__getScale9GridPositionX(x);
			var scaledTop = graphics.__getScale9GridPositionY(y);
			var scaledRight = graphics.__getScale9GridPositionX(x + width);
			var scaledBottom = graphics.__getScale9GridPositionY(y + height);

			x = scaledLeft;
			y = scaledTop;
			width = scaledRight - scaledLeft;
			height = scaledBottom - scaledTop;
		}

		if (width != 0.0 || height != 0.0)
		{
			// flash doesn't draw the ellipse if both the width and height are zero
			var ox = (width / 2) * KAPPA; // control point offset horizontal
			var oy = (height / 2) * KAPPA; // control point offset vertical
			var xe = x + width; // x-end
			var ye = y + height; // y-end
			var xm = x + width / 2; // x-middle
			var ym = y + height / 2; // y-middle

			cairo.moveTo(xe, ym);
			cairo.curveTo(xe, ym + oy, xm + ox, ye, xm, ye);
			cairo.curveTo(xm - ox, ye, x, ym + oy, x, ym);
			cairo.curveTo(x, ym - oy, xm - ox, y, xm, y);
			cairo.curveTo(xm + ox, y, xe, ym - oy, xe, ym);
			cairo.closePath();
			pathStart.setTo(xe, ym);
			pathPosition.setTo(xe, ym);
		}
	}

	private static function drawRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (fillBitmap != null && !stroke && !graphics.__useScale9Grid)
		{
			var sl = fillMatrix.__transformInverseX(x, y);
			var st = fillMatrix.__transformInverseY(x, y);
			var sr = fillMatrix.__transformInverseX(x + width, y + height);
			var sb = fillMatrix.__transformInverseY(x + width, y + height);

			if (st >= 0 && sl >= 0 && sr <= fillBitmap.width && sb <= fillBitmap.height)
			{
				// ignores winding even-odd
				drawImage(fillBitmap, sl, st, sr - sl, sb - st, x, y, width, height);
				return;
			}
		}
		if (graphics.__useScale9Grid)
		{
			var scaledLeft = graphics.__getScale9GridPositionX(x);
			var scaledTop = graphics.__getScale9GridPositionY(y);
			var scaledRight = graphics.__getScale9GridPositionX(x + width);
			var scaledBottom = graphics.__getScale9GridPositionY(y + height);

			x = scaledLeft;
			y = scaledTop;
			width = scaledRight - scaledLeft;
			height = scaledBottom - scaledTop;
		}
		if (width != 0.0 || height != 0.0)
		{
			// flash doesn't draw the rectangle if both the width and height are zero
			cairo.rectangle(x, y, width, height);
		}
	}

	private static function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void
	{
		if (ellipseHeight == null) ellipseHeight = ellipseWidth;

		if (ellipseWidth > width) ellipseWidth = width;
		if (ellipseHeight > height) ellipseHeight = height;

		ellipseWidth *= 0.5;
		ellipseHeight *= 0.5;

		var left = x;
		var top = y;
		var right = x + width;
		var bottom = y + height;

		if (graphics.__useScale9Grid)
		{
			var scaledLeft = graphics.__getScale9GridPositionX(left);
			var scaledTop = graphics.__getScale9GridPositionY(top);
			var scaledRight = graphics.__getScale9GridPositionX(right);
			var scaledBottom = graphics.__getScale9GridPositionY(bottom);

			var scaledEllipseLeft = graphics.__getScale9GridPositionX(left + ellipseWidth) - scaledLeft;
			var scaledEllipseRight = scaledRight - graphics.__getScale9GridPositionX(right - ellipseWidth);
			var scaledEllipseWidth = Math.min(scaledEllipseLeft, scaledEllipseRight);

			var scaledEllipseTop = graphics.__getScale9GridPositionY(top + ellipseHeight) - scaledTop;
			var scaledEllipseBottom = scaledBottom - graphics.__getScale9GridPositionY(bottom - ellipseHeight);
			var scaledEllipseHeight = Math.min(scaledEllipseTop, scaledEllipseBottom);

			if (scaledEllipseWidth > (scaledRight - scaledLeft) / 2) scaledEllipseWidth = (scaledRight - scaledLeft) / 2;
			if (scaledEllipseHeight > (scaledBottom - scaledTop) / 2) scaledEllipseHeight = (scaledBottom - scaledTop) / 2;

			left = scaledLeft;
			top = scaledTop;
			right = scaledRight;
			bottom = scaledBottom;
			ellipseWidth = scaledEllipseWidth;
			ellipseHeight = scaledEllipseHeight;
		}
		var width = right - left;
		var height = bottom - top;

		if (width != 0 && height != 0)
		{
			var cx1 = -ellipseWidth + (ellipseWidth * SIN45);
			var cx2 = -ellipseWidth + (ellipseWidth * TAN22);
			var cy1 = -ellipseHeight + (ellipseHeight * SIN45);
			var cy2 = -ellipseHeight + (ellipseHeight * TAN22);

			cairo.moveTo(right, bottom - ellipseHeight);
			quadraticCurveTo(right, bottom + cy2, right + cx1, bottom + cy1);
			quadraticCurveTo(right + cx2, bottom, right - ellipseWidth, bottom);
			cairo.lineTo(left + ellipseWidth, bottom);
			quadraticCurveTo(left - cx2, bottom, left - cx1, bottom + cy1);
			quadraticCurveTo(left, bottom + cy2, left, bottom - ellipseHeight);
			cairo.lineTo(left, top + ellipseHeight);
			quadraticCurveTo(left, top - cy2, left - cx1, top - cy1);
			quadraticCurveTo(left - cx2, top, left + ellipseWidth, top);
			cairo.lineTo(right - ellipseWidth, top);
			quadraticCurveTo(right + cx2, top, right + cx1, top - cy1);
			quadraticCurveTo(right, top - cy2, right, top + ellipseHeight);
			cairo.lineTo(right, bottom - ellipseHeight);
			cairo.closePath();
		}
	}

	private static function drawQuads(rects:Vector<Float>, indices:Vector<Int>, transforms:Vector<Float>):Void
	{
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

		var tileRect = Rectangle.__pool.get();
		var tileTransform = Matrix.__pool.get();

		var ri:Int;
		var ti:Int;

		var oldFillMatrix = fillMatrix;
		fillMatrix = tempMatrix;

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
				tileTransform.setTo(1, 0, 0, 1, transforms[ti], transforms[ti + 1]);
			}
			else
			{
				tileTransform.setTo(1, 0, 0, 1, tileRect.x, tileRect.y);
			}

			cairo.save();
			cairo.transform(tileTransform.__toMatrix3(tempMatrix3));

			fillMatrix.setTo(1, 0, 0, 1, -tileRect.x, -tileRect.y);
			drawRect(0, 0, tileRect.width, tileRect.height);

			cairo.restore();
		}

		fillMatrix = oldFillMatrix;

		Rectangle.__pool.release(tileRect);
		Matrix.__pool.release(tileTransform);
	}

	private static function drawTriangles(v:Vector<Float>, ind:Vector<Int>, uvt:Vector<Float>, culling:TriangleCulling):Void
	{
		var seenEdgeMap = new IntMap<Bool>();

		var i = 0;
		var l = ind.length;
		var vertLength = Std.int(v.length / 2);
		var uvtStep = (uvt != null && uvt.length != v.length) ? 3 : 2;
		var doPaint = fillBitmap != null && uvt != null;

		var ia:Int, ib:Int, ic:Int;
		var x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float;
		var u1:Float, u2:Float, u3:Float, v1:Float, v2:Float, v3:Float;
		var abKey:Int, bcKey:Int, caKey:Int;
		var abShared:Bool = false;
		var bcShared:Bool = false;
		var caShared:Bool = false;

		var x:Float;
		var y:Float;
		var minX = Math.POSITIVE_INFINITY;
		var minY = Math.POSITIVE_INFINITY;
		var maxX = Math.NEGATIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;

		for (i in 0...vertLength)
		{
			x = v[i * 2];
			y = v[i * 2 + 1];

			if (minX > x) minX = x;
			if (minY > y) minY = y;
			if (maxX < x) maxX = x;
			if (maxY < y) maxY = y;
		}

		cairo.antialias = NONE;

		while (i < l)
		{
			ia = i;
			ib = i + 1;
			ic = i + 2;

			x1 = v[ind[ia] * 2];
			y1 = v[ind[ia] * 2 + 1];
			x2 = v[ind[ib] * 2];
			y2 = v[ind[ib] * 2 + 1];
			x3 = v[ind[ic] * 2];
			y3 = v[ind[ic] * 2 + 1];

			if (graphics.__useScale9Grid)
			{
				x1 = graphics.__getScale9GridPositionX(x1);
				y1 = graphics.__getScale9GridPositionY(y1);
				x2 = graphics.__getScale9GridPositionX(x2);
				y2 = graphics.__getScale9GridPositionY(y2);
				x3 = graphics.__getScale9GridPositionX(x3);
				y3 = graphics.__getScale9GridPositionY(y3);
			}

			if (!stroke)
			{
				var ccw = isCCW(x1, y1, x2, y2, x3, y3);

				if ((culling == POSITIVE && !ccw) || (culling == NEGATIVE && ccw))
				{
					i += 3;
					continue;
				}
			}

			if (stroke)
			{
				abKey = edgeKey(ind[ia], ind[ib]);
				bcKey = edgeKey(ind[ib], ind[ic]);
				caKey = edgeKey(ind[ic], ind[ia]);
				abShared = seenEdgeMap.exists(abKey);
				bcShared = seenEdgeMap.exists(bcKey);
				caShared = seenEdgeMap.exists(caKey);
				seenEdgeMap.set(abKey, true);
				seenEdgeMap.set(bcKey, true);
				seenEdgeMap.set(caKey, true);
				if (!abShared)
				{
					cairo.moveTo(x1, y1);
					cairo.lineTo(x2, y2);
				}
				if (!bcShared)
				{
					cairo.moveTo(x2, y2);
					cairo.lineTo(x3, y3);
				}
				if (!caShared)
				{
					cairo.moveTo(x3, y3);
					cairo.lineTo(x1, y1);
				}

				i += 3;
				continue;
			}

			if (doPaint)
			{
				paint();
			}

			cairo.moveTo(x1, y1);
			cairo.lineTo(x2, y2);
			cairo.lineTo(x3, y3);
			cairo.closePath();

			if (doPaint)
			{
				var oldFillMatrix = fillMatrix;
				fillMatrix = tempMatrix;
				u1 = uvt[ind[ia] * uvtStep];
				v1 = uvt[ind[ia] * uvtStep + 1];
				u2 = uvt[ind[ib] * uvtStep];
				v2 = uvt[ind[ib] * uvtStep + 1];
				u3 = uvt[ind[ic] * uvtStep];
				v3 = uvt[ind[ic] * uvtStep + 1];
				calculatePatternMatrixFromTri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3, minX * 2, minY * 2, fillBitmap.width, fillBitmap.height,
					fillMatrix);
				paintFill();
				cairo.newPath();
				fillMatrix = oldFillMatrix;
			}

			i += 3;
		}

		cairo.antialias = SUBPIXEL;
	}

	private static function endPath():Void
	{
		endFill();
		if (hitTesting && hitTestResult) return;
		endStroke(hasFill);
	}

	private static function endFill():Void
	{
		if (fillCommands.length == 0) return;
		playCommands(fillCommands, fillStart, fillPosition, true);
	}

	private static function endStroke(close:Bool):Void
	{
		if (strokeCommands.length == 0) return;
		playCommands(strokeCommands, strokeStart, strokePosition, close);
	}

	private static inline function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Bool
	{
		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
	}

	private static function applyPatternMatrix(pattern:CairoPattern, bitmapMatrix:Matrix, commands:DrawCommandBuffer):Void
	{
		var matrix = Matrix.__pool.get();
		graphics.__calculatePatternMatrix(bitmapMatrix, commands, matrix);
		matrix.invert();
		pattern.matrix = matrix.__toMatrix3(tempMatrix3);
		cairo.source = pattern;
		Matrix.__pool.release(matrix);
	}

	private static function playCommands(commands:DrawCommandBuffer, start:Point, position:Point, close:Bool):Void
	{
		stroke = commands == strokeCommands;

		if (stroke && masking) return;

		pathStart = start;
		pathPosition = position;
		closePath = close;

		cairo.newPath();
		cairo.moveTo(position.x, position.y);

		var data = new DrawCommandReader(commands);

		var x:Float;
		var y:Float;
		var width:Float;
		var height:Float;
		var ox:Float;
		var oy:Float;
		var xe:Float;
		var ye:Float;
		var xm:Float;
		var ym:Float;
		var r:Float;
		var g:Float;
		var b:Float;

		for (type in commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();

					if (graphics.__useScale9Grid)
					{
						var scaledControlX1 = graphics.__getScale9GridPositionX(c.controlX1);
						var scaledControlY1 = graphics.__getScale9GridPositionY(c.controlY1);
						var scaledControlX2 = graphics.__getScale9GridPositionX(c.controlX2);
						var scaledControlY2 = graphics.__getScale9GridPositionY(c.controlY2);
						var scaledAnchorX = graphics.__getScale9GridPositionX(c.anchorX);
						var scaledAnchorY = graphics.__getScale9GridPositionY(c.anchorY);

						cairo.curveTo(scaledControlX1, scaledControlY1, scaledControlX2, scaledControlY2, scaledAnchorX, scaledAnchorY);
						position.setTo(scaledAnchorX, scaledAnchorY);
					}
					else
					{
						cairo.curveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						position.setTo(c.anchorX, c.anchorY);
					}

				case CURVE_TO:
					var c = data.readCurveTo();

					if (graphics.__useScale9Grid)
					{
						var scaledControlX = graphics.__getScale9GridPositionX(c.controlX);
						var scaledControlY = graphics.__getScale9GridPositionY(c.controlY);
						var scaledAnchorX = graphics.__getScale9GridPositionX(c.anchorX);
						var scaledAnchorY = graphics.__getScale9GridPositionY(c.anchorY);

						quadraticCurveTo(scaledControlX, scaledControlY, scaledAnchorX, scaledAnchorY);
						position.setTo(scaledAnchorX, scaledAnchorY);
					}
					else
					{
						quadraticCurveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
						position.setTo(c.anchorX, c.anchorY);
					}

				case LINE_TO:
					var c = data.readLineTo();
					x = c.x;
					y = c.y;

					if (graphics.__useScale9Grid)
					{
						x = graphics.__getScale9GridPositionX(x);
						y = graphics.__getScale9GridPositionY(y);
					}

					if (position.x != x || position.y != y)
					{
						// flash doesn't draw the line if the previous
						// position is equal to the new position
						cairo.lineTo(x, y);
						position.setTo(x, y);
					}

				case MOVE_TO:
					var c = data.readMoveTo();
					x = c.x;
					y = c.y;

					if (graphics.__useScale9Grid)
					{
						x = graphics.__getScale9GridPositionX(x);
						y = graphics.__getScale9GridPositionY(y);
					}

					if (position.x != x || position.y != y)
					{
						cairo.moveTo(x, y);
						position.setTo(x, y);
					}
					start.setTo(position.x, position.y);

				case LINE_STYLE:
					var c = data.readLineStyle();

					if (inPath)
					{
						paintStroke();
						cairo.newPath();
						cairo.moveTo(position.x, position.y);
					}

					if (c.thickness != null && (hitTesting || c.alpha >= 0.005))
					{
						var strokePadding = c.thickness > 0.0 ? c.thickness : 1.0;
						if (!graphics.__useScale9Grid)
						{
							var scaleX = Math.abs(graphics.__owner.__worldTransform.a);
							var scaleY = Math.abs(graphics.__owner.__worldTransform.d);
							var scale = 1.0;
							switch (c.scaleMode)
							{
								case LineScaleMode.NONE:
									scale = Math.max(scaleX, scaleY);
								case LineScaleMode.VERTICAL:
									scale = scaleX;
								case LineScaleMode.HORIZONTAL:
									scale = scaleY;
								default:
							}
							if (scale < 1.0) scale = 1.0;
							strokePadding /= scale;
						}
						cairo.lineWidth = strokePadding;

						cairo.lineJoin = switch (c.joints)
						{
							case MITER: MITER;
							case BEVEL: BEVEL;
							default: ROUND;
						}
						cairo.lineCap = switch (c.caps)
						{
							case NONE: BUTT;
							case SQUARE: SQUARE;
							default: ROUND;
						}

						cairo.miterLimit = c.miterLimit;

						r = ((c.color & 0xFF0000) >>> 16) / 0xFF;
						g = ((c.color & 0x00FF00) >>> 8) / 0xFF;
						b = (c.color & 0x0000FF) / 0xFF;
						if (c.alpha == 1)
						{
							strokePattern = CairoPattern.createRGB(r, g, b);
						}
						else
						{
							strokePattern = CairoPattern.createRGBA(r, g, b, c.alpha);
						}
					}

					strokeMatrix.identity();
					strokeBitmap = null;

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();

					if (inPath)
					{
						paintStroke();
						cairo.newPath();
						cairo.moveTo(position.x, position.y);
					}

					strokePattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);
					strokeBitmap = null;

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();

					if (inPath)
					{
						paintStroke();
						cairo.newPath();
						cairo.moveTo(position.x, position.y);
					}

					if (c.bitmap.readable)
					{
						strokeBitmap = c.bitmap;
						strokePattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						strokeMatrix.copyFrom(c.matrix != null ? c.matrix : Matrix.__identity);
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						strokePattern = CairoPattern.createRGB(0, 0, 0);
						strokeBitmap = null;
						strokeMatrix.identity();
					}

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();

					if (c.bitmap.readable && !hitTesting && !masking)
					{
						fillBitmap = c.bitmap;
						fillPattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						fillMatrix.copyFrom(c.matrix != null ? c.matrix : Matrix.__identity);
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						fillPattern = CairoPattern.createRGB(0, 0, 0);
						fillBitmap = null;
						fillMatrix.identity();
					}

				case BEGIN_FILL:
					var c = data.readBeginFill();

					if (hasFill)
					{
						r = ((c.color & 0xFF0000) >>> 16) / 0xFF;
						g = ((c.color & 0x00FF00) >>> 8) / 0xFF;
						b = (c.color & 0x0000FF) / 0xFF;

						if (c.alpha == 1)
						{
							fillPattern = CairoPattern.createRGB(r, g, b);
						}
						else
						{
							fillPattern = CairoPattern.createRGBA(r, g, b, c.alpha);
						}
					}

					fillBitmap = null;
					fillMatrix.identity();

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();

					fillBitmap = null;
					fillPattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);

				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					var shaderBuffer = c.shaderBuffer;

					if (hasFill)
					{
						if (shaderBuffer.inputs[0].readable && !hitTesting && !masking)
						{
							fillBitmap = shaderBuffer.inputs[0];
							fillPattern = createImagePattern(fillBitmap, shaderBuffer.inputWrap[0] != CLAMP, shaderBuffer.inputFilter[0] != NEAREST);
							fillMatrix.copyFrom(c.matrix != null ? c.matrix : Matrix.__identity);
						}
						else
						{
							// if it's hardware-only BitmapData, fall back to
							// drawing solid black because we have no software
							// pixels to work with
							fillPattern = CairoPattern.createRGB(0, 0, 0);
							fillMatrix.identity();
						}
					}

				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					drawEllipse(c.x, c.y, c.width, c.height);

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					drawCircle(c.x, c.y, c.radius);

				case DRAW_RECT:
					var c = data.readDrawRect();
					drawRect(c.x, c.y, c.width, c.height);

				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

				case DRAW_QUADS:
					var c = data.readDrawQuads();
					drawQuads(c.rects, c.indices, c.transforms);

				case DRAW_TRIANGLES:
					var c = data.readDrawTriangles();
					drawTriangles(c.vertices, c.indices, c.uvtData, c.culling);

				case WINDING_EVEN_ODD:
					data.readWindingEvenOdd();
					cairo.fillRule = EVEN_ODD;

				case WINDING_NON_ZERO:
					data.readWindingNonZero();
					cairo.fillRule = WINDING;

				default:
					data.skip(type);
			}
			if (hitTestResult) break;
		}

		paint();

		commands.clear();
		data.destroy();
	}

	private static function paint():Void
	{
		if (closePath)
		{
			if (stroke && hasStroke && (pathPosition.x != pathStart.x || pathPosition.y != pathStart.y))
			{
				cairo.lineTo(pathStart.x, pathStart.y);
			}
			else
			{
				cairo.closePath();
			}
		}
		if (stroke)
		{
			if (hasStroke) paintStroke();
		}
		else
		{
			if (hasFill) paintFill();
		}
		if (!masking) cairo.newPath();
	}

	private static function processCommands(renderer:CairoRenderer = null):Void
	{
		fillCommands.clear();
		strokeCommands.clear();

		cairo.fillRule = EVEN_ODD;
		fillBitmap = null;
		strokeBitmap = null;
		fillPattern = null;
		strokePattern = null;
		fillMatrix.identity();
		strokeMatrix.identity();
		inPath = false;
		hasStroke = false;
		hasFill = false;
		hitTestResult = false;

		var x0 = 0.0;
		var y0 = 0.0;
		if (graphics.__useScale9Grid)
		{
			x0 = graphics.__getScale9GridPositionX(0.0);
			y0 = graphics.__getScale9GridPositionY(0.0);
		}

		fillStart.setTo(x0, y0);
		fillPosition.setTo(x0, y0);
		strokeStart.setTo(x0, y0);
		strokePosition.setTo(x0, y0);

		var data = new DrawCommandReader(graphics.__commands);

		for (type in graphics.__commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					fillCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
					if (hasStroke) strokeCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
					inPath = true;

				case CURVE_TO:
					var c = data.readCurveTo();
					fillCommands.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
					if (hasStroke) strokeCommands.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
					inPath = true;

				case LINE_TO:
					var c = data.readLineTo();
					fillCommands.lineTo(c.x, c.y);
					if (hasStroke) strokeCommands.lineTo(c.x, c.y);
					inPath = true;

				case MOVE_TO:
					var c = data.readMoveTo();
					fillCommands.moveTo(c.x, c.y);
					if (hasStroke) strokeCommands.moveTo(c.x, c.y);
					inPath = true;

				case END_FILL:
					var c = data.readEndFill();
					endPath();
					hasFill = false;
					inPath = false;

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();
					strokeCommands.lineGradientStyle(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();
					strokeCommands.lineBitmapStyle(c.bitmap, c.matrix, c.repeat, c.smooth);

				case LINE_STYLE:
					var c = data.readLineStyle();
					if (hitTesting && hasStroke) endStroke(false);
					hasStroke = c.thickness != null && (hitTesting || c.alpha >= 0.005);
					strokeCommands.lineStyle(c.thickness, c.color, c.alpha, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);

				case BEGIN_BITMAP_FILL:
					endPath();
					var c = data.readBeginBitmapFill();
					hasFill = c.bitmap.readable;
					fillCommands.beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);

				case BEGIN_FILL:
					endPath();
					var c = data.readBeginFill();
					hasFill = c.alpha >= 0.005;
					fillCommands.beginFill(c.color, c.alpha);

				case BEGIN_GRADIENT_FILL:
					endPath();
					var c = data.readBeginGradientFill();
					hasFill = true;
					fillCommands.beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);

				case BEGIN_SHADER_FILL:
					endPath();
					var c = data.readBeginShaderFill();
					hasFill = c.shaderBuffer.inputCount > 0;
					fillCommands.beginShaderFill(c.shaderBuffer, c.matrix);

				case DRAW_CIRCLE:
					if (inPath) endPath();
					var c = data.readDrawCircle();
					fillCommands.drawCircle(c.x, c.y, c.radius);
					if (hasStroke) strokeCommands.drawCircle(c.x, c.y, c.radius);
					inPath = false;

				case DRAW_ELLIPSE:
					if (inPath) endPath();
					var c = data.readDrawEllipse();
					fillCommands.drawEllipse(c.x, c.y, c.width, c.height);
					if (hasStroke) strokeCommands.drawEllipse(c.x, c.y, c.width, c.height);

				case DRAW_RECT:
					if (inPath) endPath();
					var c = data.readDrawRect();
					fillCommands.drawRect(c.x, c.y, c.width, c.height);
					if (hasStroke) strokeCommands.drawRect(c.x, c.y, c.width, c.height);
					inPath = false;

				case DRAW_ROUND_RECT:
					if (inPath) endPath();
					var c = data.readDrawRoundRect();
					fillCommands.drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
					if (hasStroke) strokeCommands.drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
					inPath = false;

				case DRAW_TRIANGLES:
					if (inPath) endPath();
					var c = data.readDrawTriangles();
					fillCommands.drawTriangles(c.vertices, c.indices, c.uvtData, c.culling);
					if (hasStroke) strokeCommands.drawTriangles(c.vertices, c.indices, c.uvtData, c.culling);
					inPath = false;

				case DRAW_QUADS:
					if (inPath) endPath();
					var c = data.readDrawQuads();
					fillCommands.drawQuads(c.rects, c.indices, c.transforms);
					if (hasStroke) strokeCommands.drawQuads(c.rects, c.indices, c.transforms);
					inPath = false;

				case OVERRIDE_BLEND_MODE:
					var c = data.readOverrideBlendMode();
					if (renderer != null) renderer.__setBlendModeCairo(cairo, c.blendMode);

				case WINDING_EVEN_ODD:
					var c = data.readWindingEvenOdd();
					fillCommands.windingEvenOdd();

				case WINDING_NON_ZERO:
					var c = data.readWindingNonZero();
					fillCommands.windingNonZero();

				default:
					data.skip(type);
			}
			if (hitTestResult) break;
		}

		if (!hitTesting || !hitTestResult) endPath();

		data.destroy();
	}

	private static inline function edgeKey(a:Int, b:Int):Int
	{
		// Make an unordered unique 32-bit key
		return (a < b) ? (a << 16) | b : (b << 16) | a;
	}

	private static inline function calculatePatternMatrixFromTri(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, u1:Float, v1:Float, u2:Float,
			v2:Float, u3:Float, v3:Float, offsetX:Float, offsetY:Float, texWidth:Int, texHeight:Int, matrix:Matrix):Void
	{
		u1 *= texWidth;
		u2 *= texWidth;
		u3 *= texWidth;
		v1 *= texHeight;
		v2 *= texHeight;
		v3 *= texHeight;

		var denom = (u1 * (v3 - v2) + u2 * (v1 - v3) + u3 * (v2 - v1));
		if (Math.abs(denom) < 1e-8)
		{
			matrix.identity();
		}
		else
		{
			var a = -(x1 * (v2 - v3) + x2 * (v3 - v1) + x3 * (v1 - v2)) / denom;
			var b = -(y1 * (v2 - v3) + y2 * (v3 - v1) + y3 * (v1 - v2)) / denom;
			var c = -(x1 * (u3 - u2) + x2 * (u1 - u3) + x3 * (u2 - u1)) / denom;
			var d = -(y1 * (u3 - u2) + y2 * (u1 - u3) + y3 * (u2 - u1)) / denom;
			var e = (x1 * (u2 * v3 - u3 * v2) + x2 * (u3 * v1 - u1 * v3) + x3 * (u1 * v2 - u2 * v1)) / denom;
			var f = (y1 * (u2 * v3 - u3 * v2) + y2 * (u3 * v1 - u1 * v3) + y3 * (u1 * v2 - u2 * v1)) / denom;

			e += offsetX;
			f += offsetY;

			matrix.setTo(a, b, c, d, e, f);
		}
	}

	private static function drawImage(bitmap:BitmapData, sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float, dw:Float, dh:Float):Void
	{
		if (dw == 0.0 || dh == 0.0) return;

		cairo.save();

		// Set up clip for cropping
		cairo.newPath();
		cairo.rectangle(dx, dy, dw, dh);
		cairo.clip();

		// Set up transformation
		cairo.translate(dx - sx * (dw / sw), dy - sy * (dh / sh));
		cairo.scale(dw / sw, dh / sh);

		// Direct paint - no path filling
		cairo.setSourceSurface(bitmap.getSurface(), 0, 0);
		if (worldAlpha == 1.0)
		{
			cairo.paint();
		}
		else
		{
			cairo.paintWithAlpha(worldAlpha);
		}

		cairo.restore();
	}

	private static function quadraticCurveTo(cx:Float, cy:Float, x:Float, y:Float):Void
	{
		var current:Vector2 = null;

		if (!cairo.hasCurrentPoint)
		{
			cairo.moveTo(cx, cy);
			current = new Vector2(cx, cy);
		}
		else
		{
			current = cairo.currentPoint;
		}

		var cx1 = current.x + ((2 / 3) * (cx - current.x));
		var cy1 = current.y + ((2 / 3) * (cy - current.y));
		var cx2 = x + ((2 / 3) * (cx - x));
		var cy2 = y + ((2 / 3) * (cy - y));

		cairo.curveTo(cx1, cy1, cx2, cy2, x, y);
	}
	#end

	public static function render(graphics:Graphics, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		CairoGraphics.graphics = graphics;
		allowSmoothing = renderer.__allowSmoothing;
		worldAlpha = renderer.__getAlpha(graphics.__owner.__worldAlpha);

		#if (openfl_disable_hdpi || openfl_disable_hdpi_graphics)
		var pixelRatio = 1;
		#else
		var pixelRatio = renderer.__pixelRatio;
		#end

		graphics.__update(renderer.__worldTransform, pixelRatio);

		if (graphics.__useScale9Grid)
		{
			graphics.__bitmapScaleX = graphics.__owner.scaleX;
			graphics.__bitmapScaleY = graphics.__owner.scaleY;
		}
		else
		{
			graphics.__bitmapScaleX = 1;
			graphics.__bitmapScaleY = 1;
		}

		if (!graphics.__softwareDirty || graphics.__managed)
		{
			CairoGraphics.graphics = null;
			return;
		}

		var bounds = graphics.__bounds;
		var width = graphics.__width;
		var height = graphics.__height;

		if (!graphics.__visible || graphics.__commands.length == 0 || bounds.isEmpty() || width < 1 || height < 1)
		{
			graphics.__cairo = null;
			graphics.__bitmap = null;
		}
		else
		{
			var needsUpscaling = false;
			var transform = graphics.__renderTransform;

			if (graphics.__cairo != null)
			{
				var surface:CairoImageSurface = cast graphics.__cairo.target;

				if (width > surface.width || height > surface.height)
				{
					graphics.__cairo = null;
					needsUpscaling = true;
				}
			}

			if (graphics.__cairo == null || graphics.__bitmap == null)
			{
				var bitmap = needsUpscaling ? new BitmapData(Std.int(width * 1.25), Std.int(height * 1.25), true, 0) : new BitmapData(width, height, true, 0);
				var surface = bitmap.getSurface();
				graphics.__cairo = new Cairo(surface);
				graphics.__bitmap = bitmap;
			}

			cairo = graphics.__cairo;

			renderer.__setBlendModeCairo(cairo, NORMAL);
			renderer.applyMatrix(transform, cairo);
			cairo.antialias = SUBPIXEL;

			cairo.setOperator(CLEAR);
			cairo.paint();
			cairo.setOperator(OVER);

			#if debug_hitTest
			hitTesting = true;
			hitTestPoint.setTo(Math.NaN, Math.NaN);
			#end

			var offset = Point.__pool.get();
			graphics.__calculateRenderOffset(offset);
			cairo.translate(-offset.x, -offset.y);

			processCommands(renderer);

			cairo.translate(offset.x, offset.y);
			Point.__pool.release(offset);

			hitTesting = false;

			graphics.__bitmap.image.dirty = true;
			graphics.__bitmap.image.version++;
		}

		graphics.__softwareDirty = false;
		graphics.__dirty = false;
		CairoGraphics.graphics = null;

		var status = cairo.status();
		if (status != 0)
		{
			trace("CairoStatus: " + Std.string(status), cairo.matrix, cairo.source != null ? cairo.source.matrix : "-");
		}
		#end
	}

	public static function renderMask(graphics:Graphics, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		if (graphics.__commands.length == 0) return;

		CairoGraphics.graphics = graphics;
		cairo = renderer.cairo;

		masking = true;

		processCommands(renderer);

		masking = false;

		CairoGraphics.graphics = null;
		#end
	}

	public static function hitTest(graphics:Graphics, x:Float, y:Float):Bool
	{
		#if lime_cairo
		if (graphics.__commands.length == 0) return false;

		CairoGraphics.graphics = graphics;
		var bounds = graphics.__bounds;

		if (graphics.__useScale9Grid)
		{
			x *= graphics.__owner.scaleX;
			y *= graphics.__owner.scaleY;
		}

		if (graphics.__cairo == null)
		{
			var bitmap = new BitmapData(Math.floor(Math.max(1, bounds.width)), Math.floor(Math.max(1, bounds.height)), true, 0);
			var surface = bitmap.getSurface();
			graphics.__cairo = new Cairo(surface);
			// graphics.__bitmap = bitmap;
		}

		cairo = graphics.__cairo;

		hitTesting = true;
		hitTestPoint.setTo(x, y);

		var offset = Point.__pool.get();
		graphics.__calculateRenderOffset(offset);
		cairo.translate(-offset.x, -offset.y);

		processCommands();

		cairo.translate(offset.x, offset.y);
		Point.__pool.release(offset);

		hitTesting = false;
		CairoGraphics.graphics = null;

		return hitTestResult;
		#end

		return false;
	}
}
#end
