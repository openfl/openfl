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
	private static var fillScale9Bounds:Scale9GridBounds;
	private static var graphics:Graphics;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var hitTesting:Bool;
	private static var inversePendingMatrix:Matrix;
	private static var pendingMatrix:Matrix;
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var strokePattern:#if (js && html5) CanvasPattern #else Dynamic #end;
	private static var bitmapStroke:BitmapData;
	private static var bitmapStrokeMatrix:Matrix;
	private static var strokeScale9Bounds:Scale9GridBounds;
	@SuppressWarnings("checkstyle:Dynamic") private static var windingRule:#if (js && html5) CanvasWindingRule #else Dynamic #end;
	private static var worldAlpha:Float;
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
			var scale9Grid:Rectangle = graphics.__owner.__scale9Grid;
			#if (openfl_legacy_scale9grid && !canvas)
			var hasScale9Grid:Bool = false;
			#else
			var hasScale9Grid = scale9Grid != null && !graphics.__owner.__isMask && graphics.__worldTransform.b == 0 && graphics.__worldTransform.c == 0;
			#end

			if (bitmapStrokeMatrix != null || (hasScale9Grid && strokeScale9Bounds != null && bitmapStroke != null))
			{
				var matrix = Matrix.__pool.get();
				if (bitmapStrokeMatrix != null)
				{
					matrix.copyFrom(bitmapStrokeMatrix);
				}
				else
				{
					matrix.identity();
				}
				if (hasScale9Grid && strokeScale9Bounds != null && bitmapStroke != null)
				{
					var scaleX = strokeScale9Bounds.getScaleX();
					var scaleY = strokeScale9Bounds.getScaleY();
					if (scaleX > 0.0 && scaleY > 0.0)
					{
						matrix.scale(scaleX, scaleY);
					}
				}

				var strokePatternMatrix = new DOMMatrix([matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty]);
				strokePattern.setTransform(cast strokePatternMatrix);

				Matrix.__pool.release(matrix);
			}
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
	private static function createBitmapFill(bitmap:BitmapData, bitmapRepeat:Bool, smooth:Bool):#if (js && html5) CanvasPattern #else Dynamic #end
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

				var scale9Grid:Rectangle = graphics.__owner.__scale9Grid;
				#if (openfl_legacy_scale9grid && !canvas)
				var hasScale9Grid:Bool = false;
				#else
				var hasScale9Grid = scale9Grid != null && !graphics.__owner.__isMask && graphics.__worldTransform.b == 0 && graphics.__worldTransform.c == 0;
				#end
				if (hasScale9Grid)
				{
					point.x = toScale9Position(point.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
					point.y = toScale9Position(point.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
					point2.x = toScale9Position(point2.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
					point2.y = toScale9Position(point2.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
					point3.x = toScale9Position(point3.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
					point3.y = toScale9Position(point3.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
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

				pendingMatrix = null;
				inversePendingMatrix = null;

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

					var scale9Grid:Rectangle = graphics.__owner.__scale9Grid;
					#if (openfl_legacy_scale9grid && !canvas)
					var hasScale9Grid:Bool = false;
					#else
					var hasScale9Grid = scale9Grid != null && !graphics.__owner.__isMask && graphics.__worldTransform.b == 0
						&& graphics.__worldTransform.c == 0;
					#end
					if (hasScale9Grid)
					{
						point.x = toScale9Position(point.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						point.y = toScale9Position(point.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
						point2.x = toScale9Position(point2.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						point2.y = toScale9Position(point2.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
					}

					gradientFill = context.createLinearGradient(point.x, point.y, point2.x, point2.y);

					pendingMatrix = null;
					inversePendingMatrix = null;

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

				pendingMatrix = new Matrix();
				pendingMatrix.tx = matrix.tx - dimensions.width / 2;
				pendingMatrix.ty = matrix.ty - dimensions.height / 2;

				inversePendingMatrix = pendingMatrix.clone();
				inversePendingMatrix.invert();

				var path:Path2D = cast new Path2D();
				path.rect(0, 0, canvas.width, canvas.height);
				path.closePath();
				var gradientMatrix:DOMMatrix = new DOMMatrix([matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty]);
				var inverseMatrix = cast gradientMatrix.inverse();
				var untransformedPath:Path2D = cast new Path2D();
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

	private static function createTempPatternCanvas(bitmap:BitmapData, repeat:Bool, width:Int, height:Int):#if (js && html5) CanvasElement #else Void #end
	{
		// TODO: Don't create extra canvas elements like this

		#if (js && html5)
		var canvas:CanvasElement = cast Browser.document.createElement("canvas");
		var context = canvas.getContext("2d");

		canvas.width = width;
		canvas.height = height;

		context.fillStyle = context.createPattern(bitmap.image.src, repeat ? "repeat" : "no-repeat");
		context.beginPath();
		context.moveTo(0, 0);
		context.lineTo(0, height);
		context.lineTo(width, height);
		context.lineTo(width, 0);
		context.lineTo(0, 0);
		context.closePath();
		if (!hitTesting) context.fill(windingRule);
		return canvas;
		#end
	}

	private static function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>, ?scale9Grid:Rectangle,
			?scale9UnscaledWidth:Float, ?scale9UnscaledHeight:Float, ?scaleX:Float, ?scaleY:Float):Void
	{
		#if (js && html5)
		if (ellipseHeight == null) ellipseHeight = ellipseWidth;

		ellipseWidth *= 0.5;
		ellipseHeight *= 0.5;

		if (ellipseWidth > width / 2) ellipseWidth = width / 2;
		if (ellipseHeight > height / 2) ellipseHeight = height / 2;
		if (scale9Grid != null)
		{
			var scaledLeft = toScale9Position(x, scale9Grid.x, scale9Grid.width, scale9UnscaledWidth, scaleX);
			var scaledTop = toScale9Position(y, scale9Grid.y, scale9Grid.height, scale9UnscaledHeight, scaleY);
			var scaledRight = toScale9Position(x + width, scale9Grid.x, scale9Grid.width, scale9UnscaledWidth, scaleX);
			var scaledBottom = toScale9Position(y + height, scale9Grid.y, scale9Grid.height, scale9UnscaledHeight, scaleY);

			if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
			{
				applyScale9GridUnscaledX(x);
				applyScale9GridUnscaledY(y);
				applyScale9GridUnscaledX(x + width);
				applyScale9GridUnscaledY(y + height);
				applyScale9GridScaledX(scaledLeft);
				applyScale9GridScaledY(scaledTop);
				applyScale9GridScaledX(scaledRight);
				applyScale9GridScaledY(scaledBottom);
			}

			var scaledLeftX = toScale9Position(x + ellipseWidth, scale9Grid.x, scale9Grid.width, scale9UnscaledWidth, scaleX);
			var scaledTopY = toScale9Position(y + ellipseHeight, scale9Grid.y, scale9Grid.height, scale9UnscaledHeight, scaleY);

			var scaledRightX = toScale9Position(x + width - ellipseWidth, scale9Grid.x, scale9Grid.width, scale9UnscaledWidth, scaleX);
			var scaledBottomY = toScale9Position(y + height - ellipseHeight, scale9Grid.y, scale9Grid.height, scale9UnscaledHeight, scaleY);

			context.moveTo(scaledLeftX, scaledTop);
			context.lineTo(scaledRightX, scaledTop);
			context.quadraticCurveTo(scaledRight, scaledTop, scaledRight, scaledTopY);
			context.lineTo(scaledRight, scaledBottomY);
			context.quadraticCurveTo(scaledRight, scaledBottom, scaledRightX, scaledBottom);
			context.lineTo(scaledLeftX, scaledBottom);
			context.quadraticCurveTo(scaledLeft, scaledBottom, scaledLeft, scaledBottomY);
			context.lineTo(scaledLeft, scaledTopY);
			context.quadraticCurveTo(scaledLeft, scaledTop, scaledLeftX, scaledTop);
		}
		else
		{
			var xe = x + width,
				ye = y + height,
				cx1 = -ellipseWidth + (ellipseWidth * SIN45),
				cx2 = -ellipseWidth + (ellipseWidth * TAN22),
				cy1 = -ellipseHeight + (ellipseHeight * SIN45),
				cy2 = -ellipseHeight + (ellipseHeight * TAN22);

			context.moveTo(xe, ye - ellipseHeight);
			context.quadraticCurveTo(xe, ye + cy2, xe + cx1, ye + cy1);
			context.quadraticCurveTo(xe + cx2, ye, xe - ellipseWidth, ye);
			context.lineTo(x + ellipseWidth, ye);
			context.quadraticCurveTo(x - cx2, ye, x - cx1, ye + cy1);
			context.quadraticCurveTo(x, ye + cy2, x, ye - ellipseHeight);
			context.lineTo(x, y + ellipseHeight);
			context.quadraticCurveTo(x, y - cy2, x - cx1, y - cy1);
			context.quadraticCurveTo(x - cx2, y, x + ellipseWidth, y);
			context.lineTo(xe - ellipseWidth, y);
			context.quadraticCurveTo(xe + cx2, y, xe + cx1, y - cy1);
			context.quadraticCurveTo(xe, y - cy2, xe, y + ellipseHeight);
			context.lineTo(xe, ye - ellipseHeight);
		}
		#end
	}

	private static function endFill():Void
	{
		#if (js && html5)
		context.beginPath();
		playCommands(fillCommands, false);
		fillCommands.clear();
		#end
	}

	private static function endStroke():Void
	{
		#if (js && html5)
		context.beginPath();
		playCommands(strokeCommands, true);
		context.closePath();
		strokeCommands.clear();
		#end
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

	private static function applyScale9GridUnscaledX(x:Float):Void
	{
		if (fillScale9Bounds != null && bitmapFill != null)
		{
			fillScale9Bounds.applyUnscaledX(x);
		}
		if (strokeScale9Bounds != null && bitmapStroke != null)
		{
			strokeScale9Bounds.applyUnscaledX(x);
		}
	}

	private static function applyScale9GridUnscaledY(y:Float):Void
	{
		if (fillScale9Bounds != null && bitmapFill != null)
		{
			fillScale9Bounds.applyUnscaledY(y);
		}
		if (strokeScale9Bounds != null && bitmapStroke != null)
		{
			strokeScale9Bounds.applyUnscaledY(y);
		}
	}

	private static function applyScale9GridScaledX(x:Float):Void
	{
		if (fillScale9Bounds != null && bitmapFill != null)
		{
			fillScale9Bounds.applyScaledX(x);
		}
		if (strokeScale9Bounds != null && bitmapStroke != null)
		{
			strokeScale9Bounds.applyScaledX(x);
		}
	}

	private static function applyScale9GridScaledY(y:Float):Void
	{
		if (fillScale9Bounds != null && bitmapFill != null)
		{
			fillScale9Bounds.applyScaledY(y);
		}
		if (strokeScale9Bounds != null && bitmapStroke != null)
		{
			strokeScale9Bounds.applyScaledY(y);
		}
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

			var px = transform.__transformX(x, y);
			var py = transform.__transformY(x, y);

			x = px;
			y = py;

			x -= transform.__transformX(bounds.x, bounds.y);
			y -= transform.__transformY(bounds.x, bounds.y);

			var cacheCanvas = graphics.__canvas;
			var cacheContext = graphics.__context;
			graphics.__canvas = hitTestCanvas;
			graphics.__context = hitTestContext;

			context = graphics.__context;
			context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);

			fillCommands.clear();
			strokeCommands.clear();

			hasFill = false;
			hasStroke = false;
			bitmapFill = null;
			bitmapRepeat = false;

			windingRule = CanvasWindingRule.EVENODD;

			var data = new DrawCommandReader(graphics.__commands);

			for (type in graphics.__commands.types)
			{
				switch (type)
				{
					case CUBIC_CURVE_TO:
						var c = data.readCubicCurveTo();
						fillCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						strokeCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);

					case CURVE_TO:
						var c = data.readCurveTo();
						fillCommands.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
						strokeCommands.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);

					case LINE_TO:
						var c = data.readLineTo();
						fillCommands.lineTo(c.x, c.y);
						strokeCommands.lineTo(c.x, c.y);

					case MOVE_TO:
						var c = data.readMoveTo();
						fillCommands.moveTo(c.x, c.y);
						strokeCommands.moveTo(c.x, c.y);

					case LINE_STYLE:
						endStroke();

						if (hasStroke && (context : Dynamic).isPointInStroke(x, y))
						{
							data.destroy();
							graphics.__canvas = cacheCanvas;
							graphics.__context = cacheContext;
							CanvasGraphics.graphics = null;
							return true;
						}

						var c = data.readLineStyle();
						strokeCommands.lineStyle(c.thickness, c.color, 1, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);

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

						if (hasFill && context.isPointInPath(x, y, windingRule))
						{
							data.destroy();
							graphics.__canvas = cacheCanvas;
							graphics.__context = cacheContext;
							CanvasGraphics.graphics = null;
							return true;
						}

						endStroke();

						if (hasStroke && (context : Dynamic).isPointInStroke(x, y))
						{
							data.destroy();
							graphics.__canvas = cacheCanvas;
							graphics.__context = cacheContext;
							CanvasGraphics.graphics = null;
							return true;
						}

						hasFill = false;
						bitmapFill = null;

					case BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL, BEGIN_SHADER_FILL:
						endFill();

						if (hasFill && context.isPointInPath(x, y, windingRule))
						{
							data.destroy();
							graphics.__canvas = cacheCanvas;
							graphics.__context = cacheContext;
							CanvasGraphics.graphics = null;
							return true;
						}

						endStroke();

						if (hasStroke && (context : Dynamic).isPointInStroke(x, y))
						{
							data.destroy();
							graphics.__canvas = cacheCanvas;
							graphics.__context = cacheContext;
							CanvasGraphics.graphics = null;
							return true;
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

					case DRAW_CIRCLE:
						var c = data.readDrawCircle();
						fillCommands.drawCircle(c.x, c.y, c.radius);
						strokeCommands.drawCircle(c.x, c.y, c.radius);

					case DRAW_ELLIPSE:
						var c = data.readDrawEllipse();
						fillCommands.drawEllipse(c.x, c.y, c.width, c.height);
						strokeCommands.drawEllipse(c.x, c.y, c.width, c.height);

					case DRAW_RECT:
						var c = data.readDrawRect();
						fillCommands.drawRect(c.x, c.y, c.width, c.height);
						strokeCommands.drawRect(c.x, c.y, c.width, c.height);

					case DRAW_ROUND_RECT:
						var c = data.readDrawRoundRect();
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

			var hitTest = false;

			if (fillCommands.length > 0)
			{
				endFill();
			}

			if (hasFill && context.isPointInPath(x, y, windingRule))
			{
				hitTest = true;
			}

			if (strokeCommands.length > 0)
			{
				endStroke();
			}

			if (hasStroke && (context : Dynamic).isPointInStroke(x, y))
			{
				hitTest = true;
			}

			data.destroy();

			graphics.__canvas = cacheCanvas;
			graphics.__context = cacheContext;
			CanvasGraphics.graphics = null;
			return hitTest;
		}
		#end

		return false;
	}

	private static inline function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Bool
	{
		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
	}

	private static function normalizeUVT(uvt:Vector<Float>, skipT:Bool = false):NormalizedUVT
	{
		var max:Float = Math.NEGATIVE_INFINITY;
		var tmp = Math.NEGATIVE_INFINITY;
		var len = uvt.length;

		for (t in 1...len + 1)
		{
			if (skipT && t % 3 == 0)
			{
				continue;
			}

			tmp = uvt[t - 1];

			if (max < tmp)
			{
				max = tmp;
			}
		}

		if (!skipT)
		{
			return {max: max, uvt: uvt};
		}

		var result = new Vector<Float>();

		for (t in 1...len + 1)
		{
			if (skipT && t % 3 == 0)
			{
				continue;
			}

			result.push(uvt[t - 1]);
		}

		return {max: max, uvt: result};
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

		var hasPath:Bool = false;

		var scale9Grid:Rectangle = graphics.__owner.__scale9Grid;
		#if (openfl_legacy_scale9grid && !canvas)
		var hasScale9Grid:Bool = false;
		#else
		var hasScale9Grid = scale9Grid != null && !graphics.__owner.__isMask && graphics.__worldTransform.b == 0 && graphics.__worldTransform.c == 0;
		#end
		if (!hasScale9Grid)
		{
			scale9Grid = null;
			if (fillScale9Bounds != null)
			{
				fillScale9Bounds.clear();
			}
			if (strokeScale9Bounds != null)
			{
				strokeScale9Bounds.clear();
			}
		}

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
		var stl:Point = null;
		var sbr:Point = null;

		for (type in commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					hasPath = true;

					if (hasScale9Grid)
					{
						var scaledControlX1 = toScale9Position(c.controlX1, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledControlY1 = toScale9Position(c.controlY1, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
						var scaledControlX2 = toScale9Position(c.controlX2, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledControlY2 = toScale9Position(c.controlY2, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
						var scaledAnchorX = toScale9Position(c.anchorX, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledAnchorY = toScale9Position(c.anchorY, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);

						if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
						{
							applyScale9GridUnscaledX(c.anchorX);
							applyScale9GridUnscaledY(c.anchorY);
							applyScale9GridScaledX(scaledAnchorX);
							applyScale9GridScaledY(scaledAnchorY);
						}

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

					if (hasScale9Grid)
					{
						var scaledControlX = toScale9Position(c.controlX, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledControlY = toScale9Position(c.controlY, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
						var scaledAnchorX = toScale9Position(c.anchorX, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledAnchorY = toScale9Position(c.anchorY, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);

						if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
						{
							applyScale9GridUnscaledX(c.anchorX);
							applyScale9GridUnscaledY(c.anchorY);
							applyScale9GridScaledX(scaledAnchorX);
							applyScale9GridScaledY(scaledAnchorY);
						}

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

					if (hasScale9Grid)
					{
						var scaledLeft = toScale9Position(c.x - c.radius, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledTop = toScale9Position(c.y - c.radius, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
						var scaledRight = toScale9Position(c.x + c.radius, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledBottom = toScale9Position(c.y + c.radius, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);

						if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
						{
							applyScale9GridUnscaledX(c.x - c.radius);
							applyScale9GridUnscaledY(c.y - c.radius);
							applyScale9GridUnscaledX(c.x + c.radius);
							applyScale9GridUnscaledY(c.y + c.radius);
							applyScale9GridScaledX(scaledLeft);
							applyScale9GridScaledY(scaledTop);
							applyScale9GridScaledX(scaledRight);
							applyScale9GridScaledY(scaledBottom);
						}

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

					if (hasScale9Grid)
					{
						// TODO: this is not how Flash behaves!
						// Flash seems to use multiple curves instead
						var scaledLeft = toScale9Position(c.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledTop = toScale9Position(c.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
						var scaledRight = toScale9Position(c.x + c.width, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledBottom = toScale9Position(c.y + c.height, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);

						if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
						{
							applyScale9GridUnscaledX(c.x);
							applyScale9GridUnscaledY(c.y);
							applyScale9GridUnscaledX(c.x + c.width);
							applyScale9GridUnscaledY(c.y + c.height);
							applyScale9GridScaledX(scaledLeft);
							applyScale9GridScaledY(scaledTop);
							applyScale9GridScaledX(scaledRight);
							applyScale9GridScaledY(scaledBottom);
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
					drawRoundRect(c.x - offsetX, c.y - offsetY, c.width, c.height, c.ellipseWidth, c.ellipseHeight, scale9Grid, bounds.width, bounds.height,
						graphics.__owner.scaleX, graphics.__owner.scaleY);

				case LINE_TO:
					var c = data.readLineTo();
					hasPath = true;

					if (hasScale9Grid)
					{
						var scaledX = toScale9Position(c.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledY = toScale9Position(c.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);

						if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
						{
							applyScale9GridUnscaledX(c.x);
							applyScale9GridUnscaledY(c.y);
							applyScale9GridScaledX(scaledX);
							applyScale9GridScaledY(scaledY);
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

					if (hasScale9Grid)
					{
						var scaledX = toScale9Position(c.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
						var scaledY = toScale9Position(c.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);

						if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
						{
							applyScale9GridUnscaledX(c.x);
							applyScale9GridUnscaledY(c.y);
							applyScale9GridScaledX(scaledX);
							applyScale9GridScaledY(scaledY);
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
						strokePattern = createBitmapFill(c.bitmap, c.repeat, c.smooth);
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

					if (strokeScale9Bounds != null)
					{
						strokeScale9Bounds.clear();
					}
					else if (hasScale9Grid && bitmapStroke != null)
					{
						strokeScale9Bounds = new Scale9GridBounds();
					}

					hasStroke = true;

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					if (c.bitmap.readable)
					{
						context.fillStyle = createBitmapFill(c.bitmap, c.repeat, c.smooth);
						bitmapFill = c.bitmap;
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						context.fillStyle = "#" + StringTools.hex(0, 6);
						bitmapFill = null;
					}

					bitmapRepeat = c.repeat;

					hasFill = true;

					if (fillScale9Bounds != null)
					{
						fillScale9Bounds.clear();
					}
					else if (hasScale9Grid && bitmapFill != null)
					{
						fillScale9Bounds = new Scale9GridBounds();
					}

					if (c.matrix != null)
					{
						pendingMatrix = c.matrix;
						inversePendingMatrix = c.matrix.clone();
						inversePendingMatrix.invert();
					}
					else
					{
						pendingMatrix = null;
						inversePendingMatrix = null;
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

					if (fillScale9Bounds != null)
					{
						fillScale9Bounds.clear();
					}

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();
					context.fillStyle = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);

					hasFill = true;
					bitmapFill = null;
					setSmoothing(true);

					if (fillScale9Bounds != null)
					{
						fillScale9Bounds.clear();
					}

				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					var shaderBuffer = c.shaderBuffer;

					if (shaderBuffer.inputCount > 0)
					{
						bitmapFill = shaderBuffer.inputs[0];
						if (bitmapFill.readable)
						{
							context.fillStyle = createBitmapFill(bitmapFill, shaderBuffer.inputWrap[0] != CLAMP, shaderBuffer.inputFilter[0] != NEAREST);
						}
						else
						{
							// if it's hardware-only BitmapData, fall back to
							// drawing solid black because we have no software
							// pixels to work with
							context.fillStyle = "#" + StringTools.hex(0, 6);
						}
						hasFill = true;

						pendingMatrix = null;
						inversePendingMatrix = null;
					}

					if (fillScale9Bounds != null)
					{
						fillScale9Bounds.clear();
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
					var c = data.readDrawTriangles();
					var v = c.vertices;
					var ind = c.indices;
					var uvt = c.uvtData;
					var pattern:CanvasElement = null;
					var colorFill = bitmapFill == null;

					if (colorFill && uvt != null)
					{
						break;
					}

					if (!colorFill && uvt != null)
					{
						var skipT = uvt.length != v.length;
						var normalizedUVT = normalizeUVT(uvt, skipT);
						var maxUVT = normalizedUVT.max;
						uvt = normalizedUVT.uvt;

						if (maxUVT > 1)
						{
							pattern = createTempPatternCanvas(bitmapFill, bitmapRepeat, Std.int(bounds.width), Std.int(bounds.height));
						}
						else
						{
							pattern = createTempPatternCanvas(bitmapFill, bitmapRepeat, bitmapFill.width, bitmapFill.height);
						}
					}

					var i = 0;
					var l = ind.length;

					var a_:Int, b_:Int, c_:Int;
					var iax:Int, iay:Int, ibx:Int, iby:Int, icx:Int, icy:Int;
					var x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float;
					var uvx1:Float, uvy1:Float, uvx2:Float, uvy2:Float, uvx3:Float, uvy3:Float;
					var denom:Float;
					var t1:Float, t2:Float, t3:Float, t4:Float;
					var dx:Float, dy:Float;

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

						if (hasScale9Grid)
						{
							var scaledX1 = toScale9Position(v[iax], scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
							var scaledY1 = toScale9Position(v[iay], scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
							var scaledX2 = toScale9Position(v[ibx], scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
							var scaledY2 = toScale9Position(v[iby], scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
							var scaledX3 = toScale9Position(v[icx], scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
							var scaledY3 = toScale9Position(v[icy], scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);

							if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
							{
								applyScale9GridUnscaledX(v[iax]);
								applyScale9GridUnscaledY(v[iay]);
								applyScale9GridUnscaledX(v[ibx]);
								applyScale9GridUnscaledY(v[iby]);
								applyScale9GridUnscaledX(v[icx]);
								applyScale9GridUnscaledY(v[icy]);
								applyScale9GridScaledX(scaledX1);
								applyScale9GridScaledY(scaledY1);
								applyScale9GridScaledX(scaledX2);
								applyScale9GridScaledY(scaledY2);
								applyScale9GridScaledX(scaledX3);
								applyScale9GridScaledY(scaledY3);
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

						if (colorFill || uvt == null)
						{
							context.beginPath();
							context.moveTo(x1, y1);
							context.lineTo(x2, y2);
							context.lineTo(x3, y3);
							context.closePath();

							var inverseTranslateX = 0.0;
							var inverseTranslateY = 0.0;
							var inverseScaleX = 1.0;
							var inverseScaleY = 1.0;
							if (!hitTesting && hasScale9Grid && fillScale9Bounds != null && bitmapFill != null)
							{
								var scaleX = fillScale9Bounds.getScaleX();
								var scaleY = fillScale9Bounds.getScaleY();

								if (scaleX > 0.0 && scaleY > 0.0)
								{
									context.scale(scaleX, scaleY);
									inverseScaleX = 1.0 / scaleX;
									inverseScaleY = 1.0 / scaleY;

									var remX = fillScale9Bounds.unscaledMinX % bitmapFill.width;
									var remY = fillScale9Bounds.unscaledMinY % bitmapFill.height;

									var adjustedRemX = (fillScale9Bounds.scale9MinX % (bitmapFill.width * scaleX)) / scaleX;
									var adjustedRemY = (fillScale9Bounds.scale9MinY % (bitmapFill.height * scaleY)) / scaleY;

									var translateX = adjustedRemX - remX;
									var translateY = adjustedRemY - remY;
									context.translate(translateX, translateY);
									inverseTranslateX = -translateX;
									inverseTranslateY = -translateY;
								}
							}

							if (!hitTesting) context.fill(windingRule);

							if (!hitTesting && hasScale9Grid && fillScale9Bounds != null && bitmapFill != null)
							{
								context.translate(inverseTranslateX, inverseTranslateY);
								context.scale(inverseScaleX, inverseScaleY);
							}

							i += 3;
							continue;
						}

						uvx1 = uvt[iax] * pattern.width;
						uvx2 = uvt[ibx] * pattern.width;
						uvx3 = uvt[icx] * pattern.width;
						uvy1 = uvt[iay] * pattern.height;
						uvy2 = uvt[iby] * pattern.height;
						uvy3 = uvt[icy] * pattern.height;

						denom = uvx1 * (uvy3 - uvy2) - uvx2 * uvy3 + uvx3 * uvy2 + (uvx2 - uvx3) * uvy1;

						if (denom == 0)
						{
							i += 3;
							context.restore();
							continue;
						}

						context.save();
						context.beginPath();
						context.moveTo(x1, y1);
						context.lineTo(x2, y2);
						context.lineTo(x3, y3);
						context.closePath();
						context.clip();

						t1 = -(uvy1 * (x3 - x2) - uvy2 * x3 + uvy3 * x2 + (uvy2 - uvy3) * x1) / denom;
						t2 = (uvy2 * y3 + uvy1 * (y2 - y3) - uvy3 * y2 + (uvy3 - uvy2) * y1) / denom;
						t3 = (uvx1 * (x3 - x2) - uvx2 * x3 + uvx3 * x2 + (uvx2 - uvx3) * x1) / denom;
						t4 = -(uvx2 * y3 + uvx1 * (y2 - y3) - uvx3 * y2 + (uvx3 - uvx2) * y1) / denom;
						dx = (uvx1 * (uvy3 * x2 - uvy2 * x3) + uvy1 * (uvx2 * x3 - uvx3 * x2) + (uvx3 * uvy2 - uvx2 * uvy3) * x1) / denom;
						dy = (uvx1 * (uvy3 * y2 - uvy2 * y3) + uvy1 * (uvx2 * y3 - uvx3 * y2) + (uvx3 * uvy2 - uvx2 * uvy3) * y1) / denom;

						context.transform(t1, t2, t3, t4, dx, dy);
						context.drawImage(pattern, 0, 0, pattern.width, pattern.height);
						context.restore();

						i += 3;
					}

				case DRAW_RECT:
					var c = data.readDrawRect();
					optimizationUsed = false;

					if (bitmapFill != null && bitmapFill.readable && !hitTesting && !hasScale9Grid)
					{
						st = 0;
						sr = 0;
						sb = 0;
						sl = 0;

						canOptimizeMatrix = true;

						if (pendingMatrix != null)
						{
							if (pendingMatrix.b != 0 || pendingMatrix.c != 0)
							{
								canOptimizeMatrix = false;
							}
							else
							{
								if (stl == null) stl = Point.__pool.get();
								if (sbr == null) sbr = Point.__pool.get();

								stl.setTo(c.x, c.y);
								inversePendingMatrix.__transformPoint(stl);

								sbr.setTo(c.x + c.width, c.y + c.height);
								inversePendingMatrix.__transformPoint(sbr);

								st = stl.y;
								sl = stl.x;
								sb = sbr.y;
								sr = sbr.x;
							}
						}
						else
						{
							st = c.y;
							sl = c.x;
							sb = c.y + c.height;
							sr = c.x + c.width;
						}

						if (canOptimizeMatrix && st >= 0 && sl >= 0 && sr <= bitmapFill.width && sb <= bitmapFill.height)
						{
							optimizationUsed = true;
							if (!hitTesting)
							{
								context.drawImage(bitmapFill.image.src, sl, st, sr - sl, sb - st, c.x - offsetX, c.y - offsetY, c.width, c.height);
							}
						}
					}

					if (!optimizationUsed)
					{
						hasPath = true;
						if (hasScale9Grid)
						{
							var scaledLeft = toScale9Position(c.x, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
							var scaledTop = toScale9Position(c.y, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);
							var scaledRight = toScale9Position(c.x + c.width, scale9Grid.x, scale9Grid.width, bounds.width, graphics.__owner.scaleX);
							var scaledBottom = toScale9Position(c.y + c.height, scale9Grid.y, scale9Grid.height, bounds.height, graphics.__owner.scaleY);

							if ((fillScale9Bounds != null && bitmapFill != null) || (strokeScale9Bounds != null && bitmapStroke != null))
							{
								applyScale9GridUnscaledX(c.x);
								applyScale9GridUnscaledY(c.y);
								applyScale9GridUnscaledX(c.x + c.width);
								applyScale9GridUnscaledY(c.y + c.height);
								applyScale9GridScaledX(scaledLeft);
								applyScale9GridScaledY(scaledTop);
								applyScale9GridScaledX(scaledRight);
								applyScale9GridScaledY(scaledBottom);
							}

							var scaledWidth = scaledRight - scaledLeft;
							var scaledHeight = scaledBottom - scaledTop;
							if (scaledWidth != 0.0 || scaledHeight != 0.0)
							{
								// flash doesn't draw the rectangle if both the width
								// and height are zero
								context.rect(scaledLeft - offsetX, scaledTop - offsetY, scaledWidth, scaledHeight);
							}
						}
						else if (c.width != 0.0 || c.height != 0.0)
						{
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

		if (stl != null) Point.__pool.release(stl);
		if (sbr != null) Point.__pool.release(sbr);

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

				if (!hitTesting
					&& strokePattern != null
					&& (bitmapStrokeMatrix != null || (hasScale9Grid && strokeScale9Bounds != null && bitmapStroke != null)))
				{
					var matrix = Matrix.__pool.get();
					if (bitmapStrokeMatrix != null)
					{
						matrix.copyFrom(bitmapStrokeMatrix);
					}
					else
					{
						matrix.identity();
					}
					if (hasScale9Grid && strokeScale9Bounds != null && bitmapStroke != null)
					{
						var scaleX = strokeScale9Bounds.getScaleX();
						var scaleY = strokeScale9Bounds.getScaleY();
						if (scaleX > 0.0 && scaleY > 0.0)
						{
							matrix.scale(scaleX, scaleY);
						}
					}

					var strokePatternMatrix = new DOMMatrix([matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty]);
					strokePattern.setTransform(cast strokePatternMatrix);

					Matrix.__pool.release(matrix);
				}

				if (!hitTesting) context.stroke();
			}

			if (!stroke)
			{
				if (hasFill || bitmapFill != null)
				{
					context.translate(-bounds.x, -bounds.y);

					var inverseTranslateX = 0.0;
					var inverseTranslateY = 0.0;
					var inverseScaleX = 1.0;
					var inverseScaleY = 1.0;
					if (!hitTesting && hasScale9Grid && fillScale9Bounds != null && bitmapFill != null)
					{
						var scaleX = fillScale9Bounds.getScaleX();
						var scaleY = fillScale9Bounds.getScaleY();

						if (scaleX > 0.0 && scaleY > 0.0)
						{
							context.scale(scaleX, scaleY);
							inverseScaleX = 1.0 / scaleX;
							inverseScaleY = 1.0 / scaleY;

							var remX = fillScale9Bounds.unscaledMinX % bitmapFill.width;
							var remY = fillScale9Bounds.unscaledMinY % bitmapFill.height;

							var adjustedRemX = (fillScale9Bounds.scale9MinX % (bitmapFill.width * scaleX)) / scaleX;
							var adjustedRemY = (fillScale9Bounds.scale9MinY % (bitmapFill.height * scaleY)) / scaleY;

							var translateX = adjustedRemX - remX;
							var translateY = adjustedRemY - remY;
							context.translate(translateX, translateY);
							inverseTranslateX = -translateX;
							inverseTranslateY = -translateY;
						}
					}

					if (pendingMatrix != null)
					{
						context.transform(pendingMatrix.a, pendingMatrix.b, pendingMatrix.c, pendingMatrix.d, pendingMatrix.tx, pendingMatrix.ty);
						if (!hitTesting) context.fill(windingRule);
						context.transform(inversePendingMatrix.a, inversePendingMatrix.b, inversePendingMatrix.c, inversePendingMatrix.d,
							inversePendingMatrix.tx, inversePendingMatrix.ty);
					}
					else
					{
						if (!hitTesting) context.fill(windingRule);
					}

					if (!hitTesting && hasScale9Grid && fillScale9Bounds != null && bitmapFill != null)
					{
						context.translate(inverseTranslateX, inverseTranslateY);
						context.scale(inverseScaleX, inverseScaleY);
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

		var scale9Grid:Rectangle = graphics.__owner.__scale9Grid;
		#if (openfl_legacy_scale9grid && !canvas)
		var hasScale9Grid:Bool = false;
		#else
		var hasScale9Grid = scale9Grid != null && !graphics.__owner.__isMask && graphics.__worldTransform.b == 0 && graphics.__worldTransform.c == 0;
		#end
		if (hasScale9Grid)
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

				fillCommands.clear();
				strokeCommands.clear();

				hasFill = false;
				hasStroke = false;
				bitmapFill = null;
				bitmapRepeat = false;

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

				if (fillCommands.length > 0)
				{
					endFill();
				}

				if (strokeCommands.length > 0)
				{
					endStroke();
				}

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
}

private typedef NormalizedUVT =
{
	max:Float,
	uvt:Vector<Float>
}

private class Scale9GridBounds
{
	public var scale9MinX(default, null):Null<Float> = null;
	public var scale9MinY(default, null):Null<Float> = null;

	private var scale9MaxX:Null<Float> = null;
	private var scale9MaxY:Null<Float> = null;

	public var unscaledMinX(default, null):Null<Float> = null;
	public var unscaledMinY(default, null):Null<Float> = null;

	private var unscaledMaxX:Null<Float> = null;
	private var unscaledMaxY:Null<Float> = null;

	public function new() {}

	public function getScaleX():Float
	{
		if (scale9MaxX == null || unscaledMaxX == null)
		{
			return 1.0;
		}
		var unscaledWidth = unscaledMaxX - unscaledMinX;
		if (unscaledWidth == 0.0)
		{
			return 1.0;
		}
		return (scale9MaxX - scale9MinX) / unscaledWidth;
	}

	public function getScaleY():Float
	{
		if (scale9MaxY == null || unscaledMaxY == null)
		{
			return 1.0;
		}
		var unscaledHeight = unscaledMaxY - unscaledMinY;
		if (unscaledHeight == 0.0)
		{
			return 1.0;
		}
		return (scale9MaxY - scale9MinY) / unscaledHeight;
	}

	public function clear():Void
	{
		unscaledMinX = null;
		unscaledMaxX = null;
		unscaledMinY = null;
		unscaledMaxY = null;
		scale9MinX = null;
		scale9MaxX = null;
		scale9MinY = null;
		scale9MaxY = null;
	}

	public function applyUnscaledX(value:Float):Void
	{
		if (unscaledMinX == null || unscaledMinX > value)
		{
			unscaledMinX = value;
		}
		if (unscaledMaxX == null || unscaledMaxX < value)
		{
			unscaledMaxX = value;
		}
	}

	public function applyUnscaledY(value:Float):Void
	{
		if (unscaledMinY == null || unscaledMinY > value)
		{
			unscaledMinY = value;
		}
		if (unscaledMaxY == null || unscaledMaxY < value)
		{
			unscaledMaxY = value;
		}
	}

	public function applyScaledX(value:Float):Void
	{
		if (scale9MinX == null || scale9MinX > value)
		{
			scale9MinX = value;
		}
		if (scale9MaxX == null || scale9MaxX < value)
		{
			scale9MaxX = value;
		}
	}

	public function applyScaledY(value:Float):Void
	{
		if (scale9MinY == null || scale9MinY > value)
		{
			scale9MinY = value;
		}
		if (scale9MaxY == null || scale9MaxY < value)
		{
			scale9MaxY = value;
		}
	}
}
#end
