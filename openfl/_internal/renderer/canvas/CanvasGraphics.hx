package openfl._internal.renderer.canvas;

import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.CapsStyle;
import openfl.display.DisplayObject;
import openfl._internal.renderer.DrawCommandReader;
import openfl._internal.renderer.DrawCommandType;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.InterpolationMethod;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.utils.ByteArray;
import openfl.Vector;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasGradient;
import js.html.CanvasPattern;
import js.html.CanvasRenderingContext2D;
import js.Browser;
import js.html.ImageData;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)


class CanvasGraphics {


	private static var SIN45 = 0.70710678118654752440084436210485;
	private static var TAN22 = 0.4142135623730950488016887242097;

	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var hitTesting:Bool;
	private static var inversePendingMatrix:Matrix;
	private static var pendingMatrix:Matrix;
	private static var padding:Int = 1;

	#if (js && html5)
	private static var context:CanvasRenderingContext2D;
	private static var canvasWindingRule = js.html.CanvasWindingRule.EVENODD;
	#end

	private static var positionX = 0.0;
	private static var positionY = 0.0;
	private static var closeGap = false;
	private static var startX = 0.0;
	private static var startY = 0.0;
	private static var currentTransform = new Matrix ();
	private static var snapCoordinates:Bool = false;

	public static var drawCommandReaderPool: ObjectPool<DrawCommandReader>  = new ObjectPool<DrawCommandReader>(
		function()
		{
			return new DrawCommandReader(null);
		}
	);


	private static function closePath ():Void {

		#if (js && html5)

		var context = context;
		if (context.strokeStyle == null) {

			return;

		}

		context.closePath ();
		context.stroke ();
		context.beginPath ();

		#end

	}


	private static function createBitmapFill (bitmap:BitmapData, bitmapRepeat:Bool) {

		#if (js && html5)

		bitmap.__sync ();
		return context.createPattern (bitmap.image.src, bitmapRepeat ? "repeat" : "no-repeat");

		#else

		return null;

		#end

	}


	private static function createGradientPattern (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix, spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float) {

		#if (js && html5)

		var gradientFill = null;

		var context = context;
		if ( focalPointRatio != 0 ) {

			focalPointRatio = Math.min(Math.max(focalPointRatio, -1), 1);
		}
		switch (type) {

			case RADIAL:
				gradientFill = context.createRadialGradient (819.2 * focalPointRatio , 0, 0, 0, 0, 819.2);

			case LINEAR:

				gradientFill = context.createLinearGradient (-819.2, 0, 819.2, 0);

		}

		for (i in 0...colors.length) {

			var rgb = colors[i];
			var alpha = alphas[i];
			var r = (rgb & 0xFF0000) >>> 16;
			var g = (rgb & 0x00FF00) >>> 8;
			var b = (rgb & 0x0000FF);

			var ratio = ratios[i] / 0xFF;
			if (ratio < 0) ratio = 0;
			if (ratio > 1) ratio = 1;

			gradientFill.addColorStop (ratio, "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")");

		}

		return cast (gradientFill);

		#end

	}

	private static function drawRoundRect (x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void {

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

		var context = context;
		context.moveTo (xe, ye - ellipseHeight);
		context.quadraticCurveTo (xe, ye + cy2, xe + cx1, ye + cy1);
		context.quadraticCurveTo (xe + cx2, ye, xe - ellipseWidth, ye);
		context.lineTo (x + ellipseWidth, ye);
		context.quadraticCurveTo (x - cx2, ye, x - cx1, ye + cy1);
		context.quadraticCurveTo (x, ye + cy2, x, ye - ellipseHeight);
		context.lineTo (x, y + ellipseHeight);
		context.quadraticCurveTo (x, y - cy2, x - cx1, y - cy1);
		context.quadraticCurveTo (x - cx2, y, x + ellipseWidth, y);
		context.lineTo (xe - ellipseWidth, y);
		context.quadraticCurveTo (xe + cx2, y, xe + cx1, y - cy1);
		context.quadraticCurveTo (xe, y - cy2, xe, y + ellipseHeight);
		context.lineTo (xe, ye - ellipseHeight);
		#end

	}

	private static function beginRenderStep()
	{
		#if (js && html5)
		context.beginPath ();
		positionX = 0.0;
		positionY = 0.0;
		closeGap = false;
		startX = 0.0;
		startY = 0.0;
		#end
		resetFillStyle ();
	}

	private static inline function resetFillStyle()
	{
		hasFill = false;
		hasStroke = false;
	}

	private static function endRenderStep()
	{
		#if (js && html5)
		var canvasGraphics = CanvasGraphics;
		if (canvasGraphics.hasStroke || canvasGraphics.hasFill) {

			if (!canvasGraphics.hitTesting && canvasGraphics.hasStroke) context.stroke ();

			if (canvasGraphics.hasFill && closeGap) {

				context.lineTo (startX, startY);

			} else if (closeGap && positionX == startX && positionY == startY) {

				context.closePath ();

			}

			if (canvasGraphics.hasFill) {
				context.save ();

				var pending_matrix = canvasGraphics.pendingMatrix;
				if (pending_matrix != null && pending_matrix.a * pending_matrix.d - pending_matrix.c * pending_matrix.b != 0  ) {

					if (snapCoordinates) {
						context.setTransform (currentTransform.a, currentTransform.b, currentTransform.c, currentTransform.d, currentTransform.tx, currentTransform.ty);
					}

					context.transform (pending_matrix.a, pending_matrix.b, pending_matrix.c, pending_matrix.d, pending_matrix.tx, pending_matrix.ty);
					canvasGraphics.pendingMatrix = null;
				}

				if (!canvasGraphics.hitTesting) context.fill (canvasGraphics.canvasWindingRule);

				context.restore ();
				context.closePath ();

			}
		}
		#end
	}


	public static function hitTest (graphics:Graphics, x:Float, y:Float):Bool {

		#if (js && html5)

		var bounds = graphics.__bounds;
		var canvasGraphics = CanvasGraphics;

		if (graphics.__commands.length == 0 || bounds == null || bounds.width <= 0 || bounds.height <= 0) {

			return false;

		} else {

			hitTesting = true;

			if ( graphics.__canvas == null ) {
				graphics.__canvas = cast Browser.document.createElement ("canvas");
				graphics.__context = graphics.__canvas.getContext ("2d");
			}

			context = graphics.__context;
			var context = canvasGraphics.context;

			if (snapCoordinates) {

				currentTransform.setTo (1.0, 0.0, 0.0, 1.0, -bounds.x, -bounds.y);
				context.setTransform (1.0, 0.0, 0.0, 1.0, 0.0, 0.0);

			} else {

				context.setTransform (1.0, 0.0, 0.0, 1.0, -bounds.x, -bounds.y);

			}

			context.clearRect (0,0,graphics.__canvas.width,graphics.__canvas.height);

			x -= bounds.x;
			y -= bounds.y;

			beginRenderStep();

			var data = drawCommandReaderPool.get();
			data.reset(graphics.__commands);

			for (type in graphics.__commands.types) {

				switch (type) {

					case CUBIC_CURVE_TO:
						cubicCurveTo(data);
					case CURVE_TO:
						curveTo(data);
					case LINE_TO:
						lineTo(data);
					case MOVE_TO:
						moveTo(data);
					case END_FILL:
						data.readEndFill ();
						endRenderStep();
						if (canvasGraphics.hasFill && context.isPointInPath (x, y, canvasGraphics.canvasWindingRule)) {
							drawCommandReaderPool.put (data);
							return true;
						}

						if (canvasGraphics.hasStroke && (context:Dynamic).isPointInStroke (x, y)) {
							drawCommandReaderPool.put (data);
							return true;
						}

						beginRenderStep();
					case LINE_STYLE:
						lineStyle(data, true);
					case LINE_GRADIENT_STYLE:
						lineGradientStyle(data, true);
					case LINE_BITMAP_STYLE:
						lineBitmapStyle(data, true);

					case BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL:

						endRenderStep();

						if (hasFill && context.isPointInPath (x, y, canvasWindingRule)) {
							drawCommandReaderPool.put (data);
							return true;
						}

						if (hasStroke && (context:Dynamic).isPointInStroke (x, y)) {
							drawCommandReaderPool.put (data);
							return true;
						}

						beginRenderStep();

						if (type == BEGIN_BITMAP_FILL) {
							var c = data.readBeginBitmapFill ();
						} else if (type == BEGIN_GRADIENT_FILL) {
							var c = data.readBeginGradientFill ();
						} else {
							var c = data.readBeginFill ();
						}

						hasFill = true;

					case DRAW_CIRCLE:
						drawCircle(data);

					case DRAW_ELLIPSE:
						drawEllipse(data);

					case DRAW_IMAGE:
						drawImage(data);

						if (context.isPointInPath (x, y, canvasWindingRule)) {
							drawCommandReaderPool.put (data);
							return true;
						}

					case DRAW_RECT:
						drawRect(data);

					case DRAW_ROUND_RECT:
						drawRoundRect2(data);

					default:
						data.skip (type);
				}

			}

			endRenderStep();

			drawCommandReaderPool.put (data);

			if (hasFill && context.isPointInPath (x, y, canvasGraphics.canvasWindingRule)) {
				return true;
			}

			if (hasStroke && (context:Dynamic).isPointInStroke (x, y)) {
				return true;
			}

		}

		#end

		return false;

	}


	private static inline function isCCW (x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float) {

		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;

	}


	private static function normalizeUVT (uvt:Vector<Float>, skipT:Bool = false): { max:Float, uvt:Vector<Float> } {

		var max:Float = Math.NEGATIVE_INFINITY;
		var tmp = Math.NEGATIVE_INFINITY;
		var len = uvt.length;

		for (t in 1...len + 1) {

			if (skipT && t % 3 == 0) {

				continue;

			}

			tmp = uvt[t - 1];

			if (max < tmp) {

				max = tmp;

			}

		}

		var result = new Vector<Float> ();

		for (t in 1...len + 1) {

			if (skipT && t % 3 == 0) {

				continue;

			}

			result.push ((uvt[t - 1] / max));

		}

		return { max: max, uvt: result };

	}


	public static function render (graphics:Graphics, renderSession:RenderSession, scaleX:Float = 1.0, scaleY:Float = 1.0, isMask : Bool = false):Void {

		#if (js && html5)

		if (graphics.__dirty) {

			hitTesting = false;

			var bounds = graphics.__bounds;

			if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width <= 0 || bounds.height <= 0) {

				graphics.__canvas = null;
				graphics.__context = null;
				graphics.__bitmap = null;

			} else {

				var width = Math.ceil (graphics.__bounds.width * scaleX) + 2 * padding;
				var height = Math.ceil (graphics.__bounds.height * scaleY) + 2 * padding;

				if (graphics.__symbol != null) {

					var cachedBitmapData:BitmapData = graphics.__symbol.getCachedBitmapData (width, height);

					if (cachedBitmapData != null) {

						graphics.__bitmap = cachedBitmapData;
						graphics.__dirty = false;

						return;

					}

				}

				if (graphics.__canvas == null) {

					graphics.__canvas = cast Browser.document.createElement ("canvas");
					graphics.__context = graphics.__canvas.getContext ("2d");

				}

				context = graphics.__context;

				var context = context;

				graphics.__canvas.width = width;
				graphics.__canvas.height = height;
				snapCoordinates = graphics.snapCoordinates;

				if (snapCoordinates) {

					currentTransform.setTo (scaleX, 0.0, 0.0, scaleY, padding, padding);
					var matrix = Matrix.pool.get ();
					// :TODO: optimize this
					matrix.setTo (1.0, 0.0, 0.0, 1.0, -graphics.__bounds.x, -graphics.__bounds.y);
					currentTransform.preTransform (matrix);
					Matrix.pool.put (matrix);

				} else {

					context.setTransform (scaleX, 0, 0, scaleY, padding, padding);
					context.translate (-graphics.__bounds.x, -graphics.__bounds.y);

				}


				beginRenderStep ();

				var data = drawCommandReaderPool.get ();
				data.reset (graphics.__commands);

				if (snapCoordinates) {
					for (type in graphics.__commands.types) {

						switch (type) {

							case CURVE_TO:
								snappedCurveTo(data);

							case LINE_TO:
								snappedLineTo(data);

							case MOVE_TO:
								snappedMoveTo(data);

							case END_FILL:

								data.readEndFill ();

								endRenderStep();
								beginRenderStep();

							case BEGIN_BITMAP_FILL:
								endRenderStep();
								beginRenderStep();
								beginBitmapFill(data, isMask);

							case BEGIN_FILL:
								endRenderStep();
								beginRenderStep();
								beginFill(data, isMask);

							case BEGIN_GRADIENT_FILL:
								endRenderStep();
								beginRenderStep();
								beginGradientFill(data, isMask);

							case DRAW_IMAGE:
								snappedDrawImage(data);

							default:

								throw ":TODO:";

						}

					}

				} else {

					for (type in graphics.__commands.types) {

						switch (type) {

							case CUBIC_CURVE_TO:
								cubicCurveTo(data);

							case CURVE_TO:
								curveTo(data);

							case LINE_TO:
								lineTo(data);

							case MOVE_TO:
								moveTo(data);

							case END_FILL:

								data.readEndFill ();

								endRenderStep();
								beginRenderStep();

							case LINE_STYLE:
								lineStyle(data, isMask);

							case LINE_GRADIENT_STYLE:
								lineGradientStyle(data, isMask);

							case LINE_BITMAP_STYLE:
								lineBitmapStyle(data, isMask);

							case BEGIN_BITMAP_FILL:
								endRenderStep();
								beginRenderStep();
								beginBitmapFill(data, isMask);

							case BEGIN_FILL:
								endRenderStep();
								beginRenderStep();
								beginFill(data, isMask);

							case BEGIN_GRADIENT_FILL:
								endRenderStep();
								beginRenderStep();
								beginGradientFill(data, isMask);

							case DRAW_CIRCLE:
								drawCircle(data);

							case DRAW_IMAGE:
								drawImage(data);

							case DRAW_ELLIPSE:
								drawEllipse(data);

							case DRAW_RECT:
								drawRect(data);

							case DRAW_ROUND_RECT:
								drawRoundRect2(data);

							case DRAW_TRIANGLES:

								endRenderStep();
								beginRenderStep();

								var c = data.readDrawTriangles ();

								var v = c.vertices;
								var ind = c.indices;
								var uvt = c.uvtData;
								var pattern:CanvasElement = null;

								var i = 0;
								var l = ind.length;

								var a_:Int, b_:Int, c_:Int;
								var iax:Int, iay:Int, ibx:Int, iby:Int, icx:Int, icy:Int;
								var x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float;
								var uvx1:Float, uvy1:Float, uvx2:Float, uvy2:Float, uvx3:Float, uvy3:Float;
								var denom:Float;
								var t1:Float, t2:Float, t3:Float, t4:Float;
								var dx:Float, dy:Float;

								while (i < l) {

									a_ = i;
									b_ = i + 1;
									c_ = i + 2;

									iax = ind[a_] * 2;
									iay = ind[a_] * 2 + 1;
									ibx = ind[b_] * 2;
									iby = ind[b_] * 2 + 1;
									icx = ind[c_] * 2;
									icy = ind[c_] * 2 + 1;

									x1 = v[iax];
									y1 = v[iay];
									x2 = v[ibx];
									y2 = v[iby];
									x3 = v[icx];
									y3 = v[icy];

									switch (c.culling) {

										case POSITIVE:

											if (!isCCW (x1, y1, x2, y2, x3, y3)) {

												i += 3;
												continue;

											}

										case NEGATIVE:

											if (isCCW (x1, y1, x2, y2, x3, y3)) {

												i += 3;
												continue;

											}

										default:


									}

									var context = context;
									context.save ();
									context.beginPath ();
									context.moveTo (x1, y1);
									context.lineTo (x2, y2);
									context.lineTo (x3, y3);
									context.closePath ();

									context.clip ();

									uvx1 = uvt[iax] * pattern.width;
									uvx2 = uvt[ibx] * pattern.width;
									uvx3 = uvt[icx] * pattern.width;
									uvy1 = uvt[iay] * pattern.height;
									uvy2 = uvt[iby] * pattern.height;
									uvy3 = uvt[icy] * pattern.height;

									denom = uvx1 * (uvy3 - uvy2) - uvx2 * uvy3 + uvx3 * uvy2 + (uvx2 - uvx3) * uvy1;

									if (denom == 0) {

										i += 3;
										continue;

									}

									t1 = - (uvy1 * (x3 - x2) - uvy2 * x3 + uvy3 * x2 + (uvy2 - uvy3) * x1) / denom;
									t2 = (uvy2 * y3 + uvy1 * (y2 - y3) - uvy3 * y2 + (uvy3 - uvy2) * y1) / denom;
									t3 = (uvx1 * (x3 - x2) - uvx2 * x3 + uvx3 * x2 + (uvx2 - uvx3) * x1) / denom;
									t4 = - (uvx2 * y3 + uvx1 * (y2 - y3) - uvx3 * y2 + (uvx3 - uvx2) * y1) / denom;
									dx = (uvx1 * (uvy3 * x2 - uvy2 * x3) + uvy1 * (uvx2 * x3 - uvx3 * x2) + (uvx3 * uvy2 - uvx2 * uvy3) * x1) / denom;
									dy = (uvx1 * (uvy3 * y2 - uvy2 * y3) + uvy1 * (uvx2 * y3 - uvx3 * y2) + (uvx3 * uvy2 - uvx2 * uvy3) * y1) / denom;

									context.transform (t1, t2, t3, t4, dx, dy);
									context.drawImage (pattern, 0, 0);
									context.restore ();

									i += 3;

								}


							default:

								data.skip (type);

						}

					}

				}

				endRenderStep();

				drawCommandReaderPool.put (data);

				var bitmap = BitmapData.fromCanvas (graphics.__canvas, scaleX, scaleY);

				var bounds = graphics.__bounds;

				if (graphics.snapCoordinates) {
					throw ":TODO: handle snapCoordinates";
				}

				bitmap.__offsetX = bounds.x * scaleX;
				bitmap.__offsetY = bounds.y * scaleY;
				bitmap.__padding = padding;

				graphics.__bitmap = bitmap;

				if (graphics.__symbol != null) {

					graphics.__symbol.setCachedBitmapData (graphics.__bitmap);

				}

			}

			graphics.__dirty = false;

		}

		#end

	}

	#if (js && html5)
	private inline static function cubicCurveTo(data:DrawCommandReader)
	{
		var c = data.readCubicCurveTo();
		context.bezierCurveTo (c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
	}

	private inline static function curveTo(data:DrawCommandReader)
	{
		var c = data.readCurveTo();
		context.quadraticCurveTo (c.controlX, c.controlY, c.anchorX, c.anchorY);
	}

	private inline static function snappedCurveTo(data:DrawCommandReader)
	{
		var c = data.readCurveTo();
		var anchorX = currentTransform.__transformX (c.anchorX, c.anchorY);
		var anchorY = currentTransform.__transformY (c.anchorX, c.anchorY);
		var roundedAnchorX = Math.round (anchorX);
		var roundedAnchorY = Math.round (anchorY);
		var deltaX = roundedAnchorX - anchorX;
		var deltaY = roundedAnchorY - anchorY;
		var controlX = currentTransform.__transformX (c.controlX, c.controlY) + deltaX;
		var controlY = currentTransform.__transformY (c.controlX, c.controlY) + deltaY;
		context.quadraticCurveTo (controlX, controlY, roundedAnchorX, roundedAnchorY);
	}

	private inline static function drawCircle(data:DrawCommandReader)
	{
		var c = data.readDrawCircle();
		context.moveTo (c.x + c.radius, c.y);
		context.arc (c.x, c.y, c.radius, 0, Math.PI * 2, true);
	}

	private inline static function drawEllipse(data:DrawCommandReader)
	{
		var c = data.readDrawEllipse();
		var x = c.x;
		var y = c.y;
		var width = c.width;
		var height = c.height;

		var kappa = .5522848,
			ox = (width / 2) * kappa, // control point offset horizontal
			oy = (height / 2) * kappa, // control point offset vertical
			xe = x + width,           // x-end
			ye = y + height,           // y-end
			xm = x + width / 2,       // x-middle
			ym = y + height / 2;       // y-middle

		context.moveTo (x, ym);
		context.bezierCurveTo (x, ym - oy, xm - ox, y, xm, y);
		context.bezierCurveTo (xm + ox, y, xe, ym - oy, xe, ym);
		context.bezierCurveTo (xe, ym + oy, xm + ox, ye, xm, ye);
		context.bezierCurveTo (xm - ox, ye, x, ym + oy, x, ym);
	}

	private inline static function drawImage(data:DrawCommandReader)
	{

		var c = data.readDrawImage();

		context.save ();
		context.transform (c.matrix.a, c.matrix.b, c.matrix.c, c.matrix.d, c.matrix.tx, c.matrix.ty);

		if (!hitTesting) {

			context.drawImage (c.bitmap.image.src, 0.0, 0.0, 1.0, 1.0);

		} else {

			context.rect (0.0, 0.0, 1.0, 1.0);
		}



		context.restore ();

	}

	private inline static function snappedDrawImage(data:DrawCommandReader)
	{

		var c = data.readDrawImage();

		context.save ();

		var matrix = Matrix.pool.get ();
		matrix.copyFrom (c.matrix);
		matrix.concat (currentTransform);

		if (matrix.b != 0.0 || matrix.c != 0.0) {
			Matrix.pool.put (matrix);
			throw "can't use snapping on rotated images";
		}

		context.setTransform (
			Math.round (matrix.a),
			Math.round (matrix.b),
			Math.round (matrix.c),
			Math.round (matrix.d),
			Math.round (matrix.tx),
			Math.round (matrix.ty)
			);

		Matrix.pool.put (matrix);

		if (!hitTesting) {

			context.drawImage (c.bitmap.image.src, 0.0, 0.0, 1.0, 1.0);

		} else {

			context.fillStyle = "white";
			context.fillRect (0.0, 0.0, 1.0, 1.0);

		}

		context.restore ();

	}

	private inline static function drawRoundRect2(data:DrawCommandReader)
	{
		var c = data.readDrawRoundRect();
		drawRoundRect (c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
	}

	private inline static function lineTo(data:DrawCommandReader)
	{
		var c = data.readLineTo();

		context.lineTo (c.x, c.y);
		positionX = c.x;
		positionY = c.y;

	}

	private inline static function snappedLineTo(data:DrawCommandReader)
	{
		var c = data.readLineTo();

		var x = Math.round (currentTransform.__transformX (c.x, c.y));
		var y = Math.round (currentTransform.__transformY (c.x, c.y));

		context.lineTo (x, y);
		positionX = x;
		positionY = y;
	}

	private inline static function moveTo(data:DrawCommandReader)
	{
		var c = data.readMoveTo();
		context.moveTo (c.x, c.y);

		positionX = c.x;
		positionY = c.y;

		closeGap = true;
		startX = c.x;
		startY = c.y;
	}

	private inline static function snappedMoveTo(data:DrawCommandReader)
	{
		var c = data.readMoveTo();

		var x = Math.round (currentTransform.__transformX (c.x, c.y));
		var y = Math.round (currentTransform.__transformY (c.x, c.y));

		context.moveTo (x, y);

		positionX = x;
		positionY = y;

		closeGap = true;
		startX = x;
		startY = y;
	}

	private inline static function lineStyle(data:DrawCommandReader, isMask:Bool)
	{
		var c = data.readLineStyle ();
		if (hasStroke || hasFill) {


			if (!hitTesting) {
				if(hasStroke) {
					context.stroke ();
				}

				context.closePath ();

				if(hasFill) {
					context.fill(canvasWindingRule);
				}
			} else {
				context.closePath ();
			}

			context.beginPath ();

		}

		context.moveTo (positionX, positionY);

		if (c.thickness == null) {

			hasStroke = false;

		} else {

			context.lineWidth = (c.thickness > 0 ? Math.max(c.thickness,1) : 1);
			context.lineJoin = (c.joints == null ? "round" : Std.string (c.joints).toLowerCase ());
			context.lineCap = (c.caps == null ? "round" : switch (c.caps) {
				case CapsStyle.NONE: "butt";
				default: Std.string (c.caps).toLowerCase ();
			});

			context.miterLimit = c.miterLimit;

			if (isMask) {

				context.strokeStyle = "white";

			} else if (c.alpha == 1) {

				context.strokeStyle = "#" + StringTools.hex (c.color & 0x00FFFFFF, 6);

			} else {

				var r = (c.color & 0xFF0000) >>> 16;
				var g = (c.color & 0x00FF00) >>> 8;
				var b = (c.color & 0x0000FF);

				context.strokeStyle = "rgba(" + r + ", " + g + ", " + b + ", " + c.alpha + ")";

			}

			hasStroke = c.alpha > 0;

		}
	}

	private inline static function lineGradientStyle(data:DrawCommandReader, isMask:Bool)
	{
		var c = data.readLineGradientStyle ();
		if (hasStroke) {

			closePath ();

		}

		context.moveTo (positionX, positionY);
		if (isMask) {
			context.strokeStyle = "white";
		} else {
			context.strokeStyle = createGradientPattern (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
		}

		hasStroke = true;
	}

	private inline static function lineBitmapStyle(data:DrawCommandReader, isMask:Bool)
	{
		var c = data.readLineBitmapStyle ();
		if (hasStroke) {

			closePath ();

		}

		context.moveTo (positionX, positionY);
		if (isMask) {
			context.strokeStyle = "white";
		} else {
			context.strokeStyle = createBitmapFill (c.bitmap, c.repeat);
		}

		hasStroke = true;
	}

	private inline static function beginBitmapFill(data:DrawCommandReader, isMask:Bool)
	{
		var c = data.readBeginBitmapFill ();

		if (isMask || c.bitmap == null) {
			context.fillStyle = "white";
		} else {

			context.fillStyle = createBitmapFill (c.bitmap, c.repeat);
			hasFill = true;

			if (c.matrix != null) {

				pendingMatrix = c.matrix;
				if ( inversePendingMatrix == null ) {
					inversePendingMatrix = Matrix.pool.get();
				}
				inversePendingMatrix.copyFrom(c.matrix);
				inversePendingMatrix.invert ();

			} else {

				pendingMatrix = null;
				if ( inversePendingMatrix != null ) {
					Matrix.pool.put(inversePendingMatrix);
					inversePendingMatrix = null;
				}

			}
		}
	}

	private inline static function beginFill(data:DrawCommandReader, isMask:Bool)
	{
		var c = data.readBeginFill ();
		if (c.alpha < 0.005) {

			hasFill = false;

		} else {

			if (isMask) {

				context.fillStyle = "white";

			} else if (c.alpha == 1) {

				context.fillStyle = "#" + StringTools.hex (c.color, 6);

			} else {

				var r = (c.color & 0xFF0000) >>> 16;
				var g = (c.color & 0x00FF00) >>> 8;
				var b = (c.color & 0x0000FF);

				context.fillStyle = "rgba(" + r + ", " + g + ", " + b + ", " + c.alpha + ")";

			}

			hasFill = true;

		}
	}

	private inline static function beginGradientFill(data:DrawCommandReader, isMask:Bool)
	{
		var c = data.readBeginGradientFill ();

		if (isMask) {
			context.fillStyle = "white";
		} else {
			context.fillStyle = createGradientPattern (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
		}

		pendingMatrix = c.matrix;
		hasFill = true;
	}

	private inline static function drawRect(data:DrawCommandReader)
	{
		var c = data.readDrawRect ();
		var optimizationUsed = false;

		if (!optimizationUsed) {

			context.rect (c.x, c.y, c.width, c.height);

		}
	}
	#end
}
