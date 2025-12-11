package openfl.display._internal;

#if !flash
import openfl.display._internal.DrawCommandBuffer;
import openfl.display._internal.DrawCommandReader;
import openfl.display.BitmapData;
import openfl.display.CanvasRenderer;
import openfl.display.CapsStyle;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.InterpolationMethod;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;
#if lime
import lime._internal.graphics.ImageCanvasUtil; // TODO
#end
#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasGradient;
import js.html.CanvasPattern;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasWindingRule;
import js.Browser;
import js.html.DOMMatrix;
import js.html.Path2D;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasGraphics
{
	private static inline var SIN45:Float = 0.70710678118654752440084436210485;
	private static inline var TAN22:Float = 0.4142135623730950488016887242097;
	private static inline var GRADIENT_TRANSFORM_THRESHOLD:Float = 0.0001;
	private static inline var KAPPA:Float = 0.5522848;
	private static inline var EPSILON = 1e-8;
	private static var allowSmoothing:Bool;
	private static var bitmapRepeat:Bool;
	private static var graphics:Graphics;
	private static var hitTesting:Bool;
	private static var hasStroke:Bool;
	private static var hasFill:Bool;
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var fillCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var strokeBitmap:BitmapData;
	private static var fillBitmap:BitmapData;
	private static var strokePattern:#if (js && html5) CanvasPattern #else Dynamic #end;
	private static var strokePatternMatrix:Matrix = new Matrix();
	private static var fillPattern:#if (js && html5) CanvasPattern #else Dynamic #end;
	private static var fillPatternMatrix:Matrix = new Matrix();
	private static var strokeGradient:#if (js && html5) CanvasGradient #else Dynamic #end;
	private static var strokeGradientMatrix:Matrix = new Matrix();
	private static var fillGradient:#if (js && html5) CanvasGradient #else Dynamic #end;
	private static var fillGradientMatrix:Matrix = new Matrix();
	private static var fillGradientInverseMatrix:Matrix = new Matrix();
	@SuppressWarnings("checkstyle:Dynamic") private static var windingRule:#if (js && html5) CanvasWindingRule #else Dynamic #end;
	private static var worldAlpha:Float;
	private static var useScale9Grid:Bool;
	private static var tempUvtVector:Vector<Float> = new Vector<Float>();
	private static var tempUVPatternMatrix:Matrix = new Matrix();
	private static var seenEdgeMap:Map<Int, Bool> = new Map<Int, Bool>();
	#if (js && html5)
	private static var context:CanvasRenderingContext2D;
	private static var hitTestCanvas:CanvasElement;
	private static var hitTestContext:CanvasRenderingContext2D;
	#end

	#if (js && html5)
	private static function __init__():Void
	{
		hitTestCanvas = Browser.supported ? cast Browser.document.createElement("canvas") : null;
		hitTestContext = Browser.supported ? hitTestCanvas.getContext("2d") : null;
	}
	#end

	private static function applyStroke()
	{
		#if (js && html5)
		if (hitTesting || context.strokeStyle == null)
		{
			return;
		}

		if (strokeBitmap != null)
		{
			applyPatternMatrix(strokeBitmap, strokePatternMatrix, strokePattern);
		}
		else if (strokeGradient != null)
		{
			// TODO:
			// This is the hard case -- the Canvas API provides no good way to transform gradients,
			// and the inverse-transform trick used above for gradient fills can't be used here
			// because it will distort the stroke geometry.
		}

		context.stroke();
		#end
	}

	private static function applyFill()
	{
		#if (js && html5)
		if (hitTesting) return;

		if (fillBitmap != null)
		{
			applyPatternMatrix(fillBitmap, fillPatternMatrix, fillPattern);
		}
		else if (fillGradient != null)
		{
			context.transform(fillGradientMatrix.a, fillGradientMatrix.b, fillGradientMatrix.c, fillGradientMatrix.d, fillGradientMatrix.tx,
				fillGradientMatrix.ty);
		}

		context.fill(windingRule);

		if (fillBitmap != null)
		{
			//
		}
		else if (fillGradient != null)
		{
			context.transform(fillGradientInverseMatrix.a, fillGradientInverseMatrix.b, fillGradientInverseMatrix.c, fillGradientInverseMatrix.d,
				fillGradientInverseMatrix.tx, fillGradientInverseMatrix.ty);
		}
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private static function createImagePattern(bitmap:BitmapData, bitmapRepeat:Bool, smooth:Bool):#if (js && html5) CanvasPattern #else Dynamic #end
	{
		#if (js && html5)
		ImageCanvasUtil.convertToCanvas(bitmap.image);
		setSmoothing(smooth);
		// flash extends the pixels on the edges to fill any remaining space,
		// but context.createPattern doesn't have that as a repetition option,
		// unlike cairo.
		return context.createPattern(bitmap.image.src, bitmapRepeat ? "repeat" : "no-repeat");
		#else
		return null;
		#end
	}

	private static function toDOMMatrix(matrix:Matrix):#if (js && html5) DOMMatrix #else Dynamic #end
	{
		#if (js && html5)
		return new DOMMatrix([matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty]);
		#else
		return null;
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private static function createCanvasGradient(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix,
			spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float,
			stroke:Bool = false):#if (js && html5) CanvasGradient #else Void #end
	{
		#if (js && html5)
		var pattern:CanvasGradient = null;
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

		// When we are rendering a complex gradient, the gradient transform is handled later by
		// transforming the path before rendering; so use the identity matrix here.
		var transform = transformed ? Matrix.__identity : matrix;

		var numRepeats = 25.0;
		var gradientScale = spreadMethod == SpreadMethod.PAD ? 1.0 : numRepeats;

		// Canvas does not have support for spread/repeat modes (reflect+repeat), so we have to
		// simulate these repeat modes by duplicating color stops.
		// TODO: We'll hit the edge if the gradient is shrunk way down, but don't think we can do
		// anything better using the current Canvas API. Maybe we could consider the size of the
		// shape here to make sure we fill the area.
		var gradient:CanvasGradient;
		var colorStops:Array<{ratio:Float, color:String}> = [];

		switch (type)
		{
			case RADIAL:
				// Canvas radial gradients can not be elliptical or skewed, so transform if there
				// is a non-uniform scale or skew.
				// A scale rotation matrix is always of the form:
				// [[a  b]
				//  [-b a]]
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
				gradient = context.createRadialGradient(fcx, fcy, 0.0, cx, cy, radius * gradientScale);

			case LINEAR:
				// Canvas linear gradients are configured via the line endpoints, so we only need
				// to transform it if the basis is not orthogonal (skew in the transform).
				var x0 = transform.__transformX(-819.2, 0);
				var y0 = transform.__transformY(-819.2, 0);
				var x1 = transform.__transformX(819.2, 0);
				var y2 = transform.__transformY(819.2, 0);

				if (useScale9Grid)
				{
					x0 = graphics.__getScale9GridPositionX(x0);
					y0 = graphics.__getScale9GridPositionY(y0);
					x1 = graphics.__getScale9GridPositionX(x1);
					y2 = graphics.__getScale9GridPositionY(y2);
				}

				// If we have to scale the gradient due to spread mode, scale the endpoints away from the center.
				var dx = x1 - x0;
				var dy = y2 - y0;
				var sdx = 0.5 * (gradientScale - 1.0) * dx;
				var sdy = 0.5 * (gradientScale - 1.0) * dy;
				gradient = context.createLinearGradient(x0 - sdx, y0 - sdy, x1 + sdx, y2 + sdy,);
		}

		for (i in 0...colors.length)
		{
			var ratio = ratios[i] / 0xFF;
			if (ratio < 0) ratio = 0;
			else if (ratio > 1) ratio = 1;
			colorStops.push({
				ratio: ratio,
				color: getRGBA(colors[i], alphas[i])
			});
		}

		switch (spreadMethod)
		{
			case SpreadMethod.PAD:
				for (stop in colorStops)
				{
					gradient.addColorStop(stop.ratio, stop.color);
				}
			case SpreadMethod.REFLECT:
				var t = 0.0;
				var step = 1.0 / numRepeats;
				while (t < 1.0)
				{
					// Add the colors forward.
					for (stop in colorStops)
					{
						gradient.addColorStop(t + stop.ratio * step, stop.color);
					}
					t += step;
					// Add the colors backward.
					var i = colorStops.length - 1;
					while (i >= 0)
					{
						var stop = colorStops[i];
						gradient.addColorStop(t + (1.0 - stop.ratio) * step, stop.color);
						i--;
					}
					t += step;
				}
			case SpreadMethod.REPEAT:
				if (colorStops.length > 0)
				{
					var first_stop = colorStops[0];
					var last_stop = colorStops[colorStops.length - 1];
					var t = 0.0;
					var step = 1.0 / numRepeats;
					while (t < 1.0)
					{
						// Duplicate the start/end stops to ensure we don't blend between the seams.
						gradient.addColorStop(t, first_stop.color);
						for (stop in colorStops)
						{
							gradient.addColorStop(t + stop.ratio * step, stop.color);
						}
						gradient.addColorStop(t + step, last_stop.color);
						t += step;
					}
				}
		}

		if (stroke)
		{
			strokeGradientMatrix.copyFrom(transformed ? matrix : Matrix.__identity);
		}
		else
		{
			fillGradientMatrix.copyFrom(transformed ? matrix : Matrix.__identity);
			fillGradientInverseMatrix.copyFrom(fillGradientMatrix);
			fillGradientInverseMatrix.invert();
		}
		return gradient;
		#end
	}

	private static function getRGBA(color:UInt, alpha:Float):String
	{
		var r:UInt = (color & 0xFF0000) >>> 16;
		var g:UInt = (color & 0x00FF00) >>> 8;
		var b:UInt = (color & 0x0000FF);

		return "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")";
	}

	private static function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void
	{
		#if (js && html5)
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

			context.moveTo(scaledRight, scaledBottom - eh);
			context.quadraticCurveTo(scaledRight, scaledBottom + cy2, scaledRight + cx1, scaledBottom + cy1);
			context.quadraticCurveTo(scaledRight + cx2, scaledBottom, scaledRight - ew, scaledBottom);
			context.lineTo(scaledLeft + ew, scaledBottom);
			context.quadraticCurveTo(scaledLeft - cx2, scaledBottom, scaledLeft - cx1, scaledBottom + cy1);
			context.quadraticCurveTo(scaledLeft, scaledBottom + cy2, scaledLeft, scaledBottom - eh);
			context.lineTo(scaledLeft, scaledTop + eh);
			context.quadraticCurveTo(scaledLeft, scaledTop - cy2, scaledLeft - cx1, scaledTop - cy1);
			context.quadraticCurveTo(scaledLeft - cx2, scaledTop, scaledLeft + ew, scaledTop);
			context.lineTo(scaledRight - ew, scaledTop);
			context.quadraticCurveTo(scaledRight + cx2, scaledTop, scaledRight + cx1, scaledTop - cy1);
			context.quadraticCurveTo(scaledRight, scaledTop - cy2, scaledRight, scaledTop + eh);
			context.lineTo(scaledRight, scaledBottom - eh);
		}
		else
		{
			var cx1 = -ellipseWidth + (ellipseWidth * SIN45);
			var cx2 = -ellipseWidth + (ellipseWidth * TAN22);
			var cy1 = -ellipseHeight + (ellipseHeight * SIN45);
			var cy2 = -ellipseHeight + (ellipseHeight * TAN22);
			context.moveTo(right, bottom - ellipseHeight);
			context.quadraticCurveTo(right, bottom + cy2, right + cx1, bottom + cy1);
			context.quadraticCurveTo(right + cx2, bottom, right - ellipseWidth, bottom);
			context.lineTo(left + ellipseWidth, bottom);
			context.quadraticCurveTo(left - cx2, bottom, left - cx1, bottom + cy1);
			context.quadraticCurveTo(left, bottom + cy2, left, bottom - ellipseHeight);
			context.lineTo(left, top + ellipseHeight);
			context.quadraticCurveTo(left, top - cy2, left - cx1, top - cy1);
			context.quadraticCurveTo(left - cx2, top, left + ellipseWidth, top);
			context.lineTo(right - ellipseWidth, top);
			context.quadraticCurveTo(right + cx2, top, right + cx1, top - cy1);
			context.quadraticCurveTo(right, top - cy2, right, top + ellipseHeight);
			context.lineTo(right, bottom - ellipseHeight);
		}
		#end
	}

	private static function drawTriangles(v:Vector<Float>, ind:Vector<Int>, uvt:Vector<Float>, culling:TriangleCulling, stroke:Bool):Void
	{
		#if (js && html5)
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

		if (!hitTesting)
		{
			context.beginPath();
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
					context.moveTo(x1, y1);
					context.lineTo(x2, y2);
				}
				if (!bcShared)
				{
					context.moveTo(x2, y2);
					context.lineTo(x3, y3);
				}
				if (!caShared)
				{
					context.moveTo(x3, y3);
					context.lineTo(x1, y1);
				}

				i += 3;
				continue;
			}

			context.moveTo(x1, y1);
			context.lineTo(x2, y2);
			context.lineTo(x3, y3);
			context.closePath();

			if (!hitTesting)
			{
				if (fillBitmap != null && !stroke)
				{
					var oldFillPatternMatrix = fillPatternMatrix;
					fillPatternMatrix = tempUVPatternMatrix;
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

				// if (abShared) fixTriangleGap(x1, y1, x2, y2);
				// if (bcShared) fixTriangleGap(x2, y2, x3, y3);
				// if (caShared) fixTriangleGap(x3, y3, x1, y1);

				context.beginPath();
			}

			i += 3;
		}
		#end
	}

	private static function endFill():Void
	{
		#if (js && html5)
		if (fillCommands.length > 0)
		{
			playCommands(fillCommands, false);
		}
		#end
	}

	private static function endStroke():Void
	{
		#if (js && html5)
		if (strokeCommands.length > 0)
		{
			playCommands(strokeCommands, true);
		}
		#end
	}

	public static function hitTest(graphics:Graphics, x:Float, y:Float):Bool
	{
		#if (js && html5)
		var bounds = graphics.__bounds;
		CanvasGraphics.graphics = graphics;

		if (graphics.__commands.length == 0)
		{
			CanvasGraphics.graphics = null;
			return false;
		}

		hitTesting = true;

		var transform = graphics.__renderTransform;

		x = transform.__transformX(x - bounds.x, y - bounds.y);
		y = transform.__transformY(x - bounds.x, y - bounds.y);

		#if (!openfl_legacy_scale9grid || canvas)
		useScale9Grid = graphics.__useScale9Grid;
		#end

		if (useScale9Grid)
		{
			x *= graphics.__owner.scaleX;
			y *= graphics.__owner.scaleY;
		}

		var cacheCanvas = graphics.__canvas;
		var cacheContext = graphics.__context;

		graphics.__canvas = hitTestCanvas;
		graphics.__context = hitTestContext;

		context = graphics.__context;
		context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);

		reset();

		var hasPath = false;

		windingRule = CanvasWindingRule.EVENODD;

		var data = new DrawCommandReader(graphics.__commands);
		var result = false;
		var offsetX = graphics.__offsetX;
		var offsetY = graphics.__offsetY;
		context.translate(-offsetX, -offsetY);

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
					windingRule = CanvasWindingRule.EVENODD;

				case WINDING_NON_ZERO:
					data.readWindingNonZero();
					windingRule = CanvasWindingRule.NONZERO;

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

		context.translate(offsetX, offsetY);
		data.destroy();
		graphics.__canvas = cacheCanvas;
		graphics.__context = cacheContext;
		CanvasGraphics.graphics = null;

		return result;
		#end

		return false;
	}

	private static function endFillAndHitTest(x:Float, y:Float):Bool
	{
		#if (js && html5)
		endFill();
		return hasFill && context.isPointInPath(x, y, windingRule);
		#end
		return false;
	}

	private static function endStrokeAndHitTest(x:Float, y:Float):Bool
	{
		#if (js && html5)
		endStroke();
		return hasStroke && context.isPointInStroke(x, y);
		#end
		return false;
	}

	private static inline function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Bool
	{
		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
	}

	private static inline function applyPatternMatrix(bitmap:BitmapData, bitmapMatrix:Matrix, pattern:#if (js && html5) CanvasPattern #else Dynamic #end):Void
	{
		#if (js && html5)
		var matrix = Matrix.__pool.get();
		matrix.copyFrom(bitmapMatrix);
		if (useScale9Grid)
		{
			matrix.scale(graphics.__owner.scaleX, graphics.__owner.scaleY);
		}
		pattern.setTransform(cast toDOMMatrix(matrix));
		Matrix.__pool.release(matrix);
		#end
	}

	private static function playCommands(commands:DrawCommandBuffer, stroke:Bool = false):Void
	{
		#if (js && html5)
		context.beginPath();
		context.moveTo(0, 0);

		var positionX = 0.0;
		var positionY = 0.0;

		var startX = 0.0;
		var startY = 0.0;

		setSmoothing(true);

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
		var r:Int;
		var g:Int;
		var b:Int;

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

						context.bezierCurveTo(scaledControlX1, scaledControlY1, scaledControlX2, scaledControlY2, scaledAnchorX, scaledAnchorY);

						positionX = scaledAnchorX;
						positionY = scaledAnchorY;
					}
					else
					{
						context.bezierCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);

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

						context.quadraticCurveTo(scaledControlX, scaledControlY, scaledAnchorX, scaledAnchorY);

						positionX = scaledAnchorX;
						positionY = scaledAnchorY;
					}
					else
					{
						context.quadraticCurveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);

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

							context.moveTo(x, ym);
							context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
							context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
							context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
							context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
						}
					}
					else if (c.radius != 0.0)
					{
						// flash doesn't draw the circle if the radius is zero
						context.moveTo(c.x + c.radius, c.y);
						context.arc(c.x, c.y, c.radius, 0, Math.PI * 2, true);
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
						// flash doesn't draw the ellipse if both the width and height are zero
						ox = (width / 2) * KAPPA; // control point offset horizontal
						oy = (height / 2) * KAPPA; // control point offset vertical
						xe = x + width; // x-end
						ye = y + height; // y-end
						xm = x + width / 2; // x-middle
						ym = y + height / 2; // y-middle

						context.moveTo(x, ym);
						context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
						context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
						context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
						context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
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
							context.lineTo(scaledX, scaledY);
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
							context.lineTo(c.x, c.y);
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

						context.moveTo(scaledX, scaledY);

						positionX = scaledX;
						positionY = scaledY;
					}
					else
					{
						context.moveTo(c.x, c.y);

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
						context.closePath();
						context.beginPath();
					}

					context.moveTo(positionX, positionY);

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
						context.lineWidth = strokePadding;
						context.lineJoin = (c.joints == null ? "round" : Std.string(c.joints).toLowerCase());
						context.lineCap = (c.caps == null ? "round" : switch (c.caps)
						{
							case CapsStyle.NONE: "butt";
							default: Std.string(c.caps).toLowerCase();
						});

						context.miterLimit = c.miterLimit;

						if (c.alpha == 1)
						{
							context.strokeStyle = "#" + StringTools.hex(c.color & 0x00FFFFFF, 6);
						}
						else
						{
							r = (c.color & 0xFF0000) >>> 16;
							g = (c.color & 0x00FF00) >>> 8;
							b = (c.color & 0x0000FF);

							context.strokeStyle = "rgba(" + r + ", " + g + ", " + b + ", " + c.alpha + ")";
						}

						setSmoothing(true);
					}

					strokePattern = null;
					strokeBitmap = null;
					strokeGradient = null;

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();

					if (hasPath)
					{
						context.closePath();
						context.beginPath();
					}

					context.moveTo(positionX, positionY);
					strokeGradient = createCanvasGradient(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio, true);
					context.strokeStyle = strokeGradient;

					setSmoothing(true);
					hasStroke = true;

					strokeBitmap = null;
					strokePattern = null;

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();

					if (hasPath)
					{
						context.closePath();
						context.beginPath();
					}

					context.moveTo(positionX, positionY);
					if (c.bitmap.readable)
					{
						strokePattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						context.strokeStyle = strokePattern;
						strokeBitmap = c.bitmap;
						strokePatternMatrix.copyFrom(c.matrix != null ? c.matrix : Matrix.__identity);
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						context.strokeStyle = "#" + StringTools.hex(0, 6);
						strokePattern = null;
						strokeBitmap = null;
					}

					strokeGradient = null;
					hasStroke = true;

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					if (c.bitmap.readable)
					{
						fillPattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						context.fillStyle = fillPattern;
						fillBitmap = c.bitmap;
						fillPatternMatrix.copyFrom(c.matrix != null ? c.matrix : Matrix.__identity);
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						context.fillStyle = "#" + StringTools.hex(0, 6);
						fillBitmap = null;
						fillPattern = null;
					}

					bitmapRepeat = c.repeat;
					hasFill = true;

				case BEGIN_FILL:
					var c = data.readBeginFill();
					if (c.alpha < 0.005)
					{
						hasFill = false;
					}
					else
					{
						if (c.alpha == 1)
						{
							context.fillStyle = "#" + StringTools.hex(c.color & 0xFFFFFF, 6);
						}
						else
						{
							r = (c.color & 0xFF0000) >>> 16;
							g = (c.color & 0x00FF00) >>> 8;
							b = (c.color & 0x0000FF);

							context.fillStyle = "rgba(" + r + ", " + g + ", " + b + ", " + c.alpha + ")";
						}
						hasFill = true;
						setSmoothing(true);
					}

					fillBitmap = null;
					fillPattern = null;
					fillGradient = null;

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();

					fillGradient = context.fillStyle = createCanvasGradient(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod,
						c.interpolationMethod, c.focalPointRatio, false);

					hasFill = true;
					fillBitmap = null;
					fillPattern = null;
					setSmoothing(true);

				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					var shaderBuffer = c.shaderBuffer;

					if (shaderBuffer.inputCount > 0)
					{
						fillBitmap = shaderBuffer.inputs[0];
						if (fillBitmap.readable)
						{
							context.fillStyle = createImagePattern(fillBitmap, shaderBuffer.inputWrap[0] != CLAMP, shaderBuffer.inputFilter[0] != NEAREST);
						}
						else
						{
							// if it's hardware-only BitmapData, fall back to
							// drawing solid black because we have no software
							// pixels to work with
							context.fillStyle = "#" + StringTools.hex(0, 6);
						}
						fillPatternMatrix.copyFrom(c.matrix != null ? c.matrix : Matrix.__identity);
						bitmapRepeat = false;
						hasFill = true;
					}

				case DRAW_QUADS:
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

						context.save();
						context.transform(tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, tileTransform.tx, tileTransform.ty);

						// if (roundPixels) {

						// 	tileTransform.tx = Math.round (tileTransform.tx);
						// 	tileTransform.ty = Math.round (tileTransform.ty);

						// }

						if (fillBitmap != null && fillBitmap.readable)
						{
							context.drawImage(fillBitmap.image.src, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width,
								tileRect.height);
						}
						else
						{
							context.fillRect(0, 0, tileRect.width, tileRect.height);
						}

						context.restore();
					}

					Rectangle.__pool.release(tileRect);
					Matrix.__pool.release(tileTransform);

				case DRAW_TRIANGLES:
					var c = data.readDrawTriangles();
					hasPath = true;
					drawTriangles(c.vertices, c.indices, c.uvtData, c.culling, stroke);

				case DRAW_RECT:
					var c = data.readDrawRect();
					var optimizationUsed = false;

					if (fillBitmap != null && fillBitmap.readable && !hitTesting && !useScale9Grid)
					{
						var st = 0.0;
						var sr = 0.0;
						var sb = 0.0;
						var sl = 0.0;

						var canOptimizeMatrix = true;

						if (fillPatternMatrix.b != 0 || fillPatternMatrix.c != 0)
						{
							canOptimizeMatrix = false;
						}
						else
						{
							sl = fillPatternMatrix.__transformInverseX(c.x, c.y);
							st = fillPatternMatrix.__transformInverseY(c.x, c.y);
							sr = fillPatternMatrix.__transformInverseX(c.x + c.width, c.y + c.height);
							sb = fillPatternMatrix.__transformInverseY(c.x + c.width, c.y + c.height);
						}

						if (canOptimizeMatrix && st >= 0 && sl >= 0 && sr <= fillBitmap.width && sb <= fillBitmap.height)
						{
							optimizationUsed = true;
							context.drawImage(fillBitmap.image.src, sl, st, sr - sl, sb - st, c.x, c.y, c.width, c.height);
						}
					}

					if (!optimizationUsed)
					{
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
								hasPath = true;
								// flash doesn't draw the rectangle if both the width
								// and height are zero
								context.rect(scaledLeft, scaledTop, scaledWidth, scaledHeight);
							}
						}
						else if (c.width != 0.0 || c.height != 0.0)
						{
							hasPath = true;
							context.rect(c.x, c.y, c.width, c.height);
						}
					}

				case WINDING_EVEN_ODD:
					data.readWindingEvenOdd();
					windingRule = CanvasWindingRule.EVENODD;

				case WINDING_NON_ZERO:
					data.readWindingNonZero();
					windingRule = CanvasWindingRule.NONZERO;

				default:
					data.skip(type);
			}
		}

		data.destroy();

		if (hasPath && hasFill)
		{
			context.closePath();
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
		#end
	}

	public static function render(graphics:Graphics, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		CanvasGraphics.graphics = graphics;
		allowSmoothing = renderer.__allowSmoothing;
		worldAlpha = renderer.__getAlpha(graphics.__owner.__worldAlpha);

		#if (openfl_disable_hdpi || openfl_disable_hdpi_graphics)
		var pixelRatio = 1;
		#else
		var pixelRatio = renderer.__pixelRatio;
		#end

		#if (!openfl_legacy_scale9grid || canvas)
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

		if (!graphics.__softwareDirty)
		{
			CanvasGraphics.graphics = null;
			return;
		}

		var bounds = graphics.__bounds;

		var width = graphics.__width;
		var height = graphics.__height;

		if (!graphics.__visible || graphics.__commands.length == 0 || bounds.isEmpty() || width < 1 || height < 1)
		{
			graphics.__canvas = null;
			graphics.__context = null;
			graphics.__bitmap = null;
		}
		else
		{
			hitTesting = false;

			if (graphics.__canvas == null)
			{
				graphics.__canvas = cast Browser.document.createElement("canvas");
				graphics.__context = graphics.__canvas.getContext("2d");
			}

			context = graphics.__context;
			var transform = graphics.__renderTransform;
			var canvas = graphics.__canvas;

			var scale = renderer.__pixelRatio;
			var scaledWidth = Std.int(width * scale);
			var scaledHeight = Std.int(height * scale);

			renderer.__setBlendModeContext(context, NORMAL);

			if (renderer.__isDOM)
			{
				if (canvas.width == scaledWidth && canvas.height == scaledHeight)
				{
					context.clearRect(0, 0, scaledWidth, scaledHeight);
				}
				else
				{
					canvas.width = scaledWidth;
					canvas.height = scaledHeight;
					canvas.style.width = width + "px";
					canvas.style.height = height + "px";
				}

				context.setTransform(transform.a * scale, transform.b * scale, transform.c * scale, transform.d * scale, transform.tx * scale,
					transform.ty * scale);
			}
			else
			{
				if (canvas.width == scaledWidth && canvas.height == scaledHeight)
				{
					context.closePath();
					context.setTransform(1, 0, 0, 1, 0, 0);
					context.clearRect(0, 0, scaledWidth, scaledHeight);
				}
				else
				{
					canvas.width = width;
					canvas.height = height;
				}

				context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			}

			reset();

			var hasLineStyle = false;
			var initStrokeX = 0.0;
			var initStrokeY = 0.0;

			windingRule = CanvasWindingRule.EVENODD;

			var data = new DrawCommandReader(graphics.__commands);
			var offsetX = graphics.__offsetX;
			var offsetY = graphics.__offsetY;
			context.translate(-offsetX, -offsetY);

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
						renderer.__setBlendModeContext(context, c.blendMode);

					case WINDING_EVEN_ODD:
						data.readWindingEvenOdd();
						fillCommands.windingEvenOdd();
						windingRule = CanvasWindingRule.EVENODD;

					case WINDING_NON_ZERO:
						data.readWindingNonZero();
						fillCommands.windingNonZero();
						windingRule = CanvasWindingRule.NONZERO;

					default:
						data.skip(type);
				}
			}

			endFill();
			endStroke();

			context.translate(offsetX, offsetY);
			data.destroy();

			if (graphics.__bitmap == null)
			{
				graphics.__bitmap = BitmapData.fromCanvas(graphics.__canvas);
			}
			else if (graphics.__bitmap.width != graphics.__canvas.width || graphics.__bitmap.height != graphics.__canvas.height)
			{
				var texture = graphics.__bitmap.__texture;
				if (texture != null)
				{
					texture.dispose();
				}
				graphics.__bitmap = BitmapData.fromCanvas(graphics.__canvas);
			}
			else
			{
				// optimization: if the size of the canvas hasn't changed,
				// we can re-use the same BitmapData.
				graphics.__bitmap.image.version++;
			}
		}

		graphics.__softwareDirty = false;
		graphics.__dirty = false;
		CanvasGraphics.graphics = null;
		#end
	}

	public static function renderMask(graphics:Graphics, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		// TODO: Move to normal render method, browsers appear to support more than
		// one path in clipping now

		if (graphics.__commands.length != 0)
		{
			context = cast renderer.context;

			var positionX = 0.0;
			var positionY = 0.0;

			var data = new DrawCommandReader(graphics.__commands);

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

			var offsetX = graphics.__offsetX;
			var offsetY = graphics.__offsetY;
			context.translate(-offsetX, -offsetY);

			for (type in graphics.__commands.types)
			{
				switch (type)
				{
					case CUBIC_CURVE_TO:
						var c = data.readCubicCurveTo();
						context.bezierCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						positionX = c.anchorX;
						positionY = c.anchorY;

					case CURVE_TO:
						var c = data.readCurveTo();
						context.quadraticCurveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
						positionX = c.anchorX;
						positionY = c.anchorY;

					case DRAW_CIRCLE:
						var c = data.readDrawCircle();
						context.arc(c.x, c.y, c.radius, 0, Math.PI * 2, true);

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
						context.moveTo(x, ym);
						context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
						context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
						context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
						context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
					// closePath (false);

					case DRAW_RECT:
						var c = data.readDrawRect();
						context.beginPath();
						context.rect(c.x, c.y, c.width, c.height);
						context.closePath();

					case DRAW_ROUND_RECT:
						var c = data.readDrawRoundRect();
						drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

					case LINE_TO:
						var c = data.readLineTo();
						context.lineTo(c.x, c.y);
						positionX = c.x;
						positionY = c.y;

					case MOVE_TO:
						var c = data.readMoveTo();
						context.moveTo(c.x, c.y);
						positionX = c.x;
						positionY = c.y;

					default:
						data.skip(type);
				}
			}

			context.translate(offsetX, offsetY);
			data.destroy();
		}
		#end
	}

	private static function setSmoothing(smooth:Bool):Void
	{
		#if (js && html5)
		if (!allowSmoothing)
		{
			smooth = false;
		}

		if (context.imageSmoothingEnabled != smooth)
		{
			context.imageSmoothingEnabled = smooth;
		}
		#end
	}

	private static inline function reset():Void
	{
		#if (js && html5)
		fillCommands.clear();
		strokeCommands.clear();

		hasFill = false;
		hasStroke = false;
		fillBitmap = null;
		bitmapRepeat = false;
		fillPattern = null;
		fillGradient = null;
		strokePattern = null;
		strokeGradient = null;
		#end
	}

	private static inline function edgeKey(a:Int, b:Int):Int
	{
		// Make an unordered unique 32-bit key
		return (a < b) ? (a << 16) | b : (b << 16) | a;
	}

	private static inline function normalizeUVT(uvt:Vector<Float>):#if (js && html5) Vector<Float> #else Void #end
	{
		#if (js && html5)
		var result = new Vector<Float>();
		var len = uvt.length;
		for (t in 1...len + 1)
		{
			if (t % 3 == 0)
			{
				continue;
			}

			result.push(uvt[t - 1]);
		}
		return result;
		#end
	}

	private static inline function calculatePatternMatrixFromTri(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, u1:Float, v1:Float, u2:Float,
			v2:Float, u3:Float, v3:Float, offsetX:Float, offsetY:Float, texWidth:Int, texHeight:Int, matrix:Matrix):Void
	{
		#if (js && html5)
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
		#end
	}

	private static function fixTriangleGap(x1:Float, y1:Float, x2:Float, y2:Float, pad:Float = 1.0):Void
	{
		#if (js && html5)
		var thickness = 1.5;
		var shrink = thickness * 2;
		var dx = x2 - x1;
		var dy = y2 - y1;
		var len = Math.sqrt(dx * dx + dy * dy);
		if (len < shrink * 2) return;
		dx /= len;
		dy /= len;
		// Shorten by half a pixel on each end
		x1 += dx * shrink;
		y1 += dy * shrink;
		x2 -= dx * shrink;
		y2 -= dy * shrink;
		context.strokeStyle = fillPattern;
		context.beginPath();
		context.moveTo(x1, y1);
		context.lineTo(x2, y2);
		context.lineCap = "round";
		context.lineWidth = shrink;
		// var old = context.globalCompositeOperation;
		// context.globalCompositeOperation = "destination-over";
		context.stroke();
		// context.globalCompositeOperation = old;
		#end
	}
}
#end
