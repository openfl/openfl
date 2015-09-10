package openfl.display;
import haxe.ds.Vector;
import openfl._internal.renderer.opengl.utils.DrawPath;
import openfl.geom.Matrix;

class DrawCommandReader {

	public var buffer:DrawCommandBuffer;
	public var prev:DrawCommandType;
	
	public var bPos:Int;
	public var iPos:Int;
	public var fPos:Int;
	public var oPos:Int;
	
	public function new(buffer:DrawCommandBuffer) {
		
		this.buffer = buffer;
		bPos = iPos = fPos = oPos = 0;
		
	}
	
	public function destroy() {
		
		buffer = null;
		clear();
		
	}
	
	public function reset() {
		
		bPos = iPos = fPos = oPos = 0;
		
	}
	
	private function advance () {
		
		switch (prev) {
			
			case BEGIN_BITMAP_FILL:
				
				oPos += 2;	//bitmap, matrix
				bPos += 2;	//repeat, smooth
				
			case BEGIN_FILL:
				
				iPos += 1;	//color
				fPos += 1;	//alpha
				
			case BEGIN_GRADIENT_FILL:
				
				oPos += 8; //type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio
				
			case CUBIC_CURVE_TO:
				
				fPos += 6; //controlX1, controlY1, controlX2, controlY2, anchorX, anchorY
				
			case CURVE_TO: 
				
				fPos += 4; //controlX, controlY, anchorX, anchorY
				
			case DRAW_CIRCLE:
				
				fPos += 3; //x, y, radius
				
			case DRAW_ELLIPSE:
				
				fPos += 4; //x, y, width, height
				
			case DRAW_RECT:
				
				fPos += 4; //x, y, width, height
				
			case DRAW_ROUND_RECT:
				
				fPos += 6; //x, y, width, height, rx, ry
				
			case DRAW_TILES:
				
				oPos += 2; //sheet, tileData
				bPos += 1; //smooth
				iPos += 2; //flags, count
				
			case DRAW_TRIANGLES:
				
				oPos += 5; //vertices, indices, uvtData, culling, colors
				iPos += 1; //blendMode
				
			case END_FILL:
				
				//no parameters
				
			case LINE_STYLE:
				
				oPos += 8; //thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit
				
			case LINE_BITMAP_STYLE:
				
				oPos += 2; //bitmap, matrix
				bPos += 2; //repeat, smooth
				
			case LINE_GRADIENT_STYLE:
				
				oPos += 8; //type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio
				
			case LINE_TO:
				
				fPos += 2; //x, y
				
			case MOVE_TO:
				
				fPos += 2; //x, y
				
			case DRAW_PATH_C:
				
				oPos += 3; //commands, data, winding
				
			case OVERRIDE_MATRIX:
				
				oPos += 1; //matrix
				
			default:
				
				//do nothing
				
		}
	
	}
	
	public function readBeginBitmapFill   ():BeginBitmapFillView   { advance (); prev = BEGIN_BITMAP_FILL;   return new BeginBitmapFillView   (this); }
	public function readBeginFill         ():BeginFillView         { advance (); prev = BEGIN_FILL;          return new BeginFillView         (this); }
	public function readBeginGradientFill ():BeginGradientFillView { advance (); prev = BEGIN_GRADIENT_FILL; return new BeginGradientFillView (this); }
	public function readCubicCurveTo      ():CubicCurveToView      { advance (); prev = CUBIC_CURVE_TO;      return new CubicCurveToView      (this); }
	public function readCurveTo           ():CurveToView           { advance (); prev = CURVE_TO;            return new CurveToView           (this); }
	public function readDrawCircle        ():DrawCircleView        { advance (); prev = DRAW_CIRCLE;         return new DrawCircleView        (this); }
	public function readDrawEllipse       ():DrawEllipseView       { advance (); prev = DRAW_ELLIPSE;        return new DrawEllipseView       (this); }
	public function readDrawRect          ():DrawRectView          { advance (); prev = DRAW_RECT;           return new DrawRectView          (this); }
	public function readDrawRoundRect     ():DrawRoundRectView     { advance (); prev = DRAW_ROUND_RECT;     return new DrawRoundRectView     (this); }
	public function readDrawTiles         ():DrawTilesView         { advance (); prev = DRAW_TILES;          return new DrawTilesView         (this); }
	public function readDrawTriangles     ():DrawTrianglesView     { advance (); prev = DRAW_TRIANGLES;      return new DrawTrianglesView     (this); }
	public function readEndFill           ():EndFillView           { advance (); prev = END_FILL;            return new EndFillView           (this); }
	public function readLineStyle         ():LineStyleView         { advance (); prev = LINE_STYLE;          return new LineStyleView         (this); }
	public function readLineBitmapStyle   ():LineBitmapStyleView   { advance (); prev = LINE_BITMAP_STYLE;   return new LineBitmapStyleView   (this); }
	public function readLineGradientStyle ():LineGradientStyleView { advance (); prev = LINE_GRADIENT_STYLE; return new LineGradientStyleView (this); }
	public function readLineTo            ():LineToView            { advance (); prev = LINE_TO;             return new LineToView            (this); }
	public function readMoveTo            ():MoveToView            { advance (); prev = MOVE_TO;             return new MoveToView            (this); }
	public function readDrawPathC         ():DrawPathCView         { advance (); prev = DRAW_PATH_C;         return new DrawPathCView         (this); }
	public function readOverrideMatrix    ():OverrideMatrixView    { advance (); prev = OVERRIDE_MATRIX;     return new OverrideMatrixView    (this); }
	
	private inline function float (index:Int):Float {
		
		return buffer.f[fPos + index];
		
	}
	
	private inline function int (index:Int):Int {
		
		return buffer.i[iPos + index];
		
	}
	
	private inline function bool (index:Int):Bool {
		
		return buffer.b[bPos + index];
		
	}
	
	private inline function obj (index:Int):Dynamic {
		
		return buffer.o[oPos + index];
		
	}

}

abstract BeginBitmapFillView (DrawCommandReader) {

	public var bitmap (get, never):BitmapData;   private function get_color():BitmapData { return cast obj(0); }
	public var matrix (get, never):Matrix;       private function get_alpha():Matrix     { return cast obj(1); }
	public var repeat (get, never):Bool;         private function get_repeat():Bool      { return     bool(0); }
	public var smooth (get, never):Bool;         private function get_smooth():Bool      { return     bool(1); }
}
	
abstract BeginFillView (DrawCommandReader) {

	public var color (get, never):Int;   private function get_color():Int   { return   int(0); }
	public var alpha (get, never):Float; private function get_alpha():Float { return float(0); }
}


abstract BeginGradientFillView (DrawCommandReader) {
	
	public var type                (get, never):GradientType;              private function get_type                ():GradientType              { return cast obj(0); }
	public var colors              (get, never):Array<Dynamic>;            private function get_colors              ():Array<Dynamic>            { return cast obj(1); }
	public var alphas              (get, never):Array<Dynamic>;            private function get_alphas              ():Array<Dynamic>            { return cast obj(2); }
	public var ratios              (get, never):Array<Dynamic>;            private function get_ratios              ():Array<Dynamic>            { return cast obj(3); }
	public var matrix              (get, never):Matrix;                    private function get_matrix              ():Matrix                    { return cast obj(4); }
	public var spreadMethod        (get, never):Null<SpreadMethod>;        private function get_spreadMethod        ():Null<SpreadMethod>        { return cast obj(5); }
	public var interpolationMethod (get, never):Null<InterpolationMethod>; private function get_interpolationMethod ():Null<InterpolationMethod> { return cast obj(6); }
	public var focalPointRatio     (get, never):Null<Float>;               private function get_focalPointRatio     ():Null<Float>               { return cast obj(7); }
	
}

abstract CubicCurveToView (DrawCommandReader) {
	
	public var controlX1 (get, never):Float; private function get_controlX1():Float { return float(0); }
	public var controlY1 (get, never):Float; private function get_controlY1():Float { return float(1); }
	public var controlX2 (get, never):Float; private function get_controlX2():Float { return float(3); }
	public var controlY2 (get, never):Float; private function get_controlY2():Float { return float(4); }
	public var anchorX   (get, never):Float; private function get_anchorX  ():Float { return float(5); }
	public var anchorY   (get, never):Float; private function get_anchorY  ():Float { return float(6); }
	
}

abstract CurveToView (DrawCommandReader) {
	
	public var controlX (get, never):Float; private function get_controlX():Float { return float(0); }
	public var controlY (get, never):Float; private function get_controlY():Float { return float(1); }
	public var anchorX  (get, never):Float; private function get_anchorX ():Float { return float(2); }
	public var anchorY  (get, never):Float; private function get_anchorY ():Float { return float(3); }
	
}

abstract DrawCircleView (DrawCommandReader) {
	
	public var x     (get, never):Float; private function get_x     ():Float { return float(0); }
	public var y     (get, never):Float; private function get_y     ():Float { return float(1); }
	public var radius(get, never):Float; private function get_radius():Float { return float(2); }
	
}

abstract DrawEllipseView (DrawCommandReader) {
	
	public var x     (get, never):Float; private function get_x     ():Float { return float(0); }
	public var y     (get, never):Float; private function get_y     ():Float { return float(1); }
	public var width (get, never):Float; private function get_width ():Float { return float(2); }
	public var height(get, never):Float; private function get_height():Float { return float(3); }
	
}

abstract DrawRectView (DrawCommandReader) {
	
	public var x     (get, never):Float; private function get_x     ():Float { return float(0); }
	public var y     (get, never):Float; private function get_y     ():Float { return float(1); }
	public var width (get, never):Float; private function get_width ():Float { return float(2); }
	public var height(get, never):Float; private function get_height():Float { return float(3); }
	
}

abstract DrawRoundRectView (DrawCommandReader) {
	
	public var x     (get, never):Float; private function get_x     ():Float { return float(0); }
	public var y     (get, never):Float; private function get_y     ():Float { return float(1); }
	public var width (get, never):Float; private function get_width ():Float { return float(2); }
	public var height(get, never):Float; private function get_height():Float { return float(3); }
	public var rx    (get, never):Float; private function get_rx    ():Float { return float(4); }
	public var ry    (get, never):Float; private function get_ry    ():Float { return float(5); }
	
}

abstract DrawTilesView (DrawCommandReader) {
	
	public var sheet    (get, never):Tilesheet;    private function get_sheet    ():Tilesheet    { return cast obj(0); }
	public var tileData (get, never):Array<Float>; private function get_tileData ():Array<Float> { return cast obj(1); }
	public var smooth   (get, never):Bool;         private function get_smooth   ():Bool         { return     bool(0); }
	public var flags    (get, never):Int;          private function get_flags    ():Int          { return      int(0); }
	public var count    (get, never):Int;          private function get_count    ():Int          { return      int(1); }
	
}

abstract DrawTrianglesView (DrawCommandReader) {
	
	public var vertices  (get, never):Vector<Float>;   private function get_vertices  ():Vector<Float>   { return cast obj(0); }
	public var indices   (get, never):Vector<Int>;     private function get_indices   ():Vector<Int>     { return cast obj(1); }
	public var uvtData   (get, never):Vector<Float>;   private function get_uvtData   ():Vector<Float>   { return cast obj(2); }
	public var culling   (get, never):TriangleCulling; private function get_culling   ():TriangleCulling { return cast obj(3); }
	public var colors    (get, never):Vector<Int>;     private function get_colors    ():Vector<Int>     { return cast obj(4); }
	public var blendMode (get, never):Int;             private function get_blendMode ():Int             { return      int(0); }
	
}

abstract EndFillView (DrawCommandReader) {
	
	//does nothing
	
}

abstract LineStyleView (DrawCommandReader) {
	
	public var thickness    (get, never):Null<Float>;   private function get_thickness   ():Null<Float>   { return cast obj(0); }
	public var color        (get, never):Null<Int>;     private function get_color       ():Null<Int>     { return cast obj(1); }
	public var alpha        (get, never):Null<Float>;   private function get_alpha       ():Null<Float>   { return cast obj(2); }
	public var pixelHinting (get, never):Null<Bool>;    private function get_pixelHinting():Null<Bool>    { return cast obj(3); }
	public var scaleMode    (get, never):LineScaleMode; private function get_scaleMode   ():LineScaleMode { return cast obj(4); }
	public var caps         (get, never):CapsStyle;     private function get_caps        ():CapsStyle     { return cast obj(5); }
	public var joints       (get, never):JointStyle;    private function get_joints      ():JointStyle    { return cast obj(6); }
	public var miterLimit   (get, never):Null<Float>;   private function get_miterLimit  ():Null<Float>   { return cast obj(7); }
	
}

abstract LineBitmapStyleView (DrawCommandReader) { 
	
	public var bitmap (get, never):BitmapData; private function get_bitmap():BitmapData { return cast obj(0); }
	public var matrix (get, never):Matrix;     private function get_matrix():Matrix     { return cast obj(1); }
	public var repeat (get, never):Bool;       private function get_repeat():Bool       { return cast obj(2); }
	public var smooth (get, never):Bool;       private function get_smooth():Bool       { return cast obj(3); }
	
}

abstract LineGradientStyleView (DrawCommandReader) {
	
	public var type                (get, never):GradientType;              private function get_type                ():GradientType              { return cast obj(0); }
	public var colors              (get, never):Array<Dynamic>;            private function get_colors              ():Array<Dynamic>            { return cast obj(1); }
	public var alphas              (get, never):Array<Dynamic>;            private function get_alphas              ():Array<Dynamic>            { return cast obj(2); }
	public var ratios              (get, never):Array<Dynamic>;            private function get_ratios              ():Array<Dynamic>            { return cast obj(3); }
	public var matrix              (get, never):Matrix;                    private function get_matrix              ():Matrix                    { return cast obj(4); }
	public var spreadMethod        (get, never):Null<SpreadMethod>;        private function get_spreadMethod        ():Null<SpreadMethod>        { return cast obj(5); }
	public var interpolationMethod (get, never):Null<InterpolationMethod>; private function get_interpolationMethod ():Null<InterpolationMethod> { return cast obj(6); }
	public var focalPointRatio     (get, never):Null<Float>;               private function get_focalPointRatio     ():Null<Float>               { return cast obj(7); }
	
}

abstract LineToView (DrawCommandReader) {
	
	public var x (get, never):Float; private function get_x():Float { return float(0); }
	public var y (get, never):Float; private function get_y():Float { return float(1); }
	
}

abstract MoveToView (DrawCommandReader) {
	
	public var x (get, never):Float; private function get_x():Float { return float(0); }
	public var y (get, never):Float; private function get_y():Float { return float(1); }
	
}

abstract DrawPathCView (DrawCommandReader) {
	
	public var commands (get, never):Vector<Int>;         private function get_commands():Vector<Int>         { return cast obj(0); }
	public var data     (get, never):Vector<Float>;       private function get_data    ():Vector<Float>       { return cast obj(1); }
	public var winding  (get, never):GraphicsPathWinding; private function get_winding ():GraphicsPathWinding { return cast obj(2); }
	
}

abstract OverrideMatrixView (DrawCommandReader) {
	
	public var matrix (get, never):Matrix; private function get_matrix():Matrix { return cast obj(0); }
	
}