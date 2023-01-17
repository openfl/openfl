package openfl.display._internal;

import openfl.display.BitmapData;
import openfl.display.CanvasRenderer;
import openfl.display.CapsStyle;
import openfl.display._internal.DrawCommandBuffer;
import openfl.display._internal.DrawCommandReader;
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
import js.html.CanvasPattern;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasWindingRule;
import js.Browser;
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
	private static var bitmapFill:BitmapData;
	private static var bitmapStroke:BitmapData;
	private static var bitmapRepeat:Bool;
	private static var bounds:Rectangle;
	private static var fillCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var graphics:Graphics;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var hitTesting:Bool;
	private static var inversePendingMatrix:Matrix;
	private static var pendingMatrix:Matrix;
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
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
		return context.createPattern(bitmap.image.src, bitmapRepeat ? "repeat" : "no-repeat");
		#else
		return null;
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private static function createGradientPattern(type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix,
			spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float):#if (js && html5) CanvasPattern #else Void #end
	{
		#if (js && html5)
		var gradientFill = null,
			point = null,
			point2 = null,
			releaseMatrix = false;

		if (matrix == null)
		{
			matrix = Matrix.__pool.get();
			matrix.identity();
			releaseMatrix = true;
		}

		switch (type)
		{
			case RADIAL:
				var radius = 819.2;
				focalPointRatio = focalPointRatio > 1.0 ? 1.0 : focalPointRatio < -1.0 ? -1.0 : focalPointRatio;
				gradientFill = context.createRadialGradient(radius * focalPointRatio, 0, 0, 0, 0, radius);

				pendingMatrix = matrix.clone();
				inversePendingMatrix = matrix.clone();
				inversePendingMatrix.invert();

			case LINEAR:
				gradientFill = context.createLinearGradient(-819.2, 0, 819.2, 0);

				pendingMatrix = matrix.clone();
				inversePendingMatrix = matrix.clone();
				inversePendingMatrix.invert();
		}

		var rgb, alpha, r, g, b, ratio;

		for (i in 0...colors.length)
		{
			rgb = colors[i];
			alpha = alphas[i];
			r = (rgb & 0xFF0000) >>> 16;
			g = (rgb & 0x00FF00) >>> 8;
			b = (rgb & 0x0000FF);

			ratio = ratios[i] / 0xFF;
			if (ratio < 0) ratio = 0;
			if (ratio > 1) ratio = 1;

			gradientFill.addColorStop(ratio, "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")");
		}

		if (point != null) Point.__pool.release(point);
		if (point2 != null) Point.__pool.release(point2);
		if (releaseMatrix) Matrix.__pool.release(matrix);

		return cast(gradientFill);
		#end
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

	private static function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void
	{
		#if (js && html5)
		if (ellipseHeight == null) ellipseHeight = ellipseWidth;

		ellipseWidth *= 0.5;
		ellipseHeight *= 0.5;

		if (ellipseWidth > width / 2) ellipseWidth = width / 2;
		if (ellipseHeight > height / 2) ellipseHeight = height / 2;

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

	public static function hitTest(graphics:Graphics, x:Float, y:Float):Bool
	{
		#if (js && html5)
		bounds = graphics.__bounds;
		CanvasGraphics.graphics = graphics;

		if (graphics.__commands.length == 0 || bounds == null || bounds.width <= 0 || bounds.height <= 0)
		{
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

					case LINE_GRADIENT_STYLE:
						var c = data.readLineGradientStyle();
						strokeCommands.lineGradientStyle(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
							c.focalPointRatio);

					case LINE_BITMAP_STYLE:
						var c = data.readLineBitmapStyle();
						strokeCommands.lineBitmapStyle(c.bitmap, c.matrix, c.repeat, c.smooth);

					case LINE_STYLE:
						var c = data.readLineStyle();
						strokeCommands.lineStyle(c.thickness, c.color, 1, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);

					case END_FILL:
						data.readEndFill();
						endFill();

						if (hasFill && context.isPointInPath(x, y, windingRule))
						{
							data.destroy();
							graphics.__canvas = cacheCanvas;
							graphics.__context = cacheContext;
							return true;
						}

						endStroke();

						if (hasStroke && (context : Dynamic).isPointInStroke(x, y))
						{
							data.destroy();
							graphics.__canvas = cacheCanvas;
							graphics.__context = cacheContext;
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
							return true;
						}

						endStroke();

						if (hasStroke && (context : Dynamic).isPointInStroke(x, y))
						{
							data.destroy();
							graphics.__canvas = cacheCanvas;
							graphics.__context = cacheContext;
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

		var data = new DrawCommandReader(commands);

		var x,
			y,
			width,
			height,
			kappa = .5522848,
			ox,
			oy,
			xe,
			ye,
			xm,
			ym,
			r,
			g,
			b;
		var optimizationUsed,
			canOptimizeMatrix,
			st:Float,
			sr:Float,
			sb:Float,
			sl:Float,
			stl = null,
			sbr = null;

		for (type in commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					hasPath = true;
					context.bezierCurveTo(c.controlX1
						- offsetX, c.controlY1
						- offsetY, c.controlX2
						- offsetX, c.controlY2
						- offsetY, c.anchorX
						- offsetX,
						c.anchorY
						- offsetY);

				case CURVE_TO:
					var c = data.readCurveTo();
					hasPath = true;
					context.quadraticCurveTo(c.controlX - offsetX, c.controlY - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					hasPath = true;
					context.moveTo(c.x - offsetX + c.radius, c.y - offsetY);
					context.arc(c.x - offsetX, c.y - offsetY, c.radius, 0, Math.PI * 2, true);

				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					hasPath = true;
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

					context.moveTo(x, ym);
					context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
					context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
					context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
					context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);

				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					hasPath = true;
					drawRoundRect(c.x - offsetX, c.y - offsetY, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

				case LINE_TO:
					var c = data.readLineTo();
					hasPath = true;
					context.lineTo(c.x - offsetX, c.y - offsetY);

					positionX = c.x;
					positionY = c.y;

					if (positionX == startX && positionY == startY)
					{
						closeGap = true;
					}

				case MOVE_TO:
					var c = data.readMoveTo();
					context.moveTo(c.x - offsetX, c.y - offsetY);

					positionX = c.x;
					positionY = c.y;

					if (setStart && c.x != startX && c.y != startY)
					{
						closeGap = true;
					}

					startX = c.x;
					startY = c.y;
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
						hasStroke = true;
					}

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();
					if (stroke && hasStroke)
					{
						closePath(true);
					}

					context.moveTo(positionX - offsetX, positionY - offsetY);
					context.strokeStyle = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);

					setSmoothing(true);
					hasStroke = true;

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();
					if (stroke && hasStroke)
					{
						closePath(true);
					}

					context.moveTo(positionX - offsetX, positionY - offsetY);
					context.strokeStyle = createBitmapFill(c.bitmap, c.repeat, c.smooth);

					hasStroke = true;

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					bitmapFill = c.bitmap;
					context.fillStyle = createBitmapFill(c.bitmap, c.repeat, c.smooth);
					hasFill = true;

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

						bitmapFill = null;
						setSmoothing(true);
						hasFill = true;
					}

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();
					context.fillStyle = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);

					bitmapFill = null;
					setSmoothing(true);
					hasFill = true;

				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					var shaderBuffer = c.shaderBuffer;

					if (shaderBuffer.inputCount > 0)
					{
						bitmapFill = shaderBuffer.inputs[0];
						context.fillStyle = createBitmapFill(bitmapFill, shaderBuffer.inputWrap[0] != CLAMP, shaderBuffer.inputFilter[0] != NEAREST);
						hasFill = true;

						pendingMatrix = null;
						inversePendingMatrix = null;
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

					var ri, ti;

					context.save(); // TODO: Restore transform without save/restore

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

						if (bitmapFill != null)
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

					if (!colorFill)
					{
						// TODO move this to Graphics?

						if (uvt == null)
						{
							uvt = new Vector<Float>();

							for (i in 0...(Std.int(v.length / 2)))
							{
								uvt.push(v[i * 2] - offsetX / bitmapFill.width);
								uvt.push(v[i * 2 + 1] - offsetY / bitmapFill.height);
							}
						}

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

						x1 = v[iax] - offsetX;
						y1 = v[iay] - offsetY;
						x2 = v[ibx] - offsetX;
						y2 = v[iby] - offsetY;
						x3 = v[icx] - offsetX;
						y3 = v[icy] - offsetY;

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

						if (colorFill)
						{
							context.beginPath();
							context.moveTo(x1, y1);
							context.lineTo(x2, y2);
							context.lineTo(x3, y3);
							context.closePath();
							if (!hitTesting) context.fill(windingRule);
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

					if (bitmapFill != null && !hitTesting)
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
							if (!hitTesting) context.drawImage(bitmapFill.image.src, sl, st, sr - sl, sb - st, c.x - offsetX, c.y - offsetY, c.width,
								c.height);
						}
					}

					if (!optimizationUsed)
					{
						hasPath = true;
						context.rect(c.x - offsetX, c.y - offsetY, c.width, c.height);
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

				if (!hitTesting) context.stroke();
			}

			if (!stroke)
			{
				if (hasFill || bitmapFill != null)
				{
					context.translate(-bounds.x, -bounds.y);

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
							hasLineStyle = false;
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
				graphics.__bitmap = BitmapData.fromCanvas(graphics.__canvas);
			}

			graphics.__softwareDirty = false;
			graphics.__dirty = false;
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

			var x, y, width, height, kappa = .5522848, ox, oy, xe, ye, xm, ym;

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
