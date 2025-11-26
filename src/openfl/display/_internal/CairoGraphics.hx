package openfl.display._internal;

#if !flash
import openfl.display._internal.DrawCommandBuffer;
import openfl.display._internal.DrawCommandReader;
import openfl.display._internal.Scale9GridBounds;
import openfl.display._internal.Scale9Grid;
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
	private static var bitmapRepeat:Bool;
	private static var bounds:Rectangle;
	private static var cairo:Cairo;
	private static var fillCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var fillPattern:CairoPattern;
	private static var bitmapFill:BitmapData;
	private static var fillMatrix:Matrix;
	private static var graphics:Graphics;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var hitTesting:Bool;
	private static var strokeCommands:DrawCommandBuffer = new DrawCommandBuffer();
	private static var strokePattern:CairoPattern;
	private static var strokePatternMatrix:Matrix;
	private static var bitmapStroke:BitmapData;
	private static var fillPatternMatrix:Matrix;
	private static var seenEdgeMap:Map<Int, Bool> = new Map<Int, Bool>();
	private static var tempUvtVector:Vector<Float> = new Vector<Float>();
	private static var tempPatternMatrix = new Matrix();
	private static var tempMatrix3 = new Matrix3();
	private static var worldAlpha:Float;

	private static function closePathAndApplyStroke(strokeBefore:Bool = false):Void
	{
		if (!strokeBefore)
		{
			cairo.closePath();
		}

		applyStroke();

		if (strokeBefore)
		{
			cairo.closePath();
		}

		cairo.newPath();
	}

	private static inline function applyStroke()
	{
		if (!hitTesting)
		{
			if (bitmapStroke != null)
			{
				applyPatternMatrix(bitmapStroke, strokePatternMatrix, Scale9Grid.valid ? Scale9Grid.strokeBounds : null, strokePattern);
			}
			else if (strokePatternMatrix != null)
			{
				strokePattern.matrix = strokePatternMatrix.__toMatrix3(tempMatrix3);
			}
			else
			{
				strokePattern.matrix.identity();
			}
		}

		cairo.source = strokePattern;
		cairo.strokePreserve();
	}

	private static function applyFill()
	{
		if (!hitTesting)
		{
			if (bitmapFill != null)
			{
				applyPatternMatrix(bitmapFill, fillPatternMatrix, Scale9Grid.valid ? Scale9Grid.fillBounds : null, fillPattern);
			}
			else if (fillPatternMatrix != null)
			{
				fillPattern.matrix = fillPatternMatrix.__toMatrix3(tempMatrix3);
				// fillPattern.matrix = new Matrix3();
			}
			else
			{
				fillPattern.matrix.identity();
			}
		}

		cairo.source = fillPattern;
		cairo.fillPreserve();
	}

	private static function createImagePattern(bitmapFill:BitmapData, bitmapRepeat:Bool, smooth:Bool):CairoPattern
	{
		var pattern = CairoPattern.createForSurface(bitmapFill.getSurface());
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
		var ratio:Float = 0.0;
		var patternMatrix:Matrix = new Matrix();

		if (matrix != null)
		{
			patternMatrix.copyFrom(matrix);
			patternMatrix.a *= 8.192;
			patternMatrix.d *= 8.192;
			patternMatrix.invert();
		}

		if (stroke)
		{
			strokePatternMatrix = patternMatrix;
		}
		else
		{
			fillPatternMatrix = patternMatrix;
		}

		switch (type)
		{
			case RADIAL:
				focalPointRatio = focalPointRatio > 1.0 ? 1.0 : focalPointRatio < -1.0 ? -1.0 : focalPointRatio;

				// focal center
				var fcx = matrix.__transformX(focalPointRatio * 819.2, 0);
				var fcy = matrix.__transformY(focalPointRatio * 819.2, 0);

				// center
				var cx = matrix.__transformX(0, 0);
				var cy = matrix.__transformY(0, 0);

				// end
				var ex = matrix.__transformX(819.2, 0);
				var ey = matrix.__transformY(819.2, 0);

				if (Scale9Grid.valid)
				{
					fcx = Scale9Grid.toPositionX(fcx);
					fcy = Scale9Grid.toPositionY(fcy);
					cx = Scale9Grid.toPositionX(cx);
					cy = Scale9Grid.toPositionY(cy);
					ex = Scale9Grid.toPositionX(ex);
					ey = Scale9Grid.toPositionY(ey);
				}

				var dx = ex - cx;
				var dy = ey - cy;

				// cairo can't draw ellipical radial gradients; they must be
				// circular. in other words, the same radius in both directions.
				// we basically take the average and use that. not ideal, but
				// probably as close as we can get to flash.
				var radius = Math.sqrt(dx * dx + dy * dy);

				pattern = CairoPattern.createRadial(fcx, fcy, 0.0, cx, cy, radius);

			case LINEAR:
				var fcx = matrix.__transformX(-819.2, 0);
				var fcy = matrix.__transformY(-819.2, 0);

				var cx = matrix.__transformX(819.2, 0);
				var cy = matrix.__transformY(819.2, 0);

				if (Scale9Grid.valid)
				{
					fcx = Scale9Grid.toPositionX(fcx);
					fcy = Scale9Grid.toPositionY(fcy);
					cx = Scale9Grid.toPositionX(cx);
					cy = Scale9Grid.toPositionY(cy);
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

		return pattern;
	}

	private static function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void
	{
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
			cairo.lineTo(x + ellipseWidth, bottom);
			quadraticCurveTo(x - cx2, bottom, x - cx1, bottom + cy1);
			quadraticCurveTo(x, bottom + cy2, x, bottom - ellipseHeight);
			cairo.lineTo(x, y + ellipseHeight);
			quadraticCurveTo(x, y - cy2, x - cx1, y - cy1);
			quadraticCurveTo(x - cx2, y, x + ellipseWidth, y);
			cairo.lineTo(right - ellipseWidth, y);
			quadraticCurveTo(right + cx2, y, right + cx1, y - cy1);
			quadraticCurveTo(right, y - cy2, right, y + ellipseHeight);
			cairo.lineTo(right, bottom - ellipseHeight);
		}
	}

	private static function endFill():Void
	{
		if (fillCommands.length > 0)
		{
			cairo.newPath();
			playCommands(fillCommands, false);
			fillCommands.clear();
		}
	}

	private static function endStroke():Void
	{
		if (strokeCommands.length > 0)
		{
			cairo.newPath();
			playCommands(strokeCommands, true);
			cairo.closePath();
			strokeCommands.clear();
		}
	}
	#end

	public static function hitTest(graphics:Graphics, x:Float, y:Float):Bool
	{
		#if lime_cairo
		CairoGraphics.graphics = graphics;
		bounds = graphics.__bounds;

		if (graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0 || !bounds.contains(x, y))
		{
			CairoGraphics.graphics = null;
			return false;
		}
		else
		{
			hitTesting = true;

			#if (!openfl_legacy_scale9grid || cairo)
			Scale9Grid.setTo(graphics);
			#end

			x -= bounds.x;
			y -= bounds.y;

			if (Scale9Grid.valid)
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

			cairo.newPath();
			cairo.fillRule = EVEN_ODD;

			var data = new DrawCommandReader(graphics.__commands);

			inline function cleanUp()
			{
				data.destroy();
				CairoGraphics.graphics = null;
			}

			inline function endFillHitTest():Bool
			{
				endFill();

				if (hasFill && hasPath && cairo.inFill(x, y))
				{
					cleanUp();
					return true;
				}
				return false;
			}

			inline function endStrokeHitTest():Bool
			{
				endStroke();

				if (hasStroke && hasPath && cairo.inStroke(x, y))
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

						hasStroke = true;

					case LINE_BITMAP_STYLE:
						var c = data.readLineBitmapStyle();
						strokeCommands.lineBitmapStyle(c.bitmap, c.matrix, c.repeat, c.smooth);

						hasStroke = true;

					case END_FILL:
						if (endFillHitTest()) return true;
						if (endStrokeHitTest()) return true;

						hasPath = false;
						hasFill = false;
						bitmapFill = null;
						fillMatrix = null;

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
						data.readWindingEvenOdd();
						cairo.fillRule = EVEN_ODD;

					case WINDING_NON_ZERO:
						data.readWindingNonZero();
						cairo.fillRule = WINDING;

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

	#if lime_cairo
	private static inline function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Bool
	{
		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
	}

	private static inline function applyPatternMatrix(bitmap:BitmapData, bitmapMatrix:Matrix, scale9Bounds:Scale9GridBounds, pattern:CairoPattern):Void
	{
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
		pattern.matrix = tempPatternMatrix.__toMatrix3(tempMatrix3);
		cairo.source = pattern;
	}

	private static function playCommands(commands:DrawCommandBuffer, stroke:Bool = false):Void
	{
		if (commands.length == 0) return;

		var offsetX = bounds.x;
		var offsetY = bounds.y;

		var positionX = 0.0;
		var positionY = 0.0;

		var startX = 0.0;
		var startY = 0.0;

		cairo.fillRule = EVEN_ODD;
		cairo.antialias = SUBPIXEL;

		var hasPath:Bool = false;

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
		var r:Float;
		var g:Float;
		var b:Float;

		cairo.moveTo(0, 0);

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

						if (Scale9Grid.valid)
						{
							Scale9Grid.applyUnscaledX(c.anchorX);
							Scale9Grid.applyUnscaledY(c.anchorY);
							Scale9Grid.applyScaledX(scaledAnchorX);
							Scale9Grid.applyScaledY(scaledAnchorY);
						}

						cairo.curveTo(scaledControlX1
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

						if (Scale9Grid.valid)
						{
							Scale9Grid.applyUnscaledX(c.anchorX);
							Scale9Grid.applyUnscaledY(c.anchorY);
							Scale9Grid.applyScaledX(scaledAnchorX);
							Scale9Grid.applyScaledY(scaledAnchorY);
						}

						quadraticCurveTo(scaledControlX - offsetX, scaledControlY - offsetY, scaledAnchorX - offsetX, scaledAnchorY - offsetY);

						positionX = scaledAnchorX;
						positionY = scaledAnchorY;
					}
					else
					{
						quadraticCurveTo(c.controlX - offsetX, c.controlY - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);

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

						if (Scale9Grid.valid)
						{
							Scale9Grid.applyUnscaledX(c.x - c.radius);
							Scale9Grid.applyUnscaledY(c.y - c.radius);
							Scale9Grid.applyUnscaledX(c.x + c.radius);
							Scale9Grid.applyUnscaledY(c.y + c.radius);
							Scale9Grid.applyScaledX(scaledLeft);
							Scale9Grid.applyScaledY(scaledTop);
							Scale9Grid.applyScaledX(scaledRight);
							Scale9Grid.applyScaledY(scaledBottom);
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
						cairo.moveTo(c.x - offsetX + c.radius, c.y - offsetY);
						cairo.arc(c.x - offsetX, c.y - offsetY, c.radius, 0, Math.PI * 2);
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

						cairo.moveTo(x, ym);
						cairo.curveTo(x, ym - oy, xm - ox, y, xm, y);
						cairo.curveTo(xm + ox, y, xe, ym - oy, xe, ym);
						cairo.curveTo(xe, ym + oy, xm + ox, ye, xm, ye);
						cairo.curveTo(xm - ox, ye, x, ym + oy, x, ym);
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
							cairo.lineTo(scaledX - offsetX, scaledY - offsetY);
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
							cairo.lineTo(c.x - offsetX, c.y - offsetY);
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

						cairo.moveTo(scaledX - offsetX, scaledY - offsetY);

						positionX = scaledX;
						positionY = scaledY;
					}
					else
					{
						cairo.moveTo(c.x - offsetX, c.y - offsetY);

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

					bitmapStroke = null;
					strokePatternMatrix = null;

				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();
					if (stroke && hasStroke)
					{
						closePathAndApplyStroke(true);
					}

					cairo.moveTo(positionX - offsetX, positionY - offsetY);
					strokePattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio, true);

					hasStroke = true;

					bitmapStroke = null;
					strokePatternMatrix = null;

				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();
					if (stroke && hasStroke)
					{
						closePathAndApplyStroke(true);
					}

					cairo.moveTo(positionX - offsetX, positionY - offsetY);

					if (c.bitmap.readable)
					{
						strokePattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						bitmapStroke = c.bitmap;
						strokePatternMatrix = c.matrix;
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						strokePattern = CairoPattern.createRGB(0, 0, 0);
						bitmapStroke = null;
						strokePatternMatrix = null;
					}

					if (Scale9Grid.valid)
					{
						Scale9Grid.strokeBounds.clear();
					}

					hasStroke = true;

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();

					if (c.bitmap.readable)
					{
						fillPattern = createImagePattern(c.bitmap, c.repeat, c.smooth);
						bitmapFill = c.bitmap;
						fillMatrix = c.matrix;
					}
					else
					{
						// if it's hardware-only BitmapData, fall back to
						// drawing solid black because we have no software
						// pixels to work with
						fillPattern = CairoPattern.createRGB(0, 0, 0);
						bitmapFill = null;
						fillMatrix = null;
					}

					bitmapRepeat = c.repeat;

					hasFill = true;

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
						fillPattern = CairoPattern.createRGBA(((c.color & 0xFF0000) >>> 16) / 0xFF, ((c.color & 0x00FF00) >>> 8) / 0xFF,
							(c.color & 0x0000FF) / 0xFF, c.alpha);
						hasFill = true;
					}

					bitmapFill = null;
					fillMatrix = null;

					if (Scale9Grid.valid)
					{
						Scale9Grid.fillBounds.clear();
					}

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();

					fillPattern = createGradientPattern(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio, false);

					hasFill = true;
					bitmapFill = null;
					fillMatrix = null;

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
							fillPattern = createImagePattern(bitmapFill, shaderBuffer.inputWrap[0] != CLAMP, shaderBuffer.inputFilter[0] != NEAREST);
						}
						else
						{
							// if it's hardware-only BitmapData, fall back to
							// drawing solid black because we have no software
							// pixels to work with
							fillPattern = CairoPattern.createRGB(0, 0, 0);
						}
						hasFill = true;
						fillMatrix = null;
						bitmapRepeat = false;
					}

					if (Scale9Grid.valid)
					{
						Scale9Grid.fillBounds.clear();
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

					var ri:Int;
					var ti:Int;

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

						cairo.matrix = tileTransform.__toMatrix3(tempMatrix3);

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

					cairo.matrix = graphics.__renderTransform.__toMatrix3(tempMatrix3);
					fillPattern.extend = cacheExtend;

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
						uvt = Graphics.__normalizeUVT(uvt, tempUvtVector);
					}
					else if (!stroke && uvt == null && bitmapFill != null)
					{
						uvt = Graphics.__generateUVT(v, bitmapFill.width, bitmapFill.height, fillMatrix, tempUvtVector);
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

						abKey = Graphics.__edgeKey(ind[a_], ind[b_]);
						bcKey = Graphics.__edgeKey(ind[b_], ind[c_]);
						caKey = Graphics.__edgeKey(ind[c_], ind[a_]);

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

						u1 = uvt[iax];
						u2 = uvt[ibx];
						u3 = uvt[icx];
						v1 = uvt[iay];
						v2 = uvt[iby];
						v3 = uvt[icy];

						if (!hitTesting)
						{
							cairo.newPath();
						}

						cairo.moveTo(x1, y1);
						cairo.lineTo(x2, y2);
						cairo.lineTo(x3, y3);
						cairo.closePath();

						if (!hitTesting)
						{
							if (bitmapFill != null && !stroke)
							{
								var oldFillPatternMatrix = fillPatternMatrix;
								fillPatternMatrix = Graphics.__calculatePatternMatrixFromTri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3,
									(minX - offsetX) * 2, (minY - offsetY) * 2, bitmapFill.width, bitmapFill.height, tempPatternMatrix);
								applyFill();
								fillPatternMatrix = oldFillPatternMatrix;
							}
						}

						i += 3;
					}

				case DRAW_RECT:
					var c = data.readDrawRect();
					hasPath = true;

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
							cairo.rectangle(scaledLeft - offsetX, scaledTop - offsetY, scaledWidth, scaledHeight);
						}
					}
					else if (c.width != 0.0 || c.height != 0.0)
					{
						// flash doesn't draw the rectangle if both the width
						// and height are zero
						cairo.rectangle(c.x - offsetX, c.y - offsetY, c.width, c.height);
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

		if (hasPath)
		{
			if (hasFill && (positionX != startX || positionY != startY))
			{
				cairo.lineTo(startX - offsetX, startY - offsetY);
				positionX = startX;
				positionY = startY;
			}
			if (!hitTesting)
			{
				if (!stroke && hasFill)
				{
					cairo.translate(-bounds.x, -bounds.y);

					applyFill();

					cairo.translate(bounds.x, bounds.y);
				}
				if (stroke && hasStroke)
				{
					closePathAndApplyStroke(true);
				}
			}
		}
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
		CairoGraphics.allowSmoothing = renderer.__allowSmoothing;
		CairoGraphics.worldAlpha = renderer.__getAlpha(graphics.__owner.__worldAlpha);

		#if (openfl_disable_hdpi || openfl_disable_hdpi_graphics)
		var pixelRatio = 1;
		#else
		var pixelRatio = renderer.__pixelRatio;
		#end

		#if (!openfl_legacy_scale9grid || cairo)
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

		if (!graphics.__softwareDirty || graphics.__managed)
		{
			CairoGraphics.graphics = null;
			return;
		}

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

			reset();

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
						bitmapFill = null;
						fillMatrix = null;
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
}
#end
