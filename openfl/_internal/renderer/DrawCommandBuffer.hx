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
import openfl.utils.UnshrinkableArray;

@:allow(openfl._internal.renderer.DrawCommandReader)
class DrawCommandBuffer implements hxbit.CustomSerializable {


	public var length (get, never):Int;

	public var types:UnshrinkableArray<DrawCommandType>;
	private var b:UnshrinkableArray<Bool>;
	private var f:UnshrinkableArray<Float>;
	private var ff:UnshrinkableArray<Array<Float>>;
	private var i:UnshrinkableArray<Int>;
	private var ii:UnshrinkableArray<Array<Int>>;
	private var m:UnshrinkableArray<Matrix>;
	private var vf:UnshrinkableArray<Vector<Float>>;
	private var vi:UnshrinkableArray<Vector<Int>>;
	private var bd_ids:UnshrinkableArray<Int>;

	private var bd:UnshrinkableArray<BitmapData>;

	public function new () {

		types = new UnshrinkableArray();

		b = new UnshrinkableArray();
		i = new UnshrinkableArray();
		f = new UnshrinkableArray();
		ff = new UnshrinkableArray();
		ii = new UnshrinkableArray();
		m = new UnshrinkableArray();	
		vf = new UnshrinkableArray();	
		vi = new UnshrinkableArray();	
		bd_ids = new UnshrinkableArray();

		bd = new UnshrinkableArray();	
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
				case DRAW_IMAGE: var c = data.readDrawImage (); drawImage (c.bitmap, c.matrix, c.smooth);
				case DRAW_PATH: var c = data.readDrawPath (); drawPath (c.commands, c.data, c.winding);
				case DRAW_RECT: var c = data.readDrawRect (); drawRect (c.x, c.y, c.width, c.height);
				case DRAW_ROUND_RECT: var c = data.readDrawRoundRect (); drawRoundRect (c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
				case DRAW_TRIANGLES: var c = data.readDrawTriangles (); drawTriangles (c.vertices, c.indices, c.uvtData, c.culling);
				case END_FILL: data.readEndFill (); endFill ();
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
		bd.push (bitmap);
		m.push (matrix);
		b.push (repeat);
		b.push (smooth);

	}

	public function beginBitmapFillWithId(bitmapId:Int, matrix:Matrix, repeat:Bool, smooth:Bool):Void {

		types.push (BEGIN_BITMAP_FILL);
		bd_ids.push (bitmapId);
		m.push (matrix);
		b.push (repeat);
		b.push (smooth);

	}

	public function beginFill (color:Int, alpha:Float):Void {

		types.push (BEGIN_FILL);
		i.push (color);
		f.push (alpha);

	}


	public function beginGradientFill (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float):Void {

		types.push (BEGIN_GRADIENT_FILL);
		i.push (cast type);
		ii.push (colors);
		ff.push (alphas);
		ii.push (ratios);
		m.push (matrix);
		i.push (cast spreadMethod);
		i.push (cast interpolationMethod);
		f.push (focalPointRatio);

	}


	public function clear ():Void {

		types.clear();

		b.clear();
		i.clear();
		f.clear();
		m.clear();
		vi.clear();
		vf.clear();
		bd_ids.clear();
		ff.clear();
		ii.clear();
		bd.clear();

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
		ff = null;
		ii = null;
		m = null;
		vf = null;
		vi = null;
		bd_ids = null;

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


	public function drawImage(bitmap:BitmapData, matrix:Matrix, smooth:Bool):Void {

		types.push (DRAW_IMAGE);
		bd.push (bitmap);
		m.push (matrix);
		b.push (smooth);

	}


	public function drawImageWithId(bitmapId:Int, matrix:Matrix, smooth:Bool):Void {

		types.push (DRAW_IMAGE);
		bd_ids.push (bitmapId);
		m.push (matrix);
		b.push (smooth);

	}


	public function drawPath (commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding):Void {

		throw("Unsupported drawPath");
		types.push (DRAW_PATH);
		vi.push (commands);
		vf.push (data);
		i.push (cast winding);

	}


	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void {

		types.push (DRAW_RECT);
		f.push (x);
		f.push (y);
		f.push (width);
		f.push (height);

	}

	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Float):Void {

		types.push (DRAW_ROUND_RECT);
		f.push (x);
		f.push (y);
		f.push (width);
		f.push (height);
		f.push (ellipseWidth);
		f.push (ellipseHeight);

	}


	public function drawTriangles (vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling):Void {

		throw("Unsupported drawTriangles");
		types.push (DRAW_TRIANGLES);
		vf.push (vertices);
		vi.push (indices);
		vf.push (uvtData);
		i.push (cast culling);

	}


	public function endFill ():Void {

		types.push (END_FILL);

	}


	public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool):Void {

		types.push (LINE_BITMAP_STYLE);
		bd.push (bitmap);
		m.push (matrix);
		b.push (repeat);
		b.push (smooth);

	}


	public function lineGradientStyle (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float):Void {

		types.push (LINE_GRADIENT_STYLE);
		i.push (cast type);
		ii.push (colors);
		ff.push (alphas);
		ii.push (ratios);
		m.push (matrix);
		i.push (cast spreadMethod);
		i.push (cast interpolationMethod);
		f.push (focalPointRatio);

	}


	public function lineStyle (thickness:Float, color:Int, alpha:Float, pixelHinting:Bool, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Float):Void {

		types.push (LINE_STYLE);
		f.push (thickness);
		i.push (color);
		f.push (alpha);
		b.push (pixelHinting);
		i.push (cast scaleMode);
		i.push (cast caps);
		i.push (cast joints);
		f.push (miterLimit);

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
		m.push (matrix);

	}


	// Get & Set Methods


	private function get_length ():Int {

		return types.length;

	}

	public function resolveBitmapDatas(swflite:format.swf.lite.SWFLite) {
		bd = new UnshrinkableArray();
		for(i in 0...bd_ids.length) {
			var symbol:format.swf.lite.symbols.BitmapSymbol = cast swflite.symbols.get (bd_ids[i]);
			bd.push(BitmapData.getFromSymbol(symbol));
		}
	}

	@:keep
    public function serialize(ctx:hxbit.Serializer)
    {
		ctx.addArray(types.getInternalArray(), function(item){ ctx.addInt(Type.enumIndex(item)); });
		ctx.addDynamic(b.getInternalArray());
		ctx.addDynamic(i.getInternalArray());
		ctx.addDynamic(f.getInternalArray());
		ctx.addDynamic(ff.getInternalArray());
		ctx.addDynamic(ii.getInternalArray());
		ctx.addArray(
			m.getInternalArray(),
			function(m){
				ctx.addFloat(m.a);
				ctx.addFloat(m.b);
				ctx.addFloat(m.c);
				ctx.addFloat(m.d);
				ctx.addFloat(m.tx);
				ctx.addFloat(m.ty);
			});
		ctx.addDynamic(bd_ids.getInternalArray());
    }

    @:keep
    public function unserialize(ctx:hxbit.Serializer)
    {
		types = new UnshrinkableArray(
			128,
			ctx.getArray(function(){
				return Type.createEnumIndex(DrawCommandType, ctx.getInt());
			})
			);
		b = new UnshrinkableArray(128, cast ctx.getDynamic());
		i = new UnshrinkableArray(128, cast ctx.getDynamic());
		f = new UnshrinkableArray(128, cast ctx.getDynamic());
		ff = new UnshrinkableArray(128, cast ctx.getDynamic());
		ii = new UnshrinkableArray(128, cast ctx.getDynamic());
		m = new UnshrinkableArray(
			128,
			ctx.getArray(function(){
				var m = new Matrix();
				m.a = ctx.getFloat();
				m.b = ctx.getFloat();
				m.c = ctx.getFloat();
				m.d = ctx.getFloat();
				m.tx = ctx.getFloat();
				m.ty = ctx.getFloat();
				return m;
			})
			);	
		bd_ids = new UnshrinkableArray(128, cast ctx.getDynamic());
    }
}
