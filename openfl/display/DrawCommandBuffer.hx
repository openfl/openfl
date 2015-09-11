package openfl.display;
import openfl.geom.Matrix;

/**
 * ...
 * @author larsiusprime
 */
class DrawCommandBuffer
{
	public var types:Array<DrawCommandType>;
	public var b:Array<Bool>;
	public var i:Array<Int>;
	public var f:Array<Float>;
	public var o:Array<Dynamic>;
	public var ff:Array < Array<Float> > ;
	public var ts:Array <Tilesheet>;
	
	public var length(get, never):Int; private function get_length():Int { return types.length; }
	
	public function new() 
	{
		types = [];
		b = [];
		i = [];
		f = [];
		o = [];
		ff = [];
		ts = [];
	}
	
	public function clear()
	{
		types.splice(0, types.length);
		b.splice(0, b.length);
		i.splice(0, i.length);
		f.splice(0, f.length);
		o.splice(0, o.length);
		ff.splice(0, ff.length);
		ts.splice(0, ts.length);
	}
	
	public function destroy()
	{
		clear();
		types = null;
		b = null;
		i = null;
		f = null;
		o = null;
		ff = null;
		ts = null;
	}
	
	public function copy():DrawCommandBuffer
	{
		var dupe = new DrawCommandBuffer();
		dupe.append(this);
		return dupe;
	}
	
	public function append(other:DrawCommandBuffer):DrawCommandBuffer
	{
		var data = new DrawCommandReader(other);
		
		for (type in types)
		{
			switch(type)
			{
				case BEGIN_BITMAP_FILL   : var c = data.readBeginBitmapFill();   writeBeginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);
				case BEGIN_FILL          : var c = data.readBeginFill();         writeBeginFill(c.color, c.alpha);
				case BEGIN_GRADIENT_FILL : var c = data.readBeginGradientFill(); writeBeginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
				case CUBIC_CURVE_TO      : var c = data.readCubicCurveTo();      writeCubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
				case CURVE_TO            : var c = data.readCurveTo();           writeCurveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
				case DRAW_CIRCLE         : var c = data.readDrawCircle();        writeDrawCircle(c.x, c.y, c.radius);
				case DRAW_ELLIPSE        : var c = data.readDrawEllipse();       writeDrawEllipse(c.x, c.y, c.width, c.height);
				case DRAW_RECT           : var c = data.readDrawRect();          writeDrawRect(c.x, c.y, c.width, c.height);
				case DRAW_ROUND_RECT     : var c = data.readDrawRoundRect();     writeDrawRoundRect(c.x, c.y, c.width, c.height, c.rx, c.ry);
				case DRAW_TILES          : var c = data.readDrawTiles();         writeDrawTiles(c.sheet, c.tileData, c.smooth, c.flags, c.count);
				case DRAW_TRIANGLES      : var c = data.readDrawTriangles();     writeDrawTriangles(c.vertices, c.indices, c.uvtData, c.culling, c.colors, c.blendMode);
				case END_FILL            : var c = data.readEndFill();           writeEndFill();
				case LINE_STYLE          : var c = data.readLineStyle();         writeLineStyle(c.thickness, c.color, c.alpha, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
				case LINE_BITMAP_STYLE   : var c = data.readLineBitmapStyle();   writeLineBitmapStyle(c.bitmap, c.matrix, c.repeat, c.smooth);
				case LINE_GRADIENT_STYLE : var c = data.readLineGradientStyle(); writeLineGradientStyle(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
				case LINE_TO             : var c = data.readLineTo();            writeLineTo(c.x, c.y);
				case MOVE_TO             : var c = data.readMoveTo();            writeMoveTo(c.x, c.y);
				case DRAW_PATH_C         : var c = data.readDrawPathC();         writeDrawPathC(c.commands, c.data, c.winding);
				case OVERRIDE_MATRIX     : var c = data.readOverrideMatrix();    writeOverrideMatrix(c.matrix);
				case UNKNOWN             : //donothing
			}
		}
		
		data.destroy();
		
		return other;
	}
	
	public function writeBeginBitmapFill(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool)
	{
		types.push(BEGIN_BITMAP_FILL);
		o.push(bitmap);
		o.push(matrix);
		b.push(repeat);
		b.push(smooth);
	}
	
	public function writeBeginFill (color:Int, alpha:Float)
	{
		types.push(BEGIN_FILL);
		i.push(color);
		f.push(alpha);
	}
	
	public function writeBeginGradientFill (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix, spreadMethod:Null<SpreadMethod>, interpolationMethod:Null<InterpolationMethod>, focalPointRatio:Null<Float>)
	{
		types.push(BEGIN_GRADIENT_FILL);
		o.push(type);
		o.push(colors);
		o.push(alphas);
		o.push(ratios);
		o.push(matrix);
		o.push(spreadMethod);
		o.push(interpolationMethod);
		f.push(focalPointRatio);
	}
	
	public function writeCubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float)
	{
		types.push(CUBIC_CURVE_TO);
		f.push(controlX1);
		f.push(controlY1);
		f.push(controlX2);
		f.push(controlY2);
		f.push(anchorX);
		f.push(anchorY);
	}
	
	public function writeCurveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float)
	{
		types.push(CURVE_TO);
		f.push(controlX);
		f.push(controlY);
		f.push(anchorX);
		f.push(anchorY);
	}
	
	public function writeDrawCircle (x:Float, y:Float, radius:Float)
	{
		types.push(DRAW_CIRCLE);
		f.push(x);
		f.push(y);
		f.push(radius);
	}
	
	public function writeDrawEllipse (x:Float, y:Float, width:Float, height:Float)
	{
		types.push(DRAW_ELLIPSE);
		f.push(x);
		f.push(y);
		f.push(width);
		f.push(height);
	}
	
	public function writeDrawRect (x:Float, y:Float, width:Float, height:Float)
	{
		types.push(DRAW_RECT);
		f.push(x);
		f.push(y);
		f.push(width);
		f.push(height);
	}
	
	public function writeDrawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float)
	{
		types.push(DRAW_ROUND_RECT);
		f.push(x);
		f.push(y);
		f.push(width);
		f.push(height);
		f.push(rx);
		f.push(ry);
	}
	
	public function writeDrawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int)
	{
		types.push(DRAW_TILES);
		ts.push(sheet);
		ff.push(tileData);
		b.push(smooth);
		i.push(flags);
		i.push(count);
	}
	
	public function writeDrawTriangles (vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling, colors:Vector<Int>, blendMode:Int)
	{
		types.push(DRAW_TRIANGLES);
		o.push(vertices);
		o.push(indices);
		o.push(uvtData);
		o.push(culling);
		o.push(colors);
		i.push(blendMode);
	}
	
	public function writeEndFill()
	{
		types.push(END_FILL);
	}
	
	public function writeLineStyle (thickness:Null<Float>, color:Null<Int>, alpha:Null<Float>, pixelHinting:Null<Bool>, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Null<Float>)
	{
		types.push(LINE_STYLE);
		o.push(thickness);
		o.push(color);
		o.push(alpha);
		o.push(pixelHinting);
		o.push(scaleMode);
		o.push(caps);
		o.push(joints);
		o.push(miterLimit);
	}
	
	public function writeLineBitmapStyle (bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool)
	{
		types.push(LINE_BITMAP_STYLE);
		o.push(bitmap);
		o.push(matrix);
		b.push(repeat);
		b.push(smooth);
	}
	
	public function writeLineGradientStyle (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix, spreadMethod:Null<SpreadMethod>, interpolationMethod:Null<InterpolationMethod>, focalPointRatio:Null<Float>)
	{
		types.push(LINE_GRADIENT_STYLE);
		o.push(type);
		o.push(colors);
		o.push(alphas);
		o.push(ratios);
		o.push(matrix);
		o.push(spreadMethod);
		o.push(interpolationMethod);
		o.push(focalPointRatio);
	}
	
	public function writeLineTo (x:Float, y:Float)
	{
		types.push(LINE_TO);
		f.push(x);
		f.push(y);
	}
	
	public function writeMoveTo (x:Float, y:Float)
	{
		types.push(MOVE_TO);
		f.push(x);
		f.push(y);
	}
	
	public function writeDrawPathC (commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding)
	{
		types.push(DRAW_PATH_C);
		o.push(commands);
		o.push(data);
		o.push(winding);
	}
	
	public function writeOverrideMatrix (matrix:Matrix)
	{
		types.push(OVERRIDE_MATRIX);
		o.push(matrix);
	}
	
}