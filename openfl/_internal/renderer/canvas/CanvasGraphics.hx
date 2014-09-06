package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.CapsStyle;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if js
import js.html.CanvasPattern;
import js.html.CanvasRenderingContext2D;
import js.Browser;
#end

@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)


class CanvasGraphics {
	
	
	private static var bounds:Rectangle;
	private static var hasFill:Bool;
	private static var hasStroke:Bool;
	private static var inPath:Bool;
	private static var inversePendingMatrix:Matrix;
	private static var pendingMatrix:Matrix;
	private static var positionX:Float;
	private static var positionY:Float;
	private static var setFill:Bool;
	
	#if js
	private static var context:CanvasRenderingContext2D;
	private static var pattern:CanvasPattern;
	#end
	
	
	private static function beginPath ():Void {
		
		#if js
		if (!inPath) {
			
			context.beginPath ();
			inPath = true;
			
		}
		#end
		
	}
	
	
	private static function beginPatternFill (bitmapFill:BitmapData, bitmapRepeat:Bool):Void {
		
		#if js
		if (setFill || bitmapFill == null) return;
		
		if (pattern == null) {
			
			pattern = context.createPattern (bitmapFill.__image.src, bitmapRepeat ? "repeat" : "no-repeat");
			
		}
		
		context.fillStyle = pattern;
		setFill = true;
		#end
		
	}
	
	
	private static function closePath (closeFill:Bool):Void {
		
		#if js
		if (inPath) {
			
			if (hasFill) {
				
				context.translate( -bounds.x, -bounds.y);
				
				if (pendingMatrix != null) {
					
					context.transform (pendingMatrix.a, pendingMatrix.b, pendingMatrix.c, pendingMatrix.d, pendingMatrix.tx, pendingMatrix.ty);
					context.fill ();
					context.transform (inversePendingMatrix.a, inversePendingMatrix.b, inversePendingMatrix.c, inversePendingMatrix.d, inversePendingMatrix.tx, inversePendingMatrix.ty);
					
				} else {
					
					context.fill ();
					
				}
				
				context.translate (bounds.x, bounds.y);
				
			}
			
			context.closePath ();
			
			if (hasStroke) {
				
				context.stroke ();
				
			}
			
		}
		
		inPath = false;
		
		if (closeFill) {
			
			hasFill = false;
			hasStroke = false;
			pendingMatrix = null;
			inversePendingMatrix = null;
			
		}
		#end
		
	}
	
	
	public static function render (graphics:Graphics, renderSession:RenderSession):Void {
		
		#if js
		
		if (graphics.__dirty) {
			
			bounds = graphics.__bounds;
			
			hasFill = false;
			hasStroke = false;
			inPath = false;
			positionX = 0;
			positionY = 0;
			
			if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0) {
				
				graphics.__canvas = null;
				graphics.__context = null;
				
			} else {
				
				if (graphics.__canvas == null) {
					
					graphics.__canvas = cast Browser.document.createElement ("canvas");
					graphics.__context = graphics.__canvas.getContext ("2d");
					//untyped (context).mozImageSmoothingEnabled = false;
					//untyped (context).webkitImageSmoothingEnabled = false;
					//context.imageSmoothingEnabled = false;
					
				}
				
				context = graphics.__context;
				
				graphics.__canvas.width = Math.ceil (bounds.width);
				graphics.__canvas.height = Math.ceil (bounds.height);
				
				var offsetX = bounds.x;
				var offsetY = bounds.y;
				
				var bitmapFill:BitmapData = null;
				var bitmapRepeat = false;
				
				for (command in graphics.__commands) {
					
					switch (command) {
						
						case BeginBitmapFill (bitmap, matrix, repeat, smooth):
							
							closePath (false);
							
							if (bitmap != bitmapFill || repeat != bitmapRepeat) {
								
								bitmapFill = bitmap;
								bitmapRepeat = repeat;
								pattern = null;
								setFill = false;
								
								bitmap.__sync ();
								
							}
							
							if (matrix != null) {
								
								pendingMatrix = matrix;
								inversePendingMatrix = matrix.clone ();
								inversePendingMatrix.invert ();
								
							} else {
								
								pendingMatrix = null;
								inversePendingMatrix = null;
								
							}
							
							hasFill = true;
						
						case BeginFill (rgb, alpha):
							
							closePath (false);
							
							if (alpha == 1) {
								
								context.fillStyle = "#" + StringTools.hex (rgb, 6);
								
							} else {
								
								var r = (rgb & 0xFF0000) >>> 16;
								var g = (rgb & 0x00FF00) >>> 8;
								var b = (rgb & 0x0000FF);
								
								context.fillStyle = "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")";
								
							}
							
							bitmapFill = null;
							setFill = true;
							hasFill = true;
						
						case CurveTo (cx, cy, x, y):
							
							beginPatternFill (bitmapFill, bitmapRepeat);
							beginPath ();
							context.quadraticCurveTo (cx - offsetX, cy - offsetY, x - offsetX, y - offsetY);
							positionX = x;
							positionY = y;
						
						case DrawCircle (x, y, radius):
							
							beginPatternFill (bitmapFill, bitmapRepeat);
							beginPath ();
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
							
							beginPatternFill (bitmapFill, bitmapRepeat);
							beginPath ();
							context.moveTo (x, ym);
							context.bezierCurveTo (x, ym - oy, xm - ox, y, xm, y);
							context.bezierCurveTo (xm + ox, y, xe, ym - oy, xe, ym);
							context.bezierCurveTo (xe, ym + oy, xm + ox, ye, xm, ye);
							context.bezierCurveTo (xm - ox, ye, x, ym + oy, x, ym);
						
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
										
										var stl = inversePendingMatrix.transformPoint(new Point(x, y));
										var sbr = inversePendingMatrix.transformPoint(new Point(x + width, y + height));
										
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
									context.drawImage (bitmapFill.__image.src, sl, st, sr - sl, sb - st, x, y, width, height);
									
								}
								
							}
							
							if (!optimizationUsed) {
								
								beginPatternFill (bitmapFill, bitmapRepeat);
								beginPath ();
								context.rect (x - offsetX, y - offsetY, width, height);
								
							}
						
						case DrawTiles (sheet, tileData, smooth, flags, count):
							
							closePath (false);
							
							var useScale = (flags & Graphics.TILE_SCALE) > 0;
							var useRotation = (flags & Graphics.TILE_ROTATION) > 0;
							var useTransform = (flags & Graphics.TILE_TRANS_2x2) > 0;
							var useRGB = (flags & Graphics.TILE_RGB) > 0;
							var useAlpha = (flags & Graphics.TILE_ALPHA) > 0;
							
							if (useTransform) { useScale = false; useRotation = false; }
							
							var scaleIndex = 0;
							var rotationIndex = 0;
							var rgbIndex = 0;
							var alphaIndex = 0;
							var transformIndex = 0;
							
							var numValues = 3;
							
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
							surface = sheet.__bitmap.__image.src;
							
							while (index < totalCount) {
								
								var tileID = Std.int (tileData[index + 2]);
								
								if (tileID != previousTileID) {
									
									rect = sheet.__tileRects[tileID];
									center = sheet.__centerPoints[tileID];
									
									previousTileID = tileID;
									
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
						
						case EndFill:
							
							closePath (true);
						
						case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
							
							closePath (false);
							
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
								context.strokeStyle = (color == null ? "#000000" : "#" + StringTools.hex (color, 6));
								
								hasStroke = true;
								
							}
						
						case LineTo (x, y):
							
							beginPatternFill(bitmapFill, bitmapRepeat);
							beginPath ();
							context.lineTo (x - offsetX, y - offsetY);
							positionX = x;
							positionY = y;
							
						case MoveTo (x, y):
							
							beginPath ();
							context.moveTo (x - offsetX, y - offsetY);
							positionX = x;
							positionY = y;
						
					}
					
				}
				
			}
			
			graphics.__dirty = false;
			closePath (false);
			
		}
		
		#end
		
	}
	
	
	public static function renderMask (graphics:Graphics, renderSession:RenderSession) {
		
		if (graphics.__commands.length != 0) {
			
			var context = renderSession.context;
			
			var positionX = 0.0;
			var positionY = 0.0;
			
			var offsetX = 0;
			var offsetY = 0;
			
			for (command in graphics.__commands) {
				
				switch (command) {
					
					case CurveTo (cx, cy, x, y):
						
						context.quadraticCurveTo (cx, cy, x, y);
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
		
	}
	
	
}