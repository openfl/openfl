package openfl._v2.display; #if lime_legacy


import openfl.display.GradientType;
import openfl.display.GraphicsPathWinding;
import openfl.display.InterpolationMethod;
import openfl.geom.Matrix;
import openfl.Lib;
import openfl.display.Tilesheet;


class Graphics {
	
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	public static inline var TILE_TRANS_2x2 = 0x0010;
	public static inline var TILE_RECT = 0x0020;
	public static inline var TILE_ORIGIN = 0x0040;
	private static inline var TILE_SMOOTH = 0x1000;
	public static inline var TILE_BLEND_NORMAL = 0x00000000;
	public static inline var TILE_BLEND_ADD = 0x00010000;
	
	@:noCompletion private var __handle:Dynamic;
	
	
	public function new (handle:Dynamic) {
		
		__handle = handle;
		
	}
	
	
	public function arcTo (controlX:Float, controlY:Float, x:Float, y:Float):Void {
		
		lime_gfx_arc_to (__handle, controlX, controlY, x, y);
		
	}
	
	
	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		
		lime_gfx_begin_bitmap_fill (__handle, bitmap.__handle, matrix, repeat, smooth);
		
	}
	
	
	public function beginFill (color:Int, alpha:Float = 1.0):Void {
		
		lime_gfx_begin_fill (__handle, color, alpha);
		
	}
	
	
	public function beginGradientFill (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix = null, spreadMethod:SpreadMethod = null, interpolationMethod:InterpolationMethod = null, focalPointRatio:Float = 0.0):Void {
		
		if (matrix == null) {
			
			matrix = new Matrix ();
			matrix.createGradientBox (200, 200, 0, -100, -100);
			
		}
		
		lime_gfx_begin_gradient_fill (__handle, Type.enumIndex (type), colors, alphas, ratios, matrix, spreadMethod == null ? 0 : Type.enumIndex (spreadMethod), interpolationMethod == null ? 0 : Type.enumIndex (interpolationMethod), focalPointRatio);
		
	}
	
	
	public function clear ():Void {
		
		lime_gfx_clear (__handle);
		
	}
	
	
	public function copyFrom (sourceGraphics:Graphics):Void {
		
		openfl.Lib.notImplemented ("Graphics.copyFrom");
		
	}
	
	
	public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {
		
		openfl.Lib.notImplemented ("Graphics.cubicCurveTo");
		
	}
	
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		
		lime_gfx_curve_to (__handle, controlX, controlY, anchorX, anchorY);
		
	}
	
	
	public function drawCircle (x:Float, y:Float, radius:Float):Void {
		
		lime_gfx_draw_ellipse (__handle, x - radius, y - radius, radius * 2, radius * 2);
		
	}
	
	
	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void {
		
		lime_gfx_draw_ellipse (__handle, x, y, width, height);
		
	}
	
	
	public function drawGraphicsData (graphicsData:Array<IGraphicsData>):Void {
		
		var handles = new Array<Dynamic> ();
		
		for (datum in graphicsData) {
			
			handles.push (datum.__handle);
			
		}
		
		lime_gfx_draw_data (__handle, handles);
		
	}
	
	
	public function drawGraphicsDatum (graphicsDatum:IGraphicsData):Void {
		
		lime_gfx_draw_datum (__handle, graphicsDatum.__handle);
		
	}
	
	
	public function drawPoints (xy:Array<Float>, pointRGBA:Array<Int> = null, defaultRGBA:Int = 0xffffffff, size:Float = -1.0):Void {
		
		lime_gfx_draw_points (__handle, xy, pointRGBA, defaultRGBA, false, size);
		
	}
	
	
	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void {
		
		lime_gfx_draw_rect (__handle, x, y, width, height);
		
	}
	
	
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, radiusX:Float, radiusY:Null<Float> = null):Void {
		
		lime_gfx_draw_round_rect (__handle, x, y, width, height, radiusX, radiusY == null ? radiusX : radiusY);
		
	}
	
	
	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawRoundRectComplex");
		
	}
	
	
	public function drawPath (commands:Array<Int>, data:Array<Float>, winding:GraphicsPathWinding = null):Void {
		
		lime_gfx_draw_path (__handle, commands, data, winding == GraphicsPathWinding.EVEN_ODD);
		
	}
	
	
	public function drawTiles (sheet:Tilesheet, data:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1):Void {
		
		beginBitmapFill (sheet.__bitmap, null, false, smooth);
		
		if (smooth) {
			
			flags |= TILE_SMOOTH;
			
		}
		
		lime_gfx_draw_tiles (__handle, sheet.__handle, data, flags, count);
	}
	
	
	public function drawTriangles (vertices:Array<Float>, indices:Array<Int> = null, uvtData:Array<Float> = null, culling:TriangleCulling = null, colors:Array<Int> = null, blendMode:Int = 0):Void {
		
		var cull:Int = (culling == null ? 0 : Type.enumIndex (culling) - 1);
		lime_gfx_draw_triangles (__handle, vertices, indices, uvtData, cull, colors, blendMode);
		
	}
	
	
	public function endFill ():Void {
		
		lime_gfx_end_fill (__handle);
		
	}
	
	
	public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		
		lime_gfx_line_bitmap_fill (__handle, bitmap.__handle, matrix, repeat, smooth);
		
	}
	
	
	public function lineGradientStyle (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix = null, spreadMethod:Null<SpreadMethod> = null, interpolationMethod:Null<InterpolationMethod> = null, focalPointRatio:Float = 0.0):Void {
		
		if (matrix == null) {
			
			matrix = new Matrix ();
			matrix.createGradientBox (200, 200, 0, -100, -100);
			
		}
		
		lime_gfx_line_gradient_fill (__handle, Type.enumIndex (type), colors, alphas, ratios, matrix, spreadMethod == null ? 0 : Type.enumIndex (spreadMethod), interpolationMethod == null ? 0 : Type.enumIndex (interpolationMethod), focalPointRatio);
		
	}
	
	
	public function lineStyle (thickness:Null<Float> = null, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:LineScaleMode = null, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3):Void {
		
		lime_gfx_line_style (__handle, thickness, color, alpha, pixelHinting, scaleMode == null ?  0 : Type.enumIndex (scaleMode), caps == null ?  0 : Type.enumIndex (caps), joints == null ?  0 : Type.enumIndex (joints), miterLimit);
		
	}
	
	
	public function lineTo (x:Float, y:Float):Void {
		
		lime_gfx_line_to (__handle, x, y);
		
	}
	
	
	public function moveTo (x:Float, y:Float):Void {
		
		lime_gfx_move_to (__handle, x, y);
		
	}
	
	
	@:noCompletion @:deprecated public static inline function RGBA (rgb:Int, alpha:Int = 0xff):Int {
		
		return rgb | (alpha << 24);
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_gfx_clear = Lib.load ("lime", "lime_gfx_clear", 1);
	private static var lime_gfx_begin_fill = Lib.load ("lime", "lime_gfx_begin_fill", 3);
	private static var lime_gfx_begin_bitmap_fill = Lib.load ("lime", "lime_gfx_begin_bitmap_fill", 5);
	private static var lime_gfx_line_bitmap_fill = Lib.load ("lime", "lime_gfx_line_bitmap_fill", 5);
	private static var lime_gfx_begin_gradient_fill = Lib.load ("lime", "lime_gfx_begin_gradient_fill", -1);
	private static var lime_gfx_line_gradient_fill = Lib.load ("lime", "lime_gfx_line_gradient_fill", -1);
	private static var lime_gfx_end_fill = Lib.load ("lime", "lime_gfx_end_fill", 1);
	private static var lime_gfx_line_style = Lib.load ("lime", "lime_gfx_line_style", -1);
	private static var lime_gfx_move_to = Lib.load ("lime", "lime_gfx_move_to", 3);
	private static var lime_gfx_line_to = Lib.load ("lime", "lime_gfx_line_to", 3);
	private static var lime_gfx_curve_to = Lib.load ("lime", "lime_gfx_curve_to", 5);
	private static var lime_gfx_arc_to = Lib.load ("lime", "lime_gfx_arc_to", 5);
	private static var lime_gfx_draw_ellipse = Lib.load ("lime", "lime_gfx_draw_ellipse", 5);
	private static var lime_gfx_draw_data = Lib.load ("lime", "lime_gfx_draw_data", 2);
	private static var lime_gfx_draw_datum = Lib.load ("lime", "lime_gfx_draw_datum", 2);
	private static var lime_gfx_draw_rect = Lib.load ("lime", "lime_gfx_draw_rect", 5);
	private static var lime_gfx_draw_path = Lib.load ("lime", "lime_gfx_draw_path", 4);
	private static var lime_gfx_draw_tiles = Lib.load ("lime", "lime_gfx_draw_tiles", 5);
	private static var lime_gfx_draw_points = Lib.load ("lime", "lime_gfx_draw_points", -1);
	private static var lime_gfx_draw_round_rect = Lib.load ("lime", "lime_gfx_draw_round_rect", -1);
	private static var lime_gfx_draw_triangles = Lib.load ("lime", "lime_gfx_draw_triangles", -1);
	
	
}


#end