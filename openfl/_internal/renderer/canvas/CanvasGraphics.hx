package openfl._internal.renderer.canvas;

import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.CapsStyle;
import openfl.display.DisplayObject;
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
@:access(openfl.display.Tilesheet)


class CanvasGraphics {
	
	
	private static var SIN45 = 0.70710678118654752440084436210485;
	private static var TAN22 = 0.4142135623730950488016887242097;
	
	private static var bitmapFill:BitmapData;
	private static var bitmapStroke:BitmapData;
	private static var bitmapRepeat:Bool;
	private static var bounds:Rectangle;
	private static var fillCommands = new Array<DrawCommand> ();
	private static var graphics:Graphics;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var hitTesting:Bool;
	private static var inversePendingMatrix:Matrix;
	private static var pendingMatrix:Matrix;
	private static var strokeCommands = new Array<DrawCommand> ();
	
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
		
		#end
		
		return null;
		
	}
	
	
	private static function createGradientPattern (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix, spreadMethod:Null<SpreadMethod>, interpolationMethod:Null<InterpolationMethod>, focalPointRatio:Null<Float>) {
	
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
		if (!hitTesting) context.fill ();
		return canvas;
		#end
		
	}
	
	
	private static function drawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float):Void {
		
		#if (js && html5)
		if (ry == -1) ry = rx;
		
		rx *= 0.5;
		ry *= 0.5;
		
		if (rx > width / 2) rx = width / 2;
		if (ry > height / 2) ry = height / 2;
		
		var xe = x + width,
		ye = y + height,
		cx1 = -rx + (rx * SIN45),
		cx2 = -rx + (rx * TAN22),
		cy1 = -ry + (ry * SIN45),
		cy2 = -ry + (ry * TAN22);
		
		context.moveTo (xe, ye - ry);
		context.quadraticCurveTo (xe, ye + cy2, xe + cx1, ye + cy1);
		context.quadraticCurveTo (xe + cx2, ye, xe - rx, ye);
		context.lineTo (x + rx, ye);
		context.quadraticCurveTo (x - cx2, ye, x - cx1, ye + cy1);
		context.quadraticCurveTo (x, ye + cy2, x, ye - ry);
		context.lineTo (x, y + ry);
		context.quadraticCurveTo (x, y - cy2, x - cx1, y - cy1);
		context.quadraticCurveTo (x - cx2, y, x + rx, y);
		context.lineTo (xe - rx, y);
		context.quadraticCurveTo (xe + cx2, y, xe + cx1, y - cy1);
		context.quadraticCurveTo (xe, y - cy2, xe, y + ry);
		context.lineTo (xe, ye - ry);
		#end
		
	}
	
	
	private static function endFill ():Void {
		
		#if (js && html5)
		context.beginPath ();
		playCommands (fillCommands, false);
		fillCommands.splice (0, fillCommands.length);
		#end
		
	}
	
	
	private static function endStroke ():Void {
		
		#if (js && html5)
		context.beginPath ();
		playCommands (strokeCommands, true);
		context.closePath ();
		strokeCommands.splice (0, strokeCommands.length);
		#end
		
	}
	
	
	public static function hitTest (graphics:Graphics, x:Float, y:Float):Bool {
		
		#if (js && html5)
		
		if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width <= 0 || bounds.height <= 0) {
			
			graphics.__canvas = null;
			graphics.__context = null;
			graphics.__bitmap = null;
			
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
			
			fillCommands.splice (0, fillCommands.length);
			strokeCommands.splice (0, strokeCommands.length);
			
			hasFill = false;
			hasStroke = false;
			bitmapFill = null;
			bitmapRepeat = false;
			
			context.beginPath ();
			
			for (command in graphics.__commands) {
				
				switch (command) {
					
					case CubicCurveTo (_, _, _, _, _, _), CurveTo (_, _, _, _), LineTo (_, _), MoveTo (_, _):
						
						fillCommands.push (command);
						strokeCommands.push (command);
					
					case LineStyle (_, _, _, _, _, _, _, _), LineGradientStyle (_, _, _, _, _, _, _, _), LineBitmapStyle (_, _, _, _):
						
						strokeCommands.push (command);
					
					case EndFill:
						
						endFill ();
						endStroke ();
						
						if (hasFill && context.isPointInPath (x, y)) {
							
							return true;
							
						}
						
						if (hasStroke && (context:Dynamic).isPointInStroke (x, y)) {
							
							return true;
							
						}
						
						hasFill = false;
						bitmapFill = null;
						
					case BeginBitmapFill (_, _, _, _), BeginFill (_, _), BeginGradientFill (_, _, _, _, _, _, _, _):
						
						endFill ();
						endStroke ();
						
						if (hasFill && context.isPointInPath (x, y)) {
							
							return true;
							
						}
						
						if (hasStroke && (context:Dynamic).isPointInStroke (x, y)) {
							
							return true;
							
						}
						
						fillCommands.push (command);
						strokeCommands.push (command);
					
					case DrawCircle (_, _, _), DrawEllipse (_, _, _, _), DrawRect (_, _, _, _), DrawRoundRect (_, _, _, _, _, _):
						
						fillCommands.push (command);
						strokeCommands.push (command);
						
					
					default:
						
					
				}
				
			}
			
			if (fillCommands.length > 0) {
				
				endFill ();
				
			}
			
			if (strokeCommands.length > 0) {
				
				endStroke ();
				
			}
			
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
	
	
	private static function playCommands (commands:Array<DrawCommand>, stroke:Bool = false):Void {
		
		#if (js && html5)
		bounds = graphics.__bounds;
		
		var offsetX = bounds.x;
		var offsetY = bounds.y;
		
		var positionX = 0.0;
		var positionY = 0.0;
		
		var closeGap = false;
		var startX = 0.0;
		var startY = 0.0;
		
		for (command in commands) {
			
			switch (command) {
				
				case CubicCurveTo (cx1, cy1, cx2, cy2, x, y):
					
					context.bezierCurveTo (cx1 - offsetX, cy1 - offsetY, cx2 - offsetX, cy2 - offsetY, x - offsetX, y - offsetY);
				
				case CurveTo (cx, cy, x, y):
					
					context.quadraticCurveTo (cx - offsetX, cy - offsetY, x - offsetX, y - offsetY);
				
				case DrawCircle (x, y, radius):
					
					context.moveTo (x - offsetX + radius, y - offsetY);
					context.arc (x - offsetX, y - offsetY, radius, 0, Math.PI * 2, true);
				
				case DrawEllipse (x, y, width, height):
					
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
				
				case DrawRoundRect (x, y, width, height, rx, ry):
					
					drawRoundRect (x - offsetX, y - offsetY, width, height, rx, ry);
				
				case LineTo (x, y):
					
					context.lineTo (x - offsetX, y - offsetY);
					
					positionX = x;
					positionY = y;
				
				case MoveTo (x, y):
					
					context.moveTo (x - offsetX, y - offsetY);
					
					positionX = x;
					positionY = y;
					
					closeGap = true;
					startX = x;
					startY = y;
				
				case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
					
					if (stroke && hasStroke) {
						
						context.closePath ();
						if (!hitTesting) context.stroke ();
						context.beginPath ();
						
					}
					
					context.moveTo (positionX - offsetX, positionY - offsetY);
					
					if (thickness == null) {
						
						hasStroke = false;
						
					} else {
						
						context.lineWidth = thickness;
						
						context.lineJoin = (joints == null ? "round" : Std.string (joints).toLowerCase ());
						context.lineCap = (caps == null ? "round" : switch (caps) {
							case CapsStyle.NONE: "butt";
							default: Std.string (caps).toLowerCase ();
						});
						
						context.miterLimit = (miterLimit == null ? 3 : miterLimit);
						
						if (alpha == 1 || alpha == null) {
							
							context.strokeStyle = (color == null ? "#000000" : "#" + StringTools.hex (color & 0x00FFFFFF, 6));
							
						} else {
							
							var r = (color & 0xFF0000) >>> 16;
							var g = (color & 0x00FF00) >>> 8;
							var b = (color & 0x0000FF);
							
							context.strokeStyle = (color == null ? "#000000" : "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")");
							
						}
						
						hasStroke = true;
						
					}
				
				case LineGradientStyle  (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):
					
					if (stroke && hasStroke) {
						
						closePath ();
						
					}
					
					context.moveTo (positionX - offsetX, positionY - offsetY);
					context.strokeStyle = createGradientPattern (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
					
					hasStroke = true;
					
				case LineBitmapStyle  (bitmap, matrix, repeat, smooth):
					
					if (stroke && hasStroke) {
						
						closePath ();
						
					}
					
					context.moveTo (positionX - offsetX, positionY - offsetY);
					context.strokeStyle = createBitmapFill (bitmap, repeat);
					
					hasStroke = true;
					
				case BeginBitmapFill (bitmap, matrix, repeat, smooth):
					
					context.fillStyle = createBitmapFill (bitmap, true);
					hasFill = true;
					
					if (matrix != null) {
						
						pendingMatrix = matrix;
						inversePendingMatrix = matrix.clone ();
						inversePendingMatrix.invert ();
						
					} else {
						
						pendingMatrix = null;
						inversePendingMatrix = null;
						
					}
				
				case BeginFill (rgb, alpha):
					
					if (alpha < 0.005) {
						
						hasFill = false;
						
					} else {
						
						if (alpha == 1) {
							
							context.fillStyle = "#" + StringTools.hex (rgb, 6);
							
						} else {
							
							var r = (rgb & 0xFF0000) >>> 16;
							var g = (rgb & 0x00FF00) >>> 8;
							var b = (rgb & 0x0000FF);
							
							context.fillStyle = "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")";
							
						}
						
						bitmapFill = null;
						hasFill = true;
						
					}
				
				case BeginGradientFill (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):
					
					context.fillStyle = createGradientPattern (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
					
					bitmapFill = null;
					hasFill = true;
				
				case DrawRect (x, y, width, height):
					
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
								
								var stl = inversePendingMatrix.transformPoint (new Point (x, y));
								var sbr = inversePendingMatrix.transformPoint (new Point (x + width, y + height));
								
								st = stl.y;
								sl = stl.x;
								sb = sbr.y;
								sr = sbr.x;
								
							}
							
						} else {
							
							st = y;
							sl = x;
							sb = y + height;
							sr = x + width;
							
						}
						
						if (canOptimizeMatrix && st >= 0 && sl >= 0 && sr <= bitmapFill.width && sb <= bitmapFill.height) {
							
							optimizationUsed = true;
							if (!hitTesting) context.drawImage (bitmapFill.image.src, sl, st, sr - sl, sb - st, x - offsetX, y - offsetY, width, height);
							
						}
					}
					
					if (!optimizationUsed) {
						
						context.rect (x - offsetX, y - offsetY, width, height);
						
					}
					
				
				default:
					
			}
			
		}
		
		if (stroke && hasStroke) {
			
			if (hasFill && closeGap) {
				
				context.lineTo (startX - offsetX, startY - offsetY);
				
			}
			
			if (!hitTesting) context.stroke ();
			
		}
		
		if (!stroke) {
			
			if (hasFill || bitmapFill != null) {
				
				context.translate (-bounds.x, -bounds.y);
				
				if (pendingMatrix != null) {
					
					context.transform (pendingMatrix.a, pendingMatrix.b, pendingMatrix.c, pendingMatrix.d, pendingMatrix.tx, pendingMatrix.ty);
					if (!hitTesting) context.fill ();
					context.transform (inversePendingMatrix.a, inversePendingMatrix.b, inversePendingMatrix.c, inversePendingMatrix.d, inversePendingMatrix.tx, inversePendingMatrix.ty);
					
				} else {
					
					if (!hitTesting) context.fill ();
					
				}
				
				context.translate (bounds.x, bounds.y);
				context.closePath ();
				
			}
			
		}
		#end
		
	}
	
	
	public static function render (graphics:Graphics, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		if (graphics.__dirty) {
			
			hitTesting = false;
			
			CanvasGraphics.graphics = graphics;
			bounds = graphics.__bounds;
			
			if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width <= 0 || bounds.height <= 0) {
				
				graphics.__canvas = null;
				graphics.__context = null;
				graphics.__bitmap = null;
				
			} else {
				
				if (graphics.__canvas == null) {
					
					graphics.__canvas = cast Browser.document.createElement ("canvas");
					graphics.__context = graphics.__canvas.getContext ("2d");
					
				}
				
				context = graphics.__context;
				
				graphics.__canvas.width = Math.ceil (bounds.width);
				graphics.__canvas.height = Math.ceil (bounds.height);
				
				fillCommands.splice (0, fillCommands.length);
				strokeCommands.splice (0, strokeCommands.length);
				
				hasFill = false;
				hasStroke = false;
				bitmapFill = null;
				bitmapRepeat = false;
				
				for (command in graphics.__commands) {
					
					switch (command) {
						
						case CubicCurveTo (_, _, _, _, _, _), CurveTo (_, _, _, _), LineTo (_, _), MoveTo (_, _):
							
							fillCommands.push (command);
							strokeCommands.push (command);
						
						case EndFill:
							
							endFill ();
							endStroke ();
							hasFill = false;
							bitmapFill = null;
						
						case LineStyle (_, _, _, _, _, _, _, _), LineGradientStyle (_, _, _, _, _, _, _, _), LineBitmapStyle (_, _, _, _):
							
							strokeCommands.push (command);
							
						case BeginBitmapFill (_, _, _, _), BeginFill (_, _), BeginGradientFill (_, _, _, _, _, _, _, _):
							
							endFill ();
							endStroke ();
							
							fillCommands.push (command);
							strokeCommands.push (command);
						
						case DrawCircle (_, _, _), DrawEllipse (_, _, _, _), DrawRect (_, _, _, _), DrawRoundRect (_, _, _, _, _, _):
							
							fillCommands.push (command);
							strokeCommands.push (command);
							
						case DrawTriangles (vertices, indices, uvtData, culling, _, _):
							
							endFill ();
							endStroke ();
							
							var v = vertices;
							var ind = indices;
							var uvt = uvtData;
							var pattern:CanvasElement = null;
							var colorFill = bitmapFill == null;
							
							if (colorFill && uvt != null) {
								
								// Flash doesn't draw anything if the fill isn't a bitmap and there are uvt values
								break;
								
							}
							
							if (!colorFill) {
								
								//TODO move this to Graphics?
								
								if (uvtData == null) {
									
									uvtData = new Vector<Float> ();
									
									for (i in 0...(Std.int (v.length / 2))) {
										
										uvtData.push (v[i * 2] / bitmapFill.width);
										uvtData.push (v[i * 2 + 1] / bitmapFill.height);
										
									}
									
								}
								
								var skipT = uvtData.length != v.length;
								var normalizedUVT = normalizeUVT (uvtData, skipT);
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
							
							var a:Int, b:Int, c:Int;
							var iax:Int, iay:Int, ibx:Int, iby:Int, icx:Int, icy:Int;
							var x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float;
							var uvx1:Float, uvy1:Float, uvx2:Float, uvy2:Float, uvx3:Float, uvy3:Float;
							var denom:Float;
							var t1:Float, t2:Float, t3:Float, t4:Float;
							var dx:Float, dy:Float;
							
							while (i < l) {
								
								a = i;
								b = i + 1;
								c = i + 2;
								
								iax = ind[a] * 2;
								iay = ind[a] * 2 + 1;
								ibx = ind[b] * 2;
								iby = ind[b] * 2 + 1;
								icx = ind[c] * 2;
								icy = ind[c] * 2 + 1;
								
								x1 = v[iax];
								y1 = v[iay];
								x2 = v[ibx];
								y2 = v[iby];
								x3 = v[icx];
								y3 = v[icy];
								
								switch (culling) {
									
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
									if (!hitTesting) context.fill ();
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
							
						case DrawTiles (sheet, tileData, smooth, flags, count):
							
							var useScale = (flags & Graphics.TILE_SCALE) > 0;
							var useRotation = (flags & Graphics.TILE_ROTATION) > 0;
							var useTransform = (flags & Graphics.TILE_TRANS_2x2) > 0;
							var useRGB = (flags & Graphics.TILE_RGB) > 0;
							var useAlpha = (flags & Graphics.TILE_ALPHA) > 0;
							var useRect = (flags & Graphics.TILE_RECT) > 0;
							var useOrigin = (flags & Graphics.TILE_ORIGIN) > 0;
							var useBlendAdd = (flags & Graphics.TILE_BLEND_ADD) > 0;
							
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
							
							var totalCount = tileData.length;
							if (count >= 0 && totalCount > count) totalCount = count;
							var itemCount = Std.int (totalCount / numValues);
							var index = 0;
							
							var rect = null;
							var center = null;
							var previousTileID = -1;
							
							var surface:Dynamic;
							sheet.__bitmap.__sync ();
							surface = sheet.__bitmap.image.src;
							
							if (useBlendAdd) {
								
								context.globalCompositeOperation = "lighter";
								
							}
							
							while (index < totalCount) {
								
								var tileID = (!useRect) ? Std.int (tileData[index + 2]) : -1;
								
								if (!useRect && tileID != previousTileID) {
									
									rect = sheet.__tileRects[tileID];
									center = sheet.__centerPoints[tileID];
									
									previousTileID = tileID;
									
								} else if (useRect) {
									
									rect = sheet.__rectTile;
									rect.setTo (tileData[index + 2], tileData[index + 3], tileData[index + 4], tileData[index + 5]);
									center = sheet.__point;
									
									if (useOrigin) {
										
										center.setTo (tileData[index + 6], tileData[index + 7]);
										
									} else {
										
										center.setTo (0, 0);
										
									}
									
								}
								
								if (rect != null && rect.width > 0 && rect.height > 0 && center != null) {
									
									context.save ();
									context.translate (tileData[index], tileData[index + 1]);
									
									if (useRotation) {
										
										context.rotate (tileData[index + rotationIndex]);
										
									}
									
									var scale = 1.0;
									
									if (useScale) {
										
										scale = tileData[index + scaleIndex];
										
									}
									
									if (useTransform) {
										
										context.transform (tileData[index + transformIndex], tileData[index + transformIndex + 1], tileData[index + transformIndex + 2], tileData[index + transformIndex + 3], 0, 0);
										
									}
									
									if (useAlpha) {
										
										context.globalAlpha = tileData[index + alphaIndex];
										
									}
									
									context.drawImage (surface, rect.x, rect.y, rect.width, rect.height, -center.x * scale, -center.y * scale, rect.width * scale, rect.height * scale);
									context.restore ();
									
								}
								
								index += numValues;
								
							}
							
							if (useBlendAdd) {
								
								context.globalCompositeOperation = "source-over";
								
							}
						
						default:
							
							openfl.Lib.notImplemented ("CanvasGraphics");
						
					}
					
				}
				
				if (fillCommands.length > 0) {
					
					endFill ();
					
				}
				
				if (strokeCommands.length > 0) {
					
					endStroke ();
					
				}
				
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
			
			for (command in graphics.__commands) {
				
				switch (command) {
					
					case CubicCurveTo (cx1, cx2, cy1, cy2, x, y):
						
						context.bezierCurveTo (cx1 - offsetX, cy1 - offsetY, cx2 - offsetX, cy2 - offsetY, x - offsetX, y - offsetY);
						positionX = x;
						positionY = y;
					
					case CurveTo (cx, cy, x, y):
						
						context.quadraticCurveTo (cx - offsetX, cy - offsetY, x - offsetX, y - offsetY);
						positionX = x;
						positionY = y;
					
					case DrawCircle (x, y, radius):
						
						context.arc (x - offsetX, y - offsetY, radius, 0, Math.PI * 2, true);
					
					case DrawEllipse (x, y, width, height):
						
						x -= offsetX;
						y -= offsetY;
						
						var kappa = .5522848,
							ox = (width / 2) * kappa, // control point offset horizontal
							oy = (height / 2) * kappa, // control point offset vertical
							xe = x + width,           // x-end
							ye = y + height,           // y-end
							xm = x + width / 2,       // x-middle
							ym = y + height / 2;       // y-middle
						
						//closePath (false);
						//beginPath ();
						context.moveTo (x, ym);
						context.bezierCurveTo (x, ym - oy, xm - ox, y, xm, y);
						context.bezierCurveTo (xm + ox, y, xe, ym - oy, xe, ym);
						context.bezierCurveTo (xe, ym + oy, xm + ox, ye, xm, ye);
						context.bezierCurveTo (xm - ox, ye, x, ym + oy, x, ym);
						//closePath (false);
					
					case DrawRect (x, y, width, height):
						
						context.rect (x - offsetX, y - offsetY, width, height);
					
					case DrawRoundRect (x, y, width, height, rx, ry):
						
						drawRoundRect (x - offsetX, y - offsetY, width, height, rx, ry);
					
					case LineTo (x, y):
						
						context.lineTo (x - offsetX, y - offsetY);
						positionX = x;
						positionY = y;
						
					case MoveTo (x, y):
						
						context.moveTo (x - offsetX, y - offsetY);
						positionX = x;
						positionY = y;
					
					default:
					
				}
				
			}
			
		}
		
		#end
		
	}
	
	
}