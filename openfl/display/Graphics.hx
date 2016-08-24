package openfl.display;


import lime.graphics.cairo.Cairo;
import lime.graphics.Image;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.DrawCommandBuffer;
import openfl._internal.renderer.DrawCommandReader;
//import openfl._internal.renderer.opengl.utils.RenderTexture;
import openfl.display.Shader;
import openfl.errors.ArgumentError;
import openfl.display.GraphicsPathCommand;
import openfl.display.GraphicsBitmapFill;
import openfl.display.GraphicsEndFill;
import openfl.display.GraphicsGradientFill;
import openfl.display.GraphicsPath;
import openfl.display.GraphicsSolidFill;
import openfl.display.GraphicsStroke;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


@:final class Graphics {
	
	
	private var __bounds:Rectangle;
	private var __commands:DrawCommandBuffer;
	private var __dirty (default, set):Bool = true;
	private var __height:Int;
	private var __positionX:Float;
	private var __positionY:Float;
	private var __renderTransform:Matrix;
	private var __strokePadding:Float;
	private var __transformDirty:Bool;
	private var __visible:Bool;
	//private var __cachedTexture:RenderTexture;
	private var __owner:DisplayObject;
	private var __width:Int;
	private var __worldTransform:Matrix;
	
	#if (js && html5)
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	#else
	private var __cairo:Cairo;
	#end
	
	private var __bitmap:BitmapData;
	
	
	private function new (owner:DisplayObject) {
		
		__owner = owner;
		
		__commands = new DrawCommandBuffer ();
		__strokePadding = 0;
		__positionX = 0;
		__positionY = 0;
		__renderTransform = new Matrix ();
		__worldTransform = new Matrix ();
		__width = 0;
		__height = 0;
		
		#if (js && html5)
		moveTo (0, 0);
		#end
		
	}
	
	
	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {
		
		__commands.beginBitmapFill(bitmap, matrix != null ? matrix.clone () : null, repeat, smooth);
		
		__visible = true;
		
	}
	
	
	public function beginFill (color:Int = 0, alpha:Float = 1):Void {
		
		__commands.beginFill (color & 0xFFFFFF, alpha);
		
		if (alpha > 0) __visible = true;
		
	}
	
	
	public function beginGradientFill (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = SpreadMethod.PAD, interpolationMethod:InterpolationMethod = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
		
		__commands.beginGradientFill (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		
		for (alpha in alphas) {
			
			if (alpha > 0) {
				
				__visible = true;
				break;
				
			}
			
		}
		
	}
	
	
	public function clear ():Void {
		
		__commands.clear ();
		__strokePadding = 0;
		
		if (__bounds != null) {
			
			__dirty = true;
			__transformDirty = true;
			__bounds = null;
			
		}
		
		__visible = false;
		
		#if (js && html5)
		moveTo (0, 0);
		#end
		
	}
	
	
	public function copyFrom (sourceGraphics:Graphics):Void {
		
		__bounds = sourceGraphics.__bounds != null ? sourceGraphics.__bounds.clone () : null;
		__commands = sourceGraphics.__commands.copy ();
		__dirty = true;
		__strokePadding = sourceGraphics.__strokePadding;
		__positionX = sourceGraphics.__positionX;
		__positionY = sourceGraphics.__positionY;
		__transformDirty = true;
		__visible = sourceGraphics.__visible;
		
	}
	
	
	public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {
		
		__inflateBounds (__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds (__positionX + __strokePadding, __positionY + __strokePadding);
		
		var ix1, iy1, ix2, iy2;
		
		ix1 = anchorX;
		ix2 = anchorX;
		
		if (!(((controlX1 < anchorX && controlX1 > __positionX) || (controlX1 > anchorX && controlX1 < __positionX)) && ((controlX2 < anchorX && controlX2 > __positionX) || (controlX2 > anchorX && controlX2 < __positionX)))) {
			
			var u = (2 * __positionX - 4 * controlX1 + 2 * controlX2);
			var v = (controlX1 - __positionX);
			var w = (-__positionX + 3 * controlX1 + anchorX - 3 * controlX2);
			
			var t1 = (-u + Math.sqrt (u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt (u * u - 4 * v * w)) / (2 * w);
			
			if (t1 > 0 && t1 < 1) {
				
				ix1 = __calculateBezierCubicPoint (t1, __positionX, controlX1, controlX2, anchorX);
				
			}
			
			if (t2 > 0 && t2 < 1) {
				
				ix2 = __calculateBezierCubicPoint (t2, __positionX, controlX1, controlX2, anchorX);
				
			}
			
		}
		
		iy1 = anchorY;
		iy2 = anchorY;
		
		if (!(((controlY1 < anchorY && controlY1 > __positionX) || (controlY1 > anchorY && controlY1 < __positionX)) && ((controlY2 < anchorY && controlY2 > __positionX) || (controlY2 > anchorY && controlY2 < __positionX)))) {
			
			var u = (2 * __positionX - 4 * controlY1 + 2 * controlY2);
			var v = (controlY1 - __positionX);
			var w = (-__positionX + 3 * controlY1 + anchorY - 3 * controlY2);
			
			var t1 = (-u + Math.sqrt (u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt (u * u - 4 * v * w)) / (2 * w);
			
			if (t1 > 0 && t1 < 1) {
				
				iy1 = __calculateBezierCubicPoint (t1, __positionX, controlY1, controlY2, anchorY);
				
			}
			
			if (t2 > 0 && t2 < 1) {
				
				iy2 = __calculateBezierCubicPoint (t2, __positionX, controlY1, controlY2, anchorY);
				
			}
			
		}
		
		__inflateBounds (ix1 - __strokePadding, iy1 - __strokePadding);
		__inflateBounds (ix1 + __strokePadding, iy1 + __strokePadding);
		__inflateBounds (ix2 - __strokePadding, iy2 - __strokePadding);
		__inflateBounds (ix2 + __strokePadding, iy2 + __strokePadding);
		
		__positionX = anchorX;
		__positionY = anchorY;
		
		__commands.cubicCurveTo (controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
		
		__dirty = true;
		
	}
	
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		
		__inflateBounds (__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds (__positionX + __strokePadding, __positionY + __strokePadding);
		
		var ix, iy;
		
		if ((controlX < anchorX && controlX > __positionX) || (controlX > anchorX && controlX < __positionX)) {
			
			ix = anchorX;
			
		} else {
			
			var tx = ((__positionX - controlX) / (__positionX - 2 * controlX + anchorX));
			ix = __calculateBezierQuadPoint (tx, __positionX, controlX, anchorX);
			
		}
		
		if ((controlY < anchorY && controlY > __positionY) || (controlY > anchorY && controlY < __positionY)) {
			
			iy = anchorY;
			
		} else {
			
			var ty = ((__positionY - controlY) / (__positionY - (2 * controlY) + anchorY));
			iy = __calculateBezierQuadPoint (ty, __positionY, controlY, anchorY);
			
		}
		
		__inflateBounds (ix - __strokePadding, iy - __strokePadding);
		__inflateBounds (ix + __strokePadding, iy + __strokePadding);
		
		__positionX = anchorX;
		__positionY = anchorY;
		
		__commands.curveTo (controlX, controlY, anchorX, anchorY);
		
		__dirty = true;
		
	}
	
	
	public function drawCircle (x:Float, y:Float, radius:Float):Void {
		
		if (radius <= 0) return;
		
		__inflateBounds (x - radius - __strokePadding, y - radius - __strokePadding);
		__inflateBounds (x + radius + __strokePadding, y + radius + __strokePadding);
		
		__commands.drawCircle (x, y, radius);
		
		__dirty = true;
		
	}
	
	
	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __strokePadding, y - __strokePadding);
		__inflateBounds (x + width + __strokePadding, y + height + __strokePadding);
		
		__commands.drawEllipse (x, y, width, height);
		
		__dirty = true;
		
	}
	
	
	public function drawGraphicsData (graphicsData:Vector<IGraphicsData>):Void {
		
		var fill:GraphicsSolidFill;
		var bitmapFill:GraphicsBitmapFill;
		var gradientFill:GraphicsGradientFill;
		var stroke:GraphicsStroke;
		var path:GraphicsPath;
		
		for (graphics in graphicsData) {
			
			if (Std.is (graphics, GraphicsSolidFill)) {
				
				fill = cast graphics;
				beginFill (fill.color, fill.alpha);
				
			} else if (Std.is (graphics, GraphicsBitmapFill)) {
				
				bitmapFill = cast graphics;
				beginBitmapFill (bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);
				
			} else if (Std.is (graphics, GraphicsGradientFill)) {
				
				gradientFill = cast graphics;
				beginGradientFill (gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix, gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);
				
			} else if (Std.is (graphics, GraphicsStroke)) {
				
				stroke = cast graphics;
				
				if (Std.is (stroke.fill, GraphicsSolidFill)) {
					
					fill = cast stroke.fill;
					lineStyle (stroke.thickness, fill.color, fill.alpha, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
					
				} else {
					
					lineStyle (stroke.thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
					
					if (Std.is (stroke.fill, GraphicsBitmapFill)) {
						
						bitmapFill = cast stroke.fill;
						lineBitmapStyle (bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);
						
					} else if (Std.is (stroke.fill, GraphicsGradientFill)) {
						
						gradientFill = cast stroke.fill;
						lineGradientStyle (gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix, gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);
						
					}
					
				}
				
			} else if (Std.is (graphics, GraphicsPath)) {
				
				path = cast graphics;
				drawPath (path.commands, path.data, path.winding);
				
			} else if (Std.is (graphics, GraphicsEndFill)) {
				
				endFill ();
				
			}
			
		}
		
	}
	
	
	public function drawPath (commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding = GraphicsPathWinding.EVEN_ODD):Void {
		
		var dataIndex = 0;
		
		for (command in commands) {
			
			switch (command) {
				
				case GraphicsPathCommand.MOVE_TO:
					
					moveTo (data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;
					
				case GraphicsPathCommand.LINE_TO:
					
					lineTo (data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;
				
				case GraphicsPathCommand.WIDE_MOVE_TO:
					
					moveTo (data[dataIndex + 2], data[dataIndex + 3]); break;
					dataIndex += 4;
				
				case GraphicsPathCommand.WIDE_LINE_TO:
					
					lineTo (data[dataIndex + 2], data[dataIndex + 3]); break;
					dataIndex += 4;
					
				case GraphicsPathCommand.CURVE_TO:
					
					curveTo (data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3]);
					dataIndex += 4;
					
				case GraphicsPathCommand.CUBIC_CURVE_TO:
					
					cubicCurveTo (data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3], data[dataIndex + 4], data[dataIndex + 5]);
					dataIndex += 6;
				
				default:
				
			}
			
		}
		
	}
	
	
	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __strokePadding, y - __strokePadding);
		__inflateBounds (x + width + __strokePadding, y + height + __strokePadding);
		
		__commands.drawRect (x, y, width, height);
		
		__dirty = true;
		
	}
	
	
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float> = null):Void {
		
		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __strokePadding, y - __strokePadding);
		__inflateBounds (x + width + __strokePadding, y + height + __strokePadding);
		
		__commands.drawRoundRect (x, y, width, height, ellipseWidth, ellipseHeight);
		
		__dirty = true;
		
	}
	
	
	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawRoundRectComplex");
		
	}
	
	
	public function drawTriangles (vertices:Vector<Float>, indices:Vector<Int> = null, uvtData:Vector<Float> = null, culling:TriangleCulling = TriangleCulling.NONE):Void {
		
		var vlen = Std.int (vertices.length / 2);
		
		if (culling == null) {
			
			culling = NONE;
			
		}
		
		if (indices == null) {
			
			if (vlen % 3 != 0) {
				
				throw new ArgumentError ("Not enough vertices to close a triangle.");
				
			}
			
			indices = new Vector<Int> ();
			
			for (i in 0...vlen) {
				
				indices.push (i);
				
			}
			
		}
		
		__inflateBounds (0, 0);
		
		var tmpx = Math.NEGATIVE_INFINITY;
		var tmpy = Math.NEGATIVE_INFINITY;
		var maxX = Math.NEGATIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;
		
		for (i in 0...vlen) {
			
			tmpx = vertices[i * 2];
			tmpy = vertices[i * 2 + 1];
			if (maxX < tmpx) maxX = tmpx;
			if (maxY < tmpy) maxY = tmpy;
			
		}
		
		__inflateBounds (maxX, maxY);
		__commands.drawTriangles (vertices, indices, uvtData, culling);
		
		__dirty = true;
		__visible = true;
		
	}
	
	
	public function endFill ():Void {
		
		__commands.endFill();
		
	}
	
	
	public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		
		__commands.lineBitmapStyle (bitmap, matrix != null ? matrix.clone () : null, repeat, smooth);
		
	}
	
	
	public function lineGradientStyle (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = SpreadMethod.PAD, interpolationMethod:InterpolationMethod = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
		
		__commands.lineGradientStyle (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		
	}
	
	
	public function lineStyle (thickness:Null<Float> = null, color:Int = 0, alpha:Float = 1, pixelHinting:Bool = false, scaleMode:LineScaleMode = LineScaleMode.NORMAL, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3):Void {
		
		if (thickness != null) {
			
			if (joints == JointStyle.MITER) {
				
				if (thickness > __strokePadding) __strokePadding = thickness;
				
			} else {
				
				if (thickness / 2 > __strokePadding) __strokePadding = thickness / 2;
				
			}
			
		}
		
		__commands.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		
		if (thickness != null) __visible = true;
		
	}
	
	
	public function lineTo (x:Float, y:Float):Void {
		
		if (!Math.isFinite(x) || !Math.isFinite(y)) {
			
			return;
			
		}
		
		// TODO: Should we consider the origin instead, instead of inflating in all directions?
		
		__inflateBounds (__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds (__positionX + __strokePadding, __positionY + __strokePadding);
		
		__positionX = x;
		__positionY = y;
		
		__inflateBounds (__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds (__positionX + __strokePadding * 2, __positionY + __strokePadding);
		
		__commands.lineTo (x, y);
		
		__dirty = true;
		
	}
	
	
	public function moveTo (x:Float, y:Float):Void {
		
		__positionX = x;
		__positionY = y;
		
		__commands.moveTo (x, y);
		
	}
	
	
	public function readGraphicsData (recurse:Bool = true):Vector<IGraphicsData> {
		
		var graphicsData = new Vector<IGraphicsData> ();
		__owner.__readGraphicsData (graphicsData, recurse);
		return graphicsData;
		
	}
	
	
	private function __calculateBezierCubicPoint (t:Float, p1:Float, p2:Float, p3:Float, p4:Float):Float {
		
		var iT = 1 - t;
		return p1 * (iT * iT * iT) + 3 * p2 * t * (iT * iT) + 3 * p3 * iT * (t * t) + p4 * (t * t * t);
		
	}
	
	
	private function __calculateBezierQuadPoint (t:Float, p1:Float, p2:Float, p3:Float):Float {
		
		var iT = 1 - t;
		return iT * iT * p1 + 2 * iT * t * p2 + t * t * p3;
		
	}
	
	
	private function __cleanup ():Void {
		
		if (__bounds != null) {
			
			__dirty = true;
			__transformDirty = true;
			
		}
		
		__bitmap = null;
		
		#if (js && html5)
		__canvas = null;
		__context = null;
		#else
		__cairo = null;
		#end
		
	}
	
	
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__bounds == null) return;
		
		var bounds = openfl.geom.Rectangle.__temp;
		__bounds.__transform (bounds, matrix);
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, matrix:Matrix):Bool {
		
		if (__bounds == null) return false;
		
		var px = matrix.__transformInverseX (x, y);
		var py = matrix.__transformInverseY (x, y);
		
		if (px > __bounds.x && py > __bounds.y && __bounds.contains (px, py)) {
			
			if (shapeFlag) {
				
				#if (js && html5)
				return CanvasGraphics.hitTest (this, px, py);
				#elseif (cpp || neko)
				return CairoGraphics.hitTest (this, px, py);
				#end
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private function __inflateBounds (x:Float, y:Float):Void {
		
		if (__bounds == null) {
			
			__bounds = new Rectangle (x, y, 0, 0);
			__transformDirty = true;
			return;
			
		}
		
		if (x < __bounds.x) {
			
			__bounds.width += __bounds.x - x;
			__bounds.x = x;
			__transformDirty = true;
			
		}
		
		if (y < __bounds.y) {
			
			__bounds.height += __bounds.y - y;
			__bounds.y = y;
			__transformDirty = true;
			
		}
		
		if (x > __bounds.x + __bounds.width) {
			
			__bounds.width = x - __bounds.x;
			
		}
		
		if (y > __bounds.y + __bounds.height) {
			
			__bounds.height = y - __bounds.y;
			
		}
		
	}
	
	
	private function __readGraphicsData (graphicsData:Vector<IGraphicsData>):Void {
		
		var data = new DrawCommandReader (__commands);
		var path;
		
		for (type in __commands.types) {
			
			switch (type) {
				
				case CUBIC_CURVE_TO:
					
					var c = data.readCubicCurveTo ();
					
					// TODO: Convert cubic curve to bezier path
				
				case CURVE_TO:
					
					var c = data.readCurveTo ();
					path = new GraphicsPath ();
					path.curveTo (c.controlX, c.controlY, c.anchorX, c.anchorY);
					graphicsData.push (path);
				
				case LINE_TO:
					
					var c = data.readLineTo ();
					path = new GraphicsPath ();
					path.lineTo (c.x, c.y);
					graphicsData.push (path);
					
				case MOVE_TO:
					
					var c = data.readMoveTo ();
					path = new GraphicsPath ();
					path.moveTo (c.x, c.y);
					graphicsData.push (path);
				
				case LINE_GRADIENT_STYLE:
					
					var c = data.readLineGradientStyle ();
					
					// TODO
				
				case LINE_BITMAP_STYLE:
					
					var c = data.readLineBitmapStyle ();
					
					// TODO
				
				case LINE_STYLE:
					
					var c = data.readLineStyle ();
					graphicsData.push (new GraphicsStroke (c.thickness, /*c.color, c.alpha,*/ c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit));
				
				case END_FILL:
					
					data.readEndFill ();
					graphicsData.push (new GraphicsEndFill ());
				
				case BEGIN_BITMAP_FILL:
					
					var c = data.readBeginBitmapFill ();
					graphicsData.push (new GraphicsBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth));
				
				case BEGIN_FILL:
					
					var c = data.readBeginFill ();
					graphicsData.push (new GraphicsSolidFill (c.color, 1));
				
				case BEGIN_GRADIENT_FILL:
					
					var c = data.readBeginGradientFill ();
					graphicsData.push (new GraphicsGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio));
				
				case DRAW_CIRCLE:
					
					var c = data.readDrawCircle ();
					
					// TODO
				
				case DRAW_ELLIPSE:
					
					var c = data.readDrawEllipse ();
					
					// TODO
				
				case DRAW_RECT:
					
					var c = data.readDrawEllipse ();
					
					// TODO
				
				case DRAW_ROUND_RECT:
					
					var c = data.readDrawEllipse ();
					
					// TODO
				
				default:
					
					data.skip (type);
				
			}
			
		}
		
	}
	
	
	private function __update ():Void {
		
		if (__bounds == null || __bounds.width <= 0 || __bounds.height <= 0) return;
		
		var parentTransform = __owner.__getRenderTransform ();
		var scaleX, scaleY;
		
		if (parentTransform.b == 0) {
			
			scaleX = parentTransform.a;
			
		} else {
			
			scaleX = Math.sqrt (parentTransform.a * parentTransform.a + parentTransform.b * parentTransform.b);
			
		}
		
		if (parentTransform.c == 0) {
			
			scaleY = parentTransform.d;
			
		} else {
			
			scaleY = Math.sqrt (parentTransform.c * parentTransform.c + parentTransform.d * parentTransform.d);
			
		}
		
		#if openfl_disable_graphics_upscaling
		if (scaleX > 1) scaleX = 1;
		if (scaleY > 1) scaleY = 1;
		#end
		
		var width = __bounds.width * scaleX;
		var height = __bounds.height * scaleY;
		
		if (Math.abs (width - __width) > 2 || Math.abs (height - __height) > 2) {
			
			__dirty = true;
			__width = Math.floor (width);
			__height = Math.floor (height);
			
			__renderTransform.a = width / __bounds.width;
			__renderTransform.d = height / __bounds.height;
			
		}
		
		if (__width <= 0 || __height <= 0) return;
		
		__worldTransform.a = 1 / __renderTransform.a;
		__worldTransform.b = 0;
		__worldTransform.c = 0;
		__worldTransform.d = 1 / __renderTransform.d;
		__worldTransform.tx = __bounds.x;
		__worldTransform.ty = __bounds.y;
		__worldTransform.concat (__owner.__worldTransform);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set___dirty (value:Bool):Bool {
		
		if (value && __owner != null) {
			
			@:privateAccess __owner.__setRenderDirty();
			
		}
		
		return __dirty = value;
		
	}
	
	
}