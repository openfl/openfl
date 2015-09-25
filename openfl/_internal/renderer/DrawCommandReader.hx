package openfl._internal.renderer;


import openfl._internal.renderer.opengl.utils.DrawPath;
import openfl.display.BitmapData;
import openfl.display.CapsStyle;
import openfl.display.GradientType;
import openfl.display.GraphicsPathWinding;
import openfl.display.InterpolationMethod;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.SpreadMethod;
import openfl.display.Tilesheet;
import openfl.display.TriangleCulling;
import openfl.geom.Matrix;
import openfl.Vector;

@:allow(openfl._internal.renderer)


class DrawCommandReader {
	
	
	public var buffer:DrawCommandBuffer;
	
	private var bPos:Int;
	private var iiPos:Int;
	private var iPos:Int;
	private var ffPos:Int;
	private var fPos:Int;
	private var oPos:Int;
	private var prev:DrawCommandType;
	private var tsPos:Int;
	
	
	public function new (buffer:DrawCommandBuffer) {
		
		this.buffer = buffer;
		
		bPos = iPos = fPos = oPos = ffPos = iiPos = tsPos = 0;
		prev = UNKNOWN;
		
	}
	
	
	private inline function advance ():Void {
		
		switch (prev) {
			
			case BEGIN_BITMAP_FILL:
				
				oPos += 2; //bitmap, matrix
				bPos += 2; //repeat, smooth
			
			case BEGIN_FILL:
				
				iPos += 1; //color
				fPos += 1; //alpha
			
			case BEGIN_GRADIENT_FILL:
				
				oPos += 5; //type, matrix, spreadMethod, interpolationMethod, focalPointRatio
				iiPos += 2; //colors, ratios
				ffPos += 1; //alphas
			
			case CUBIC_CURVE_TO:
				
				fPos += 6; //controlX1, controlY1, controlX2, controlY2, anchorX, anchorY
			
			case CURVE_TO: 
				
				fPos += 4; //controlX, controlY, anchorX, anchorY
			
			case DRAW_CIRCLE:
				
				fPos += 3; //x, y, radius
			
			case DRAW_ELLIPSE:
				
				fPos += 4; //x, y, width, height
			
			case DRAW_PATH:
				
				oPos += 3; //commands, data, winding
			
			case DRAW_RECT:
				
				fPos += 4; //x, y, width, height
			
			case DRAW_ROUND_RECT:
				
				fPos += 6; //x, y, width, height, rx, ry
			
			case DRAW_TILES:
				
				tsPos += 1; //sheet
				ffPos += 1; //tileData
				bPos += 1; //smooth
				iPos += 2; //flags, count
			
			case DRAW_TRIANGLES:
				
				oPos += 5; //vertices, indices, uvtData, culling, colors
				iPos += 1; //blendMode
			
			case END_FILL:
				
				//no parameters
			
			case LINE_BITMAP_STYLE:
				
				oPos += 2; //bitmap, matrix
				bPos += 2; //repeat, smooth
			
			case LINE_GRADIENT_STYLE:
				
				oPos += 5; //type, matrix, spreadMethod, interpolationMethod, focalPointRatio
				iiPos += 2; //colors, ratios
				ffPos += 1; //alphas
			
			case LINE_STYLE:
				
				oPos += 8; //thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit
			
			case LINE_TO:
				
				fPos += 2; //x, y
			
			case MOVE_TO:
				
				fPos += 2; //x, y
				
			
			case OVERRIDE_MATRIX:
				
				oPos += 1; //matrix
			
			default:
				
			
		}
		
	}
	
	
	private inline function bool (index:Int):Bool {
		
		return buffer.b[bPos + index];
		
	}
	
	
	public function destroy ():Void {
		
		buffer = null;
		reset ();
		
	}
	
	
	private inline function fArr (index:Int):Array<Float> {
		
		return buffer.ff[ffPos + index];
		
	}
	
	
	private inline function float (index:Int):Float {
		
		return buffer.f[fPos + index];
		
	}
	
	
	private inline function iArr (index:Int):Array<Int> {
		
		return buffer.ii[iiPos + index];
		
	}
	
	
	private inline function int (index:Int):Int {
		
		return buffer.i[iPos + index];
		
	}
	
	
	private inline function obj (index:Int):Dynamic {
		
		return buffer.o[oPos + index];
		
	}
	
	
	public inline function readBeginBitmapFill ():BeginBitmapFillView { advance (); prev = BEGIN_BITMAP_FILL; return new BeginBitmapFillView (this); }
	public inline function readBeginFill ():BeginFillView { advance (); prev = BEGIN_FILL; return new BeginFillView (this); }
	public inline function readBeginGradientFill ():BeginGradientFillView { advance (); prev = BEGIN_GRADIENT_FILL; return new BeginGradientFillView (this); }
	public inline function readCubicCurveTo ():CubicCurveToView { advance (); prev = CUBIC_CURVE_TO; return new CubicCurveToView (this); }
	public inline function readCurveTo ():CurveToView { advance (); prev = CURVE_TO; return new CurveToView (this); }
	public inline function readDrawCircle ():DrawCircleView { advance (); prev = DRAW_CIRCLE; return new DrawCircleView (this); }
	public inline function readDrawEllipse ():DrawEllipseView { advance (); prev = DRAW_ELLIPSE; return new DrawEllipseView (this); }
	public inline function readDrawPath ():DrawPathView { advance (); prev = DRAW_PATH; return new DrawPathView (this); }
	public inline function readDrawRect ():DrawRectView { advance (); prev = DRAW_RECT; return new DrawRectView (this); }
	public inline function readDrawRoundRect ():DrawRoundRectView { advance (); prev = DRAW_ROUND_RECT; return new DrawRoundRectView (this); }
	public inline function readDrawTiles ():DrawTilesView { advance (); prev = DRAW_TILES; return new DrawTilesView (this); }
	public inline function readDrawTriangles ():DrawTrianglesView { advance (); prev = DRAW_TRIANGLES; return new DrawTrianglesView (this); }
	public inline function readEndFill ():EndFillView { advance (); prev = END_FILL; return new EndFillView (this); }
	public inline function readLineBitmapStyle ():LineBitmapStyleView { advance (); prev = LINE_BITMAP_STYLE; return new LineBitmapStyleView (this); }
	public inline function readLineGradientStyle ():LineGradientStyleView { advance (); prev = LINE_GRADIENT_STYLE; return new LineGradientStyleView (this); }
	public inline function readLineStyle ():LineStyleView { advance (); prev = LINE_STYLE; return new LineStyleView (this); }
	public inline function readLineTo ():LineToView { advance (); prev = LINE_TO; return new LineToView (this); }
	public inline function readMoveTo ():MoveToView { advance (); prev = MOVE_TO; return new MoveToView (this); }
	public inline function readOverrideMatrix ():OverrideMatrixView { advance (); prev = OVERRIDE_MATRIX; return new OverrideMatrixView (this); }
	
	
	public function reset ():Void {
		
		bPos = iPos = fPos = oPos = ffPos = iiPos = tsPos = 0;
		
	}
	
	
	public inline function skip (type:DrawCommandType):Void {
		
		advance ();
		prev = type;
		
	}
	
	
	private inline function tileSheet (index:Int):Tilesheet {
		
		return buffer.ts[tsPos + index];
		
	}
	
	
}


abstract BeginBitmapFillView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var bitmap (get, never):BitmapData; private inline function get_bitmap ():BitmapData { return cast this.obj (0); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return cast this.obj (1); }
	public var repeat (get, never):Bool; private inline function get_repeat ():Bool { return this.bool (0); }
	public var smooth (get, never):Bool; private inline function get_smooth ():Bool { return this.bool (1); }
	
}


abstract BeginFillView (DrawCommandReader) {

	public inline function new (d:DrawCommandReader) { this = d; }
	public var color (get, never):Int; private inline function get_color ():Int { return this.int (0); }
	public var alpha (get, never):Float; private inline function get_alpha ():Float { return this.float (0); }
	
}


abstract BeginGradientFillView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var type (get, never):GradientType; private inline function get_type ():GradientType { return cast this.obj (0); }
	public var colors (get, never):Array<Int>; private inline function get_colors ():Array<Int> { return cast this.iArr (0); }
	public var alphas (get, never):Array<Float>; private inline function get_alphas ():Array<Float> { return cast this.fArr (0); }
	public var ratios (get, never):Array<Int>; private inline function get_ratios ():Array<Int> { return cast this.iArr (1); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return cast this.obj (1); }
	public var spreadMethod (get, never):Null<SpreadMethod>; private inline function get_spreadMethod ():Null<SpreadMethod> { return cast this.obj (2); }
	public var interpolationMethod (get, never):Null<InterpolationMethod>; private inline function get_interpolationMethod ():Null<InterpolationMethod> { return cast this.obj (3); }
	public var focalPointRatio (get, never):Null<Float>; private inline function get_focalPointRatio ():Null<Float> { return cast this.obj (4); }
	
}


abstract CubicCurveToView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var controlX1 (get, never):Float; private inline function get_controlX1 ():Float { return this.float (0); }
	public var controlY1 (get, never):Float; private inline function get_controlY1 ():Float { return this.float (1); }
	public var controlX2 (get, never):Float; private inline function get_controlX2 ():Float { return this.float (3); }
	public var controlY2 (get, never):Float; private inline function get_controlY2 ():Float { return this.float (4); }
	public var anchorX (get, never):Float; private inline function get_anchorX ():Float { return this.float (5); }
	public var anchorY (get, never):Float; private inline function get_anchorY ():Float { return this.float (6); }
	
}


abstract CurveToView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var controlX (get, never):Float; private inline function get_controlX ():Float { return this.float (0); }
	public var controlY (get, never):Float; private inline function get_controlY ():Float { return this.float (1); }
	public var anchorX (get, never):Float; private inline function get_anchorX ():Float { return this.float (2); }
	public var anchorY (get, never):Float; private inline function get_anchorY ():Float { return this.float (3); }
	
}


abstract DrawCircleView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var x (get, never):Float; private inline function get_x ():Float { return this.float (0); }
	public var y (get, never):Float; private inline function get_y ():Float { return this.float (1); }
	public var radius(get, never):Float; private inline function get_radius ():Float { return this.float (2); }
	
}


abstract DrawEllipseView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var x (get, never):Float; private inline function get_x ():Float { return this.float (0); }
	public var y (get, never):Float; private inline function get_y ():Float { return this.float (1); }
	public var width (get, never):Float; private inline function get_width ():Float { return this.float (2); }
	public var height(get, never):Float; private inline function get_height ():Float { return this.float (3); }
	
}


abstract DrawPathView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var commands (get, never):Vector<Int>; private inline function get_commands ():Vector<Int> { return cast this.obj (0); }
	public var data (get, never):Vector<Float>; private inline function get_data ():Vector<Float> { return cast this.obj (1); }
	public var winding (get, never):GraphicsPathWinding; private inline function get_winding ():GraphicsPathWinding { return cast this.obj (2); }
	
}


abstract DrawRectView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var x (get, never):Float; private inline function get_x ():Float { return this.float (0); }
	public var y (get, never):Float; private inline function get_y ():Float { return this.float (1); }
	public var width (get, never):Float; private inline function get_width ():Float { return this.float (2); }
	public var height(get, never):Float; private inline function get_height ():Float { return this.float (3); }
	
}


abstract DrawRoundRectView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var x (get, never):Float; private inline function get_x ():Float { return this.float (0); }
	public var y (get, never):Float; private inline function get_y ():Float { return this.float (1); }
	public var width (get, never):Float; private inline function get_width ():Float { return this.float (2); }
	public var height(get, never):Float; private inline function get_height ():Float { return this.float (3); }
	public var rx (get, never):Float; private inline function get_rx ():Float { return this.float (4); }
	public var ry (get, never):Float; private inline function get_ry ():Float { return this.float (5); }
	
}


abstract DrawTilesView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var sheet (get, never):Tilesheet; private inline function get_sheet ():Tilesheet { return this.tileSheet (0); }
	public var tileData (get, never):Array<Float>; private inline function get_tileData ():Array<Float> { return this.fArr (0); }
	public var smooth (get, never):Bool; private inline function get_smooth ():Bool { return this.bool (0); }
	public var flags (get, never):Int; private inline function get_flags ():Int { return this.int (0); }
	public var count (get, never):Int; private inline function get_count ():Int { return this.int (1); }
	
}


abstract DrawTrianglesView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var vertices (get, never):Vector<Float>; private inline function get_vertices ():Vector<Float> { return cast this.obj (0); }
	public var indices (get, never):Vector<Int>; private inline function get_indices ():Vector<Int> { return cast this.obj (1); }
	public var uvtData (get, never):Vector<Float>; private inline function get_uvtData ():Vector<Float> { return cast this.obj (2); }
	public var culling (get, never):TriangleCulling; private inline function get_culling ():TriangleCulling { return cast this.obj (3); }
	public var colors (get, never):Vector<Int>; private inline function get_colors ():Vector<Int> { return cast this.obj (4); }
	public var blendMode (get, never):Int; private inline function get_blendMode ():Int { return this.int (0); }
	
}


abstract EndFillView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	
}


abstract LineBitmapStyleView (DrawCommandReader) { 
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var bitmap (get, never):BitmapData; private inline function get_bitmap ():BitmapData { return cast this.obj (0); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return cast this.obj (1); }
	public var repeat (get, never):Bool; private inline function get_repeat ():Bool { return cast this.bool (0); }
	public var smooth (get, never):Bool; private inline function get_smooth ():Bool { return cast this.bool (1); }
	
}


abstract LineGradientStyleView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var type (get, never):GradientType; private inline function get_type ():GradientType { return cast this.obj (0); }
	public var colors (get, never):Array<Int>; private inline function get_colors ():Array<Int> { return cast this.iArr (0); }
	public var alphas (get, never):Array<Float>; private inline function get_alphas ():Array<Float> { return cast this.fArr (0); }
	public var ratios (get, never):Array<Int>; private inline function get_ratios ():Array<Int> { return cast this.iArr (1); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return cast this.obj (1); }
	public var spreadMethod (get, never):Null<SpreadMethod>; private inline function get_spreadMethod ():Null<SpreadMethod> { return cast this.obj (2); }
	public var interpolationMethod (get, never):Null<InterpolationMethod>; private inline function get_interpolationMethod ():Null<InterpolationMethod> { return cast this.obj (3); }
	public var focalPointRatio (get, never):Null<Float>; private inline function get_focalPointRatio ():Null<Float> { return cast this.obj (4); }
	
}


abstract LineStyleView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var thickness (get, never):Null<Float>; private inline function get_thickness ():Null<Float> { return cast this.obj (0); }
	public var color (get, never):Null<Int>; private inline function get_color ():Null<Int> { return cast this.obj (1); }
	public var alpha (get, never):Null<Float>; private inline function get_alpha ():Null<Float> { return cast this.obj (2); }
	public var pixelHinting (get, never):Null<Bool>; private inline function get_pixelHinting ():Null<Bool> { return cast this.obj (3); }
	public var scaleMode (get, never):LineScaleMode; private inline function get_scaleMode ():LineScaleMode { return cast this.obj (4); }
	public var caps (get, never):CapsStyle; private inline function get_caps ():CapsStyle { return cast this.obj (5); }
	public var joints (get, never):JointStyle; private inline function get_joints ():JointStyle { return cast this.obj (6); }
	public var miterLimit (get, never):Null<Float>; private inline function get_miterLimit ():Null<Float> { return cast this.obj (7); }
	
}


abstract LineToView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var x (get, never):Float; private inline function get_x ():Float { return this.float (0); }
	public var y (get, never):Float; private inline function get_y ():Float { return this.float (1); }
	
}


abstract MoveToView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var x (get, never):Float; private inline function get_x ():Float { return this.float (0); }
	public var y (get, never):Float; private inline function get_y ():Float { return this.float (1); }
	
}


abstract OverrideMatrixView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return cast this.obj (0); }
	
}