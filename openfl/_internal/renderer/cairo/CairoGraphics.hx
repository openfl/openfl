package openfl._internal.renderer.cairo;


import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoExtend;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
import lime.math.Matrix3;
import lime.math.Vector2;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.CapsStyle;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.Vector;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.Tilesheet)
@:access(openfl.geom.Matrix)


class CairoGraphics {
	
	
	private static var SIN45 = 0.70710678118654752440084436210485;
	private static var TAN22 = 0.4142135623730950488016887242097;
	
	private static var bitmapFill:BitmapData;
	private static var bitmapRepeat:Bool;
	private static var bounds:Rectangle;
	private static var cairo:Cairo;
	private static var fillCommands:Array<DrawCommand>;
	private static var fillPattern:CairoPattern;
	private static var graphics:Graphics;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var inversePendingMatrix:Matrix;
	private static var pendingMatrix:Matrix;
	private static var strokeCommands:Array<DrawCommand>;
	private static var strokePattern:CairoPattern;
	
	
	private static function beginPatternFill (bitmapFill:BitmapData, bitmapRepeat:Bool):Void {
		
		if (hasFill || bitmapFill == null) return;
		
		if (fillPattern == null) {
			
			fillPattern = CairoPattern.createForSurface (bitmapFill.getSurface ());
			
			if (bitmapRepeat) {
				
				fillPattern.extend = CairoExtend.REPEAT;
				
			}
			
		}
		
		cairo.source = fillPattern;
		hasFill = true;
		
	}
	
	
	private static function createTempPatternCanvas (bitmap:BitmapData, repeat:Bool, width:Int, height:Int) {
		
		var surface = new CairoSurface (ARGB32, width, height);
		var pattern = CairoPattern.createForSurface (surface);
		
		if (repeat) {
			
			pattern.extend = CairoExtend.REPEAT;
			
		}
		
		cairo.source = pattern;
		cairo.newPath ();
		cairo.moveTo (0, 0);
		cairo.lineTo (0, height);
		cairo.lineTo (width, height);
		cairo.lineTo (width, 0);
		cairo.lineTo (0, 0);
		cairo.closePath ();
		cairo.fill ();
		pattern.destroy ();
		return surface;
		
		// TODO: Don't create extra canvas elements like this
		
		//#if (js && html5)
		//var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
		//var context = canvas.getContext ("2d");
		//
		//canvas.width = width;
		//canvas.height = height;
		//
		//context.fillStyle = context.createPattern (bitmap.__image.src, repeat ? "repeat" : "no-repeat");
		//context.beginPath ();
		//context.moveTo (0, 0);
		//context.lineTo (0, height);
		//context.lineTo (width, height);
		//context.lineTo (width, 0);
		//context.lineTo (0, 0);
		//context.closePath ();
		//context.fill ();
		//return canvas;
		//#end
		
	}
	
	
	private static function endFill ():Void {
		
		cairo.newPath ();
		playCommands (fillCommands, false);
		fillCommands = [];
		
	}
	
	
	private static function endStroke ():Void {
		
		cairo.newPath ();
		playCommands (strokeCommands, true);
		cairo.closePath ();
		strokeCommands = [];
		
	}
	
	
	private static function drawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float):Void {
		
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
		
		cairo.moveTo (xe, ye - ry);
		quadraticCurveTo (xe, ye + cy2, xe + cx1, ye + cy1);
		quadraticCurveTo (xe + cx2, ye, xe - rx, ye);
		cairo.lineTo (x + rx, ye);
		quadraticCurveTo (x - cx2, ye, x - cx1, ye + cy1);
		quadraticCurveTo (x, ye + cy2, x, ye - ry);
		cairo.lineTo (x, y + ry);
		quadraticCurveTo (x, y - cy2, x - cx1, y - cy1);
		quadraticCurveTo (x - cx2, y, x + rx, y);
		cairo.lineTo (xe - rx, y);
		quadraticCurveTo (xe + cx2, y, xe + cx1, y - cy1);
		quadraticCurveTo (xe, y - cy2, xe, y + ry);
		cairo.lineTo (xe, ye - ry);
		
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
					
					cairo.curveTo (cx1 - offsetX, cy1 - offsetY, cx2 - offsetX, cy2 - offsetY, x - offsetX, y - offsetY);
				
				case CurveTo (cx, cy, x, y):
					
					quadraticCurveTo (cx - offsetX, cy - offsetY, x - offsetX, y - offsetY);
				
				case DrawCircle (x, y, radius):
					
					cairo.moveTo (x - offsetX + radius, y - offsetY);
					cairo.arc (x - offsetX, y - offsetY, radius, 0, Math.PI * 2);
				
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
					
					cairo.moveTo (x, ym);
					cairo.curveTo (x, ym - oy, xm - ox, y, xm, y);
					cairo.curveTo (xm + ox, y, xe, ym - oy, xe, ym);
					cairo.curveTo (xe, ym + oy, xm + ox, ye, xm, ye);
					cairo.curveTo (xm - ox, ye, x, ym + oy, x, ym);
				
				case DrawRoundRect (x, y, width, height, rx, ry):
					
					drawRoundRect (x - offsetX, y - offsetY, width, height, rx, ry);
				
				case LineTo (x, y):
					
					cairo.lineTo (x - offsetX, y - offsetY);
					
					positionX = x;
					positionY = y;
				
				case MoveTo (x, y):
					
					cairo.moveTo (x - offsetX, y - offsetY);
					
					positionX = x;
					positionY = y;
					
					closeGap = true;
					startX = x;
					startY = y;
				
				case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
					
					if (stroke && hasStroke) {
						
						cairo.closePath ();
						cairo.source = strokePattern;
						cairo.strokePreserve ();
						cairo.newPath ();
						
					}
					
					cairo.moveTo (positionX - offsetX, positionY - offsetY);
					
					if (thickness == null) {
						
						hasStroke = false;
						
					} else {
						
						cairo.lineWidth = thickness;
						
						if (joints == null) {
							
							cairo.lineJoin = ROUND;
							
						} else {
							
							cairo.lineJoin = switch (joints) {
								
								case MITER: MITER;
								case BEVEL: BEVEL;
								default: ROUND;
								
							}
							
						}
						
						if (caps == null) {
							
							cairo.lineCap = ROUND;
							
						} else {
							
							cairo.lineCap = switch (caps) {
								
								case NONE: BUTT;
								case SQUARE: SQUARE;
								default: ROUND;
								
							}
							
						}
						
						cairo.miterLimit = (miterLimit == null ? 3 : miterLimit);
						
						if (strokePattern != null) {
							
							strokePattern.destroy ();
							
						}
						
						var r = ((color & 0xFF0000) >>> 16) / 0xFF;
						var g = ((color & 0x00FF00) >>> 8) / 0xFF;
						var b = (color & 0x0000FF) / 0xFF;
						
						if (alpha == 1 || alpha == null) {
							
							strokePattern = CairoPattern.createRGB (r, g, b);
							
						} else {
							
							strokePattern = CairoPattern.createRGBA (r, g, b, alpha);
							
						}
						
						hasStroke = true;
						
					}
				
				case BeginBitmapFill (bitmap, matrix, repeat, smooth):
					
					if (bitmap != bitmapFill || repeat != bitmapRepeat) {
						
						bitmapFill = bitmap;
						bitmapRepeat = repeat;
						
						if (fillPattern != null) {
							
							fillPattern.destroy ();
							
						}
						
						fillPattern = null;
						hasFill = false;
						
						//bitmap.__sync ();
						
					}
					
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
						
						if (fillPattern != null) {
							
							fillPattern.destroy ();
							
						}
						
						fillPattern = CairoPattern.createRGBA (((rgb & 0xFF0000) >>> 16) / 0xFF, ((rgb & 0x00FF00) >>> 8) / 0xFF, (rgb & 0x0000FF) / 0xFF, alpha);
						
						bitmapFill = null;
						hasFill = true;
						
					}
				
				case BeginGradientFill (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):
					
					var gradientFill = null;
					
					switch (type) {
						
						case RADIAL:
							
							if (matrix == null) matrix = new Matrix ();
							var point = matrix.transformPoint (new Point (1638.4, 0));
							
							if (fillPattern != null) {
								
								fillPattern.destroy ();
								
							}
							
							fillPattern = CairoPattern.createRadial (matrix.tx, matrix.ty, 0, matrix.tx, matrix.ty, (point.x - matrix.tx) / 2);
						
						case LINEAR:
							
							var matrix = matrix != null ? matrix.clone () : new Matrix ();
							var point1 = matrix.transformPoint (new Point (-819.2, 0));
							var point2 = matrix.transformPoint (new Point (819.2, 0));
							
							if (fillPattern != null) {
								
								fillPattern.destroy ();
								
							}
							
							fillPattern = CairoPattern.createLinear (point1.x, point1.y, point2.x, point2.y);
						
					}
					
					for (i in 0...colors.length) {
						
						var rgb = colors[i];
						var alpha = alphas[i];
						var r = ((rgb & 0xFF0000) >>> 16) / 0xFF;
						var g = ((rgb & 0x00FF00) >>> 8) / 0xFF;
						var b = (rgb & 0x0000FF) / 0xFF;
						
						var ratio = ratios[i] / 0xFF;
						if (ratio < 0) ratio = 0;
						if (ratio > 1) ratio = 1;
						
						fillPattern.addColorStopRGBA (ratio, r, g, b, alpha);
						
					}
					
					//context.fillStyle = gradientFill;
					
					bitmapFill = null;
					hasFill = true;
				
				case DrawRect (x, y, width, height):
					
					//var optimizationUsed = false;
					//
					//if (bitmapFill != null) {
						//
						//var st:Float = 0;
						//var sr:Float = 0;
						//var sb:Float = 0;
						//var sl:Float = 0;
						//
						//var canOptimizeMatrix = true;
						//
						//if (pendingMatrix != null) {
							//
							//if (pendingMatrix.b != 0 || pendingMatrix.c != 0) {
								//
								//canOptimizeMatrix = false;
								//
							//} else {
								//
								//var stl = inversePendingMatrix.transformPoint (new Point (x, y));
								//var sbr = inversePendingMatrix.transformPoint (new Point (x + width, y + height));
								//
								//st = stl.y;
								//sl = stl.x;
								//sb = sbr.y;
								//sr = sbr.x;
								//
							//}
							//
						//} else {
							//
							//st = y;
							//sl = x;
							//sb = y + height;
							//sr = x + width;
							//
						//}
						//
						//if (canOptimizeMatrix && st >= 0 && sl >= 0 && sr <= bitmapFill.width && sb <= bitmapFill.height) {
							//
							//optimizationUsed = true;
							////context.drawImage (bitmapFill.__image.src, sl, st, sr - sl, sb - st, x - offsetX, y - offsetY, width, height);
						//}
					//}
					//
					//if (!optimizationUsed) {
						
						if (fillPattern != null) {
							
							var matrix = fillPattern.matrix;
							matrix.translate (x, y);
							fillPattern.matrix = matrix;
							
						}
						
						cairo.rectangle (x - offsetX, y - offsetY, width, height);
						
					//}
					
				
				default:
					
			}
			
		}
		
		if (stroke && hasStroke) {
			
			if (hasFill && closeGap) {
				
				cairo.lineTo (startX - offsetX, startY - offsetY);
				
			}
			
			cairo.source = strokePattern;
			cairo.strokePreserve ();
			
		}
		
		if (!stroke) {
			
			if (hasFill || bitmapFill != null) {
				
				if (bitmapFill != null) {
					
					beginPatternFill (bitmapFill, bitmapRepeat);
					
				} else {
					
					cairo.source = fillPattern;
					
				}
				
				cairo.translate (-bounds.x, -bounds.y);
				
				if (pendingMatrix != null) {
					
					cairo.transform (pendingMatrix.__toMatrix3 ());
					cairo.fillPreserve ();
					cairo.transform (inversePendingMatrix.__toMatrix3 ());
					
				} else {
					
					cairo.fillPreserve ();
					
				}
				
				cairo.translate (bounds.x, bounds.y);
				cairo.closePath ();
				//cairo.paint ();
				
			}
			
		}
		
	}
	
	
	private static function quadraticCurveTo (cx:Float, cy:Float, x:Float, y:Float):Void {
		
		var current = null;
		
		if (!cairo.hasCurrentPoint) {
			
			cairo.moveTo (cx, cy);
			current = new Vector2 (cx, cy);
			
		} else {
			
			current = cairo.currentPoint;
			
		}
		
		var cx1 = current.x + ((2 / 3) * (cx - current.x));
		var cy1 = current.y + ((2 / 3) * (cy - current.y));
		var cx2 = x + ((2 / 3) * (cx - x));
		var cy2 = y + ((2 / 3) * (cy - y));
		
		cairo.curveTo (cx1, cy1, cx2, cy2, x, y);
		
	}
	
	
	public static function render (graphics:Graphics, renderSession:RenderSession):Void {
		
		if (graphics.__dirty) {
			
			CairoGraphics.graphics = graphics;
			bounds = graphics.__bounds;
			
			if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0) {
				
				if (graphics.__cairo != null) {
					
					graphics.__cairo.destroy ();
					graphics.__cairo = null;
					
				}
				
			} else {
				
				if (graphics.__cairo != null) {
					
					var surface = graphics.__cairo.target;
					
					if (bounds.width != surface.width || bounds.height != surface.height) {
						
						graphics.__cairo.destroy ();
						graphics.__cairo = null;
						
					}
					
				}
				
				if (graphics.__cairo == null) {
					
					var surface = new CairoSurface (ARGB32, Math.ceil (bounds.width), Math.ceil (bounds.height));
					graphics.__cairo = new Cairo (surface);
					surface.destroy ();
					
				}
				
				cairo = graphics.__cairo;
				
				var offsetX = bounds.x;
				var offsetY = bounds.y;
				
				fillCommands = new Array<DrawCommand> ();
				strokeCommands = new Array<DrawCommand> ();
				
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
						
						case LineStyle (_, _, _, _, _, _, _, _):
							
							strokeCommands.push (command);
						
						case BeginBitmapFill (_, _, _, _), BeginFill (_, _), BeginGradientFill (_, _, _, _, _, _, _, _):
							
							endFill ();
							endStroke ();
							
							fillCommands.push (command);
							strokeCommands.push (command);
						
						case DrawCircle (_, _, _), DrawEllipse (_, _, _, _), DrawRect (_, _, _, _), DrawRoundRect (_, _, _, _, _, _):
							
							endFill ();
							endStroke ();
							
							fillCommands.push (command);
							strokeCommands.push (command);
						
						case DrawTriangles (vertices, indices, uvtData, culling, _, _):
						
							endFill ();
							endStroke ();
							
							var v = vertices;
							var ind = indices;
							var uvt = uvtData;
							var pattern:CairoSurface = null;
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
									
									cairo.newPath ();
									cairo.moveTo (x1, y1);
									cairo.lineTo (x2, y2);
									cairo.lineTo (x3, y3);
									cairo.closePath ();
									cairo.fillPreserve ();
									i += 3;
									continue;
									
								} 
								
								cairo.save ();
								cairo.newPath ();
								cairo.moveTo (x1, y1);
								cairo.lineTo (x2, y2);
								cairo.lineTo (x3, y3);
								cairo.closePath ();
								
								cairo.clip ();
								
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
								
								var matrix = new Matrix3 (t1, t2, t3, t4, dx, dy);
								//cairo.transform (t1, t2, t3, t4, dx, dy);
								cairo.transform (matrix);
								cairo.setSourceSurface (pattern, 0, 0);
								cairo.paint ();
								//cairo.drawImage (pattern, 0, 0);
								cairo.restore ();
								
								i += 3;
								
							}
						
						case DrawTiles (sheet, tileData, smooth, flags, count):
							
							return;
							
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
							surface = sheet.__bitmap.getSurface ();
							
							cairo.setSourceSurface (surface, 0, 0);
							
							if (useBlendAdd) {
								
								cairo.operator = ADD;
								//context.globalCompositeOperation = "lighter";
								
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
									
									cairo.save ();
									cairo.translate (tileData[index], tileData[index + 1]);
									
									if (useRotation) {
										
										//cairo.rotate (tileData[index + rotationIndex]);
										
									}
									
									var scale = 1.0;
									
									if (useScale) {
										
										scale = tileData[index + scaleIndex];
										
									}
									
									if (useTransform) {
										
										var matrix = new Matrix3 (tileData[index + transformIndex], tileData[index + transformIndex + 1], tileData[index + transformIndex + 2], tileData[index + transformIndex + 3], 0, 0);
										cairo.transform (matrix);
										
									}
									
									//cairo.setSourceSurface (
									
									if (useAlpha) {
										
										cairo.paintWithAlpha (tileData[index + alphaIndex]);
										//context.globalAlpha = tileData[index + alphaIndex];
										
									} else {
										
										cairo.paint ();
										
									}
									
									//context.drawImage (surface, rect.x, rect.y, rect.width, rect.height, -center.x * scale, -center.y * scale, rect.width * scale, rect.height * scale);
									cairo.restore ();
									
								}
								
								index += numValues;
								
							}
							
							if (useBlendAdd) {
								
								cairo.operator = OVER;
								//context.globalCompositeOperation = "source-over";
								
							}
						
						default:
							
							openfl.Lib.notImplemented ("CairoGraphics");
						
					}
					
				}
				
			}
			
			graphics.__dirty = false;
			
			if (fillCommands.length > 0) {
				
				endFill ();
				
			}
			
			if (strokeCommands.length > 0) {
				
				endStroke ();
				
			}
			
		}
		
	}
	
	
	public static function renderMask (graphics:Graphics, renderSession:RenderSession) {
		
		if (graphics.__commands.length != 0) {
			
			var cairo = renderSession.cairo;
			
			var positionX = 0.0;
			var positionY = 0.0;
			
			var offsetX = 0;
			var offsetY = 0;
			
			for (command in graphics.__commands) {
				
				switch (command) {
					
					case CubicCurveTo (cx1, cx2, cy1, cy2, x, y):
						
						cairo.curveTo (cx1 - offsetX, cy1 - offsetY, cx2 - offsetX, cy2 - offsetY, x - offsetX, y - offsetY);
						positionX = x;
						positionY = y;
					
					case CurveTo (cx, cy, x, y):
						
						quadraticCurveTo (cx - offsetX, cy - offsetY, x - offsetX, y - offsetY);
						positionX = x;
						positionY = y;
					
					case DrawCircle (x, y, radius):
						
						cairo.arc (x - offsetX, y - offsetY, radius, 0, Math.PI * 2);
					
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
						cairo.moveTo (x, ym);
						cairo.curveTo (x, ym - oy, xm - ox, y, xm, y);
						cairo.curveTo (xm + ox, y, xe, ym - oy, xe, ym);
						cairo.curveTo (xe, ym + oy, xm + ox, ye, xm, ye);
						cairo.curveTo (xm - ox, ye, x, ym + oy, x, ym);
						//closePath (false);
					
					case DrawRect (x, y, width, height):
						
						cairo.rectangle (x - offsetX, y - offsetY, width, height);
					
					case DrawRoundRect (x, y, width, height, rx, ry):
						
						drawRoundRect (x - offsetX, y - offsetY, width, height, rx, ry);
					
					case LineTo (x, y):
						
						cairo.lineTo (x - offsetX, y - offsetY);
						positionX = x;
						positionY = y;
						
					case MoveTo (x, y):
						
						cairo.moveTo (x - offsetX, y - offsetY);
						positionX = x;
						positionY = y;
					
					default:
					
				}
				
			}
			
		}
		
	}
	
	
}
