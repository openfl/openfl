package openfl._internal.renderer;


import openfl.display.BitmapData;
import openfl.display.CapsStyle;
import openfl.display.GradientType;
import openfl.display.GraphicsPathWinding;
import openfl.display.InterpolationMethod;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.Shader;
import openfl.display.SpreadMethod;
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
	private var mPos:Int;
	private var viPos:Int;
	private var vfPos:Int;
	private var prev:DrawCommandType;
	private var bdPos:Int;
	
	public function new (buffer:DrawCommandBuffer) {
		
		this.buffer = buffer;
		
		bPos = iPos = fPos = mPos = viPos = vfPos = ffPos = iiPos = bdPos = 0;
		prev = UNKNOWN;
		
	}

	public function endCheck()
	{
		advance();

		#if (js && dev)
		js.Browser.console.assert(bPos == buffer.b.length);
		js.Browser.console.assert(ffPos == buffer.ff.length);
		js.Browser.console.assert(fPos == buffer.f.length);
		js.Browser.console.assert(iiPos == buffer.ii.length);
		js.Browser.console.assert(iPos == buffer.i.length);
		js.Browser.console.assert(mPos == buffer.m.length);
		js.Browser.console.assert(bdPos == buffer.bd.length);
		js.Browser.console.assert(viPos == buffer.vi.length);
		js.Browser.console.assert(vfPos == buffer.vf.length);
		#end
	}
	
	
	private function advance ():Void {
		
		switch (prev) {
			
			case BEGIN_BITMAP_FILL:
				
				bdPos += 1; //bitmap
				mPos += 1; // matrix
				bPos += 2; //repeat, smooth
			
			case BEGIN_FILL:
				
				iPos += 1; //color
				fPos += 1; //alpha
			
			case BEGIN_GRADIENT_FILL:
				
				mPos += 1;  //matrix
				iiPos += 2; //colors, ratios
				ffPos += 1; //alphas
				fPos += 1;  //focalPointRatio
				iPos += 3; //type, spreadMethod, interpolationMethod
			
			case CUBIC_CURVE_TO:
				
				fPos += 6; //controlX1, controlY1, controlX2, controlY2, anchorX, anchorY
			
			case CURVE_TO: 
				
				fPos += 4; //controlX, controlY, anchorX, anchorY
			
			case DRAW_CIRCLE:
				
				fPos += 3; //x, y, radius
			
			case DRAW_ELLIPSE:
				
				fPos += 4; //x, y, width, height
			
			case DRAW_IMAGE:

				bdPos += 1; //bitmap
				mPos += 1; // matrix
				bPos += 1; // smooth

			case DRAW_PATH:
				
				viPos += 1; // commands
				vfPos += 1; // data
				iPos += 1; // winding
			
			case DRAW_RECT:
				
				fPos += 4; //x, y, width, height
			
			case DRAW_ROUND_RECT:
				
				fPos += 6; //x, y, width, height, ellipseWidth, ellipseHeight
			
			case DRAW_TILES:
				
				throw("Unsupported DRAW_TILES");	
			
			case DRAW_TRIANGLES:

				vfPos += 2; //vertices, uvtData
				viPos += 1; // indices
				iPos += 1; //culling
			
			case END_FILL:
				
				//no parameters
			
			case LINE_BITMAP_STYLE:
				
				bdPos += 1; //bitmap
				mPos += 1; //matrix
				bPos += 2; //repeat, smooth
			
			case LINE_GRADIENT_STYLE:
				
				mPos += 1; // matrix
				iiPos += 2; //colors, ratios
				ffPos += 1; //alphas
				fPos += 1; //focalPointRatio
				iPos += 3; //type, spreadMethod, interpolationMethod
			
			case LINE_STYLE:
				
				iPos += 4; //color, scaleMode, caps, joints
				fPos += 3; //thickness, alpha, miterLimit
				bPos += 1; //pixelHinting
			
			case LINE_TO:
				
				fPos += 2; //x, y
			
			case MOVE_TO:
				
				fPos += 2; //x, y
				
			
			case OVERRIDE_MATRIX:
				
				mPos += 1; //matrix
			
			default:
				
			
		}
		
	}
	

	public function destroy ():Void {
		
		buffer = null;
		reset ();
		
	}
	
	private inline function bool (index:Int):Bool {
		
		return buffer.b[bPos + index];
		
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
	
	private inline function matrix (index:Int):Matrix {
		
		return buffer.m[mPos + index];
		
	}

	private inline function iVec (index:Int):Vector<Int> {
		
		return buffer.vi[viPos + index];
		
	}

	private inline function fVec (index:Int):Vector<Float> {
		
		return buffer.vf[vfPos + index];
		
	}

	private inline function bitmapData (index:Int):BitmapData {
		
		return buffer.bd[bdPos + index];
		
	}
	
	
	public inline function readBeginBitmapFill ():BeginBitmapFillView { advance (); prev = BEGIN_BITMAP_FILL; return new BeginBitmapFillView (this); }
	public inline function readBeginFill ():BeginFillView { advance (); prev = BEGIN_FILL; return new BeginFillView (this); }
	public inline function readBeginGradientFill ():BeginGradientFillView { advance (); prev = BEGIN_GRADIENT_FILL; return new BeginGradientFillView (this); }
	public inline function readCubicCurveTo ():CubicCurveToView { advance (); prev = CUBIC_CURVE_TO; return new CubicCurveToView (this); }
	public inline function readCurveTo ():CurveToView { advance (); prev = CURVE_TO; return new CurveToView (this); }
	public inline function readDrawCircle ():DrawCircleView { advance (); prev = DRAW_CIRCLE; return new DrawCircleView (this); }
	public inline function readDrawEllipse ():DrawEllipseView { advance (); prev = DRAW_ELLIPSE; return new DrawEllipseView (this); }
	public inline function readDrawImage ():DrawImageView { advance (); prev = DRAW_IMAGE; return new DrawImageView (this); }
	public inline function readDrawPath ():DrawPathView { advance (); prev = DRAW_PATH; return new DrawPathView (this); }
	public inline function readDrawRect ():DrawRectView { advance (); prev = DRAW_RECT; return new DrawRectView (this); }
	public inline function readDrawRoundRect ():DrawRoundRectView { advance (); prev = DRAW_ROUND_RECT; return new DrawRoundRectView (this); }
	public inline function readDrawTriangles ():DrawTrianglesView { advance (); prev = DRAW_TRIANGLES; return new DrawTrianglesView (this); }
	public inline function readEndFill ():EndFillView { advance (); prev = END_FILL; return new EndFillView (this); }
	public inline function readLineBitmapStyle ():LineBitmapStyleView { advance (); prev = LINE_BITMAP_STYLE; return new LineBitmapStyleView (this); }
	public inline function readLineGradientStyle ():LineGradientStyleView { advance (); prev = LINE_GRADIENT_STYLE; return new LineGradientStyleView (this); }
	public inline function readLineStyle ():LineStyleView { advance (); prev = LINE_STYLE; return new LineStyleView (this); }
	public inline function readLineTo ():LineToView { advance (); prev = LINE_TO; return new LineToView (this); }
	public inline function readMoveTo ():MoveToView { advance (); prev = MOVE_TO; return new MoveToView (this); }
	public inline function readOverrideMatrix ():OverrideMatrixView { advance (); prev = OVERRIDE_MATRIX; return new OverrideMatrixView (this); }
	
	
	public function reset (?buffer:DrawCommandBuffer = null):Void {
		this.buffer = buffer;
		bPos = iPos = fPos = mPos = viPos = vfPos = ffPos = iiPos = bdPos = 0;
		prev = UNKNOWN;
	}
	
	
	public inline function skip (type:DrawCommandType):Void {
		
		advance ();
		prev = type;
		
	}
	
		
}


abstract BeginBitmapFillView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var bitmap (get, never):BitmapData; private inline function get_bitmap ():BitmapData { return this.bitmapData (0); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return this.matrix (0); }
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
	public var type (get, never):GradientType; private inline function get_type ():GradientType { return cast this.int (0); }
	public var colors (get, never):Array<Int>; private inline function get_colors ():Array<Int> { return this.iArr (0); }
	public var alphas (get, never):Array<Float>; private inline function get_alphas ():Array<Float> { return this.fArr (0); }
	public var ratios (get, never):Array<Int>; private inline function get_ratios ():Array<Int> { return this.iArr (1); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return this.matrix (0); }
	public var spreadMethod (get, never):SpreadMethod; private inline function get_spreadMethod ():SpreadMethod { return cast this.int (1); }
	public var interpolationMethod (get, never):InterpolationMethod; private inline function get_interpolationMethod ():InterpolationMethod { return cast this.int (2); }
	public var focalPointRatio (get, never):Float; private inline function get_focalPointRatio ():Float { return this.float (0); }
	
}


abstract CubicCurveToView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var controlX1 (get, never):Float; private inline function get_controlX1 ():Float { return this.float (0); }
	public var controlY1 (get, never):Float; private inline function get_controlY1 ():Float { return this.float (1); }
	public var controlX2 (get, never):Float; private inline function get_controlX2 ():Float { return this.float (2); }
	public var controlY2 (get, never):Float; private inline function get_controlY2 ():Float { return this.float (3); }
	public var anchorX (get, never):Float; private inline function get_anchorX ():Float { return this.float (4); }
	public var anchorY (get, never):Float; private inline function get_anchorY ():Float { return this.float (5); }
	
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


abstract DrawImageView (DrawCommandReader) {

	public inline function new (d:DrawCommandReader) { this = d; }
	public var bitmap (get, never):BitmapData; private inline function get_bitmap ():BitmapData { return this.bitmapData (0); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return this.matrix (0); }
	public var smooth (get, never):Bool; private inline function get_smooth ():Bool { return this.bool (0); }

}


abstract DrawPathView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var commands (get, never):Vector<Int>; private inline function get_commands ():Vector<Int> { return this.iVec (0); }
	public var data (get, never):Vector<Float>; private inline function get_data ():Vector<Float> { return this.fVec (0); }
	public var winding (get, never):GraphicsPathWinding; private inline function get_winding ():GraphicsPathWinding { return cast this.int (0); }
	
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
	public var ellipseWidth (get, never):Float; private inline function get_ellipseWidth ():Float { return this.float (4); }
	public var ellipseHeight (get, never):Float; private inline function get_ellipseHeight ():Float { return this.float (5); }
	
}


abstract DrawTrianglesView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var vertices (get, never):Vector<Float>; private inline function get_vertices ():Vector<Float> { return this.fVec (0); }
	public var indices (get, never):Vector<Int>; private inline function get_indices ():Vector<Int> { return this.iVec (1); }
	public var uvtData (get, never):Vector<Float>; private inline function get_uvtData ():Vector<Float> { return this.fVec (2); }
	public var culling (get, never):TriangleCulling; private inline function get_culling ():TriangleCulling { return cast this.int (3); }
	
}


abstract EndFillView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	
}


abstract LineBitmapStyleView (DrawCommandReader) { 
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var bitmap (get, never):BitmapData; private inline function get_bitmap ():BitmapData { return this.bitmapData (0); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return this.matrix (0); }
	public var repeat (get, never):Bool; private inline function get_repeat ():Bool { return this.bool (0); }
	public var smooth (get, never):Bool; private inline function get_smooth ():Bool { return this.bool (1); }
	
}


abstract LineGradientStyleView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var type (get, never):GradientType; private inline function get_type ():GradientType { return cast this.int (0); }
	public var colors (get, never):Array<Int>; private inline function get_colors ():Array<Int> { return this.iArr (0); }
	public var alphas (get, never):Array<Float>; private inline function get_alphas ():Array<Float> { return this.fArr (0); }
	public var ratios (get, never):Array<Int>; private inline function get_ratios ():Array<Int> { return this.iArr (1); }
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return this.matrix (0); }
	public var spreadMethod (get, never):SpreadMethod; private inline function get_spreadMethod ():SpreadMethod { return cast this.int (1); }
	public var interpolationMethod (get, never):InterpolationMethod; private inline function get_interpolationMethod ():InterpolationMethod { return cast this.int (2); }
	public var focalPointRatio (get, never):Float; private inline function get_focalPointRatio ():Float { return this.float (0); }
	
}


abstract LineStyleView (DrawCommandReader) {
	
	public inline function new (d:DrawCommandReader) { this = d; }
	public var thickness (get, never):Float; private inline function get_thickness ():Float { return this.float (0); }
	public var color (get, never):Int; private inline function get_color ():Int { return cast this.int (0); }
	public var alpha (get, never):Float; private inline function get_alpha ():Float { return cast this.float (1); }
	public var pixelHinting (get, never):Bool; private inline function get_pixelHinting ():Bool { return cast this.bool (0); }
	public var scaleMode (get, never):LineScaleMode; private inline function get_scaleMode ():LineScaleMode { return cast this.int (1); }
	public var caps (get, never):CapsStyle; private inline function get_caps ():CapsStyle { return cast this.int (2); }
	public var joints (get, never):JointStyle; private inline function get_joints ():JointStyle { return cast this.int (3); }
	public var miterLimit (get, never):Float; private inline function get_miterLimit ():Float { return cast this.float (2); }
	
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
	public var matrix (get, never):Matrix; private inline function get_matrix ():Matrix { return this.matrix (0); }
	
}
