package openfl.display._internal;

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
	private static var SIN45:Float = 0.70710678118654752440084436210485;
	private static var TAN22:Float = 0.4142135623730950488016887242097;
	private static var allowSmoothing:Bool;
	private static var bitmapFill:BitmapData;
	private static var bitmapRepeat:Bool;
	private static var bounds:Rectangle;
	private static var cairo:Cairo;
	private static var fillCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var fillPattern:CairoPattern;
	private static var fillPatternMatrix:Matrix;
	private static var graphics:Graphics;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var hitTesting:Bool;
	private static var inversePendingMatrix:Matrix;
	private static var pendingMatrix:Matrix;
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var strokePattern:CairoPattern;
	private static var tempMatrix3 = new Matrix3();
	private static var worldAlpha:Float;

	private static function closePath(strokeBefore:Bool = false):Void
	{
		if (strokePattern == null)
		{
			return;
		}

		if (!strokeBefore)
		{
			cairo.closePath();
		}

		cairo.source = strokePattern;
		if (!hitTesting) cairo.strokePreserve();

		if (strokeBefore)
		{
			cairo.closePath();
		}

		cairo.newPath();
	}

	private static function createGradientPattern(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix,
			spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float):CairoPattern
	{
		var pattern:CairoPattern = null,
			point:Point = null,
			point2:Point = null,
			releaseMatrix = false;

		if (matrix == null)
		{
			matrix = Matrix.__pool.get();
			releaseMatrix = true;
		}

		switch (type)
		{
			case RADIAL:
				point = Point.__pool.get();
				point.setTo(1638.4, 0);
				matrix.__transformPoint(point);

				var x = matrix.tx + graphics.__bounds.x;
				var y = matrix.ty + graphics.__bounds.y;

				pattern = CairoPattern.createRadial(x, y, 0, x, y, Math.abs((point.x - matrix.tx) / 2));

			case LINEAR:
				point = Point.__pool.get();
				point.setTo(-819.2, 0);
				matrix.__transformPoint(point);

				point2 = Point.__pool.get();
				point2.setTo(819.2, 0);
				matrix.__transformPoint(point2);

				point.x += graphics.__bounds.x;
				point2.x += graphics.__bounds.x;
				point.y += graphics.__bounds.y;
				point2.y += graphics.__bounds.y;

				pattern = CairoPattern.createLinear(point.x, point.y, point2.x, point2.y);
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
			if (ratio > 1) ratio = 1;

			pattern.addColorStopRGBA(ratio, r, g, b, alpha);
		}

		if (point != null) Point.__pool.release(point);
		if (point2 != null) Point.__pool.release(point2);
		if (releaseMatrix) Matrix.__pool.release(matrix);

		var mat = pattern.matrix;

		mat.tx = bounds.x;
		mat.ty = bounds.y;

		pattern.matrix = mat;

		return pattern;
	}

	private static function createImagePattern(bitmapFill:BitmapData, matrix:Matrix, bitmapRepeat:Bool, smooth:Bool):CairoPattern
	{
		var pattern = CairoPattern.createForSurface(bitmapFill.getSurface());
		pattern.filter = (smooth && allowSmoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;

		if (bitmapRepeat)
		{
			pattern.extend = CairoExtend.REPEAT;
		}

		fillPatternMatrix = matrix;

		return pattern;
	}

	private static function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void
	{
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

		cairo.moveTo(xe, ye - ellipseHeight);
		quadraticCurveTo(xe, ye + cy2, xe + cx1, ye + cy1);
		quadraticCurveTo(xe + cx2, ye, xe - ellipseWidth, ye);
		cairo.lineTo(x + ellipseWidth, ye);
		quadraticCurveTo(x - cx2, ye, x - cx1, ye + cy1);
		quadraticCurveTo(x, ye + cy2, x, ye - ellipseHeight);
		cairo.lineTo(x, y + ellipseHeight);
		quadraticCurveTo(x, y - cy2, x - cx1, y - cy1);
		quadraticCurveTo(x - cx2, y, x + ellipseWidth, y);
		cairo.lineTo(xe - ellipseWidth, y);
		quadraticCurveTo(xe + cx2, y, xe + cx1, y - cy1);
		quadraticCurveTo(xe, y - cy2, xe, y + ellipseHeight);
		cairo.lineTo(xe, ye - ellipseHeight);
	}

	private static function endFill():Void
	{
		cairo.newPath();
		playCommands(fillCommands, false);
		fillCommands.clear();
	}

	private static function endStroke():Void
	{
		cairo.newPath();
		playCommands(strokeCommands, true);
		cairo.closePath();
		strokeCommands.clear();
	}
	#end

	public static function hitTest(graphics:Graphics, x:Float, y:Float):Bool
	{
		#if lime_cairo
		CairoGraphics.graphics = graphics;
		bounds = graphics.__bounds;

		if (graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0 || !bounds.contains(x, y))
		{
			return false;
		}
		else
		{
			hitTesting = true;

			x -= bounds.x;
			y -= bounds.y;

			if (graphics.__cairo == null)
			{
				var bitmap = new BitmapData(Math.floor(Math.max(1, bounds.width)), Math.floor(Math.max(1, bounds.height)), true, 0);
				var surface = bitmap.getSurface();
				graphics.__cairo = new Cairo(surface);
				// graphics.__bitmap = bitmap;
			}

			cairo = graphics.__cairo;

			fillCommands.clear();
			strokeCommands.clear();

			hasFill = false;
			hasStroke = false;

			fillPattern = null;
			strokePattern = null;

			cairo.newPath();
			cairo.fillRule = EVEN_ODD;

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

						if (hasFill && cairo.inFill(x, y))
						{
							data.destroy();
							return true;
						}

						endStroke();

						if (hasStroke && cairo.inStroke(x, y))
						{
							data.destroy();
							return true;
						}

						hasFill = false;
						bitmapFill = null;

					case BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL, BEGIN_SHADER_FILL:
						endFill();

						if (hasFill && cairo.inFill(x, y))
						{
							data.destroy();
							return true;
						}

						endStroke();

						if (hasStroke && cairo.inStroke(x, y))
						{
							data.destroy();
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
						data.readWindingEvenOdd();
						cairo.fillRule = EVEN_ODD;

					case WINDING_NON_ZERO:
						data.readWindingNonZero();
						cairo.fillRule = WINDING;

					default:
						data.skip(type);
				}
			}

			var hitTest = false;

			if (fillCommands.length > 0)
			{
				endFill();
			}

			if (hasFill && cairo.inFill(x, y))
			{
				hitTest = true;
			}

			if (strokeCommands.length > 0)
			{
				endStroke();
			}

			if (hasStroke && cairo.inStroke(x, y))
			{
				hitTest = true;
			}

			data.destroy();

			return hitTest;
		}
		#end

		return false;
	}

	#if lime_cairo
	private static inline function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float)
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
		if (commands.length == 0) return;

		bounds = graphics.__bounds;

		var offsetX = bounds.x;
		var offsetY = bounds.y;

		var positionX = 0.0;
		var positionY = 0.0;

		var closeGap = false;
		var startX = 0.0;
		var startY = 0.0;
		var setStart = false;

		cairo.fillRule = EVEN_ODD;
		cairo.antialias = SUBPIXEL;

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

		for (type in commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					hasPath = true;
					cairo.curveTo(c.controlX1
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
					quadraticCurveTo(c.controlX - offsetX, c.controlY - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					hasPath = true;
					cairo.moveTo(c.x - offsetX + c.radius, c.y - offsetY);
					cairo.arc(c.x - offsetX, c.y - offsetY, c.radius, 0, Math.PI * 2);

				case DRAW_RECT:
					var c = data.readDrawRect();
					hasPath = true;
					cairo.rectangle(c.x - offsetX, c.y - offsetY, c.width, c.height);

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

					cairo.moveTo(x, ym);
					cairo.curveTo(x, ym - oy, xm - ox, y, xm, y);
					cairo.curveTo(xm + ox, y, xe, ym - oy, xe, ym);
					cairo.curveTo(xe, ym + oy, xm + ox, ye, xm, ye);
					cairo.curveTo(xm - ox, ye, x, ym + oy, x, ym);

				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					hasPath = true;
					drawRoundRect(c.x - offsetX, c.y - offsetY, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

				case LINE_TO:
					var c = data.readLineTo();
					hasPath = true;
					cairo.lineTo(c.x - offsetX, c.y - offsetY);

					positionX = c.x;
					positionY = c.y;

					if (positionX == startX && positionY == startY)
					{
						closeGap = true;
					}

				case MOVE_TO:
					var c = data.readMoveTo();
					cairo.moveTo(c.x - offsetX, c.y - offsetY);

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

					cairo.moveTo(positionX - offsetX, positionY - offsetY);

					if (c.thickness == null)
					{
						hasStroke = false;
					}
					else
					{
						hasStroke = true;

						cairo.lineWidth = (c.thickness > 0 ? c.thickness : 1);

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

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();
					if (stroke && hasStroke)
					{
						closePath(true);
					}

					cairo.moveTo(positionX - offsetX, positionY - offsetY);
					strokePattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);

					hasStroke = true;

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();
					if (stroke && hasStroke)
					{
						closePath(true);
					}

					cairo.moveTo(positionX - offsetX, positionY - offsetY);
					strokePattern = createImagePattern(c.bitmap, c.matrix, c.repeat, c.smooth);

					hasStroke = true;

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					fillPattern = createImagePattern(c.bitmap, c.matrix, c.repeat, c.smooth);

					bitmapFill = c.bitmap;
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
						if (fillPattern != null)
						{
							fillPatternMatrix = null;
						}

						fillPattern = CairoPattern.createRGBA(((c.color & 0xFF0000) >>> 16) / 0xFF, ((c.color & 0x00FF00) >>> 8) / 0xFF,
							(c.color & 0x0000FF) / 0xFF, c.alpha);
						hasFill = true;
					}

					bitmapFill = null;

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();
					if (fillPattern != null)
					{
						fillPatternMatrix = null;
					}

					fillPattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio);

					hasFill = true;
					bitmapFill = null;

				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					var shaderBuffer = c.shaderBuffer;

					if (shaderBuffer.inputCount > 0)
					{
						fillPattern = createImagePattern(shaderBuffer.inputs[0], null, shaderBuffer.inputWrap[0] != CLAMP,
							shaderBuffer.inputFilter[0] != NEAREST);

						bitmapFill = shaderBuffer.inputs[0];
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

					var sourceRect = (bitmapFill != null) ? bitmapFill.rect : null;
					tempMatrix3.identity();

					var transform = graphics.__renderTransform;
					// var roundPixels = renderer.__roundPixels;
					var alpha = CairoGraphics.worldAlpha;

					var ri, ti;

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

						cairo.matrix = tileTransform.__toMatrix3();

						tempMatrix3.tx = tileRect.x;
						tempMatrix3.ty = tileRect.y;
						fillPattern.matrix = tempMatrix3;
						cairo.source = fillPattern;

						if (tileRect != sourceRect)
						{
							cairo.save();

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

						if (tileRect != sourceRect)
						{
							cairo.restore();
						}
					}

					Rectangle.__pool.release(tileRect);
					Matrix.__pool.release(tileTransform);

					cairo.matrix = graphics.__renderTransform.__toMatrix3();
					fillPattern.extend = cacheExtend;

				case DRAW_TRIANGLES:
					var c = data.readDrawTriangles();
					var v = c.vertices;
					var ind = c.indices;
					var uvt:Vector<Float> = c.uvtData;
					var colorFill = bitmapFill == null;

					if (colorFill && uvt != null)
					{
						break;
					}

					var width = 0;
					var height = 0;
					var currentMatrix = graphics.__renderTransform.__toMatrix3();

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

						var skipT = c.uvtData.length != v.length;
						var normalizedUVT = normalizeUVT(uvt, skipT);
						var maxUVT = normalizedUVT.max;
						uvt = normalizedUVT.uvt;

						if (maxUVT > 1)
						{
							width = Std.int(bounds.width);
							height = Std.int(bounds.height);
						}
						else
						{
							width = bitmapFill.width;
							height = bitmapFill.height;
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

					cairo.antialias = NONE;

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
							cairo.newPath();
							cairo.moveTo(x1, y1);
							cairo.lineTo(x2, y2);
							cairo.lineTo(x3, y3);
							cairo.closePath();
							cairo.source = fillPattern;
							if (!hitTesting) cairo.fillPreserve();
							i += 3;
							continue;
						}

						cairo.matrix = graphics.__renderTransform.__toMatrix3();
						// cairo.identityMatrix();
						// cairo.resetClip();

						uvx1 = uvt[iax] * width;
						uvx2 = uvt[ibx] * width;
						uvx3 = uvt[icx] * width;
						uvy1 = uvt[iay] * height;
						uvy2 = uvt[iby] * height;
						uvy3 = uvt[icy] * height;

						denom = uvx1 * (uvy3 - uvy2) - uvx2 * uvy3 + uvx3 * uvy2 + (uvx2 - uvx3) * uvy1;

						if (denom == 0)
						{
							i += 3;
							continue;
						}

						cairo.newPath();
						cairo.moveTo(x1, y1);
						cairo.lineTo(x2, y2);
						cairo.lineTo(x3, y3);
						cairo.closePath();
						// cairo.clip ();

						x1 *= currentMatrix.a;
						x2 *= currentMatrix.a;
						x3 *= currentMatrix.a;
						y1 *= currentMatrix.d;
						y2 *= currentMatrix.d;
						y3 *= currentMatrix.d;

						t1 = -(uvy1 * (x3 - x2) - uvy2 * x3 + uvy3 * x2 + (uvy2 - uvy3) * x1) / denom;
						t2 = (uvy2 * y3 + uvy1 * (y2 - y3) - uvy3 * y2 + (uvy3 - uvy2) * y1) / denom;
						t3 = (uvx1 * (x3 - x2) - uvx2 * x3 + uvx3 * x2 + (uvx2 - uvx3) * x1) / denom;
						t4 = -(uvx2 * y3 + uvx1 * (y2 - y3) - uvx3 * y2 + (uvx3 - uvx2) * y1) / denom;
						dx = (uvx1 * (uvy3 * x2 - uvy2 * x3) + uvy1 * (uvx2 * x3 - uvx3 * x2) + (uvx3 * uvy2 - uvx2 * uvy3) * x1) / denom;
						dy = (uvx1 * (uvy3 * y2 - uvy2 * y3) + uvy1 * (uvx2 * y3 - uvx3 * y2) + (uvx3 * uvy2 - uvx2 * uvy3) * y1) / denom;

						tempMatrix3.setTo(t1, t2, t3, t4, dx, dy);
						cairo.matrix = tempMatrix3;
						cairo.source = fillPattern;
						if (!hitTesting) cairo.fill();

						i += 3;
					}

					cairo.matrix = graphics.__renderTransform.__toMatrix3();

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

		if (hasPath)
		{
			if (stroke && hasStroke)
			{
				if (hasFill)
				{
					if (positionX != startX || positionY != startY)
					{
						cairo.lineTo(startX - offsetX, startY - offsetY);
						closeGap = true;
					}

					if (closeGap) closePath(true);
				}
				else if (closeGap && positionX == startX && positionY == startY)
				{
					closePath(true);
				}

				cairo.source = strokePattern;
				if (!hitTesting) cairo.strokePreserve();
			}

			if (!stroke && hasFill)
			{
				cairo.translate(-bounds.x, -bounds.y);

				if (fillPatternMatrix != null)
				{
					var matrix = Matrix.__pool.get();
					matrix.copyFrom(fillPatternMatrix);
					matrix.invert();

					if (pendingMatrix != null)
					{
						matrix.concat(pendingMatrix);
					}

					fillPattern.matrix = matrix.__toMatrix3();

					Matrix.__pool.release(matrix);
				}

				cairo.source = fillPattern;

				if (pendingMatrix != null)
				{
					cairo.transform(pendingMatrix.__toMatrix3());
					if (!hitTesting) cairo.fillPreserve();
					cairo.transform(inversePendingMatrix.__toMatrix3());
				}
				else
				{
					if (!hitTesting) cairo.fillPreserve();
				}

				cairo.translate(bounds.x, bounds.y);
				cairo.closePath();
			}
		}
	}

	private static function quadraticCurveTo(cx:Float, cy:Float, x:Float, y:Float):Void
	{
		var current = null;

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
		CairoGraphics.allowSmoothing = renderer.__allowSmoothing;
		CairoGraphics.worldAlpha = renderer.__getAlpha(graphics.__owner.__worldAlpha);

		#if (openfl_disable_hdpi || openfl_disable_hdpi_graphics)
		var pixelRatio = 1;
		#else
		var pixelRatio = renderer.__pixelRatio;
		#end

		graphics.__update(renderer.__worldTransform, pixelRatio);

		if (!graphics.__softwareDirty || graphics.__managed) return;

		bounds = graphics.__bounds;

		var width = graphics.__width;
		var height = graphics.__height;

		if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || width < 1 || height < 1)
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

			fillCommands.clear();
			strokeCommands.clear();

			hasFill = false;
			hasStroke = false;

			fillPattern = null;
			strokePattern = null;

			var hasLineStyle = false;
			var initStrokeX = 0.0;
			var initStrokeY = 0.0;

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

			if (fillCommands.length > 0)
			{
				endFill();
			}

			if (strokeCommands.length > 0)
			{
				endStroke();
			}

			data.destroy();

			graphics.__bitmap.image.dirty = true;
			graphics.__bitmap.image.version++;
		}

		graphics.__softwareDirty = false;
		graphics.__dirty = false;
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
						cairo.curveTo(c.controlX1
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
						quadraticCurveTo(c.controlX - offsetX, c.controlY - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);
						positionX = c.anchorX;
						positionY = c.anchorY;

					case DRAW_CIRCLE:
						var c = data.readDrawCircle();
						cairo.arc(c.x - offsetX, c.y - offsetY, c.radius, 0, Math.PI * 2);

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
						cairo.moveTo(x, ym);
						cairo.curveTo(x, ym - oy, xm - ox, y, xm, y);
						cairo.curveTo(xm + ox, y, xe, ym - oy, xe, ym);
						cairo.curveTo(xe, ym + oy, xm + ox, ye, xm, ye);
						cairo.curveTo(xm - ox, ye, x, ym + oy, x, ym);
					// closePath (false);

					case DRAW_RECT:
						var c = data.readDrawRect();
						cairo.rectangle(c.x - offsetX, c.y - offsetY, c.width, c.height);

					case DRAW_ROUND_RECT:
						var c = data.readDrawRoundRect();
						drawRoundRect(c.x - offsetX, c.y - offsetY, c.width, c.height, c.ellipseWidth, c.ellipseHeight);

					case LINE_TO:
						var c = data.readLineTo();
						cairo.lineTo(c.x - offsetX, c.y - offsetY);
						positionX = c.x;
						positionY = c.y;

					case MOVE_TO:
						var c = data.readMoveTo();
						cairo.moveTo(c.x - offsetX, c.y - offsetY);
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
}

private typedef NormalizedUVT =
{
	max:Float,
	uvt:Vector<Float>
}
