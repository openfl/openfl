package openfl.display; #if !flash #if (next || js)


import openfl.errors.ArgumentError;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
#end


class Graphics {
	
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	public static inline var TILE_TRANS_2x2 = 0x0010;
	public static inline var TILE_BLEND_NORMAL = 0x00000000;
	public static inline var TILE_BLEND_ADD = 0x00010000;
	
	private var __bounds:Rectangle;
	private var __commands:Array<DrawCommand> = [];
	private var __dirty:Bool = true;
	private var __glData:Array<GLData> = [];
	private var __glGraphicsData:Array<DrawPath>;
	private var __halfStrokeWidth:Float;
	private var __positionX:Float;
	private var __positionY:Float;
	private var __visible:Bool = true;
	
	#if js
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	#end
	
	
	public function new () {
		
		__commands = new Array ();
		__halfStrokeWidth = 0;
		__positionX = 0;
		__positionY = 0;
		
	}
	
	
	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {
		
		__commands.push (BeginBitmapFill (bitmap, matrix, repeat, smooth));
		
		__visible = true;
		
	}
	
	
	public function beginFill (color:Int = 0, alpha:Float = 1):Void {
		
		__commands.push (BeginFill (color & 0xFFFFFF, alpha));
		
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
	
	
	public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		// TODO: Is this the right calculation for bounds?
		
		__inflateBounds (controlX1, controlY1);
		__inflateBounds (controlX2, controlY2);
		
		__positionX = anchorX;
		__positionY = anchorY;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__commands.push (CubicCurveTo (controlX1, controlY1, controlX2, controlY2, anchorX, anchorY));
		
		__dirty = true;
		
	}
	
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float) {
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		// TODO: Be a little less lenient in canvas size?
		
		__inflateBounds (controlX, controlY);
		
		__positionX = anchorX;
		__positionY = anchorY;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__commands.push (CurveTo (controlX, controlY, anchorX, anchorY));
		
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
		
		if (width <= 0 || height <= 0) return;
		if (rx > width / 2) rx = width / 2;
		if (ry > height / 2) ry = height / 2;
		if (ry < 0) ry = rx;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);
		
		__commands.push (DrawRoundRect (x, y, width, height, rx, ry));
		
		__dirty = true;
		
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
	
	
	public function drawTriangles (vertices:Vector<Float>, indices:Vector<Int> = null, uvtData:Vector<Float> = null, culling:TriangleCulling = null):Void {
		
		var vlen = Std.int(vertices.length / 2);
		
		if (culling == null) {
			culling = NONE;
		}
		
		if (indices == null) {
			if (vlen % 3 != 0) {
				throw new ArgumentError("Not enough vertices to close a triangle.");
			}
			indices = new Vector<Int>();
			
			for (i in 0...vlen) {
				indices.push(i);
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
		__commands.push (DrawTriangles(vertices, indices, uvtData, culling));
		__dirty = true;
		__visible = true;
		
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
		
		__positionX = x;
		__positionY = y;
		
		__commands.push (MoveTo (x, y));
		
	}
	
	
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__bounds == null) return;
		
		var bounds = __bounds.clone ().transform (matrix);
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, matrix:Matrix):Bool {
		
		//TODO: Shape flag
		
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
	
	
}


enum DrawCommand {
	
	BeginBitmapFill (bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool);
	BeginFill (color:Int, alpha:Float);
	CubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float);
	CurveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float);
	DrawCircle (x:Float, y:Float, radius:Float);
	DrawEllipse (x:Float, y:Float, width:Float, height:Float);
	DrawRect (x:Float, y:Float, width:Float, height:Float);
	DrawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float);
	DrawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int);
	DrawTriangles (vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling);
	EndFill;
	LineStyle (thickness:Null<Float>, color:Null<Int>, alpha:Null<Float>, pixelHinting:Null<Bool>, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Null<Float>);
	LineTo (x:Float, y:Float);
	MoveTo (x:Float, y:Float);
	
}


#else
typedef Graphics = openfl._v2.display.Graphics;
#end
#else
typedef Graphics = flash.display.Graphics;
#end