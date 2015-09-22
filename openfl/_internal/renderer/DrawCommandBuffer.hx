package openfl._internal.renderer;


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

@:allow(openfl._internal.renderer.DrawCommandReader)


class DrawCommandBuffer {
	
	
	public var length (get, never):Int; 
	public var types:Array<DrawCommandType>;
	
	private var b:Array<Bool>;
	private var f:Array<Float>;
	private var ff:Array<Array<Float>>;
	private var i:Array<Int>;
	private var ii:Array<Array<Int>>;
	private var o:Array<Dynamic>;
	private var ts:Array<Tilesheet>;
	
	
	public function new () {
		
		types = [];
		
		b = [];
		i = [];
		f = [];
		o = [];
		ff = [];
		ii = [];
		ts = [];
		
	}
	
	
	public function append (other:DrawCommandBuffer):DrawCommandBuffer {
		
		var data = new DrawCommandReader (other);
		
		for (type in other.types) {
			
			switch (type) {
				
				case BEGIN_BITMAP_FILL: var c = data.readBeginBitmapFill (); beginBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth);
				case BEGIN_FILL: var c = data.readBeginFill (); beginFill (c.color, c.alpha);
				case BEGIN_GRADIENT_FILL: var c = data.readBeginGradientFill (); beginGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
				case CUBIC_CURVE_TO: var c = data.readCubicCurveTo (); cubicCurveTo (c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
				case CURVE_TO: var c = data.readCurveTo (); curveTo (c.controlX, c.controlY, c.anchorX, c.anchorY);
				case DRAW_CIRCLE: var c = data.readDrawCircle (); drawCircle (c.x, c.y, c.radius);
				case DRAW_ELLIPSE: var c = data.readDrawEllipse (); drawEllipse (c.x, c.y, c.width, c.height);
				case DRAW_PATH: var c = data.readDrawPath (); drawPath (c.commands, c.data, c.winding);
				case DRAW_RECT: var c = data.readDrawRect (); drawRect (c.x, c.y, c.width, c.height);
				case DRAW_ROUND_RECT: var c = data.readDrawRoundRect (); drawRoundRect (c.x, c.y, c.width, c.height, c.rx, c.ry);
				case DRAW_TILES: var c = data.readDrawTiles (); drawTiles (c.sheet, c.tileData, c.smooth, c.flags, c.count);
				case DRAW_TRIANGLES: var c = data.readDrawTriangles (); drawTriangles (c.vertices, c.indices, c.uvtData, c.culling, c.colors, c.blendMode);
				case END_FILL: var c = data.readEndFill (); endFill ();
				case LINE_BITMAP_STYLE: var c = data.readLineBitmapStyle (); lineBitmapStyle (c.bitmap, c.matrix, c.repeat, c.smooth);
				case LINE_GRADIENT_STYLE: var c = data.readLineGradientStyle (); lineGradientStyle (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
				case LINE_STYLE: var c = data.readLineStyle (); lineStyle (c.thickness, c.color, c.alpha, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
				case LINE_TO: var c = data.readLineTo (); lineTo (c.x, c.y);
				case MOVE_TO: var c = data.readMoveTo (); moveTo (c.x, c.y);
				case OVERRIDE_MATRIX: var c = data.readOverrideMatrix (); overrideMatrix (c.matrix);
				default:
				
			}
			
		}
		
		data.destroy ();
		return other;
		
	}
	
	
	public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool):Void {
		
		types.push (BEGIN_BITMAP_FILL);
		o.push (bitmap);
		o.push (matrix);
		b.push (repeat);
		b.push (smooth);
		
	}
	
	public function beginFill (color:Int, alpha:Float):Void {
		
		types.push (BEGIN_FILL);
		i.push (color);
		f.push (alpha);
		
	}
	
	
	public function beginGradientFill (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:Null<SpreadMethod>, interpolationMethod:Null<InterpolationMethod>, focalPointRatio:Null<Float>):Void {
		
		types.push (BEGIN_GRADIENT_FILL);
		o.push (type);
		ii.push (colors);
		ff.push (alphas);
		ii.push (ratios);
		o.push (matrix);
		o.push (spreadMethod);
		o.push (interpolationMethod);
		o.push (focalPointRatio);
		
	}
	
	
	public function clear ():Void {
		
		types.splice (0, types.length);
		
		b.splice (0, b.length);
		i.splice (0, i.length);
		f.splice (0, f.length);
		o.splice (0, o.length);
		ff.splice (0, ff.length);
		ii.splice (0, ii.length);
		ts.splice (0, ts.length);
		
	}
	
	
	public function copy ():DrawCommandBuffer {
		
		var copy = new DrawCommandBuffer ();
		copy.append (this);
		return copy;
		
	}
	
	
	public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {
		
		types.push (CUBIC_CURVE_TO);
		f.push (controlX1);
		f.push (controlY1);
		f.push (controlX2);
		f.push (controlY2);
		f.push (anchorX);
		f.push (anchorY);
		
	}
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		
		types.push (CURVE_TO);
		f.push (controlX);
		f.push (controlY);
		f.push (anchorX);
		f.push (anchorY);
		
	}
	
	
	public function destroy ():Void {
		
		clear ();
		
		types = null;
		
		b = null;
		i = null;
		f = null;
		o = null;
		ff = null;
		ii = null;
		ts = null;
		
	}
	
	
	public function drawCircle (x:Float, y:Float, radius:Float):Void {
		
		types.push (DRAW_CIRCLE);
		f.push (x);
		f.push (y);
		f.push (radius);
		
	}
	
	
	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void {
		
		types.push (DRAW_ELLIPSE);
		f.push (x);
		f.push (y);
		f.push (width);
		f.push (height);
		
	}
	
	
	public function drawPath (commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding):Void {
		
		types.push (DRAW_PATH);
		o.push (commands);
		o.push (data);
		o.push (winding);
		
	}
	
	
	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void {
		
		types.push (DRAW_RECT);
		f.push (x);
		f.push (y);
		f.push (width);
		f.push (height);
		
	}
	
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float):Void {
		
		types.push (DRAW_ROUND_RECT);
		f.push (x);
		f.push (y);
		f.push (width);
		f.push (height);
		f.push (rx);
		f.push (ry);
		
	}
	
	
	public function drawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int):Void {
		
		types.push (DRAW_TILES);
		ts.push (sheet);
		ff.push (tileData);
		b.push (smooth);
		i.push (flags);
		i.push (count);
		
	}
	
	
	public function drawTriangles (vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling, colors:Vector<Int>, blendMode:Int):Void {
		
		types.push (DRAW_TRIANGLES);
		o.push (vertices);
		o.push (indices);
		o.push (uvtData);
		o.push (culling);
		o.push (colors);
		i.push (blendMode);
		
	}
	
	
	public function endFill ():Void {
		
		types.push (END_FILL);
		
	}
	
	
	public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool):Void {
		
		types.push (LINE_BITMAP_STYLE);
		o.push (bitmap);
		o.push (matrix);
		b.push (repeat);
		b.push (smooth);
		
	}
	
	
	public function lineGradientStyle (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:Null<SpreadMethod>, interpolationMethod:Null<InterpolationMethod>, focalPointRatio:Null<Float>):Void {
		
		types.push (LINE_GRADIENT_STYLE);
		o.push (type);
		ii.push (colors);
		ff.push (alphas);
		ii.push (ratios);
		o.push (matrix);
		o.push (spreadMethod);
		o.push (interpolationMethod);
		o.push (focalPointRatio);
		
	}
	
	
	public function lineStyle (thickness:Null<Float>, color:Null<Int>, alpha:Null<Float>, pixelHinting:Null<Bool>, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Null<Float>):Void {
		
		types.push (LINE_STYLE);
		o.push (thickness);
		o.push (color);
		o.push (alpha);
		o.push (pixelHinting);
		o.push (scaleMode);
		o.push (caps);
		o.push (joints);
		o.push (miterLimit);
		
	}
	
	
	public function lineTo (x:Float, y:Float):Void {
		
		types.push (LINE_TO);
		f.push (x);
		f.push (y);
		
	}
	
	
	public function moveTo (x:Float, y:Float):Void {
		
		types.push (MOVE_TO);
		f.push (x);
		f.push (y);
		
	}
	
	
	public function overrideMatrix (matrix:Matrix):Void {
		
		types.push (OVERRIDE_MATRIX);
		o.push (matrix);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_length ():Int {
		
		return types.length;
		
	}
	
	
}