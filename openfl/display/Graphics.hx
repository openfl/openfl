package openfl.display; #if !flash


import openfl.geom.Point;
import openfl.display.Stage;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if js
import js.html.CanvasElement;
import js.html.CanvasPattern;
import js.html.CanvasRenderingContext2D;
import js.Browser;
#end


@:access(openfl.display.BitmapData)
class Graphics {
	
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	public static inline var TILE_TRANS_2x2 = 0x0010;
	public static inline var TILE_BLEND_NORMAL = 0x00000000;
	public static inline var TILE_BLEND_ADD = 0x00010000;
	
	private var __bounds:Rectangle;
	private var __commands:Array<DrawCommand>;
	private var __dirty:Bool;
	private var __halfStrokeWidth:Float;
	private var __hasFill:Bool;
	private var __hasStroke:Bool;
	private var __inPath:Bool;
	private var __inversePendingMatrix:Matrix;
	private var __pendingMatrix:Matrix;
	private var __positionX:Float;
	private var __positionY:Float;
	private var __setFill:Bool;
	private var __visible:Bool;
	
	#if js
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	private var __pattern:CanvasPattern;
	#end
	
	
	public function new () {
		
		__commands = new Array ();
		__halfStrokeWidth = 0;
		__positionX = 0;
		__positionY = 0;
		
	}
	
	
	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		
		__commands.push (BeginBitmapFill (bitmap, matrix, repeat, smooth));
		
		__visible = true;
			
	}
	
	
	public function beginFill (rgb:Int, alpha:Float = 1):Void {
		
		__commands.push (BeginFill (rgb & 0xFFFFFF, alpha));
		
		if (alpha > 0) __visible = true;
		
	}
	
	
	public function beginGradientFill (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix = null, spreadMethod:Null<SpreadMethod> = null, interpolationMethod:Null<InterpolationMethod> = null, focalPointRatio:Null<Float> = null):Void {
		
		openfl.Lib.notImplemented ("Graphics.beginGradientFill");
		
	}
	
	
	public function clear ():Void {
		
		__commands = new Array ();
		__halfStrokeWidth = 0;
		
		if (__bounds != null) {
			
			__dirty = true;
			__bounds = null;
			
		}
		
		__visible = false;
		
	}
	
	
	public function curveTo (cx:Float, cy:Float, x:Float, y:Float):Void {
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		// TODO: Be a little less lenient in canvas size?
		
		__inflateBounds (cx, cy);
		
		__positionX = x;
		__positionY = y;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__commands.push (CurveTo (cx, cy, x, y));
		
		__dirty = true;
		
	}
	
	
	public function drawCircle (x:Float, y:Float, radius:Float):Void {
		
		if (radius <= 0) return;
		
		__inflateBounds (x - radius - __halfStrokeWidth, y - radius - __halfStrokeWidth);
		__inflateBounds (x + radius + __halfStrokeWidth, y + radius + __halfStrokeWidth);
		
		__commands.push (DrawCircle (x, y, radius));
		
		__dirty = true;
		
	}
	
	
	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);
		
		__commands.push (DrawEllipse (x, y, width, height));
		
		__dirty = true;
		
	}
	
	
	public function drawGraphicsData (graphicsData:Vector<IGraphicsData>):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawGraphicsData");
		
	}
	
	
	public function drawPath (commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding = null):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawPath");
		
	}
	
	
	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);
		
		__commands.push (DrawRect (x, y, width, height));
		
		__dirty = true;
		
	}
	
	
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float = -1):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawRoundRect");
		
	}
	
	
	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawRoundRectComplex");
		
	}
	
	
	public function drawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1):Void {
		
		// Checking each tile for extents did not include rotation or scale, and could overflow the maximum canvas
		// size of some mobile browsers. Always use the full stage size for drawTiles instead?
		
		__inflateBounds (0, 0);
		__inflateBounds (Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		
		__commands.push (DrawTiles (sheet, tileData, smooth, flags, count));
		
		__dirty = true;
		__visible = true;
		
	}
	
	
	public function drawTriangles (vertices:Vector<Float>, indices:Vector<Int> = null, uvtData:Vector<Float> = null, culling:TriangleCulling):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawTriangles");
		
	}
	
	
	public function endFill ():Void {
		
		__commands.push (EndFill);
		
	}
	
	
	public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		
		openfl.Lib.notImplemented ("Graphics.lineBitmapStyle");
		
	}
	
	
	public function lineGradientStyle (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix = null, spreadMethod:SpreadMethod = null, interpolationMethod:InterpolationMethod = null, focalPointRatio:Null<Float> = null):Void {
		
		openfl.Lib.notImplemented ("Graphics.lineGradientStyle");
		
	}
	
	
	public function lineStyle (thickness:Null<Float> = null, color:Null<Int> = null, alpha:Null<Float> = null, pixelHinting:Null<Bool> = null, scaleMode:LineScaleMode = null, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Null<Float> = null):Void {
		
		__halfStrokeWidth = (thickness != null) ? thickness / 2 : 0;
		__commands.push (LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit));
		
		if (thickness != null) __visible = true;
		
	}
	
	
	public function lineTo (x:Float, y:Float):Void {
		
		// TODO: Should we consider the origin instead, instead of inflating in all directions?
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__positionX = x;
		__positionY = y;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__commands.push (LineTo (x, y));
		
		__dirty = true;
		
	}
	
	
	public function moveTo (x:Float, y:Float):Void {
		
		__commands.push (MoveTo (x, y));
		
		__positionX = x;
		__positionY = y;
		
	}
	
	
	private function __beginPath ():Void {
		
		#if js
		if (!__inPath) {
			
			__context.beginPath ();
			__inPath = true;
			
		}
		#end
		
	}
	
	
	private function __beginPatternFill (bitmapFill:BitmapData, bitmapRepeat:Bool):Void {
		
		#if js
		if (__setFill || bitmapFill == null) return;
		
		if (__pattern == null) {
			
			if (bitmapFill.__sourceImage != null) {
				
				__pattern = __context.createPattern (bitmapFill.__sourceImage, bitmapRepeat ? "repeat" : "no-repeat");
				
			} else {
				
				__pattern = __context.createPattern (bitmapFill.__sourceCanvas, bitmapRepeat ? "repeat" : "no-repeat");
				
			}
			
		}
		
		__context.fillStyle = __pattern;
		__setFill = true;
		#end
		
	}
	
	
	private function __closePath (closeFill:Bool):Void {
		
		#if js
		if (__inPath) {
			
			if (__hasFill) {
				
				__context.translate( -__bounds.x, -__bounds.y);
				
				if (__pendingMatrix != null) {
					
					__context.transform (__pendingMatrix.a, __pendingMatrix.b, __pendingMatrix.c, __pendingMatrix.d, __pendingMatrix.tx, __pendingMatrix.ty);
					__context.fill ();
					__context.transform (__inversePendingMatrix.a, __inversePendingMatrix.b, __inversePendingMatrix.c, __inversePendingMatrix.d, __inversePendingMatrix.tx, __inversePendingMatrix.ty);
					
				} else {
					
					__context.fill ();
					
				}
				
				__context.translate( __bounds.x, __bounds.y);
				
			}
			
			__context.closePath ();
			
			if (__hasStroke) {
				
				__context.stroke ();
				
			}
			
		}
		
		__inPath = false;
		
		if (closeFill) {
			
			__hasFill = false;
			__hasStroke = false;
			__pendingMatrix = null;
			__inversePendingMatrix = null;
			
		}
		#end
		
	}
	
	
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__bounds == null) return;
		
		var bounds = __bounds.clone ().transform (matrix);
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, matrix:Matrix):Bool {
		
		if (__bounds == null) return false;
		
		var bounds = __bounds.clone ().transform (matrix);
		return (x > bounds.x && y > bounds.y && x <= bounds.right && y <= bounds.bottom);
		
	}
	
	
	private function __inflateBounds (x:Float, y:Float):Void {
		
		if (__bounds == null) {
			
			__bounds = new Rectangle (x, y, 0, 0);
			return;
			
		}
		
		if (x < __bounds.x) {
			
			__bounds.width += __bounds.x - x;
			__bounds.x = x;
			
		}
		
		if (y < __bounds.y) {
			
			__bounds.height += __bounds.y - y;
			__bounds.y = y;
			
		}
		
		if (x > __bounds.x + __bounds.width) {
			
			__bounds.width = x - __bounds.x;
			
		}
		
		if (y > __bounds.y + __bounds.height) {
			
			__bounds.height = y - __bounds.y;
			
		}
		
	}
	
	
	private function __render ():Void {
		
		#if js
		if (__dirty) {
			
			__hasFill = false;
			__hasStroke = false;
			__inPath = false;
			__positionX = 0;
			__positionY = 0;
			
			if (!__visible || __commands.length == 0 || __bounds == null || __bounds.width == 0 || __bounds.height == 0) {
				
				__canvas = null;
				__context = null;
				
			} else {
				
				if (__canvas == null) {
					
					__canvas = cast Browser.document.createElement ("canvas");
					__context = __canvas.getContext ("2d");
					//untyped (__context).mozImageSmoothingEnabled = false;
					//untyped (__context).webkitImageSmoothingEnabled = false;
					//__context.imageSmoothingEnabled = false;
					
				}
				
				__canvas.width = Math.ceil (__bounds.width);
				__canvas.height = Math.ceil (__bounds.height);
				
				var offsetX = __bounds.x;
				var offsetY = __bounds.y;
				
				var bitmapFill:BitmapData = null;
				var bitmapRepeat = false;
				
				for (command in __commands) {
					
					switch (command) {
						
						case BeginBitmapFill (bitmap, matrix, repeat, smooth):
							
							__closePath (false);
							
							if (bitmap != bitmapFill || repeat != bitmapRepeat) {
								
								bitmapFill = bitmap;
								bitmapRepeat = repeat;
								__pattern = null;
								__setFill = false;
								
								bitmap.__syncImageData ();
								
							}
							
							if (matrix != null) {
								
								__pendingMatrix = matrix;
								__inversePendingMatrix = matrix.clone();
								__inversePendingMatrix.invert();
								
							} else {
								
								__pendingMatrix = null;
								__inversePendingMatrix = null;
								
							}
							
							__hasFill = true;
						
						case BeginFill (rgb, alpha):
							
							__closePath (false);
							
							if (alpha == 1) {
								
								__context.fillStyle = "#" + StringTools.hex (rgb, 6);
								
							} else {
								
								var r = (rgb & 0xFF0000) >>> 16;
								var g = (rgb & 0x00FF00) >>> 8;
								var b = (rgb & 0x0000FF);
								
								__context.fillStyle = "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")";
								
							}
							
							bitmapFill = null;
							__setFill = true;
							__hasFill = true;
						
						case CurveTo (cx, cy, x, y):
							
							__beginPatternFill(bitmapFill, bitmapRepeat);
							__beginPath ();
							__context.quadraticCurveTo (cx - offsetX, cy - offsetY, x - offsetX, y - offsetY);
							__positionX = x;
							__positionY = y;
						
						case DrawCircle (x, y, radius):
							
							__beginPatternFill(bitmapFill, bitmapRepeat);
							__beginPath ();
							__context.moveTo (x - offsetX + radius, y - offsetY);
							__context.arc (x - offsetX, y - offsetY, radius, 0, Math.PI * 2, true);
						
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
							
							__beginPatternFill(bitmapFill, bitmapRepeat);
							__beginPath ();
							__context.moveTo(x, ym);
							__context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
							__context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
							__context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
							__context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
						
						case DrawRect (x, y, width, height):
							
							var optimizationUsed = false;
							
							if (bitmapFill != null) {
								
								var st:Float = 0;
								var sr:Float = 0;
								var sb:Float = 0;
								var sl:Float = 0;
								
								var canOptimizeMatrix = true;
								
								if (__pendingMatrix != null) {
									
									if (__pendingMatrix.b != 0 || __pendingMatrix.c != 0) {
										
										canOptimizeMatrix = false;
										
									} else {
										
										var stl = __inversePendingMatrix.transformPoint(new Point(x, y));
										var sbr = __inversePendingMatrix.transformPoint(new Point(x + width, y + height));
										
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
									
									if (bitmapFill.__sourceImage != null) {
										
										__context.drawImage (bitmapFill.__sourceImage, sl, st, sr - sl, sb - st, x, y, width, height);
										
									} else {
										
										__context.drawImage (bitmapFill.__sourceCanvas, sl, st, sr - sl, sb - st, x, y, width, height);
										
									}
									
								}
								
							}
							
							if (!optimizationUsed) {
								
								__beginPatternFill(bitmapFill, bitmapRepeat);
								__beginPath ();
								__context.rect (x - offsetX, y - offsetY, width, height);
								
							}
						
						case DrawTiles (sheet, tileData, smooth, flags, count):
							
							__closePath (false);
							
							var useScale = (flags & TILE_SCALE) > 0;
							var useRotation = (flags & TILE_ROTATION) > 0;
							var useTransform = (flags & TILE_TRANS_2x2) > 0;
							var useRGB = (flags & TILE_RGB) > 0;
							var useAlpha = (flags & TILE_ALPHA) > 0;
							
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
							sheet.__bitmap.__syncImageData ();
							
							if (sheet.__bitmap.__sourceImage != null) {
								
								surface = sheet.__bitmap.__sourceImage;
								
							} else {
								
								surface = sheet.__bitmap.__sourceCanvas;
								
							}
							
							while (index < totalCount) {
								
								var tileID = Std.int (tileData[index + 2]);
								
								if (tileID != previousTileID) {
									
									rect = sheet.__tileRects[tileID];
									center = sheet.__centerPoints[tileID];
									
									previousTileID = tileID;
									
								}
								
								if (rect != null && rect.width > 0 && rect.height > 0 && center != null) {
									
									__context.save ();
									__context.translate (tileData[index], tileData[index + 1]);
									
									if (useRotation) {
										
										__context.rotate (tileData[index + rotationIndex]);
										
									}
									
									var scale = 1.0;
									
									if (useScale) {
										
										scale = tileData[index + scaleIndex];
										
									}
									
									if (useTransform) {
										
										__context.transform (tileData[index + transformIndex], tileData[index + transformIndex + 1], tileData[index + transformIndex + 2], tileData[index + transformIndex + 3], 0, 0);
										
									}
									
									if (useAlpha) {
										
										__context.globalAlpha = tileData[index + alphaIndex];
										
									}
									
									__context.drawImage (surface, rect.x, rect.y, rect.width, rect.height, -center.x * scale, -center.y * scale, rect.width * scale, rect.height * scale);
									__context.restore ();
									
								}
								
								index += numValues;
								
							}
						
						case EndFill:
							
							__closePath(true);

						case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
							
							__closePath(false);
							if (thickness == null) {
								
								__hasStroke = false;
								
							} else {
								
								__context.lineWidth = thickness;
								
								#if (haxe_ver > 3.100)
								__context.lineJoin = joints;
								__context.lineCap = caps;
								#else
								__context.lineJoin = Std.string (joints).toLowerCase ();
								__context.lineCap = switch (caps) {
									case CapsStyle.NONE: "butt";
									default: Std.string (caps).toLowerCase ();
								}
								#end
								
								__context.miterLimit = miterLimit;
								__context.strokeStyle =  "#" + StringTools.hex (color, 6);
								
								__hasStroke = true;
								
							}
						
						case LineTo (x, y):
							
							__beginPatternFill(bitmapFill, bitmapRepeat);
							__beginPath ();
							__context.lineTo (x - offsetX, y - offsetY);
							__positionX = x;
							__positionY = y;
							
						case MoveTo (x, y):
							
							__beginPath ();
							__context.moveTo (x - offsetX, y - offsetY);
							__positionX = x;
							__positionY = y;
						
					}
					
				}
				
			}
			
			__dirty = false;
			__closePath(false);

		}
		#end
		
	}
	
	
	private function __renderMask (renderSession:RenderSession) {
		
		if (__commands.length != 0) {
			
			var __context = renderSession.context;
			
			var __positionX = 0.0;
			var __positionY = 0.0;
			
			var offsetX = 0;
			var offsetY = 0;
			
			for (command in __commands) {
				
				switch (command) {
					
					case CurveTo (cx, cy, x, y):
						
						__context.quadraticCurveTo (cx, cy, x, y);
						__positionX = x;
						__positionY = y;
					
					case DrawCircle (x, y, radius):
						
						__context.arc (x - offsetX, y - offsetY, radius, 0, Math.PI * 2, true);
					
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
						
						//__closePath (false);
						//__beginPath ();
						__context.moveTo(x, ym);
						__context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
						__context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
						__context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
						__context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
						//__closePath (false);
					
					case DrawRect (x, y, width, height):
						
						__context.rect (x - offsetX, y - offsetY, width, height);
					
					case LineTo (x, y):
						
						__context.lineTo (x - offsetX, y - offsetY);
						__positionX = x;
						__positionY = y;
						
					case MoveTo (x, y):
						
						__context.moveTo (x - offsetX, y - offsetY);
						__positionX = x;
						__positionY = y;
					
					default:
					
				}
				
			}
			
		}
		
	}
	
	
}


enum DrawCommand {
	
	BeginBitmapFill (bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool);
	BeginFill (rgb:Int, alpha:Float);
	CurveTo (cx:Float, cy:Float, x:Float, y:Float);
	DrawCircle (x:Float, y:Float, radius:Float);
	DrawEllipse (x:Float, y:Float, width:Float, height:Float);
	DrawRect (x:Float, y:Float, width:Float, height:Float);
	DrawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int);
	EndFill;
	LineStyle (thickness:Null<Float>, color:Null<Int>, alpha:Null<Float>, pixelHinting:Null<Bool>, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Null<Float>);
	LineTo (x:Float, y:Float);
	MoveTo (x:Float, y:Float);
	
}


#else
typedef Graphics = flash.display.Graphics;
#end