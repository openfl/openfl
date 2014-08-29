package openfl.display; #if !flash


import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.geom.Point;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

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

	private var __hasFill:Bool = false;
	private var __fillColor:Null<Int> = null;
	private var __fillApha:Float = 1;

	private var __lineWidth:Float = 0;
	private var __lineColor:Int = 0;
	private var __lineAlpha:Float = 1;

	//private var __tint:Int = 0xFFFFFF;
	//private var __blendMode:BlendMode = NORMAL;
	private var __dirty:Bool = true;

	private var __graphicsData:Array<DrawPath> = [];
	private var __currentPath:DrawPath;
	private var __openGL:Array<Dynamic> = [];

	private var __bounds:Rectangle;
	private var __halfStrokeWidth:Float;
	private var __positionX:Float;
	private var __positionY:Float;


	#if js
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	#end
	//TODO delete
	private var __commands:Array<DrawCommand> = [];
	private var __visible:Bool = true;

	public function new() {

		__currentPath = new DrawPath();
		__halfStrokeWidth = 0;
		__positionX = 0;
		__positionY = 0;

	}

	public function beginFill(color:Int = 0, alpha:Float = 1) {

		__hasFill = alpha > 0;
		__fillColor = color;
		__fillApha = alpha;

		__commands.push (BeginFill (color & 0xFFFFFF, alpha));

	}

	public function endFill() {

		__hasFill = false;
		__fillColor = null;
		__fillApha = 1;

	}

	public function lineStyle (thickness:Null<Float> = null, color:Int = 0, alpha:Float = 1, pixelHinting:Bool = false, scaleMode:LineScaleMode = null, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Null<Float> = null) {

		if(thickness == null || thickness < 0) {
			__lineWidth = 0;
		} else if (thickness == 0){
			__lineWidth = 1;
		} else {
			__lineWidth = thickness;
		}

		__halfStrokeWidth = __lineWidth / 2;

		__commands.push (LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit));

		graphicDataPop();

		__lineColor = color;
		__lineAlpha = alpha;

		__currentPath = new DrawPath();
		__currentPath.update(this);
		__currentPath.points = [];
		__currentPath.type = Polygon;

		__graphicsData.push(__currentPath);

	}

	public function moveTo (x:Float, y:Float) {

		__positionX = x;
		__positionY = y;

		__commands.push (MoveTo (x, y));

		graphicDataPop();

		__currentPath = new DrawPath();
		__currentPath.update(this);
		__currentPath.type = Polygon;
		__currentPath.points.push(x);
		__currentPath.points.push(y);

		__graphicsData.push(__currentPath);

	}

	public function lineTo (x:Float, y:Float) {

		// TODO: Should we consider the origin instead, instead of inflating in all directions?
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__positionX = x;
		__positionY = y;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);

		__commands.push (LineTo (x, y));

		__currentPath.points.push(x);
		__currentPath.points.push(y);
		__dirty = true;

	}

	public function curveTo (cx:Float, cy:Float, x:Float, y:Float) {

		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		// TODO: Be a little less lenient in canvas size?
		
		__inflateBounds (cx, cy);
		
		__positionX = x;
		__positionY = y;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);

		__commands.push (CurveTo (cx, cy, x, y));

		if(__currentPath.points.length == 0) {
			moveTo(0, 0);
		}

		var xa:Float = 0;
		var ya:Float = 0;
		var n = 20;

		var points = __currentPath.points;
		var fromX = points[points.length-2];
		var fromY = points[points.length-1];

		var px:Float = 0;
		var py:Float = 0;

		var tmp:Float = 0;

		for(i in 1...n+1) {

			tmp = i / n;

			xa = fromX + ((cx - fromX) * tmp);
			ya = fromY + ((cy - fromY) * tmp);

			px = xa + (((cx + (x - cx) * tmp)) - xa) * tmp;
			py = ya + (((cy + (y - cy) * tmp)) - ya) * tmp;

			points.push(px);
			points.push(py);

		}

		__dirty = true;

	}

	public function cubicCurveTo (cx:Float, cy:Float, cx2:Float, cy2:Float, x:Float, y:Float) {

		if(__currentPath.points.length == 0) {
			moveTo(0, 0);
		}

		var n = 20;
		var dt:Float = 0;
		var dt2:Float = 0;
		var dt3:Float = 0;
		var t2:Float = 0;
		var t3:Float = 0;

		var points = __currentPath.points;
		var fromX = points[points.length-2];
		var fromY = points[points.length-1];

		var px:Float = 0;
		var py:Float = 0;

		var tmp:Float = 0;

		for(i in 1...n+1) {

			tmp = i / n;

			dt = 1 - tmp;
			dt2 = dt * dt;
			dt3 = dt2 * dt;

			t2 = tmp * tmp;
			t3 = t2 * tmp;

			px = dt3 * fromX + 3 * dt2 * tmp * cx + 3 * dt * t2 * cx2 + t3 * x;
			py = dt3 * fromY + 3 * dt2 * tmp * cy + 3 * dt * t2 * cy2 + t3 * y;

			points.push(px);
			points.push(py);

		}

		__dirty = true;

	}

	public function drawRect (x:Float, y:Float, width:Float, height:Float) {

		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);

		__commands.push (DrawRect (x, y, width, height));

		graphicDataPop();

		__currentPath = new DrawPath();
		__currentPath.update(this);
		__currentPath.type = Rectangle(false);
		__currentPath.points = [x, y, width, height];

		__graphicsData.push(__currentPath);

		__dirty = true;

	}

	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, radius:Float) {

		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);

		graphicDataPop();

		__currentPath = new DrawPath();
		__currentPath.update(this);
		__currentPath.type = Rectangle(true);
		__currentPath.points = [x, y, width, height, radius];

		__graphicsData.push(__currentPath);

		__dirty = true;

	}

	public function drawCircle (x:Float, y:Float, radius:Float) {

		if (radius <= 0) return;
		
		__inflateBounds (x - radius - __halfStrokeWidth, y - radius - __halfStrokeWidth);
		__inflateBounds (x + radius + __halfStrokeWidth, y + radius + __halfStrokeWidth);

		__commands.push (DrawCircle (x, y, radius));

		graphicDataPop();

		__currentPath = new DrawPath();
		__currentPath.update(this);
		__currentPath.type = Circle;
		__currentPath.points = [x, y, radius];

		__graphicsData.push(__currentPath);

		__dirty = true;

	}

	public function drawEllipse (x:Float, y:Float, width:Float, height:Float) {

		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);

		__commands.push (DrawEllipse (x, y, width, height));

		graphicDataPop();

		__currentPath = new DrawPath();
		__currentPath.update(this);
		__currentPath.type = Ellipse;
		__currentPath.points = [x, y, width, height];

		__graphicsData.push(__currentPath);

		__dirty = true;

	}

	public function clear() {

		__commands = new Array ();
		__lineWidth = 0;
		__halfStrokeWidth = 0;
		__hasFill = false;
		__graphicsData = [];
		__dirty = false;
		if(__bounds != null) {
			__dirty = true;
			__bounds = null;
		}

	}




	public function drawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1):Void { }

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


	private inline function graphicDataPop() {
		if(__currentPath.points.length == 0) __graphicsData.pop();
	}
	
}

@:access(openfl.display.Graphics)
class DrawPath {

	public var lineWidth:Float = 0;
	public var lineColor:Int = 0;
	public var lineAlpha:Float = 1;

	public var hasFill:Bool = false;
	public var fillColor:Null<Int> = null;
	public var fillAlpha:Float = 1;

	public var points:Array<Float> = [];

	public var type:GraphicType = Polygon;

	public function new() {

	}

	public function update(graphics:Graphics):Void {
		updateLine(graphics.__lineWidth, graphics.__lineColor, graphics.__lineAlpha);
		updateFill(graphics.__hasFill, graphics.__fillColor, graphics.__fillApha);
	}

	public function updateLine(width:Float, color:Int, alpha:Float):Void {
		lineWidth = width;
		lineColor = color;
		lineAlpha = alpha;
	}

	public function updateFill(fill:Bool, color:Int, alpha:Float):Void {
		hasFill = fill;
		fillColor = color;
		fillAlpha = alpha;
	}

}

typedef LineStyle = {
	width:Float,
	color:Float,
	alpha:Float,

	scaleMode:LineScaleMode,
	caps:CapsStyle,
	joints:JointStyle,
	miterLimit:Float,
}

enum GraphicType {

	Polygon;
	Rectangle(rounded:Bool);
	Circle;
	Ellipse;

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