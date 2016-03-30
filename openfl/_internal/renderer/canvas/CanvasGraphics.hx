package openfl._internal.renderer.canvas;

import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.CapsStyle;
import openfl.display.DisplayObject;
import openfl._internal.renderer.DrawCommandBuffer;
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
    #if (haxe_ver >= 3.2)
    import js.html.CanvasWindingRule;
    #end
import js.Browser;
import js.html.ImageData;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.Tilesheet)


class CanvasGraphics {
	
	
	private static var SIN45 = 0.70710678118654752440084436210485;
	private static var TAN22 = 0.4142135623730950488016887242097;
	
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
	
	#if (js && html5)
	private static var context:CanvasRenderingContext2D;
	#end
	
	
	private static function closePath ():Void {
		
		#if (js && html5)
		
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
		
		switch (type) {
			
			case RADIAL:
				
				if (matrix == null) matrix = new Matrix ();
				var point = matrix.transformPoint (new Point (1638.4, 0));
				gradientFill = context.createRadialGradient (matrix.tx, matrix.ty, 0, matrix.tx, matrix.ty, (point.x - matrix.tx) / 2);
			
			case LINEAR:
				
				var matrix = matrix != null ? matrix : new Matrix ();
				var point1 = matrix.transformPoint (new Point (-819.2, 0));
				var point2 = matrix.transformPoint (new Point (819.2, 0));
				
				gradientFill = context.createLinearGradient (point1.x, point1.y, point2.x, point2.y);
			
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
	
	
	private static function createTempPatternCanvas (bitmap:BitmapData, repeat:Bool, width:Int, height:Int) {
		
		// TODO: Don't create extra canvas elements like this
		
		#if (js && html5)
		var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
		var context = canvas.getContext ("2d");
		
		canvas.width = width;
		canvas.height = height;
		
		context.fillStyle = context.createPattern (bitmap.image.src, repeat ? "repeat" : "no-repeat");
		context.beginPath ();
		context.moveTo (0, 0);
		context.lineTo (0, height);
		context.lineTo (width, height);
		context.lineTo (width, 0);
		context.lineTo (0, 0);
		context.closePath ();
		if (!hitTesting) context.fill (#if (haxe_ver >= 3.2) CanvasWindingRule.EVENODD #end);
		return canvas;
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
	
	
	private static function endFill ():Void {
		
		#if (js && html5)
		context.beginPath ();
		playCommands (fillCommands, false);
		fillCommands.clear();
		#end
		
	}
	
	
	private static function endStroke ():Void {
		
		#if (js && html5)
		context.beginPath ();
		playCommands (strokeCommands, true);
		context.closePath ();
		strokeCommands.clear();
		#end
		
	}
	
	
	public static function hitTest (graphics:Graphics, x:Float, y:Float):Bool {
		
		#if (js && html5)
		
		if (graphics.__commands.length == 0 || bounds == null || bounds.width <= 0 || bounds.height <= 0) {
			
			return false;
			
		} else {
			
			hitTesting = true;
			
			x -= bounds.x;
			y -= bounds.y;
			
			if (graphics.__canvas == null) {
				
				graphics.__canvas = cast Browser.document.createElement ("canvas");
				graphics.__context = graphics.__canvas.getContext ("2d");
				
			}
			
			context = graphics.__context;
			
			fillCommands.clear ();
			strokeCommands.clear ();
			
			hasFill = false;
			hasStroke = false;
			bitmapFill = null;
			bitmapRepeat = false;
			
			context.beginPath ();
			
			var data = new DrawCommandReader (graphics.__commands);
			
			for (type in graphics.__commands.types) {
				
				switch (type) {
					
					case CUBIC_CURVE_TO:
						
						var c = data.readCubicCurveTo ();
						fillCommands.cubicCurveTo (c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						strokeCommands.cubicCurveTo (c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
					
					case CURVE_TO:
						
						var c = data.readCurveTo ();
						fillCommands.curveTo (c.controlX, c.controlY, c.anchorX, c.anchorY);
						strokeCommands.curveTo (c.controlX, c.controlY, c.anchorX, c.anchorY);
					
					case LINE_TO:
						
						var c = data.readLineTo ();
						fillCommands.lineTo (c.x, c.y);
						strokeCommands.lineTo (c.x, c.y);
						
					case MOVE_TO:
						
						var c = data.readMoveTo ();
						fillCommands.moveTo (c.x, c.y);
						strokeCommands.moveTo (c.x, c.y);
					
					case LINE_GRADIENT_STYLE:
						
						var c = data.readLineGradientStyle ();
						strokeCommands.lineGradientStyle (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
					
					case LINE_BITMAP_STYLE:
						
						var c = data.readLineBitmapStyle ();
						strokeCommands.lineBitmapStyle (c.bitmap, c.matrix, c.repeat, c.smooth);
					
					case LINE_STYLE:
						
						var c = data.readLineStyle ();
						strokeCommands.lineStyle (c.thickness, c.color, 1, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
					
					case END_FILL:
						
						data.readEndFill ();
						endFill ();
						endStroke ();
						
						if (hasFill && context.isPointInPath (x, y)) {
							
							data.destroy ();
							return true;
							
						}
						
						if (hasStroke && (context:Dynamic).isPointInStroke (x, y)) {
							
							data.destroy ();
							return true;
							
						}
						
						hasFill = false;
						bitmapFill = null;
					
					case BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL:
						
						endFill ();
						endStroke ();
						
						if (hasFill && context.isPointInPath (x, y)) {
							
							data.destroy ();
							return true;
							
						}
						
						if (hasStroke && (context:Dynamic).isPointInStroke (x, y)) {
							
							data.destroy ();
							return true;
							
						}
						
						if (type == BEGIN_BITMAP_FILL) {
							
							var c = data.readBeginBitmapFill ();
							fillCommands.beginBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth);
							strokeCommands.beginBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth);
							
						} else if (type == BEGIN_GRADIENT_FILL) {
							
							var c = data.readBeginGradientFill ();
							fillCommands.beginGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
							strokeCommands.beginGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
							
						} else {
							
							var c = data.readBeginFill ();
							fillCommands.beginFill (c.color, 1);
							strokeCommands.beginFill (c.color, 1);
							
						}
					
					case DRAW_CIRCLE:
						
						var c = data.readDrawCircle ();
						fillCommands.drawCircle (c.x, c.y, c.radius);
						strokeCommands.drawCircle (c.x, c.y, c.radius);
					
					case DRAW_ELLIPSE:
						
						var c = data.readDrawEllipse ();
						fillCommands.drawEllipse (c.x, c.y, c.width, c.height);
						strokeCommands.drawEllipse (c.x, c.y, c.width, c.height);
					
					case DRAW_RECT:
						
						var c = data.readDrawRect ();
						fillCommands.drawRect (c.x, c.y, c.width, c.height);
						strokeCommands.drawRect (c.x, c.y, c.width, c.height);
					
					case DRAW_ROUND_RECT:
						
						var c = data.readDrawRoundRect ();
						fillCommands.drawRoundRect (c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
						strokeCommands.drawRoundRect (c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
					
					default:
						
						data.skip (type);
					
				}
				
			}
			
			if (fillCommands.length > 0) {
				
				endFill ();
				
			}
			
			if (strokeCommands.length > 0) {
				
				endStroke ();
				
			}
			
			data.destroy ();
			
			if (hasFill && context.isPointInPath (x, y)) {
				
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
	
	
	private static function playCommands (commands:DrawCommandBuffer, stroke:Bool = false):Void {
		
		#if (js && html5)
		bounds = graphics.__bounds;
		
		var offsetX = bounds.x;
		var offsetY = bounds.y;
		
		var positionX = 0.0;
		var positionY = 0.0;
		
		var closeGap = false;
		var startX = 0.0;
		var startY = 0.0;
		
		var data = new DrawCommandReader (commands);
		
		for (type in commands.types) {
			
			switch (type) {
				
				case CUBIC_CURVE_TO:
					
					var c = data.readCubicCurveTo ();
					context.bezierCurveTo (c.controlX1 - offsetX, c.controlY1 - offsetY, c.controlX2 - offsetX, c.controlY2 - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);

                    positionX = c.anchorX;
                    positionY = c.anchorY;

				case CURVE_TO:
					
					var c = data.readCurveTo ();
					context.quadraticCurveTo (c.controlX - offsetX, c.controlY - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);

                    positionX = c.anchorX;
                    positionY = c.anchorY;
				
				case DRAW_CIRCLE:
					
					var c = data.readDrawCircle ();
					context.moveTo (c.x - offsetX + c.radius, c.y - offsetY);
					context.arc (c.x - offsetX, c.y - offsetY, c.radius, 0, Math.PI * 2, true);
				
				case DRAW_ELLIPSE:
					
					var c = data.readDrawEllipse ();
					var x = c.x;
					var y = c.y;
					var width = c.width;
					var height = c.height;
					x -= offsetX;
					y -= offsetY;
					
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
				
				case DRAW_ROUND_RECT:
					
					var c = data.readDrawRoundRect ();
					drawRoundRect (c.x - offsetX, c.y - offsetY, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
				
				case LINE_TO:
					
					var c = data.readLineTo ();
					context.lineTo (c.x - offsetX, c.y - offsetY);
					
					positionX = c.x;
					positionY = c.y;
				
				case MOVE_TO:
					
					var c = data.readMoveTo ();
					context.moveTo (c.x - offsetX, c.y - offsetY);
					
					positionX = c.x;
					positionY = c.y;
					
					closeGap = true;
					startX = c.x;
					startY = c.y;
				
				case LINE_STYLE:
					
					var c = data.readLineStyle ();
					if (stroke && hasStroke) {

						if (!hitTesting) context.stroke ();
						context.beginPath ();
						
					}
					
					context.moveTo (positionX - offsetX, positionY - offsetY);
					
					if (c.thickness == null) {
						
						hasStroke = false;
						
					} else {
						
						context.lineWidth = (c.thickness > 0 ? c.thickness : 1);
						
						context.lineJoin = (c.joints == null ? "round" : Std.string (c.joints).toLowerCase ());
						context.lineCap = (c.caps == null ? "round" : switch (c.caps) {
							case CapsStyle.NONE: "butt";
							default: Std.string (c.caps).toLowerCase ();
						});
						
						context.miterLimit = c.miterLimit;
						
						if (c.alpha == 1) {
							
							context.strokeStyle = "#" + StringTools.hex (c.color & 0x00FFFFFF, 6);
							
						} else {
							
							var r = (c.color & 0xFF0000) >>> 16;
							var g = (c.color & 0x00FF00) >>> 8;
							var b = (c.color & 0x0000FF);
							
							context.strokeStyle = "rgba(" + r + ", " + g + ", " + b + ", " + c.alpha + ")";
							
						}
						
						hasStroke = true;
						
					}
				
				case LINE_GRADIENT_STYLE:
					
					var c = data.readLineGradientStyle ();
					if (stroke && hasStroke) {
						
						closePath ();
						
					}
					
					context.moveTo (positionX - offsetX, positionY - offsetY);
					context.strokeStyle = createGradientPattern (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
					
					hasStroke = true;
				
				case LINE_BITMAP_STYLE:
					
					var c = data.readLineBitmapStyle ();
					if (stroke && hasStroke) {
						
						closePath ();
						
					}
					
					context.moveTo (positionX - offsetX, positionY - offsetY);
					context.strokeStyle = createBitmapFill (c.bitmap, c.repeat);
					
					hasStroke = true;
				
				case BEGIN_BITMAP_FILL:
					
					var c = data.readBeginBitmapFill ();
					context.fillStyle = createBitmapFill (c.bitmap, true);
					hasFill = true;
					
					if (c.matrix != null) {
						
						pendingMatrix = c.matrix;
						inversePendingMatrix = c.matrix.clone ();
						inversePendingMatrix.invert ();
						
					} else {
						
						pendingMatrix = null;
						inversePendingMatrix = null;
						
					}
				
				case BEGIN_FILL:
					
					var c = data.readBeginFill ();
					if (c.alpha < 0.005) {
						
						hasFill = false;
						
					} else {
						
						if (c.alpha == 1) {
							
							context.fillStyle = "#" + StringTools.hex (c.color, 6);
							
						} else {
							
							var r = (c.color & 0xFF0000) >>> 16;
							var g = (c.color & 0x00FF00) >>> 8;
							var b = (c.color & 0x0000FF);
							
							context.fillStyle = "rgba(" + r + ", " + g + ", " + b + ", " + c.alpha + ")";
							
						}
						
						bitmapFill = null;
						hasFill = true;
						
					}
				
				case BEGIN_GRADIENT_FILL:
					
					var c = data.readBeginGradientFill ();
					context.fillStyle = createGradientPattern (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
					
					bitmapFill = null;
					hasFill = true;
				
				case DRAW_RECT:
					
					var c = data.readDrawRect ();
					var optimizationUsed = false;
					
					if (bitmapFill != null) {
						
						var st:Float = 0;
						var sr:Float = 0;
						var sb:Float = 0;
						var sl:Float = 0;
						
						var canOptimizeMatrix = true;
						
						if (pendingMatrix != null) {
							
							if (pendingMatrix.b != 0 || pendingMatrix.c != 0) {
								
								canOptimizeMatrix = false;
								
							} else {
								
								var stl = inversePendingMatrix.transformPoint (new Point (c.x, c.y));
								var sbr = inversePendingMatrix.transformPoint (new Point (c.x + c.width, c.y + c.height));
								
								st = stl.y;
								sl = stl.x;
								sb = sbr.y;
								sr = sbr.x;
								
							}
							
						} else {
							
							st = c.y;
							sl = c.x;
							sb = c.y + c.height;
							sr = c.x + c.width;
							
						}
						
						if (canOptimizeMatrix && st >= 0 && sl >= 0 && sr <= bitmapFill.width && sb <= bitmapFill.height) {
							
							optimizationUsed = true;
							if (!hitTesting) context.drawImage (bitmapFill.image.src, sl, st, sr - sl, sb - st, c.x - offsetX, c.y - offsetY, c.width, c.height);
							
						}
					}
					
					if (!optimizationUsed) {
						
						context.rect (c.x - offsetX, c.y - offsetY, c.width, c.height);
						
					}
				
				default:
					
					data.skip (type);
				
			}
			
		}
		
		data.destroy ();
		
		if (stroke && hasStroke) {
			
			if (hasFill && closeGap) {
				
				context.lineTo (startX - offsetX, startY - offsetY);
				
			} else if (closeGap && positionX == startX && positionY == startY) {
				
				context.closePath ();
				
			}
			
			if (!hitTesting) context.stroke ();
			
		}
		
		if (!stroke) {
			
			if (hasFill || bitmapFill != null) {
				
				context.translate (-bounds.x, -bounds.y);
				
				if (pendingMatrix != null) {
					
					context.transform (pendingMatrix.a, pendingMatrix.b, pendingMatrix.c, pendingMatrix.d, pendingMatrix.tx, pendingMatrix.ty);
					if (!hitTesting) context.fill (#if (haxe_ver >= 3.2) CanvasWindingRule.EVENODD #end);
					context.transform (inversePendingMatrix.a, inversePendingMatrix.b, inversePendingMatrix.c, inversePendingMatrix.d, inversePendingMatrix.tx, inversePendingMatrix.ty);
					
				} else {
					
					if (!hitTesting) context.fill (#if (haxe_ver >= 3.2) CanvasWindingRule.EVENODD #end);
					
				}
				
				context.translate (bounds.x, bounds.y);
				context.closePath ();
				
			}
			
		}
		#end
		
	}
	
	
	public static function render (graphics:Graphics, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		// TODO: Handle world transform if we want to use direct render
		
		//var directRender = (graphics.__hardware && renderSession.context != null);
		var directRender = false;
		
		if (graphics.__dirty || directRender) {
			
			hitTesting = false;
			
			CanvasGraphics.graphics = graphics;
			bounds = graphics.__bounds;
			
			if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width <= 0 || bounds.height <= 0) {
				
				graphics.__canvas = null;
				graphics.__context = null;
				graphics.__bitmap = null;
				
			} else {
				
				if (directRender) {
					
					context = cast renderSession.context;
					bounds.setTo (0, 0, context.canvas.width, context.canvas.width);
					
				} else {
					
					if (graphics.__canvas == null) {
						
						graphics.__canvas = cast Browser.document.createElement ("canvas");
						graphics.__context = graphics.__canvas.getContext ("2d");
						
					}
					
					context = graphics.__context;
					
					graphics.__canvas.width = Math.ceil (bounds.width);
					graphics.__canvas.height = Math.ceil (bounds.height);
					
				}
				
				fillCommands.clear ();
				strokeCommands.clear ();
				
				hasFill = false;
				hasStroke = false;
				bitmapFill = null;
				bitmapRepeat = false;
				
				var data = new DrawCommandReader (graphics.__commands);
				
				for (type in graphics.__commands.types) {
					
					switch (type) {
						
						case CUBIC_CURVE_TO:
							
							var c = data.readCubicCurveTo ();
							fillCommands.cubicCurveTo (c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
							strokeCommands.cubicCurveTo (c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						
						case CURVE_TO:
							
							var c = data.readCurveTo ();
							fillCommands.curveTo (c.controlX, c.controlY, c.anchorX, c.anchorY);
							strokeCommands.curveTo (c.controlX, c.controlY, c.anchorX, c.anchorY);
						
						case LINE_TO:
							
							var c = data.readLineTo ();
							fillCommands.lineTo (c.x, c.y);
							strokeCommands.lineTo (c.x, c.y);
						
						case MOVE_TO:
							
							var c = data.readMoveTo ();
							fillCommands.moveTo (c.x, c.y);
							strokeCommands.moveTo (c.x, c.y);
						
						case END_FILL:
							
							data.readEndFill ();
							endFill ();
							endStroke ();
							hasFill = false;
							bitmapFill = null;
						
						case LINE_STYLE:
							
							var c = data.readLineStyle ();
							strokeCommands.lineStyle (c.thickness, c.color, c.alpha, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
						
						case LINE_GRADIENT_STYLE:
							
							var c = data.readLineGradientStyle ();
							strokeCommands.lineGradientStyle (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
						
						case LINE_BITMAP_STYLE:
							
							var c = data.readLineBitmapStyle ();
							strokeCommands.lineBitmapStyle (c.bitmap, c.matrix, c.repeat, c.smooth);
						
						case BEGIN_BITMAP_FILL, BEGIN_FILL, BEGIN_GRADIENT_FILL:
							
							endFill ();
							endStroke ();
							
							if (type == BEGIN_BITMAP_FILL) {
								
								var c = data.readBeginBitmapFill ();
								fillCommands.beginBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth);
								strokeCommands.beginBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth);
								
							} else if (type == BEGIN_GRADIENT_FILL) {
								
								var c = data.readBeginGradientFill ();
								fillCommands.beginGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
								strokeCommands.beginGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
								
							} else {
								
								var c = data.readBeginFill ();
								fillCommands.beginFill (c.color, c.alpha);
								strokeCommands.beginFill (c.color, c.alpha);
								
							}
						
						case DRAW_CIRCLE:
							
							var c = data.readDrawCircle ();
							fillCommands.drawCircle (c.x, c.y, c.radius);
							strokeCommands.drawCircle (c.x, c.y, c.radius);
						
						case DRAW_ELLIPSE:
							
							var c = data.readDrawEllipse ();
							fillCommands.drawEllipse (c.x, c.y, c.width, c.height);
							strokeCommands.drawEllipse (c.x, c.y, c.width, c.height);
						
						case DRAW_RECT:
							
							var c = data.readDrawRect ();
							fillCommands.drawRect (c.x, c.y, c.width, c.height);
							strokeCommands.drawRect (c.x, c.y, c.width, c.height);
						
						case DRAW_ROUND_RECT:
							
							var c = data.readDrawRoundRect ();
							fillCommands.drawRoundRect (c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
							strokeCommands.drawRoundRect (c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
						
						case DRAW_TRIANGLES:
							
							endFill ();
							endStroke ();
							
							var c = data.readDrawTriangles ();
							
							var v = c.vertices;
							var ind = c.indices;
							var uvt = c.uvtData;
							var pattern:CanvasElement = null;
							var colorFill = bitmapFill == null;
							
							if (colorFill && uvt != null) {
								
								// Flash doesn't draw anything if the fill isn't a bitmap and there are uvt values
								break;
								
							}
							
							if (!colorFill) {
								
								//TODO move this to Graphics?
								
								if (uvt == null) {
									
									uvt = new Vector<Float> ();
									
									for (i in 0...(Std.int (v.length / 2))) {
										
										uvt.push (v[i * 2] / bitmapFill.width);
										uvt.push (v[i * 2 + 1] / bitmapFill.height);
										
									}
									
								}
								
								var skipT = uvt.length != v.length;
								var normalizedUVT = normalizeUVT (uvt, skipT);
								var maxUVT = normalizedUVT.max;
								uvt = normalizedUVT.uvt;
								
								if (maxUVT > 1) {
									
									pattern = createTempPatternCanvas (bitmapFill, bitmapRepeat, Std.int (bounds.width), Std.int (bounds.height));
									
								} else {
									
									pattern = createTempPatternCanvas (bitmapFill, bitmapRepeat, bitmapFill.width, bitmapFill.height);
									
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
								
								if (colorFill) {
									
									context.beginPath ();
									context.moveTo (x1, y1);
									context.lineTo (x2, y2);
									context.lineTo (x3, y3);
									context.closePath ();
									if (!hitTesting) context.fill (#if (haxe_ver >= 3.2) CanvasWindingRule.EVENODD #end);
									i += 3;
									continue;
									
								} 
								
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
						
						case DRAW_TILES:
							
							var c = data.readDrawTiles ();
							
							var useScale = (c.flags & Graphics.TILE_SCALE) > 0;
							var offsetX = bounds.x;
							var offsetY = bounds.y;
							
							var useRotation = (c.flags & Graphics.TILE_ROTATION) > 0;
							var useTransform = (c.flags & Graphics.TILE_TRANS_2x2) > 0;
							var useRGB = (c.flags & Graphics.TILE_RGB) > 0;
							var useAlpha = (c.flags & Graphics.TILE_ALPHA) > 0;
							var useRect = (c.flags & Graphics.TILE_RECT) > 0;
							var useOrigin = (c.flags & Graphics.TILE_ORIGIN) > 0;
							var useBlendAdd = (c.flags & Graphics.TILE_BLEND_ADD) > 0;
							
							if (useTransform) { useScale = false; useRotation = false; }
							
							var scaleIndex = 0;
							var rotationIndex = 0;
							var rgbIndex = 0;
							var alphaIndex = 0;
							var transformIndex = 0;
							
							var numValues = 3;
							
							if (useRect) { numValues = useOrigin ? 8 : 6; }
							if (useScale) { scaleIndex = numValues; numValues ++; }
							if (useRotation) { rotationIndex = numValues; numValues ++; }
							if (useTransform) { transformIndex = numValues; numValues += 4; }
							if (useRGB) { rgbIndex = numValues; numValues += 3; }
							if (useAlpha) { alphaIndex = numValues; numValues ++; }
							
							var totalCount = c.tileData.length;
							if (c.count >= 0 && totalCount > c.count) totalCount = c.count;
							var itemCount = Std.int (totalCount / numValues);
							var index = 0;
							
							var rect = null;
							var center = null;
							var previousTileID = -1;
							
							var surface:Dynamic;
							c.sheet.__bitmap.__sync ();
							surface = c.sheet.__bitmap.image.src;
							
							if (useBlendAdd) {
								
								context.globalCompositeOperation = "lighter";
								
							}
							
							while (index < totalCount) {
								
								var tileID = (!useRect) ? Std.int (c.tileData[index + 2]) : -1;
								
								if (!useRect && tileID != previousTileID) {
									
									rect = c.sheet.__tileRects[tileID];
									center = c.sheet.__centerPoints[tileID];
									
									previousTileID = tileID;
									
								} else if (useRect) {
									
									rect = c.sheet.__rectTile;
									rect.setTo (c.tileData[index + 2], c.tileData[index + 3], c.tileData[index + 4], c.tileData[index + 5]);
									center = c.sheet.__point;
									
									if (useOrigin) {
										
										center.setTo (c.tileData[index + 6], c.tileData[index + 7]);
										
									} else {
										
										center.setTo (0, 0);
										
									}
									
								}
								
								if (rect != null && rect.width > 0 && rect.height > 0 && center != null) {
									
									context.save ();
									context.translate (c.tileData[index] - offsetX, c.tileData[index + 1] - offsetY);
									
									if (useRotation) {
										
										context.rotate (c.tileData[index + rotationIndex]);
										
									}
									
									var scale = 1.0;
									
									if (useScale) {
										
										scale = c.tileData[index + scaleIndex];
										
									}
									
									if (useTransform) {
										
										context.transform (c.tileData[index + transformIndex], c.tileData[index + transformIndex + 1], c.tileData[index + transformIndex + 2], c.tileData[index + transformIndex + 3], 0, 0);
										
									}
									
									if (useAlpha) {
										
										context.globalAlpha = c.tileData[index + alphaIndex];
										
									}
									
									context.imageSmoothingEnabled = c.smooth;
									
									context.drawImage (surface, rect.x, rect.y, rect.width, rect.height, -center.x * scale, -center.y * scale, rect.width * scale, rect.height * scale);
									context.restore ();
									
								}
								
								index += numValues;
								
							}
							
							if (useBlendAdd) {
								
								context.globalCompositeOperation = "source-over";
								
							}
						
						default:
							
							data.skip (type);
						
					}
					
				}
				
				if (fillCommands.length > 0) {
					
					endFill ();
					
				}
				
				if (strokeCommands.length > 0) {
					
					endStroke ();
					
				}
				
				data.destroy ();
				graphics.__bitmap = BitmapData.fromCanvas (graphics.__canvas);
				
			}
			
			graphics.__dirty = false;
			
		}
		
		#end
		
	}
	
	
	public static function renderMask (graphics:Graphics, renderSession:RenderSession) {
		
		#if (js && html5)
		
		if (graphics.__commands.length != 0) {
			
			context = cast renderSession.context;
			
			var positionX = 0.0;
			var positionY = 0.0;
			
			var offsetX = 0;
			var offsetY = 0;
			
			var data = new DrawCommandReader (graphics.__commands);
			
			for (type in graphics.__commands.types) {
				
				switch (type) {
					
					case CUBIC_CURVE_TO:
						
						var c = data.readCubicCurveTo ();
						context.bezierCurveTo (c.controlX1 - offsetX, c.controlY1 - offsetY, c.controlX2 - offsetX, c.controlY2 - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);
						positionX = c.anchorX;
						positionY = c.anchorY;
					
					case CURVE_TO:
						
						var c = data.readCurveTo ();
						context.quadraticCurveTo (c.controlX - offsetX, c.controlY - offsetY, c.anchorX - offsetX, c.anchorY - offsetY);
						positionX = c.anchorX;
						positionY = c.anchorY;
					
					case DRAW_CIRCLE:
						
						var c = data.readDrawCircle ();
						context.arc (c.x - offsetX, c.y - offsetY, c.radius, 0, Math.PI * 2, true);
					
					case DRAW_ELLIPSE:
						
						var c = data.readDrawEllipse ();
						var x = c.x;
						var y = c.y;
						var width = c.width;
						var height = c.height;
						x -= offsetX;
						y -= offsetY;
						
						var kappa = .5522848,
							ox = (width / 2) * kappa, // control point offset horizontal
							oy = (height / 2) * kappa, // control point offset vertical
							xe = x + width,           // x-end
							ye = y + height,          // y-end
							xm = x + width / 2,       // x-middle
							ym = y + height / 2;      // y-middle
						
						//closePath (false);
						//beginPath ();
						context.moveTo (x, ym);
						context.bezierCurveTo (x, ym - oy, xm - ox, y, xm, y);
						context.bezierCurveTo (xm + ox, y, xe, ym - oy, xe, ym);
						context.bezierCurveTo (xe, ym + oy, xm + ox, ye, xm, ye);
						context.bezierCurveTo (xm - ox, ye, x, ym + oy, x, ym);
						//closePath (false);
					
					case DRAW_RECT:
						
						var c = data.readDrawRect ();
						context.rect (c.x - offsetX, c.y - offsetY, c.width, c.height);
					
					case DRAW_ROUND_RECT:
						
						var c = data.readDrawRoundRect ();
						drawRoundRect (c.x - offsetX, c.y - offsetY, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
					
					case LINE_TO:
						
						var c = data.readLineTo ();
						context.lineTo (c.x - offsetX, c.y - offsetY);
						positionX = c.x;
						positionY = c.y;
					
					case MOVE_TO:
						
						var c = data.readMoveTo ();
						context.moveTo (c.x - offsetX, c.y - offsetY);
						positionX = c.x;
						positionY = c.y;
					
					default:
						
						data.skip (type);
					
				}
				
			}
			
			data.destroy ();
			
		}
		
		#end
		
	}
	
	
}
