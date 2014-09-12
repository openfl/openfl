package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.CapsStyle;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.Vector;

#if js
import js.html.CanvasElement;
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
							
						case DrawTriangles (vertices, indices, uvtData, culling):
							
							closePath(false);
							
							var v = vertices;
							var ind = indices;
							//var uvt = normalizeUvt(uvtData);
							var uvt = uvtData;
							
							//trace(v.toArray());
							//trace(ind.toArray());
							//trace(uvt.toArray());
							
							var pattern = createTempPatternCanvas(bitmapFill, bitmapRepeat, bounds.width, bounds.height);
							//context.drawImage(pattern, 0, 0);
							//return;
							var i = 0;
							var j = 0;
							var k = 0;
							var l = ind.length;
							
							var a:Int, b:Int, c:Int;
							var iax:Int, iay:Int, ibx:Int, iby:Int, icx:Int, icy:Int;
							var x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float;
							
							var uvx1:Float, uvy1:Float, uvx2:Float, uvy2:Float, uvx3:Float, uvy3:Float;
							
							var pow = bitmapFill.width / pattern.width;
							var poh = bitmapFill.height / pattern.height;
							
							var w:Float, h:Float, sx:Float, sy:Float;
							var t1:Float, t2:Float, t3:Float, t4:Float;
							
							var muv:Matrix = new Matrix();
							var mve:Matrix = new Matrix();
							var uvxSort:Array<Float>;
							var uvySort:Array<Float>;
							while (i < l) {
								a = i;
								b = i + 1;
								c = i + 2;
								
								iax = ind[a] * 2;		iay = ind[a] * 2 + 1;
								ibx = ind[b] * 2;		iby = ind[b] * 2 + 1;
								icx = ind[c] * 2;		icy = ind[c] * 2 + 1;
								
								x1 = v[iax];	y1 = v[iay];
								x2 = v[ibx];	y2 = v[iby];
								x3 = v[icx];	y3 = v[icy];
								
								if (false || !isCCW(x1, y1, x2, y2, x3, y3)) {
									//trace("wasn't CCW");
									a = i + 2;
									b = i + 1;
									c = i;
									
									
									iax = ind[a] * 2;		iay = ind[a] * 2 + 1;
									ibx = ind[b] * 2;		iby = ind[b] * 2 + 1;
									icx = ind[c] * 2;		icy = ind[c] * 2 + 1;
									
									x1 = v[iax];	y1 = v[iay];
									x2 = v[ibx];	y2 = v[iby];
									x3 = v[icx];	y3 = v[icy];
									
									//trace("Is it now? " + isCCW(x1, y1, x2, y2, x3, y3));
								}
								
								
								context.save();
								context.beginPath();
								context.moveTo(x1, y1);
								context.lineTo(x2, y2);
								context.lineTo(x3, y3);
								context.lineTo(x1, y1);
								context.closePath();
								
								context.clip(); 
								
								
								
								
								if(true) {
									// need to find the width and height of the src image
									uvx1 = uvt[iax] * pattern.width * pow;
									uvx2 = uvt[ibx] * pattern.width * pow;
									uvx3 = uvt[icx] * pattern.width * pow;
									uvy1 = uvt[iay] * pattern.height * poh;
									uvy2 = uvt[iby] * pattern.height * poh;
									uvy3 = uvt[icy] * pattern.height * poh;
									
									//trace(uvt[iax], uvt[iay]);
									//trace(uvt[ibx], uvt[iby]);
									//trace(uvt[icx], uvt[icy]);
									uvxSort = [uvx1, uvx2, uvx3];
									uvySort = [uvy1, uvy2, uvy3];
									uvxSort.sort(function(a, b) return Std.int(a - b));
									uvySort.sort(function(a, b) return Std.int(a - b));
									
									if (uvxSort[0] < 0) uvxSort[0] = 0;
									if (uvySort[0] < 0) uvySort[0] = 0;
									
									trace(uvx1, uvy1);
									trace(uvx2, uvy2);
									trace(uvx3, uvy3);
									//trace(sortX, sortY);

									w = uvxSort[2] - uvxSort[0];
									h = uvySort[2] - uvySort[0];

									trace(w, h);
									
									mve.setTo(x2 - x1, y2 - y1, x3 - x1 , y3 - y1, 0, 0);
									
									muv.setTo(uvx2 - uvx1, uvy2 - uvy1, uvx3 - uvx1, uvy3 - uvy1, 0, 0);
									muv.invert();
									trace(mve, muv);
									mve.concat(muv);
									//mve.invert();
									//trace(mve);
									

									t1 = mve.a;
									t2 = mve.c;
									t3 = mve.b;
									t4 = mve.d;
									trace('($x1,$y1) ($x2,$y2) ($x3,$y3)',t1, t2, t3, t4, x1 - (uvx1 * t1 + uvy1 * t2), y1 - (uvx1 * t3 + uvy1 * t4));

									context.transform(t1, t2, t3, t4, x1 - (uvx1 * t1 + uvy1 * t2), y1 - (uvx1 * t3 + uvy1 * t4));
									context.drawImage(pattern, uvxSort[0], uvySort[0], w, h, 0, 0, w, h);
									trace(uvxSort, uvySort, w, h);
									
									context.lineWidth = 2;
									context.strokeStyle = "#000000";
									context.stroke();
									
									context.restore();
									
									i += 3;
									
									trace("END");
								}
							}						
							
							if(false) {
								var i = 0;
								var j = 0;
								var k = 0;
								var l = ind.length;
								var c = context;
								var w:Float, h:Float, sw:Float, sh:Float;
								var t1:Float, t2:Float, t3:Float, t4:Float;
								var pow = bitmapFill.width / pattern.width;
								var poh = bitmapFill.height / pattern.height;
								while (i < l) {
									
									c.save();
									c.beginPath();
									c.moveTo(v[ind[i] * 2], v[ind[i] * 2 + 1]);
									c.lineTo(v[ind[i + 1] * 2], v[ind[i + 1] * 2 + 1]);
									c.lineTo(v[ind[i + 2] * 2], v[ind[i + 2] * 2 + 1]);
									c.lineTo(v[ind[i] * 2], v[ind[i] * 2 + 1]);
									c.closePath();
									
									c.lineWidth = 1;
									c.strokeStyle = "#000000";
									c.stroke();
									//break;
									c.clip();
									
									if (i % 6 == 0) {
										sw = -1;
										w = (uvt[ind[i + 1 + j] * 2] - uvt[ind[i + j] * 2]) * pattern.width * pow;
										h = (uvt[ind[i + 2] * 2 + 1] - uvt[ind[i] * 2 + 1]) * pattern.height * poh;
										if (j == 0 && w < 0) {
											k = i + 9;
											while (k < l) {
												if (uvt[ind[i + 2] * 2 + 1] == uvt[ind[k + 2] * 2 + 1]) {
													j = k - i;
													break;
												}
												k += 3;
											}
											if (j == 0) {
												j = l - i;
											}
											w = (uvt[ind[i + 1 + j] * 2] - uvt[ind[i + j] * 2]) * pattern.width * pow;
										}
										if (i + j >= l) {
											w = (uvt[ind[i + j - l] * 2] - uvt[ind[i + 1] * 2]) * pattern.width * pow;
											sw = uvt[ind[i] * 2] == 1 ? 0 : pattern.width * pow * uvt[ind[i] * 2] + w;
											if (sw > pattern.width) {
												sw -= pattern.width;
											}
										} else {
											sw = pattern.width * pow * uvt[ind[i + j] * 2];
										}
										sh = pattern.height * poh * uvt[ind[i] * 2 + 1];
										if (h < 0) {
											h = (uvt[ind[i + 2 - (i > 0 ? 6 : -6)] * 2 + 1] - uvt[ind[i - (i > 0 ? 6 : -6)] * 2 + 1]) * pattern.height * poh;
											sh = 0;
										}
										
										t1 = (v[ind[i + 1] * 2] - v[ind[i] * 2]) / w;
										t2 = (v[ind[i + 1] * 2 + 1] - v[ind[i] * 2 + 1]) / w;
										t3 = (v[ind[i + 2] * 2] - v[ind[i] * 2]) / h;
										t4 = (v[ind[i + 2] * 2 + 1] - v[ind[i] * 2 + 1]) / h;
										c.transform(t1, t2, t3, t4, v[ind[i] * 2], v[ind[i] * 2 + 1]);
										c.drawImage(pattern,
													offsetX + sw, offsetY + sh, 
													w, h,
													0, 0,
													w, h);
										trace("i%6==0", t1, t2, t3, t4, sw, sh, w, h);
									} else {
										w = (uvt[ind[i + 2 + j] * 2] - uvt[ind[i + 1 + j] * 2]) * pattern.width * pow;
										h = (uvt[ind[i + 2] * 2 + 1] - uvt[ind[i] * 2 + 1]) * pattern.height * poh;
										if (j == 0 && w < 0) {
											k = i + 9;
											while(k < l) {
												if (uvt[ind[i + 2] * 2 + 1] == uvt[ind[k + 2] * 2 + 1]) {
													j = k - i;
													break;
												}
												k += 3;
											}
											if (j == 0) {
												j = l - i;
											}
											w = (uvt[ind[i + 2 + j] * 2] - uvt[ind[i + 1 + j] * 2]) * pattern.width * pow;
										}
										if (i + 1 + j >= l) {
											w = (uvt[ind[i + 1 + j - l] * 2] - uvt[ind[i + 2] * 2]) * pattern.width * pow;
											sw = uvt[ind[i + 1] * 2] == 1 ? 0 : pattern.width * pow * uvt[ind[i + 1] * 2] + w;
											if (sw > pattern.width) {
												sw -= pattern.width;
											}
										} else {
											sw = pattern.width * pow * uvt[ind[i + 1 + j] * 2];
										}
										sh = pattern.height * poh * uvt[ind[i] * 2 + 1];
										if (h < 0) {
											h = (uvt[ind[i + 2 - (i > 0 ? 6 : -6)] * 2 + 1] - uvt[ind[i - (i > 0 ? 6 : -6)] * 2 + 1]) * pattern.height * poh;
											sh = 0;
										}
										t1 = (v[ind[i + 2] * 2] - v[ind[i + 1] * 2]) / w;
										t2 = (v[ind[i + 2] * 2 + 1] - v[ind[i + 1] * 2 + 1]) / w;
										t3 = (v[ind[i + 2] * 2] - v[ind[i] * 2]) / h;
										t4 = (v[ind[i + 2] * 2 + 1] - v[ind[i] * 2 + 1]) / h;
										c.transform(t1, t2, t3, t4, v[ind[i + 1] * 2], v[ind[i + 1] * 2 + 1]);
										c.drawImage(pattern,
													offsetX + sw, offsetY + sh,
													w, h,
													0, -h,
													w, h);
													
										trace("i%6!=0", t1, t2, t3, t4, sw, sh, w, h);
									}
									c.restore();
									
									i += 3;
								}
							}
							
						case _:
							openfl.Lib.notImplemented("CanvasGraphics");
						
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
	
	private static function createTempPatternCanvas(bitmap:BitmapData, repeat:Bool, width:Float, height:Float) {
		
		var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
		var context:CanvasRenderingContext2D = canvas.getContext ("2d");
		
		canvas.width = Math.ceil (width);
		canvas.height = Math.ceil (height);
		
		context.fillStyle = context.createPattern(bitmap.__image.src, repeat ? "repeat" : "no-repeat");
		context.beginPath();
		context.moveTo(0, 0);
		context.lineTo(0, height);
		context.lineTo(width, height);
		context.lineTo(width, 0);
		context.lineTo(0, 0);
		context.closePath();
		context.fill();
		return canvas;
	}
	
	private static function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float) {
		var vx1 = x2 - x1;
		var vy1 = y2 - y1;
		var vx2 = x3 - x1;
		var vy2 = y3 - y1;
		
		//trace('$vx1*$vy2 - $vy1*$vx2 = ' + (vx1 * vy2 - vy1 * vx2));
		return (vx1 * vy2 - vy1 * vx2) < 0;
	}
	
	private static function normalizeUvt(uvt:Vector<Float>):Vector<Float> {
		var max:Float = Math.NEGATIVE_INFINITY;
		var len = uvt.length;
		var m = 0.0;
		for(t in 0...len) {
			m = uvt[t];
			if (max < m) max = m;
		}
		
		var result:Vector<Float> = new Vector<Float>(len);
		for(t in 0...len) {
			result[t] = (uvt[t] / max);
		}
		
		return result;
	}
	
}