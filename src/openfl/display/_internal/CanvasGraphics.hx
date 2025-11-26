package openfl.display._internal;

#if !flash
import openfl.display._internal.DrawCommandBuffer;
import openfl.display._internal.DrawCommandReader;
import openfl.display._internal.Scale9GridBounds;
import openfl.display._internal.Scale9Grid;
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
	private static var allowSmoothing:Bool;
	private static var bitmapRepeat:Bool;
	private static var bounds:Rectangle;
	private static var graphics:Graphics;
	private static var hitTesting:Bool;
	private static var hasStroke:Bool;
	private static var hasFill:Bool;
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var fillCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var strokeBitmap:BitmapData;
	private static var fillBitmap:BitmapData;
	private static var strokePattern:#if (js && html5) CanvasPattern #else Dynamic #end;
	private static var strokePatternMatrix:Matrix;
	private static var fillPattern:#if (js && html5) CanvasPattern #else Dynamic #end;
	private static var fillPatternMatrix:Matrix;
	private static var strokeGradient:#if (js && html5) CanvasGradient #else Dynamic #end;
	private static var strokeGradientMatrix:Matrix;
	private static var fillGradient:#if (js && html5) CanvasGradient #else Dynamic #end;
	private static var fillGradientMatrix:Matrix;
	@SuppressWarnings("checkstyle:Dynamic") private static var windingRule:#if (js && html5) CanvasWindingRule #else Dynamic #end;
	private static var worldAlpha:Float;
	#if (js && html5)
	private static var tempUvtVector:Vector<Float> = new Vector<Float>();
	private static var tempUVPatternMatrix:Matrix = new Matrix();
	private static var seenEdgeMap:Map<Int, Bool> = new Map<Int, Bool>();
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

	private static function closePathAndApplyStroke(strokeBefore:Bool = false):Void
	{
		#if (js && html5)
		if (!strokeBefore)
		{
			context.closePath();
		}

		applyStroke();

		if (strokeBefore)
		{
			context.closePath();
		}

		context.beginPath();
		#end
	}

	private static inline function applyStroke()
	{
		#if (js && html5)
		if (hitTesting || context.strokeStyle == null)
		{
			return;
		}

		if (strokeBitmap != null)
		{
			applyPatternMatrix(strokeBitmap, strokePatternMatrix, Scale9Grid.valid ? Scale9Grid.strokeBounds : null, strokePattern);
		}
		else if (strokeGradient != null && strokeGradientMatrix != null)
		{
			// This is the hard case -- the Canvas API provides no good way to transform gradients,
			// and the inverse-transform trick used above for gradient fills can't be used here
			// because it will distort the stroke geometry.
			// Another possibility is to avoid the Path2D API, instead drawing using explicit path
			// commands (`context.lineTo`), then push the gradient transform, and finally stroke
			// the path using `stroke()`. But this will be tons of JS calls if there are many strokes.
			// So let's settle for allocating a new canvas gradient that is a best-effort match of the
			// the desired transform. This will not match Flash exactly, but should be relatively rare.
			// TODO:
			context.transform(strokeGradientMatrix.a, strokeGradientMatrix.b, strokeGradientMatrix.c, strokeGradientMatrix.d, strokeGradientMatrix.tx,
				strokeGradientMatrix.ty);
		}

		context.stroke();

		if (strokeBitmap != null)
		{
			//
		}
		else if (strokeGradient != null && strokeGradientMatrix != null)
		{
			var inverse = Matrix.__pool.get();
			inverse.copyFrom(strokeGradientMatrix);
			inverse.invert();
			context.transform(inverse.a, inverse.b, inverse.c, inverse.d, inverse.tx, inverse.ty);
			Matrix.__pool.release(inverse);
		}
		#end
	}

	private static function applyFill()
	{
		#if (js && html5)
		if (hitTesting) return;

		if (fillBitmap != null)
		{
			applyPatternMatrix(fillBitmap, fillPatternMatrix, Scale9Grid.valid ? Scale9Grid.fillBounds : null, fillPattern);
		}
		else if (fillGradient != null && fillGradientMatrix != null)
		{
			context.transform(fillGradientMatrix.a, fillGradientMatrix.b, fillGradientMatrix.c, fillGradientMatrix.d, fillGradientMatrix.tx,
				fillGradientMatrix.ty);
		}

		context.fill(windingRule);

		if (fillBitmap != null)
		{
			//
		}
		else if (fillGradient != null && fillGradientMatrix != null)
		{
			var inverse = Matrix.__pool.get();
			inverse.copyFrom(fillGradientMatrix);
			inverse.invert();
			context.transform(inverse.a, inverse.b, inverse.c, inverse.d, inverse.tx, inverse.ty);
			Matrix.__pool.release(inverse);
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

	private static function reverseGradientBox(m:Matrix):Matrix
	{
		// var a = m.a * 1638.4;
		// var b = m.b * 1638.4;
		// var c = m.c * 1638.4;
		// var d = m.d * 1638.4;
		// // var width = Math.sqrt(a * a + c * c);
		// // var height = Math.sqrt(b * b + d * d);
		// var tx = m.tx - a / 2;
		// var ty = m.ty - d / 2;
		// m.setTo(a, b, c, d, -50, -50);
		// return m;
		var a = m.a;
		var b = m.b;
		var c = m.c;
		var d = m.d;
		var tx = m.tx;
		var ty = m.ty;

		// Recover scale
		var scaleX = Math.sqrt(a * a + c * c);
		var scaleY = Math.sqrt(b * b + d * d);

		// Original width/height
		var width = scaleX * 1638.4;
		var height = scaleY * 1638.4;

		// Rotation
		// var rotation = Math.atan2(b, d);

		// Original translation
		var origTx = tx - width / 2;
		var origTy = ty - height / 2;

		// m.setTo(width, b, c, height, origTx, origTy);
		m.createBox(width, height, 0, origTx, origTy);
		return m;
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private static function createGradient(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix,
			spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float,
			stroke:Bool = false):#if (js && html5) CanvasGradient #else Void #end
	{
		#if (js && html5)
		var pattern:CanvasGradient = null;
		if (matrix == null)
		{
			matrix = new Matrix();
		}
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
		var transform = transformed ? new Matrix(1, 0, 0, 1, 0, 0) : matrix;

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
			strokeGradientMatrix = transformed ? matrix : null;
		}
		else
		{
			fillGradientMatrix = transformed ? matrix : null;
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

	private static function getDimensions(matrix:Matrix):Dynamic
	{
		var angle:Float = Math.atan2(matrix.c, matrix.a);
		var cos:Float = Math.cos(angle);

		var w:Float = (matrix.a / cos) * 1638.4;
		var h:Float = (matrix.d / cos) * 1638.4;

		if (w == 0 && h == 0)
		{
			w = h = 819.2;
		}
		return {
			width: w,
			height: h
		};
	}

	private static function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void
	{
		#if (js && html5)
		if (ellipseHeight == null) ellipseHeight = ellipseWidth;

		if (ellipseWidth > width) ellipseWidth = width;
		if (ellipseHeight > height) ellipseHeight = height;

		ellipseWidth *= 0.5;
		ellipseHeight *= 0.5;

		var right = x + width;
		var bottom = y + height;

		if (Scale9Grid.valid)
		{
			var scaledLeft = Scale9Grid.toPositionX(x);
			var scaledTop = Scale9Grid.toPositionY(y);
			var scaledRight = Scale9Grid.toPositionX(x + width);
			var scaledBottom = Scale9Grid.toPositionY(y + height);

			Scale9Grid.applyUnscaledX(x);
			Scale9Grid.applyUnscaledY(y);
			Scale9Grid.applyUnscaledX(x + width);
			Scale9Grid.applyUnscaledY(y + height);
			Scale9Grid.applyScaledX(scaledLeft);
			Scale9Grid.applyScaledY(scaledTop);
			Scale9Grid.applyScaledX(scaledRight);
			Scale9Grid.applyScaledY(scaledBottom);

			var scaledLeftX = Scale9Grid.toPositionX(x + ellipseWidth);
			var scaledTopY = Scale9Grid.toPositionY(y + ellipseHeight);
			var scaledRightX = Scale9Grid.toPositionX(x + width - ellipseWidth);
			var scaledBottomY = Scale9Grid.toPositionY(y + height - ellipseHeight);

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
			context.lineTo(x + ellipseWidth, bottom);
			context.quadraticCurveTo(x - cx2, bottom, x - cx1, bottom + cy1);
			context.quadraticCurveTo(x, bottom + cy2, x, bottom - ellipseHeight);
			context.lineTo(x, y + ellipseHeight);
			context.quadraticCurveTo(x, y - cy2, x - cx1, y - cy1);
			context.quadraticCurveTo(x - cx2, y, x + ellipseWidth, y);
			context.lineTo(right - ellipseWidth, y);
			context.quadraticCurveTo(right + cx2, y, right + cx1, y - cy1);
			context.quadraticCurveTo(right, y - cy2, right, y + ellipseHeight);
			context.lineTo(right, bottom - ellipseHeight);
		}
		#end
	}

	private static function endFill():Void
	{
		#if (js && html5)
		if (fillCommands.length > 0)
		{
			context.beginPath();
			playCommands(fillCommands, false);
			fillCommands.clear();
		}
		#end
	}

	private static function endStroke():Void
	{
		#if (js && html5)
		if (strokeCommands.length > 0)
		{
			context.beginPath();
			playCommands(strokeCommands, true);
			context.closePath();
			strokeCommands.clear();
		}
		#end
	}

	public static function hitTest(graphics:Graphics, x:Float, y:Float):Bool
	{
		#if (js && html5)
		bounds = graphics.__bounds;
		CanvasGraphics.graphics = graphics;

		if (graphics.__commands.length == 0 || bounds == null || bounds.width <= 0 || bounds.height <= 0)
		{
			CanvasGraphics.graphics = null;
			return false;
		}
		else
		{
			hitTesting = true;

			var transform = graphics.__renderTransform;

			var px = transform.__transformX(x - bounds.x, y - bounds.y);
			var py = transform.__transformY(x - bounds.x, y - bounds.y);

			x = px;
			y = py;

			#if (!openfl_legacy_scale9grid || canvas)
			Scale9Grid.setTo(graphics);
			#end

			if (Scale9Grid.valid)
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

			inline function cleanUp()
			{
				data.destroy();
				graphics.__canvas = cacheCanvas;
				graphics.__context = cacheContext;
				CanvasGraphics.graphics = null;
			}

			inline function endFillHitTest():Bool
			{
				endFill();

				if (hasFill && hasPath && context.isPointInPath(x, y, windingRule))
				{
					cleanUp();
					return true;
				}
				return false;
			}

			inline function endStrokeHitTest():Bool
			{
				endStroke();

				if (hasStroke && hasPath && context.isPointInStroke(x, y))
				{
					cleanUp();
					return true;
				}
				return false;
			}

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

					case LINE_STYLE:
						if (endStrokeHitTest()) return true;

						var c = data.readLineStyle();
						strokeCommands.lineStyle(c.thickness, c.color, 1, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);

						hasPath = false;
						hasStroke = (c.thickness != null);

					case LINE_GRADIENT_STYLE:
						var c = data.readLineGradientStyle();
						strokeCommands.lineGradientStyle(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
							c.focalPointRatio);

					case LINE_BITMAP_STYLE:
						var c = data.readLineBitmapStyle();
						strokeCommands.lineBitmapStyle(c.bitmap, c.matrix, c.repeat, c.smooth);

					case END_FILL:
						if (endFillHitTest()) return true;
						if (endStrokeHitTest()) return true;

						hasPath = false;
						hasFill = false;

					case BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL, BEGIN_SHADER_FILL:
						if (endFillHitTest()) return true;
						if (endStrokeHitTest()) return true;

						if (type == BEGIN_BITMAP_FILL)
						{
							var c = data.readBeginBitmapFill();
							fillCommands.beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);
							strokeCommands.beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);
						}
						else if (type == BEGIN_GRADIENT_FILL)
						{
							var c = data.readBeginGradientFill();
							fillCommands.beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
								c.focalPointRatio);
							strokeCommands.beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
								c.focalPointRatio);
						}
						else if (type == BEGIN_SHADER_FILL)
						{
							var c = data.readBeginShaderFill();
							fillCommands.beginShaderFill(c.shaderBuffer);
							strokeCommands.beginShaderFill(c.shaderBuffer);
						}
						else
						{
							var c = data.readBeginFill();
							fillCommands.beginFill(c.color, 1);
							strokeCommands.beginFill(c.color, 1);
						}

						hasPath = false;
						hasFill = true;

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
						windingRule = CanvasWindingRule.EVENODD;

					case WINDING_NON_ZERO:
						windingRule = CanvasWindingRule.NONZERO;

					default:
						data.skip(type);
				}
			}

			if (endFillHitTest()) return true;
			if (endStrokeHitTest()) return true;

			cleanUp();
			return false;
		}
		#end

		return false;
	}

	private static inline function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Bool
	{
		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
	}

	private static inline function applyPatternMatrix(bitmap:BitmapData, bitmapMatrix:Matrix, scale9Bounds:Scale9GridBounds,
			pattern:#if (js && html5) CanvasPattern #else Dynamic #end):Void
	{
		#if (js && html5)
		var matrix = Matrix.__pool.get();
		if (bitmapMatrix != null)
		{
			matrix.copyFrom(bitmapMatrix);
		}
		else
		{
			matrix.identity();
		}
		if (scale9Bounds != null && bitmap != null)
		{
			scale9Bounds.calculateBitmapMatrix(bitmap.width, bitmap.height, matrix, matrix);
		}
		pattern.setTransform(cast toDOMMatrix(matrix));
		Matrix.__pool.release(matrix);
		#end
	}

	private static function playCommands(commands:DrawCommandBuffer, stroke:Bool = false):Void
	{
		#if (js && html5)
		bounds = graphics.__bounds;

		var offsetX = bounds.x;
		var offsetY = bounds.y;

		var positionX = 0.0;
		var positionY = 0.0;

		var startX = 0.0;
		var startY = 0.0;

		windingRule = CanvasWindingRule.EVENODD;
		setSmoothing(true);

		var hasPath = false;

		var data = new DrawCommandReader(commands);

		var x:Float;
		var y:Float;
		var width:Float;
		var height:Float;
		var kappa = 0.5522848;
		var ox:Float;
		var oy:Float;
		var xe:Float;
		var ye:Float;
		var xm:Float;
		var ym:Float;
		var r:Int;
		var g:Int;
		var b:Int;
		var optimizationUsed:Bool;
		var canOptimizeMatrix:Bool;
		var st:Float;
		var sr:Float;
		var sb:Float;
		var sl:Float;

		context.moveTo(0, 0);

		for (type in commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					hasPath = true;

					if (Scale9Grid.valid)
					{
						var scaledControlX1 = Scale9Grid.toPositionX(c.controlX1);
						var scaledControlY1 = Scale9Grid.toPositionY(c.controlY1);
						var scaledControlX2 = Scale9Grid.toPositionX(c.controlX2);
						var scaledControlY2 = Scale9Grid.toPositionY(c.controlY2);
						var scaledAnchorX = Scale9Grid.toPositionX(c.anchorX);
						var scaledAnchorY = Scale9Grid.toPositionY(c.anchorY);

						Scale9Grid.applyUnscaledX(c.anchorX);
						Scale9Grid.applyUnscaledY(c.anchorY);
						Scale9Grid.applyScaledX(scaledAnchorX);
						Scale9Grid.applyScaledY(scaledAnchorY);

						context.bezierCurveTo(scaledControlX1
							- offsetX, scaledControlY1
							- offsetY, scaledControlX2
							- offsetX, scaledControlY2
							- offsetY,
							scaledAnchorX
							- offsetX, scaledAnchorY
							- offsetY);

						positionX = scaledAnchorX;
						positionY = scaledAnchorY;
					}
					else
					{
						context.bezierCurveTo(c.controlX1
							- offsetX, c.controlY1
							- offsetY, c.controlX2
							- offsetX, c.controlY2
							- offsetY, c.anchorX
							- offsetX,
							c.anchorY
							- offsetY);

						positionX = c.anchorX;
						positionY = c.anchorY;
					}

				case CURVE_TO:
					var c = data.readCurveTo();
					hasPath = true;

					if (Scale9Grid.valid)
					{
						var scaledControlX = Scale9Grid.toPositionX(c.controlX);
						var scaledControlY = Scale9Grid.toPositionY(c.controlY);
						var scaledAnchorX = Scale9Grid.toPositionX(c.anchorX);
						var scaledAnchorY = Scale9Grid.toPositionY(c.anchorY);

						Scale9Grid.applyUnscaledX(c.anchorX);
						Scale9Grid.applyUnscaledY(c.anchorY);
						Scale9Grid.applyScaledX(scaledAnchorX);
						Scale9Grid.applyScaledY(scaledAnchorY);

						context.quadraticCurveTo(scaledControlX - offsetX, scaledControlY - offsetY, scaledAnchorX - offsetX, scaledAnchorY - offsetY);

						positionX = scaledAnchorX;
						positionY = scaledAnchorY;
					}
					else
					{
						context.quadraticCurveTo(c.controlX - offsetX, c.controlY - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);

						positionX = c.anchorX;
						positionY = c.anchorY;
					}

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					hasPath = true;

					if (Scale9Grid.valid)
					{
						var scaledLeft = Scale9Grid.toPositionX(c.x - c.radius);
						var scaledTop = Scale9Grid.toPositionY(c.y - c.radius);
						var scaledRight = Scale9Grid.toPositionX(c.x + c.radius);
						var scaledBottom = Scale9Grid.toPositionY(c.y + c.radius);

						Scale9Grid.applyUnscaledX(c.x - c.radius);
						Scale9Grid.applyUnscaledY(c.y - c.radius);
						Scale9Grid.applyUnscaledX(c.x + c.radius);
						Scale9Grid.applyUnscaledY(c.y + c.radius);
						Scale9Grid.applyScaledX(scaledLeft);
						Scale9Grid.applyScaledY(scaledTop);
						Scale9Grid.applyScaledX(scaledRight);
						Scale9Grid.applyScaledY(scaledBottom);

						x = scaledLeft - offsetX;
						y = scaledTop - offsetY;
						width = scaledRight - scaledLeft;
						height = scaledBottom - scaledTop;

						if (width != 0.0 || height != 0.0)
						{
							ox = (width / 2) * kappa; // control point offset horizontal
							oy = (height / 2) * kappa; // control point offset vertical
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
						context.moveTo(c.x - offsetX + c.radius, c.y - offsetY);
						context.arc(c.x - offsetX, c.y - offsetY, c.radius, 0, Math.PI * 2, true);
					}

				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					hasPath = true;

					if (Scale9Grid.valid)
					{
						// TODO: this is not how Flash behaves!
						// Flash seems to use multiple curves instead
						var scaledLeft = Scale9Grid.toPositionX(c.x);
						var scaledTop = Scale9Grid.toPositionY(c.y);
						var scaledRight = Scale9Grid.toPositionX(c.x + c.width);
						var scaledBottom = Scale9Grid.toPositionY(c.y + c.height);

						if (Scale9Grid.valid)
						{
							Scale9Grid.applyUnscaledX(c.x);
							Scale9Grid.applyUnscaledY(c.y);
							Scale9Grid.applyUnscaledX(c.x + c.width);
							Scale9Grid.applyUnscaledY(c.y + c.height);
							Scale9Grid.applyScaledX(scaledLeft);
							Scale9Grid.applyScaledY(scaledTop);
							Scale9Grid.applyScaledX(scaledRight);
							Scale9Grid.applyScaledY(scaledBottom);
						}

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
						x -= offsetX;
						y -= offsetY;

						ox = (width / 2) * kappa; // control point offset horizontal
						oy = (height / 2) * kappa; // control point offset vertical
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
					drawRoundRect(c.x - offsetX, c.y - offsetY, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

				case LINE_TO:
					var c = data.readLineTo();
					hasPath = true;

					if (Scale9Grid.valid)
					{
						var scaledX = Scale9Grid.toPositionX(c.x);
						var scaledY = Scale9Grid.toPositionY(c.y);

						if (Scale9Grid.valid)
						{
							Scale9Grid.applyUnscaledX(c.x);
							Scale9Grid.applyUnscaledY(c.y);
							Scale9Grid.applyScaledX(scaledX);
							Scale9Grid.applyScaledY(scaledY);
						}

						if (positionX != scaledX || positionY != scaledY)
						{
							context.lineTo(scaledX - offsetX, scaledY - offsetY);
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
							context.lineTo(c.x - offsetX, c.y - offsetY);
						}

						positionX = c.x;
						positionY = c.y;
					}

				case MOVE_TO:
					var c = data.readMoveTo();

					if (Scale9Grid.valid)
					{
						var scaledX = Scale9Grid.toPositionX(c.x);
						var scaledY = Scale9Grid.toPositionY(c.y);

						if (Scale9Grid.valid)
						{
							Scale9Grid.applyUnscaledX(c.x);
							Scale9Grid.applyUnscaledY(c.y);
							Scale9Grid.applyScaledX(scaledX);
							Scale9Grid.applyScaledY(scaledY);
						}

						context.moveTo(scaledX - offsetX, scaledY - offsetY);

						positionX = scaledX;
						positionY = scaledY;
					}
					else
					{
						context.moveTo(c.x - offsetX, c.y - offsetY);

						positionX = c.x;
						positionY = c.y;
					}

					startX = positionX;
					startY = positionY;

				case LINE_STYLE:
					var c = data.readLineStyle();
					if (stroke && hasStroke)
					{
						closePathAndApplyStroke(true);
					}

					context.moveTo(positionX - offsetX, positionY - offsetY);

					if (c.thickness == null)
					{
						hasStroke = false;
					}
					else
					{
						hasStroke = true;

						context.lineWidth = (c.thickness > 0 ? c.thickness : 1);

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
					strokePatternMatrix = null;
					strokeGradient = null;
					strokeGradientMatrix = null;

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();
					if (stroke && hasStroke)
					{
						closePathAndApplyStroke(true);
					}

					context.moveTo(positionX - offsetX, positionY - offsetY);
					strokeGradient = createGradient(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio,
						true);
					context.strokeStyle = strokePattern;

					setSmoothing(true);
					hasStroke = true;

					strokeBitmap = null;
					strokePattern = null;
					strokePatternMatrix = null;

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();
					if (stroke && hasStroke)
					{
						closePathAndApplyStroke(true);
					}

					context.moveTo(positionX - offsetX, positionY - offsetY);
					if (c.bitmap.readable)
					{
						strokePattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						context.strokeStyle = strokePattern;
						strokeBitmap = c.bitmap;
						strokePatternMatrix = c.matrix;
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						context.strokeStyle = "#" + StringTools.hex(0, 6);
						strokePattern = null;
						strokeBitmap = null;
						strokePatternMatrix = null;
					}

					if (Scale9Grid.valid) Scale9Grid.strokeBounds.clear();

					strokeGradient = null;
					strokeGradientMatrix = null;
					hasStroke = true;

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					if (c.bitmap.readable)
					{
						fillPattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						context.fillStyle = fillPattern;
						fillBitmap = c.bitmap;
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
					fillPatternMatrix = c.matrix;

					if (Scale9Grid.valid)
					{
						Scale9Grid.fillBounds.clear();
					}

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

					if (Scale9Grid.valid)
					{
						Scale9Grid.fillBounds.clear();
					}

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();
					fillGradient = context.fillStyle = createGradient(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio, false);

					hasFill = true;
					fillBitmap = null;
					fillPattern = null;
					setSmoothing(true);

					if (Scale9Grid.valid)
					{
						Scale9Grid.fillBounds.clear();
					}

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
						hasFill = true;
					}

					if (Scale9Grid.valid)
					{
						Scale9Grid.fillBounds.clear();
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

					var transform = graphics.__renderTransform;
					// var roundPixels = renderer.__roundPixels;
					var alpha = CanvasGraphics.worldAlpha;

					var ri:Int;
					var ti:Int;

					context.save(); // TODO: Restore transform without save/restore

					for (i in 0...length)
					{
						ri = (hasIndices ? (indices[i] * 4) : i * 4);
						if (ri < 0) continue;

						// TODO: scale9Grid
						tileRect.setTo(rects[ri], rects[ri + 1], rects[ri + 2], rects[ri + 3]);

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

						tileTransform.tx += positionX - offsetX;
						tileTransform.ty += positionY - offsetY;
						tileTransform.concat(transform);

						// if (roundPixels) {

						// 	tileTransform.tx = Math.round (tileTransform.tx);
						// 	tileTransform.ty = Math.round (tileTransform.ty);

						// }

						context.setTransform(tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, tileTransform.tx, tileTransform.ty);

						if (fillBitmap != null && fillBitmap.readable)
						{
							context.drawImage(fillBitmap.image.src, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width,
								tileRect.height);
						}
						else
						{
							context.fillRect(0, 0, tileRect.width, tileRect.height);
						}
					}

					Rectangle.__pool.release(tileRect);
					Matrix.__pool.release(tileTransform);

					context.restore();

				case DRAW_TRIANGLES:
					if (stroke && !hasStroke || !stroke && !hasFill)
					{
						continue;
					}

					var c = data.readDrawTriangles();
					var v = c.vertices;
					var ind = c.indices;
					var uvt = c.uvtData;
					hasPath = true;

					seenEdgeMap.clear();

					if (uvt != null && uvt.length != v.length)
					{
						uvt = Graphics.normalizeUVT(uvt, tempUvtVector);
					}
					else if (!stroke && uvt == null && fillBitmap != null)
					{
						uvt = Graphics.generateUVT(v, fillBitmap.width, fillBitmap.height, fillPatternMatrix, tempUvtVector);
					}

					var i = 0;
					var l = ind.length;
					var vertLength = Std.int(v.length / 2);

					var a_:Int, b_:Int, c_:Int;
					var iax:Int, iay:Int, ibx:Int, iby:Int, icx:Int, icy:Int;
					var x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float;
					var u1:Float, u2:Float, u3:Float, v1:Float, v2:Float, v3:Float;
					var abKey:Int, bcKey:Int, caKey:Int;
					var abShared:Bool = false,
						bcShared:Bool = false,
						caShared:Bool = false;

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

					while (i < l)
					{
						a_ = i;
						b_ = i + 1;
						c_ = i + 2;

						iax = ind[a_] * 2;
						iay = ind[a_] * 2 + 1;
						ibx = ind[b_] * 2;
						iby = ind[b_] * 2 + 1;
						icx = ind[c_] * 2;
						icy = ind[c_] * 2 + 1;

						if (Scale9Grid.valid)
						{
							var scaledX1 = Scale9Grid.toPositionX(v[iax]);
							var scaledY1 = Scale9Grid.toPositionY(v[iay]);
							var scaledX2 = Scale9Grid.toPositionX(v[ibx]);
							var scaledY2 = Scale9Grid.toPositionY(v[iby]);
							var scaledX3 = Scale9Grid.toPositionX(v[icx]);
							var scaledY3 = Scale9Grid.toPositionY(v[icy]);

							if (Scale9Grid.valid)
							{
								Scale9Grid.applyUnscaledX(v[iax]);
								Scale9Grid.applyUnscaledY(v[iay]);
								Scale9Grid.applyUnscaledX(v[ibx]);
								Scale9Grid.applyUnscaledY(v[iby]);
								Scale9Grid.applyUnscaledX(v[icx]);
								Scale9Grid.applyUnscaledY(v[icy]);
								Scale9Grid.applyScaledX(scaledX1);
								Scale9Grid.applyScaledY(scaledY1);
								Scale9Grid.applyScaledX(scaledX2);
								Scale9Grid.applyScaledY(scaledY2);
								Scale9Grid.applyScaledX(scaledX3);
								Scale9Grid.applyScaledY(scaledY3);
							}

							x1 = scaledX1 - offsetX;
							y1 = scaledY1 - offsetY;
							x2 = scaledX2 - offsetX;
							y2 = scaledY2 - offsetY;
							x3 = scaledX3 - offsetX;
							y3 = scaledY3 - offsetY;
						}
						else
						{
							x1 = v[iax] - offsetX;
							y1 = v[iay] - offsetY;
							x2 = v[ibx] - offsetX;
							y2 = v[iby] - offsetY;
							x3 = v[icx] - offsetX;
							y3 = v[icy] - offsetY;
						}

						if (!stroke)
						{
							switch (c.culling)
							{
								case POSITIVE:
									if (!isCCW(x1, y1, x2, y2, x3, y3))
									{
										i += 3;
										continue;
									}

								case NEGATIVE:
									if (isCCW(x1, y1, x2, y2, x3, y3))
									{
										i += 3;
										continue;
									}

								default:
							}
						}

						abKey = Graphics.edgeKey(ind[a_], ind[b_]);
						bcKey = Graphics.edgeKey(ind[b_], ind[c_]);
						caKey = Graphics.edgeKey(ind[c_], ind[a_]);

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

						u1 = uvt[iax];
						u2 = uvt[ibx];
						u3 = uvt[icx];
						v1 = uvt[iay];
						v2 = uvt[iby];
						v3 = uvt[icy];

						if (!hitTesting)
						{
							context.beginPath();
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
								fillPatternMatrix = Graphics.calculatePatternMatrixFromTri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3,
									(minX - offsetX) * 2, (minY - offsetY) * 2, fillBitmap.width, fillBitmap.height, tempUVPatternMatrix);
								applyFill();
								fillPatternMatrix = oldFillPatternMatrix;
							}

							// if (abShared) fixTriangleGap(x1, y1, x2, y2);
							// if (bcShared) fixTriangleGap(x2, y2, x3, y3);
							// if (caShared) fixTriangleGap(x3, y3, x1, y1);
						}

						i += 3;
					}

				case DRAW_RECT:
					var c = data.readDrawRect();
					optimizationUsed = false;

					if (fillBitmap != null && fillBitmap.readable && !hitTesting && !Scale9Grid.valid)
					{
						st = 0;
						sr = 0;
						sb = 0;
						sl = 0;

						canOptimizeMatrix = true;

						if (fillPatternMatrix != null)
						{
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
						}
						else
						{
							st = c.y;
							sl = c.x;
							sb = c.y + c.height;
							sr = c.x + c.width;
						}

						if (!hitTesting && canOptimizeMatrix && st >= 0 && sl >= 0 && sr <= fillBitmap.width && sb <= fillBitmap.height)
						{
							optimizationUsed = true;
							context.drawImage(fillBitmap.image.src, sl, st, sr - sl, sb - st, c.x - offsetX, c.y - offsetY, c.width, c.height);
						}
					}

					if (!optimizationUsed)
					{
						if (Scale9Grid.valid)
						{
							var scaledLeft = Scale9Grid.toPositionX(c.x);
							var scaledTop = Scale9Grid.toPositionY(c.y);
							var scaledRight = Scale9Grid.toPositionX(c.x + c.width);
							var scaledBottom = Scale9Grid.toPositionY(c.y + c.height);

							if (Scale9Grid.valid)
							{
								Scale9Grid.applyUnscaledX(c.x);
								Scale9Grid.applyUnscaledY(c.y);
								Scale9Grid.applyUnscaledX(c.x + c.width);
								Scale9Grid.applyUnscaledY(c.y + c.height);
								Scale9Grid.applyScaledX(scaledLeft);
								Scale9Grid.applyScaledY(scaledTop);
								Scale9Grid.applyScaledX(scaledRight);
								Scale9Grid.applyScaledY(scaledBottom);
							}

							var scaledWidth = scaledRight - scaledLeft;
							var scaledHeight = scaledBottom - scaledTop;
							if (scaledWidth != 0.0 || scaledHeight != 0.0)
							{
								hasPath = true;
								// flash doesn't draw the rectangle if both the width
								// and height are zero
								context.rect(scaledLeft - offsetX, scaledTop - offsetY, scaledWidth, scaledHeight);
							}
						}
						else if (c.width != 0.0 || c.height != 0.0)
						{
							hasPath = true;
							context.rect(c.x - offsetX, c.y - offsetY, c.width, c.height);
						}
					}

				case WINDING_EVEN_ODD:
					windingRule = CanvasWindingRule.EVENODD;

				case WINDING_NON_ZERO:
					windingRule = CanvasWindingRule.NONZERO;

				default:
					data.skip(type);
			}
		}

		data.destroy();

		if (hasPath)
		{
			if (hasFill && (positionX != startX || positionY != startY))
			{
				context.lineTo(startX - offsetX, startY - offsetY);
				positionX = startX;
				positionY = startY;
			}
			if (!hitTesting)
			{
				if (!stroke && hasFill)
				{
					context.translate(-bounds.x, -bounds.y);

					applyFill();

					context.translate(bounds.x, bounds.y);
				}
				if (stroke && hasStroke)
				{
					closePathAndApplyStroke(true);
				}
			}
		}
		#end
	}

	public static function render(graphics:Graphics, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		#if (openfl_disable_hdpi || openfl_disable_hdpi_graphics)
		var pixelRatio = 1;
		#else
		var pixelRatio = renderer.__pixelRatio;
		#end

		#if (!openfl_legacy_scale9grid || canvas)
		Scale9Grid.setTo(graphics);
		#end

		if (Scale9Grid.valid)
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

		if (graphics.__softwareDirty)
		{
			hitTesting = false;

			CanvasGraphics.graphics = graphics;
			CanvasGraphics.allowSmoothing = renderer.__allowSmoothing;
			CanvasGraphics.worldAlpha = renderer.__getAlpha(graphics.__owner.__worldAlpha);
			bounds = graphics.__bounds;

			var width = graphics.__width;
			var height = graphics.__height;

			if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || width < 1 || height < 1)
			{
				graphics.__canvas = null;
				graphics.__context = null;
				graphics.__bitmap = null;
			}
			else
			{
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
							hasFill = false;
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

						case BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL, BEGIN_SHADER_FILL:
							endFill();
							endStroke();

							if (type == BEGIN_BITMAP_FILL)
							{
								var c = data.readBeginBitmapFill();
								fillCommands.beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);
								strokeCommands.beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);
							}
							else if (type == BEGIN_GRADIENT_FILL)
							{
								var c = data.readBeginGradientFill();
								fillCommands.beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
									c.focalPointRatio);
								strokeCommands.beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
									c.focalPointRatio);
							}
							else if (type == BEGIN_SHADER_FILL)
							{
								var c = data.readBeginShaderFill();
								fillCommands.beginShaderFill(c.shaderBuffer);
								strokeCommands.beginShaderFill(c.shaderBuffer);
							}
							else
							{
								var c = data.readBeginFill();
								fillCommands.beginFill(c.color, c.alpha);
								strokeCommands.beginFill(c.color, c.alpha);
							}

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
		}
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

			var offsetX = 0;
			var offsetY = 0;

			var data = new DrawCommandReader(graphics.__commands);

			var x:Float;
			var y:Float;
			var width:Float;
			var height:Float;
			var kappa = 0.5522848;
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
						context.bezierCurveTo(c.controlX1
							- offsetX, c.controlY1
							- offsetY, c.controlX2
							- offsetX, c.controlY2
							- offsetY, c.anchorX
							- offsetX,
							c.anchorY
							- offsetY);
						positionX = c.anchorX;
						positionY = c.anchorY;

					case CURVE_TO:
						var c = data.readCurveTo();
						context.quadraticCurveTo(c.controlX - offsetX, c.controlY - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);
						positionX = c.anchorX;
						positionY = c.anchorY;

					case DRAW_CIRCLE:
						var c = data.readDrawCircle();
						context.arc(c.x - offsetX, c.y - offsetY, c.radius, 0, Math.PI * 2, true);

					case DRAW_ELLIPSE:
						var c = data.readDrawEllipse();
						x = c.x;
						y = c.y;
						width = c.width;
						height = c.height;
						x -= offsetX;
						y -= offsetY;

						ox = (width / 2) * kappa; // control point offset horizontal
						oy = (height / 2) * kappa; // control point offset vertical
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
						context.rect(c.x - offsetX, c.y - offsetY, c.width, c.height);
						context.closePath();

					case DRAW_ROUND_RECT:
						var c = data.readDrawRoundRect();
						drawRoundRect(c.x - offsetX, c.y - offsetY, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

					case LINE_TO:
						var c = data.readLineTo();
						context.lineTo(c.x - offsetX, c.y - offsetY);
						positionX = c.x;
						positionY = c.y;

					case MOVE_TO:
						var c = data.readMoveTo();
						context.moveTo(c.x - offsetX, c.y - offsetY);
						positionX = c.x;
						positionY = c.y;

					default:
						data.skip(type);
				}
			}

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
		fillPatternMatrix = null;
		fillPattern = null;
		fillGradient = null;
		fillGradientMatrix = null;
		strokePattern = null;
		strokePatternMatrix = null;
		strokeGradient = null;
		strokeGradientMatrix = null;
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
