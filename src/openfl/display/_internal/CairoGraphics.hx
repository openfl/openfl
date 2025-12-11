package openfl.display._internal;

#if !flash
import openfl.display._internal.DrawCommandBuffer;
import openfl.display._internal.DrawCommandReader;
import openfl.display.BitmapData;
import openfl.display.CairoRenderer;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.InterpolationMethod;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;
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
	private static var bitmapRepeat:Bool;
	private static var cairo:Cairo;
	private static var fillCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var fillPattern:CairoPattern;
	private static var fillBitmap:BitmapData;
	private static var graphics:Graphics;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var hitTesting:Bool;
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var strokePattern:CairoPattern;
	private static var strokePatternMatrix:Matrix = new Matrix();
	private static var strokeBitmap:BitmapData;
	private static var fillPatternMatrix:Matrix = new Matrix();
	private static var seenEdgeMap:Map<Int, Bool> = new Map<Int, Bool>();
	private static var tempUvtVector:Vector<Float> = new Vector<Float>();
	private static var tempPatternMatrix = new Matrix();
	private static var tempMatrix3 = new Matrix3();
	private static var worldAlpha:Float;
	private static var useScale9Grid:Bool;

	private static function applyStroke()
	{
		if (hitTesting || strokePattern == null)
		{
			return;
		}
		applyPatternMatrix(strokeBitmap, strokePatternMatrix, strokePattern);
		cairo.strokePreserve();
	}

	private static function applyFill()
	{
		if (hitTesting || fillPattern == null)
		{
			return;
		}
		applyPatternMatrix(fillBitmap, fillPatternMatrix, fillPattern);
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
			spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float, stroke:Bool):CairoPattern
	{
		var pattern:CairoPattern = null;
		matrix = matrix ?? Matrix.__identity;
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

				if (useScale9Grid)
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

				if (useScale9Grid)
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
			strokePatternMatrix.copyFrom(transformed ? matrix : Matrix.__identity);
		}
		else
		{
			fillPatternMatrix.copyFrom(transformed ? matrix : Matrix.__identity);
		}

		return pattern;
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

		if (useScale9Grid)
		{
			var scaledLeft = graphics.__getScale9GridPositionX(left);
			var scaledTop = graphics.__getScale9GridPositionY(top);
			var scaledRight = graphics.__getScale9GridPositionX(right);
			var scaledBottom = graphics.__getScale9GridPositionY(bottom);

			var scaledLeftX = graphics.__getScale9GridPositionX(left + ellipseWidth);
			var scaledTopY = graphics.__getScale9GridPositionY(top + ellipseHeight);
			var scaledRightX = graphics.__getScale9GridPositionX(right - ellipseWidth);
			var scaledBottomY = graphics.__getScale9GridPositionY(bottom - ellipseHeight);

			var scaledEWLeft = scaledLeftX - scaledLeft;
			var scaledEWRight = scaledRight - scaledRightX;
			var scaledEWHoriz = Math.min(scaledEWLeft, scaledEWRight);

			var scaledEHTop = scaledTopY - scaledTop;
			var scaledEHBottom = scaledBottom - scaledBottomY;
			var scaledEHVert = Math.min(scaledEHTop, scaledEHBottom);

			if (scaledEWHoriz > (scaledRight - scaledLeft) / 2) scaledEWHoriz = (scaledRight - scaledLeft) / 2;
			if (scaledEHVert > (scaledBottom - scaledTop) / 2) scaledEHVert = (scaledBottom - scaledTop) / 2;

			var cx1 = -scaledEWHoriz + (scaledEWHoriz * SIN45);
			var cx2 = -scaledEWHoriz + (scaledEWHoriz * TAN22);
			var cy1 = -scaledEHVert + (scaledEHVert * SIN45);
			var cy2 = -scaledEHVert + (scaledEHVert * TAN22);

			var ew = scaledLeftX - scaledLeft;
			var eh = scaledTopY - scaledTop;

			cairo.moveTo(scaledRight, scaledBottom - eh);
			quadraticCurveTo(scaledRight, scaledBottom + cy2, scaledRight + cx1, scaledBottom + cy1);
			quadraticCurveTo(scaledRight + cx2, scaledBottom, scaledRight - ew, scaledBottom);
			cairo.lineTo(scaledLeft + ew, scaledBottom);
			quadraticCurveTo(scaledLeft - cx2, scaledBottom, scaledLeft - cx1, scaledBottom + cy1);
			quadraticCurveTo(scaledLeft, scaledBottom + cy2, scaledLeft, scaledBottom - eh);
			cairo.lineTo(scaledLeft, scaledTop + eh);
			quadraticCurveTo(scaledLeft, scaledTop - cy2, scaledLeft - cx1, scaledTop - cy1);
			quadraticCurveTo(scaledLeft - cx2, scaledTop, scaledLeft + ew, scaledTop);
			cairo.lineTo(scaledRight - ew, scaledTop);
			quadraticCurveTo(scaledRight + cx2, scaledTop, scaledRight + cx1, scaledTop - cy1);
			quadraticCurveTo(scaledRight, scaledTop - cy2, scaledRight, scaledTop + eh);
			cairo.lineTo(scaledRight, scaledBottom - eh);
		}
		else
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
		}
	}

	private static function drawTriangles(v:Vector<Float>, ind:Vector<Int>, uvt:Vector<Float>, culling:TriangleCulling, stroke:Bool):Void
	{
		seenEdgeMap.clear();

		if (!stroke && uvt == null && fillBitmap != null)
		{
			uvt = tempUvtVector;
			graphics.__generateUV(v, fillBitmap.width, fillBitmap.height, fillPatternMatrix, uvt);
		}

		var i = 0;
		var l = ind.length;
		var vertLength = Std.int(v.length / 2);
		var uvtStep = (uvt != null && uvt.length != v.length) ? 3 : 2;

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

		if (!hitTesting)
		{
			cairo.newPath();
		}

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

			if (useScale9Grid)
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

			abKey = edgeKey(ind[ia], ind[ib]);
			bcKey = edgeKey(ind[ib], ind[ic]);
			caKey = edgeKey(ind[ic], ind[ia]);

			abShared = seenEdgeMap.exists(abKey);
			bcShared = seenEdgeMap.exists(bcKey);
			caShared = seenEdgeMap.exists(caKey);
			seenEdgeMap.set(abKey, true);
			seenEdgeMap.set(bcKey, true);
			seenEdgeMap.set(caKey, true);

			if (stroke)
			{
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

			cairo.moveTo(x1, y1);
			cairo.lineTo(x2, y2);
			cairo.lineTo(x3, y3);
			cairo.closePath();

			if (!hitTesting)
			{
				if (fillBitmap != null && !stroke)
				{
					var oldFillPatternMatrix = fillPatternMatrix;
					fillPatternMatrix = tempPatternMatrix;
					u1 = uvt[ind[ia] * uvtStep];
					v1 = uvt[ind[ia] * uvtStep + 1];
					u2 = uvt[ind[ib] * uvtStep];
					v2 = uvt[ind[ib] * uvtStep + 1];
					u3 = uvt[ind[ic] * uvtStep];
					v3 = uvt[ind[ic] * uvtStep + 1];
					calculatePatternMatrixFromTri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3, minX * 2, minY * 2, fillBitmap.width, fillBitmap.height,
						fillPatternMatrix);
					applyFill();
					fillPatternMatrix = oldFillPatternMatrix;
				}

				cairo.newPath();
			}

			i += 3;
		}
	}

	private static function endFill():Void
	{
		if (fillCommands.length > 0)
		{
			playCommands(fillCommands, false);
		}
	}

	private static function endStroke():Void
	{
		if (strokeCommands.length > 0)
		{
			playCommands(strokeCommands, true);
		}
	}
	#end

	public static function hitTest(graphics:Graphics, x:Float, y:Float):Bool
	{
		#if lime_cairo
		CairoGraphics.graphics = graphics;
		var bounds = graphics.__bounds;

		if (graphics.__commands.length == 0)
		{
			CairoGraphics.graphics = null;
			return false;
		}

		hitTesting = true;

		#if (!openfl_legacy_scale9grid || cairo)
		useScale9Grid = graphics.__useScale9Grid;
		#end

		if (useScale9Grid)
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

		reset();

		var hasPath = false;

		cairo.fillRule = EVEN_ODD;

		var data = new DrawCommandReader(graphics.__commands);
		var result = false;

		for (type in graphics.__commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					hasPath = true;
					fillCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
					strokeCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);

				case CURVE_TO:
					var c = data.readCurveTo();
					hasPath = true;
					fillCommands.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
					strokeCommands.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);

				case LINE_TO:
					var c = data.readLineTo();
					hasPath = true;
					fillCommands.lineTo(c.x, c.y);
					strokeCommands.lineTo(c.x, c.y);

				case MOVE_TO:
					var c = data.readMoveTo();
					fillCommands.moveTo(c.x, c.y);
					strokeCommands.moveTo(c.x, c.y);

				case LINE_STYLE, LINE_GRADIENT_STYLE, LINE_BITMAP_STYLE:
					if (hasPath)
					{
						if (endFillAndHitTest(x, y) || endStrokeAndHitTest(x, y))
						{
							result = true;
							break;
						}
					}

					if (type == LINE_STYLE)
					{
						var c = data.readLineStyle();
						fillCommands.lineStyle(c.thickness, c.color, 1, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
						strokeCommands.lineStyle(c.thickness, c.color, 1, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
					}
					else
					{
						data.skip(type);
					}

					hasPath = false;

				case END_FILL, BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL, BEGIN_SHADER_FILL:
					data.skip(type);

					if (hasPath)
					{
						if (endFillAndHitTest(x, y) || endStrokeAndHitTest(x, y))
						{
							result = true;
							break;
						}
					}

					if (type == END_FILL)
					{
						fillCommands.endFill();
						strokeCommands.endFill();
					}
					else
					{
						fillCommands.beginFill(0, 1);
						strokeCommands.beginFill(0, 1);
					}

					hasPath = false;

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					hasPath = true;
					fillCommands.drawCircle(c.x, c.y, c.radius);
					strokeCommands.drawCircle(c.x, c.y, c.radius);

				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					hasPath = true;
					fillCommands.drawEllipse(c.x, c.y, c.width, c.height);
					strokeCommands.drawEllipse(c.x, c.y, c.width, c.height);

				case DRAW_TRIANGLES:
					var c = data.readDrawTriangles();
					hasPath = true;
					fillCommands.drawTriangles(c.vertices, c.indices, c.uvtData, c.culling);
					strokeCommands.drawTriangles(c.vertices, c.indices, c.uvtData, c.culling);

				case DRAW_RECT:
					var c = data.readDrawRect();
					hasPath = true;
					fillCommands.drawRect(c.x, c.y, c.width, c.height);
					strokeCommands.drawRect(c.x, c.y, c.width, c.height);

				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					hasPath = true;
					fillCommands.drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
					strokeCommands.drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

				case WINDING_EVEN_ODD:
					data.readWindingEvenOdd();
					cairo.fillRule = EVEN_ODD;

				case WINDING_NON_ZERO:
					data.readWindingNonZero();
					cairo.fillRule = WINDING;

				default:
					data.skip(type);
			}
		}

		if (!result && hasPath)
		{
			if (endFillAndHitTest(x, y) || endStrokeAndHitTest(x, y))
			{
				result = true;
			}
		}

		data.destroy();
		CairoGraphics.graphics = null;

		return result;
		#end

		return false;
	}

	#if lime_cairo
	private static function endFillAndHitTest(x:Float, y:Float):Bool
	{
		endFill();
		return hasFill && cairo.inFill(x, y);
	}

	private static function endStrokeAndHitTest(x:Float, y:Float):Bool
	{
		endStroke();
		return hasStroke && cairo.inStroke(x, y);
	}

	private static inline function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Bool
	{
		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
	}

	private static inline function applyPatternMatrix(bitmap:BitmapData, bitmapMatrix:Matrix, pattern:CairoPattern):Void
	{
		var matrix = Matrix.__pool.get();
		matrix.copyFrom(bitmapMatrix);
		if (useScale9Grid)
		{
			matrix.scale(graphics.__owner.scaleX, graphics.__owner.scaleY);
		}
		matrix.invert();
		pattern.matrix = matrix.__toMatrix3(tempMatrix3);
		cairo.source = pattern;
		Matrix.__pool.release(matrix);
	}

	private static function playCommands(commands:DrawCommandBuffer, stroke:Bool = false):Void
	{
		cairo.newPath();
		cairo.moveTo(0, 0);

		var positionX = 0.0;
		var positionY = 0.0;

		var startX = 0.0;
		var startY = 0.0;

		cairo.antialias = SUBPIXEL;

		var hasPath = false;

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
					hasPath = true;

					if (useScale9Grid)
					{
						var scaledControlX1 = graphics.__getScale9GridPositionX(c.controlX1);
						var scaledControlY1 = graphics.__getScale9GridPositionY(c.controlY1);
						var scaledControlX2 = graphics.__getScale9GridPositionX(c.controlX2);
						var scaledControlY2 = graphics.__getScale9GridPositionY(c.controlY2);
						var scaledAnchorX = graphics.__getScale9GridPositionX(c.anchorX);
						var scaledAnchorY = graphics.__getScale9GridPositionY(c.anchorY);

						cairo.curveTo(scaledControlX1, scaledControlY1, scaledControlX2, scaledControlY2, scaledAnchorX, scaledAnchorY);

						positionX = scaledAnchorX;
						positionY = scaledAnchorY;
					}
					else
					{
						cairo.curveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);

						positionX = c.anchorX;
						positionY = c.anchorY;
					}

				case CURVE_TO:
					var c = data.readCurveTo();
					hasPath = true;

					if (useScale9Grid)
					{
						var scaledControlX = graphics.__getScale9GridPositionX(c.controlX);
						var scaledControlY = graphics.__getScale9GridPositionY(c.controlY);
						var scaledAnchorX = graphics.__getScale9GridPositionX(c.anchorX);
						var scaledAnchorY = graphics.__getScale9GridPositionY(c.anchorY);

						quadraticCurveTo(scaledControlX, scaledControlY, scaledAnchorX, scaledAnchorY);

						positionX = scaledAnchorX;
						positionY = scaledAnchorY;
					}
					else
					{
						quadraticCurveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);

						positionX = c.anchorX;
						positionY = c.anchorY;
					}

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					hasPath = true;

					if (useScale9Grid)
					{
						var scaledLeft = graphics.__getScale9GridPositionX(c.x - c.radius);
						var scaledTop = graphics.__getScale9GridPositionY(c.y - c.radius);
						var scaledRight = graphics.__getScale9GridPositionX(c.x + c.radius);
						var scaledBottom = graphics.__getScale9GridPositionY(c.y + c.radius);

						x = scaledLeft;
						y = scaledTop;
						width = scaledRight - scaledLeft;
						height = scaledBottom - scaledTop;

						if (width != 0.0 || height != 0.0)
						{
							ox = (width / 2) * KAPPA; // control point offset horizontal
							oy = (height / 2) * KAPPA; // control point offset vertical
							xe = x + width; // x-end
							ye = y + height; // y-end
							xm = x + width / 2; // x-middle
							ym = y + height / 2; // y-middle

							cairo.moveTo(x, ym);
							cairo.curveTo(x, ym - oy, xm - ox, y, xm, y);
							cairo.curveTo(xm + ox, y, xe, ym - oy, xe, ym);
							cairo.curveTo(xe, ym + oy, xm + ox, ye, xm, ye);
							cairo.curveTo(xm - ox, ye, x, ym + oy, x, ym);
						}
					}
					else if (c.radius != 0.0)
					{
						// flash doesn't draw the circle if the radius is zero
						cairo.moveTo(c.x + c.radius, c.y);
						cairo.arc(c.x, c.y, c.radius, 0, Math.PI * 2);
					}

				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					hasPath = true;

					if (useScale9Grid)
					{
						var scaledLeft = graphics.__getScale9GridPositionX(c.x);
						var scaledTop = graphics.__getScale9GridPositionY(c.y);
						var scaledRight = graphics.__getScale9GridPositionX(c.x + c.width);
						var scaledBottom = graphics.__getScale9GridPositionY(c.y + c.height);

						x = scaledLeft;
						y = scaledTop;
						width = scaledRight - scaledLeft;
						height = scaledBottom - scaledTop;
					}
					else
					{
						x = c.x;
						y = c.y;
						width = c.width;
						height = c.height;
					}

					if (width != 0.0 || height != 0.0)
					{
						// flash doesn't draw the ellipse if both the width and
						// height are zero
						ox = (width / 2) * KAPPA; // control point offset horizontal
						oy = (height / 2) * KAPPA; // control point offset vertical
						xe = x + width; // x-end
						ye = y + height; // y-end
						xm = x + width / 2; // x-middle
						ym = y + height / 2; // y-middle

						cairo.moveTo(x, ym);
						cairo.curveTo(x, ym - oy, xm - ox, y, xm, y);
						cairo.curveTo(xm + ox, y, xe, ym - oy, xe, ym);
						cairo.curveTo(xe, ym + oy, xm + ox, ye, xm, ye);
						cairo.curveTo(xm - ox, ye, x, ym + oy, x, ym);
					}

				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					hasPath = true;
					drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

				case LINE_TO:
					var c = data.readLineTo();
					hasPath = true;

					if (useScale9Grid)
					{
						var scaledX = graphics.__getScale9GridPositionX(c.x);
						var scaledY = graphics.__getScale9GridPositionY(c.y);

						if (positionX != scaledX || positionY != scaledY)
						{
							cairo.lineTo(scaledX, scaledY);
						}

						positionX = scaledX;
						positionY = scaledY;
					}
					else
					{
						if (positionX != c.x || positionY != c.y)
						{
							// flash doesn't draw the line if the previous
							// position is equal to the new position
							cairo.lineTo(c.x, c.y);
						}

						positionX = c.x;
						positionY = c.y;
					}

				case MOVE_TO:
					var c = data.readMoveTo();

					if (useScale9Grid)
					{
						var scaledX = graphics.__getScale9GridPositionX(c.x);
						var scaledY = graphics.__getScale9GridPositionY(c.y);

						cairo.moveTo(scaledX, scaledY);

						positionX = scaledX;
						positionY = scaledY;
					}
					else
					{
						cairo.moveTo(c.x, c.y);

						positionX = c.x;
						positionY = c.y;
					}

					startX = positionX;
					startY = positionY;

				case END_FILL:
					var c = data.readEndFill();
					hasFill = false;

				case LINE_STYLE:
					var c = data.readLineStyle();

					applyStroke();
					if (hasPath)
					{
						cairo.closePath();
						cairo.newPath();
					}

					cairo.moveTo(positionX, positionY);

					if (c.thickness == null)
					{
						hasStroke = false;
					}
					else
					{
						hasStroke = true;
						var strokePadding = c.thickness > 0.0 ? c.thickness : 1.0;
						if (!useScale9Grid)
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

						if (c.joints == null)
						{
							cairo.lineJoin = ROUND;
						}
						else
						{
							cairo.lineJoin = switch (c.joints)
							{
								case MITER: MITER;
								case BEVEL: BEVEL;
								default: ROUND;
							}
						}

						if (c.caps == null)
						{
							cairo.lineCap = ROUND;
						}
						else
						{
							cairo.lineCap = switch (c.caps)
							{
								case NONE: BUTT;
								case SQUARE: SQUARE;
								default: ROUND;
							}
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

					strokeBitmap = null;

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();

					if (hasPath)
					{
						cairo.closePath();
						cairo.newPath();
					}

					cairo.moveTo(positionX, positionY);
					strokePattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio, true);

					hasStroke = true;

					strokeBitmap = null;

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();

					if (hasPath)
					{
						cairo.closePath();
						cairo.newPath();
					}

					cairo.moveTo(positionX, positionY);

					if (c.bitmap.readable)
					{
						strokePattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						strokeBitmap = c.bitmap;
						strokePatternMatrix.copyFrom(c.matrix ?? Matrix.__identity);
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						strokePattern = CairoPattern.createRGB(0, 0, 0);
						strokeBitmap = null;
					}

					hasStroke = true;

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					if (c.bitmap.readable)
					{
						fillPattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						fillBitmap = c.bitmap;
						fillPatternMatrix.copyFrom(c.matrix ?? Matrix.__identity);
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						fillPattern = CairoPattern.createRGB(0, 0, 0);
						fillBitmap = null;
					}

					bitmapRepeat = c.repeat;
					hasFill = true;

				case BEGIN_FILL:
					var c = data.readBeginFill();
					if (c.alpha < 0.005)
					{
						fillPattern = null;
						hasFill = false;
					}
					else
					{
						fillPattern = CairoPattern.createRGBA(((c.color & 0xFF0000) >>> 16) / 0xFF, ((c.color & 0x00FF00) >>> 8) / 0xFF,
							(c.color & 0x0000FF) / 0xFF, c.alpha);
						hasFill = true;
					}

					fillBitmap = null;

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();

					fillPattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio, false);

					hasFill = true;
					fillBitmap = null;

				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					var shaderBuffer = c.shaderBuffer;

					if (shaderBuffer.inputCount > 0)
					{
						fillBitmap = shaderBuffer.inputs[0];
						if (fillBitmap.readable)
						{
							fillPattern = createImagePattern(fillBitmap, shaderBuffer.inputWrap[0] != CLAMP, shaderBuffer.inputFilter[0] != NEAREST);
						}
						else
						{
							// if it's hardware-only BitmapData, fall back to
							// drawing solid black because we have no software
							// pixels to work with
							fillPattern = CairoPattern.createRGB(0, 0, 0);
						}
						fillPatternMatrix.copyFrom(c.matrix ?? Matrix.__identity);
						bitmapRepeat = false;
						hasFill = true;
					}

				case DRAW_QUADS:
					var cacheExtend = fillPattern.extend;
					fillPattern.extend = CairoExtend.NONE;

					var c = data.readDrawQuads();
					var rects = c.rects;
					var indices = c.indices;
					var transforms = c.transforms;

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

					var sourceRect = (fillBitmap != null) ? fillBitmap.rect : null;
					tempMatrix3.identity();

					// var roundPixels = renderer.__roundPixels;
					var alpha = worldAlpha;

					var ri:Int;
					var ti:Int;

					for (i in 0...length)
					{
						ri = (hasIndices ? (indices[i] * 4) : i * 4);
						if (ri < 0) continue;

						if (useScale9Grid)
						{
							var scaledLeft = graphics.__getScale9GridPositionX(rects[ri]);
							var scaledTop = graphics.__getScale9GridPositionY(rects[ri + 1]);
							var scaledRight = graphics.__getScale9GridPositionX(rects[ri] + rects[ri + 2]);
							var scaledBottom = graphics.__getScale9GridPositionY(rects[ri + 1] + rects[ri + 3]);
							tileRect.setTo(scaledLeft, scaledTop, scaledRight - scaledLeft, scaledBottom - scaledTop);
						}
						else
						{
							tileRect.setTo(rects[ri], rects[ri + 1], rects[ri + 2], rects[ri + 3]);
						}

						if (tileRect.width <= 0 || tileRect.height <= 0)
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

						tileTransform.tx += positionX;
						tileTransform.ty += positionY;

						// if (roundPixels) {

						// 	tileTransform.tx = Math.round (tileTransform.tx);
						// 	tileTransform.ty = Math.round (tileTransform.ty);

						// }

						cairo.save();
						cairo.transform(tileTransform.__toMatrix3(tempMatrix3));

						tempMatrix3.tx = tileRect.x;
						tempMatrix3.ty = tileRect.y;
						fillPattern.matrix = tempMatrix3;
						cairo.source = fillPattern;

						if (tileRect != sourceRect)
						{
							cairo.newPath();
							cairo.rectangle(0, 0, tileRect.width, tileRect.height);
							cairo.clip();
						}

						if (!hitTesting)
						{
							if (alpha == 1)
							{
								cairo.paint();
							}
							else
							{
								cairo.paintWithAlpha(alpha);
							}
						}
						cairo.restore();
					}

					Rectangle.__pool.release(tileRect);
					Matrix.__pool.release(tileTransform);

					fillPattern.extend = cacheExtend;

				case DRAW_TRIANGLES:
					var c = data.readDrawTriangles();
					hasPath = true;
					drawTriangles(c.vertices, c.indices, c.uvtData, c.culling, stroke);

				case DRAW_RECT:
					var c = data.readDrawRect();
					hasPath = true;

					if (useScale9Grid)
					{
						var scaledLeft = graphics.__getScale9GridPositionX(c.x);
						var scaledTop = graphics.__getScale9GridPositionY(c.y);
						var scaledRight = graphics.__getScale9GridPositionX(c.x + c.width);
						var scaledBottom = graphics.__getScale9GridPositionY(c.y + c.height);

						var scaledWidth = scaledRight - scaledLeft;
						var scaledHeight = scaledBottom - scaledTop;
						if (scaledWidth != 0.0 || scaledHeight != 0.0)
						{
							cairo.rectangle(scaledLeft, scaledTop, scaledWidth, scaledHeight);
						}
					}
					else if (c.width != 0.0 || c.height != 0.0)
					{
						// flash doesn't draw the rectangle if both the width
						// and height are zero
						cairo.rectangle(c.x, c.y, c.width, c.height);
					}

				case WINDING_EVEN_ODD:
					data.readWindingEvenOdd();
					cairo.fillRule = EVEN_ODD;

				case WINDING_NON_ZERO:
					data.readWindingNonZero();
					cairo.fillRule = WINDING;

				default:
					data.skip(type);
			}
		}

		data.destroy();

		if (hasPath && hasFill)
		{
			cairo.closePath();
		}
		if (hasPath && hasFill && !stroke)
		{
			applyFill();
		}
		if (hasPath && hasStroke && stroke)
		{
			applyStroke();
		}

		commands.clear();
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

		#if (!openfl_legacy_scale9grid || cairo)
		useScale9Grid = graphics.__useScale9Grid;
		#end

		if (useScale9Grid)
		{
			graphics.__bitmapScaleX = graphics.__owner.scaleX;
			graphics.__bitmapScaleY = graphics.__owner.scaleY;
		}
		else
		{
			graphics.__bitmapScaleX = 1;
			graphics.__bitmapScaleY = 1;
		}

		graphics.__update(renderer.__worldTransform, pixelRatio);

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
			hitTesting = false;
			var needsUpscaling = false;

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
			renderer.applyMatrix(graphics.__renderTransform, cairo);

			cairo.setOperator(CLEAR);
			cairo.paint();
			cairo.setOperator(OVER);

			reset();

			var hasLineStyle = false;
			var initStrokeX = 0.0;
			var initStrokeY = 0.0;

			cairo.fillRule = EVEN_ODD;

			var data = new DrawCommandReader(graphics.__commands);
			var offsetX = graphics.__offsetX;
			var offsetY = graphics.__offsetY;
			cairo.translate(-offsetX, -offsetY);

			for (type in graphics.__commands.types)
			{
				switch (type)
				{
					case CUBIC_CURVE_TO:
						var c = data.readCubicCurveTo();
						fillCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);

						if (hasLineStyle)
						{
							strokeCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						}
						else
						{
							initStrokeX = c.anchorX;
							initStrokeY = c.anchorY;
						}

					case CURVE_TO:
						var c = data.readCurveTo();
						fillCommands.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);

						if (hasLineStyle)
						{
							strokeCommands.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
						}
						else
						{
							initStrokeX = c.anchorX;
							initStrokeY = c.anchorY;
						}

					case LINE_TO:
						var c = data.readLineTo();
						fillCommands.lineTo(c.x, c.y);

						if (hasLineStyle)
						{
							strokeCommands.lineTo(c.x, c.y);
						}
						else
						{
							initStrokeX = c.x;
							initStrokeY = c.y;
						}

					case MOVE_TO:
						var c = data.readMoveTo();
						fillCommands.moveTo(c.x, c.y);

						if (hasLineStyle)
						{
							strokeCommands.moveTo(c.x, c.y);
						}
						else
						{
							initStrokeX = c.x;
							initStrokeY = c.y;
						}

					case END_FILL:
						data.readEndFill();
						endFill();
						endStroke();
						fillCommands.endFill();
						if (hasLineStyle)
						{
							strokeCommands.endFill();
						}
						fillBitmap = null;
						initStrokeX = 0;
						initStrokeY = 0;

					case LINE_GRADIENT_STYLE:
						var c = data.readLineGradientStyle();

						if (!hasLineStyle && (initStrokeX != 0 || initStrokeY != 0))
						{
							strokeCommands.moveTo(initStrokeX, initStrokeY);
							initStrokeX = 0;
							initStrokeY = 0;
						}

						hasLineStyle = true;
						strokeCommands.lineGradientStyle(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
							c.focalPointRatio);

					case LINE_BITMAP_STYLE:
						var c = data.readLineBitmapStyle();

						if (!hasLineStyle && (initStrokeX != 0 || initStrokeY != 0))
						{
							strokeCommands.moveTo(initStrokeX, initStrokeY);
							initStrokeX = 0;
							initStrokeY = 0;
						}

						hasLineStyle = true;
						strokeCommands.lineBitmapStyle(c.bitmap, c.matrix, c.repeat, c.smooth);

					case LINE_STYLE:
						var c = data.readLineStyle();
						endStroke();

						if (!hasLineStyle && c.thickness != null)
						{
							if (initStrokeX != 0 || initStrokeY != 0)
							{
								strokeCommands.moveTo(initStrokeX, initStrokeY);
								initStrokeX = 0;
								initStrokeY = 0;
							}
						}

						hasLineStyle = c.thickness != null;
						strokeCommands.lineStyle(c.thickness, c.color, c.alpha, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);

					case BEGIN_BITMAP_FILL:
						endFill();
						endStroke();
						var c = data.readBeginBitmapFill();
						fillCommands.beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);
						strokeCommands.beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);

					case BEGIN_FILL:
						endFill();
						endStroke();
						var c = data.readBeginFill();
						fillCommands.beginFill(c.color, c.alpha);
						strokeCommands.beginFill(c.color, c.alpha);

					case BEGIN_GRADIENT_FILL:
						endFill();
						endStroke();
						var c = data.readBeginGradientFill();
						fillCommands.beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
							c.focalPointRatio);
						strokeCommands.beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
							c.focalPointRatio);

					case BEGIN_SHADER_FILL:
						endFill();
						endStroke();
						var c = data.readBeginShaderFill();
						fillCommands.beginShaderFill(c.shaderBuffer, c.matrix);
						strokeCommands.beginShaderFill(c.shaderBuffer, c.matrix);

					case DRAW_CIRCLE:
						var c = data.readDrawCircle();
						fillCommands.drawCircle(c.x, c.y, c.radius);

						if (hasLineStyle)
						{
							strokeCommands.drawCircle(c.x, c.y, c.radius);
						}

					case DRAW_ELLIPSE:
						var c = data.readDrawEllipse();
						fillCommands.drawEllipse(c.x, c.y, c.width, c.height);

						if (hasLineStyle)
						{
							strokeCommands.drawEllipse(c.x, c.y, c.width, c.height);
						}

					case DRAW_RECT:
						var c = data.readDrawRect();
						fillCommands.drawRect(c.x, c.y, c.width, c.height);

						if (hasLineStyle)
						{
							strokeCommands.drawRect(c.x, c.y, c.width, c.height);
						}

					case DRAW_ROUND_RECT:
						var c = data.readDrawRoundRect();
						fillCommands.drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

						if (hasLineStyle)
						{
							strokeCommands.drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
						}

					case DRAW_QUADS:
						var c = data.readDrawQuads();
						fillCommands.drawQuads(c.rects, c.indices, c.transforms);

					case DRAW_TRIANGLES:
						var c = data.readDrawTriangles();
						fillCommands.drawTriangles(c.vertices, c.indices, c.uvtData, c.culling);

						if (hasLineStyle)
						{
							strokeCommands.drawTriangles(c.vertices, c.indices, c.uvtData, c.culling);
						}

					case OVERRIDE_BLEND_MODE:
						var c = data.readOverrideBlendMode();
						renderer.__setBlendModeCairo(cairo, c.blendMode);

					case WINDING_EVEN_ODD:
						data.readWindingEvenOdd();
						fillCommands.windingEvenOdd();

					case WINDING_NON_ZERO:
						data.readWindingNonZero();
						fillCommands.windingNonZero();

					default:
						data.skip(type);
				}
			}

			endFill();
			endStroke();

			cairo.translate(offsetX, offsetY);
			data.destroy();

			graphics.__bitmap.image.dirty = true;
			graphics.__bitmap.image.version++;
		}

		graphics.__softwareDirty = false;
		graphics.__dirty = false;
		CairoGraphics.graphics = null;
		#end
	}

	public static function renderMask(graphics:Graphics, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		if (graphics.__commands.length != 0)
		{
			cairo = renderer.cairo;

			var positionX = 0.0;
			var positionY = 0.0;

			var data = new DrawCommandReader(graphics.__commands);
			var offsetX = graphics.__offsetX;
			var offsetY = graphics.__offsetY;
			cairo.translate(-offsetX, -offsetY);

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

			for (type in graphics.__commands.types)
			{
				switch (type)
				{
					case CUBIC_CURVE_TO:
						var c = data.readCubicCurveTo();
						cairo.curveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						positionX = c.anchorX;
						positionY = c.anchorY;

					case CURVE_TO:
						var c = data.readCurveTo();
						quadraticCurveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
						positionX = c.anchorX;
						positionY = c.anchorY;

					case DRAW_CIRCLE:
						var c = data.readDrawCircle();
						cairo.arc(c.x, c.y, c.radius, 0, Math.PI * 2);

					case DRAW_ELLIPSE:
						var c = data.readDrawEllipse();

						x = c.x;
						y = c.y;
						width = c.width;
						height = c.height;

						ox = (width / 2) * KAPPA; // control point offset horizontal
						oy = (height / 2) * KAPPA; // control point offset vertical
						xe = x + width; // x-end
						ye = y + height; // y-end
						xm = x + width / 2; // x-middle
						ym = y + height / 2; // y-middle

						// closePath (false);
						// beginPath ();
						cairo.moveTo(x, ym);
						cairo.curveTo(x, ym - oy, xm - ox, y, xm, y);
						cairo.curveTo(xm + ox, y, xe, ym - oy, xe, ym);
						cairo.curveTo(xe, ym + oy, xm + ox, ye, xm, ye);
						cairo.curveTo(xm - ox, ye, x, ym + oy, x, ym);
					// closePath (false);

					case DRAW_RECT:
						var c = data.readDrawRect();
						cairo.rectangle(c.x, c.y, c.width, c.height);

					case DRAW_ROUND_RECT:
						var c = data.readDrawRoundRect();
						drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

					case LINE_TO:
						var c = data.readLineTo();
						cairo.lineTo(c.x, c.y);
						positionX = c.x;
						positionY = c.y;

					case MOVE_TO:
						var c = data.readMoveTo();
						cairo.moveTo(c.x, c.y);
						positionX = c.x;
						positionY = c.y;

					default:
						data.skip(type);
				}
			}

			cairo.translate(offsetX, offsetY);
			data.destroy();
		}
		#end
	}

	private static inline function reset():Void
	{
		#if lime_cairo
		fillCommands.clear();
		strokeCommands.clear();

		hasFill = false;
		hasStroke = false;
		fillPattern = null;
		strokePattern = null;
		#end
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
}
#end
