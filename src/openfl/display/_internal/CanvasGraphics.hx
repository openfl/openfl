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
	private static var allowSmoothing:Bool;
	private static var bitmapRepeat:Bool;
	private static var bounds:Rectangle;
	private static var fillCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var bitmapFill:BitmapData;
	private static var graphics:Graphics;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var hitTesting:Bool;
	private static var bitmapFillMatrix:Matrix;
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var strokePattern:#if (js && html5) CanvasPattern #else Dynamic #end;
	private static var fillPattern:#if (js && html5) CanvasPattern #else Dynamic #end;
	private static var bitmapStroke:BitmapData;
	private static var bitmapStrokeMatrix:Matrix;
	@SuppressWarnings("checkstyle:Dynamic") private static var windingRule:#if (js && html5) CanvasWindingRule #else Dynamic #end;
	private static var worldAlpha:Float;
	#if (js && html5)
	private static var tempUvtVector:Vector<Float> = new Vector<Float>();
	private static var tempPatternMatrix = new Matrix();
	private static var tempGradientFillMatrix:Matrix = new Matrix();
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

	private static function closePath(strokeBefore:Bool = false):Void
	{
		#if (js && html5)
		if (context.strokeStyle == null)
		{
			return;
		}

		if (!strokeBefore)
		{
			context.closePath();
		}

		if (!hitTesting && strokePattern != null)
		{
			applyPatternMatrix(bitmapStroke, bitmapStrokeMatrix, Scale9Grid.valid ? Scale9Grid.strokeBounds : null, strokePattern);
		}

		context.stroke();

		if (strokeBefore)
		{
			context.closePath();
		}

		context.beginPath();
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

	@SuppressWarnings("checkstyle:Dynamic")
	private static function createGradientPattern(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix,
			spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float):#if (js && html5) CanvasPattern #else Void #end
	{
		#if (js && html5)
		var gradientFill:CanvasGradient = null,
			point:Point = null,
			point2:Point = null,
			releaseMatrix = false,
			ratio:Float = 0.0;

		if (matrix == null)
		{
			matrix = Matrix.__pool.get();
			matrix.identity();
			releaseMatrix = true;
		}

		switch (type)
		{
			case RADIAL:
				focalPointRatio = focalPointRatio > 1.0 ? 1.0 : focalPointRatio < -1.0 ? -1.0 : focalPointRatio;

				// focal center
				point = Point.__pool.get();
				point.x = focalPointRatio * 819.2;
				point.y = 0.0;
				matrix.__transformPoint(point);

				// center
				point2 = Point.__pool.get();
				point2.setTo(0.0, 0.0);
				matrix.__transformPoint(point2);

				// end
				var point3 = Point.__pool.get();
				point3.x = 819.2;
				point3.y = 0.0;
				matrix.__transformPoint(point3);

				if (Scale9Grid.valid)
				{
					point.x = Scale9Grid.toPositionX(point.x);
					point.y = Scale9Grid.toPositionY(point.y);
					point2.x = Scale9Grid.toPositionX(point2.x);
					point2.y = Scale9Grid.toPositionY(point2.y);
					point3.x = Scale9Grid.toPositionX(point3.x);
					point3.y = Scale9Grid.toPositionY(point3.y);
				}

				var dx = point3.x - point2.x;
				var dy = point3.y - point2.y;

				Point.__pool.release(point3);

				// canvas can't draw ellipical radial gradients; they must be
				// circular. in other words, the same radius in both directions.
				// we basically take the average and use that. not ideal, but
				// probably as close as we can get to flash.
				var radius = Math.sqrt(dx * dx + dy * dy);

				gradientFill = context.createRadialGradient(point.x, point.y, 0.0, point2.x, point2.y, radius);

				bitmapFillMatrix = null;

				for (i in 0...colors.length)
				{
					ratio = ratios[i] / 0xFF;
					if (ratio < 0) ratio = 0;
					else if (ratio > 1) ratio = 1;

					gradientFill.addColorStop(ratio, getRGBA(colors[i], alphas[i]));
				}

				if (point != null) Point.__pool.release(point);
				if (point2 != null) Point.__pool.release(point2);
				if (releaseMatrix) Matrix.__pool.release(matrix);

				return cast(gradientFill);

			case LINEAR:
				if (spreadMethod == PAD)
				{
					point = Point.__pool.get();
					point.setTo(-819.2, 0);
					matrix.__transformPoint(point);

					point2 = Point.__pool.get();
					point2.setTo(819.2, 0);
					matrix.__transformPoint(point2);

					if (Scale9Grid.valid)
					{
						point.x = Scale9Grid.toPositionX(point.x);
						point.y = Scale9Grid.toPositionY(point.y);
						point2.x = Scale9Grid.toPositionX(point2.x);
						point2.y = Scale9Grid.toPositionY(point2.y);
					}

					gradientFill = context.createLinearGradient(point.x, point.y, point2.x, point2.y);

					bitmapFillMatrix = null;

					for (i in 0...colors.length)
					{
						ratio = ratios[i] / 0xFF;
						if (ratio < 0) ratio = 0;
						else if (ratio > 1) ratio = 1;

						gradientFill.addColorStop(ratio, getRGBA(colors[i], alphas[i]));
					}

					if (point != null) Point.__pool.release(point);
					if (point2 != null) Point.__pool.release(point2);
					if (releaseMatrix) Matrix.__pool.release(matrix);

					return cast(gradientFill);
				}

				var gradientScale:Float = spreadMethod == PAD ? 1.0 : 25.0;
				var dx = 0.5 * (gradientScale - 1.0) * 1638.4;
				var canvas:CanvasElement = cast Browser.document.createElement("canvas");
				var context2 = canvas.getContext("2d");

				var dimensions:Dynamic = getDimensions(matrix);

				canvas.width = context.canvas.width;
				canvas.height = context.canvas.height;
				gradientFill = context.createLinearGradient(-819.2 - dx, 0, 819.2 + dx, 0);
				if (spreadMethod == REFLECT)
				{
					var t:Float = 0;
					var step:Float = 1 / 25;
					var a:Int;
					while (t < 1)
					{
						for (i in 0...colors.length)
						{
							ratio = ratios[i] / 0xFF;
							ratio = t + ratio * step;
							if (ratio < 0) ratio = 0;
							else if (ratio > 1) ratio = 1;

							gradientFill.addColorStop(ratio, getRGBA(colors[i], alphas[i]));
						}
						t += step;
						a = colors.length - 1;
						while (a >= 0)
						{
							ratio = ratios[a] / 0xFF;
							ratio = t + (1.0 - ratio) * step;
							if (ratio < 0) ratio = 0;
							else if (ratio > 1) ratio = 1;
							gradientFill.addColorStop(ratio, getRGBA(colors[a], alphas[a]));
							a--;
						}
						t += step;
					}
				}
				else if (spreadMethod == REPEAT)
				{
					var t:Float = 0;
					var step:Float = 1 / 25;
					var a:Int;
					while (t < 1)
					{
						for (i in 0...colors.length)
						{
							ratio = ratios[i] / 0xFF;
							ratio = t + ratio * step;
							if (ratio < 0) ratio = 0;
							else if (ratio > 1) ratio = 1 - 0.001;

							gradientFill.addColorStop(ratio, getRGBA(colors[i], alphas[i]));
						}

						ratio = t + 0.001;
						if (ratio < 0) ratio = 0;
						else if (ratio > 1) ratio = 1;
						gradientFill.addColorStop(ratio - 0.001, getRGBA(colors[colors.length - 1], alphas[alphas.length - 1]));
						gradientFill.addColorStop(ratio, getRGBA(colors[0], alphas[0]));

						t += step;
					}
				}

				bitmapFillMatrix = tempGradientFillMatrix;
				bitmapFillMatrix.setTo(1, 0, 0, 1, matrix.tx - dimensions.width / 2, matrix.ty - dimensions.height / 2);

				var path = new Path2D();
				path.rect(0, 0, canvas.width, canvas.height);
				path.closePath();
				var gradientMatrix = new DOMMatrix([matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty]);
				var inverseMatrix = cast gradientMatrix.inverse();
				var untransformedPath = new Path2D();
				untransformedPath.addPath(path, inverseMatrix);
				context2.fillStyle = gradientFill;
				context2.setTransform(gradientMatrix.a, gradientMatrix.b, gradientMatrix.c, gradientMatrix.d, gradientMatrix.e, gradientMatrix.f);
				context2.fill(untransformedPath);
				return cast context.createPattern(canvas, 'no-repeat');
		}

		if (point != null) Point.__pool.release(point);
		if (point2 != null) Point.__pool.release(point2);
		if (releaseMatrix) Matrix.__pool.release(matrix);

		return cast(gradientFill);
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

			inline function hitTestResult(result:Bool):Bool
			{
				data.destroy();
				graphics.__canvas = cacheCanvas;
				graphics.__context = cacheContext;
				CanvasGraphics.graphics = null;
				return result;
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
						endStroke();

						if (hasStroke && hasPath && context.isPointInStroke(x, y))
						{
							return hitTestResult(true);
						}

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
						data.readEndFill();
						endFill();

						if (hasFill && hasPath && context.isPointInPath(x, y, windingRule))
						{
							return hitTestResult(true);
						}

						endStroke();

						if (hasStroke && hasPath && context.isPointInStroke(x, y))
						{
							return hitTestResult(true);
						}

						hasPath = false;
						hasFill = false;
						bitmapFill = null;
						bitmapFillMatrix = null;

					case BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL, BEGIN_SHADER_FILL:
						endFill();

						if (hasFill && hasPath && context.isPointInPath(x, y, windingRule))
						{
							return hitTestResult(true);
						}

						endStroke();

						if (hasStroke && hasPath && context.isPointInStroke(x, y))
						{
							return hitTestResult(true);
						}

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

			endFill();

			if (hasFill && hasPath && context.isPointInPath(x, y, windingRule))
			{
				return hitTestResult(true);
			}

			endStroke();

			if (hasStroke && hasPath && context.isPointInStroke(x, y))
			{
				return hitTestResult(true);
			}

			return hitTestResult(false);
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
		if (bitmapMatrix != null)
		{
			tempPatternMatrix.copyFrom(bitmapMatrix);
		}
		else
		{
			tempPatternMatrix.identity();
		}
		if (scale9Bounds != null && bitmap != null)
		{
			scale9Bounds.calculateBitmapMatrix(bitmap.width, bitmap.height, tempPatternMatrix, tempPatternMatrix);
		}
		pattern.setTransform(cast new DOMMatrix([
			tempPatternMatrix.a,
			tempPatternMatrix.b,
			tempPatternMatrix.c,
			tempPatternMatrix.d,
			tempPatternMatrix.tx,
			tempPatternMatrix.ty
		]));
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

		var closeGap = false;
		var startX = 0.0;
		var startY = 0.0;
		var setStart = false;

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

					if (positionX == startX && positionY == startY)
					{
						closeGap = true;
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

					if (setStart && positionX != startX && positionY != startY)
					{
						closeGap = true;
					}

					startX = positionX;
					startY = positionY;
					setStart = true;

				case LINE_STYLE:
					var c = data.readLineStyle();
					if (stroke && hasStroke)
					{
						closePath(true);
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
					bitmapStroke = null;
					bitmapStrokeMatrix = null;

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();
					if (stroke && hasStroke)
					{
						closePath(true);
					}

					context.moveTo(positionX - offsetX, positionY - offsetY);
					strokePattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);
					context.strokeStyle = strokePattern;

					setSmoothing(true);
					hasStroke = true;

					bitmapStroke = null;
					bitmapStrokeMatrix = null;

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();
					if (stroke && hasStroke)
					{
						closePath(true);
					}

					context.moveTo(positionX - offsetX, positionY - offsetY);
					if (c.bitmap.readable)
					{
						strokePattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						context.strokeStyle = strokePattern;
						bitmapStroke = c.bitmap;
						bitmapStrokeMatrix = c.matrix;
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						context.strokeStyle = "#" + StringTools.hex(0, 6);
						strokePattern = null;
						bitmapStroke = null;
						bitmapStrokeMatrix = null;
					}

					if (Scale9Grid.valid) Scale9Grid.strokeBounds.clear();

					hasStroke = true;

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					if (c.bitmap.readable)
					{
						fillPattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						context.fillStyle = fillPattern;
						bitmapFill = c.bitmap;
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						context.fillStyle = "#" + StringTools.hex(0, 6);
						bitmapFill = null;
						fillPattern = null;
					}

					bitmapRepeat = c.repeat;

					hasFill = true;

					if (Scale9Grid.valid)
					{
						Scale9Grid.fillBounds.clear();
					}

					if (c.matrix != null)
					{
						bitmapFillMatrix = c.matrix;
					}
					else
					{
						bitmapFillMatrix = null;
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

					bitmapFill = null;

					if (Scale9Grid.valid)
					{
						Scale9Grid.fillBounds.clear();
					}

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();
					context.fillStyle = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);

					hasFill = true;
					bitmapFill = null;
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
						bitmapFill = shaderBuffer.inputs[0];
						if (bitmapFill.readable)
						{
							context.fillStyle = createImagePattern(bitmapFill, shaderBuffer.inputWrap[0] != CLAMP, shaderBuffer.inputFilter[0] != NEAREST);
						}
						else
						{
							// if it's hardware-only BitmapData, fall back to
							// drawing solid black because we have no software
							// pixels to work with
							context.fillStyle = "#" + StringTools.hex(0, 6);
						}
						hasFill = true;

						bitmapFillMatrix = null;
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

						if (bitmapFill != null && bitmapFill.readable)
						{
							context.drawImage(bitmapFill.image.src, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width,
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

					seenEdgeMap.clear();

					if (uvt != null && uvt.length != v.length)
					{
						uvt = Graphics.normalizeUVT(uvt, tempUvtVector);
					}
					else if (!stroke && uvt == null && bitmapFill != null)
					{
						uvt = Graphics.generateUVT(v, bitmapFill.width, bitmapFill.height, bitmapFillMatrix, tempUvtVector);
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
							if (bitmapFill != null && !stroke)
							{
								var matrix = Graphics.calculatePatternMatrixFromTri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3, (minX - offsetX) * 2,
									(minY - offsetY) * 2, bitmapFill.width, bitmapFill.height, tempUVPatternMatrix);
								applyPatternMatrix(bitmapFill, matrix, Scale9Grid.valid ? Scale9Grid.fillBounds : null, fillPattern);
								context.fill(windingRule);
							}

							if (abShared) fixTriangleGap(x1, y1, x2, y2);
							if (bcShared) fixTriangleGap(x2, y2, x3, y3);
							if (caShared) fixTriangleGap(x3, y3, x1, y1);
						}

						i += 3;
					}

					// we need to do our fill / stroke in 1 operation when hitTesting
					if (stroke)
					{
						context.stroke();
					}

					if (hitTesting)
					{
						context.fill(windingRule);
					}

				case DRAW_RECT:
					var c = data.readDrawRect();
					optimizationUsed = false;

					if (bitmapFill != null && bitmapFill.readable && !hitTesting && !Scale9Grid.valid)
					{
						st = 0;
						sr = 0;
						sb = 0;
						sl = 0;

						canOptimizeMatrix = true;

						if (bitmapFillMatrix != null)
						{
							if (bitmapFillMatrix.b != 0 || bitmapFillMatrix.c != 0)
							{
								canOptimizeMatrix = false;
							}
							else
							{
								sl = bitmapFillMatrix.__transformInverseX(c.x, c.y);
								st = bitmapFillMatrix.__transformInverseY(c.x, c.y);
								sr = bitmapFillMatrix.__transformInverseX(c.x + c.width, c.y + c.height);
								sb = bitmapFillMatrix.__transformInverseY(c.x + c.width, c.y + c.height);
							}
						}
						else
						{
							st = c.y;
							sl = c.x;
							sb = c.y + c.height;
							sr = c.x + c.width;
						}

						if (!hitTesting && canOptimizeMatrix && st >= 0 && sl >= 0 && sr <= bitmapFill.width && sb <= bitmapFill.height)
						{
							optimizationUsed = true;
							context.drawImage(bitmapFill.image.src, sl, st, sr - sl, sb - st, c.x - offsetX, c.y - offsetY, c.width, c.height);
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
			if (stroke && hasStroke)
			{
				if (hasFill)
				{
					if (positionX != startX || positionY != startY)
					{
						context.lineTo(startX - offsetX, startY - offsetY);
						closeGap = true;
					}

					if (closeGap) closePath(true);
				}
				else if (closeGap && positionX == startX && positionY == startY)
				{
					closePath(true);
				}

				if (!hitTesting)
				{
					if (bitmapStroke != null)
					{
						applyPatternMatrix(bitmapStroke, bitmapStrokeMatrix, Scale9Grid.valid ? Scale9Grid.strokeBounds : null, strokePattern);
					}
					context.stroke();
				}
			}

			if (!stroke)
			{
				if (hasFill || bitmapFill != null)
				{
					context.translate(-bounds.x, -bounds.y);

					if (!hitTesting)
					{
						if (bitmapFill != null)
						{
							applyPatternMatrix(bitmapFill, bitmapFillMatrix, Scale9Grid.valid ? Scale9Grid.fillBounds : null, fillPattern);
						}
						context.fill(windingRule);
					}

					context.translate(bounds.x, bounds.y);
					context.closePath();
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

					var transform = graphics.__renderTransform;
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
							bitmapFill = null;
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

		bitmapFill = null;
		bitmapRepeat = false;
		bitmapFillMatrix = null;
		fillPattern = null;
		strokePattern = null;
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
