package openfl.display._internal;

#if !flash
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CapsStyle;
import openfl.display.GradientType;
import openfl.display.InterpolationMethod;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.SpreadMethod;
import openfl.display.TriangleCulling;
import openfl.geom.Matrix;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:allow(openfl.display._internal.DrawCommandReader)
@SuppressWarnings("checkstyle:FieldDocComment")
class DrawCommandBuffer
{
	private static inline var COW_TYPES:Int = 1;
	private static inline var COW_B:Int = 2;
	private static inline var COW_I:Int = 4;
	private static inline var COW_F:Int = 8;
	private static inline var COW_O:Int = 16;
	private static inline var COW_FF:Int = 32;
	private static inline var COW_II:Int = 64;
	private static inline var COW_ALL:Int = COW_TYPES | COW_B | COW_I | COW_F | COW_O | COW_FF | COW_II;

	private static var empty:DrawCommandBuffer = new DrawCommandBuffer();

	public var length(get, never):Int;
	public var types:Array<DrawCommandType>;

	private var b:Array<Bool>;
	private var copyOnWrite:Int;
	private var f:Array<Float>;
	private var ff:Array<Array<Float>>;
	private var i:Array<Int>;
	private var ii:Array<Array<Int>>;
	@SuppressWarnings("checkstyle:Dynamic") private var o:Array<Dynamic>;

	public function new()
	{
		if (empty == null)
		{
			types = [];

			b = [];
			i = [];
			f = [];
			o = [];
			ff = [];
			ii = [];

			copyOnWrite = COW_ALL;
		}
		else
		{
			clear();
		}
	}

	public function append(other:DrawCommandBuffer):DrawCommandBuffer
	{
		if (length == 0)
		{
			this.types = other.types;
			this.b = other.b;
			this.i = other.i;
			this.f = other.f;
			this.o = other.o;
			this.ff = other.ff;
			this.ii = other.ii;
			this.copyOnWrite = other.copyOnWrite = COW_ALL;

			return other;
		}

		var data = new DrawCommandReader(other);

		for (type in other.types)
		{
			switch (type)
			{
				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);
				case BEGIN_FILL:
					var c = data.readBeginFill();
					beginFill(c.color, c.alpha);
				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();
					beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
				case BEGIN_SHADER_FILL:
					var c = data.readBeginShaderFill();
					beginShaderFill(c.shaderBuffer);
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
				case CURVE_TO:
					var c = data.readCurveTo();
					curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);
				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					drawCircle(c.x, c.y, c.radius);
				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					drawEllipse(c.x, c.y, c.width, c.height);
				case DRAW_QUADS:
					var c = data.readDrawQuads();
					drawQuads(c.rects, c.indices, c.transforms);
				case DRAW_RECT:
					var c = data.readDrawRect();
					drawRect(c.x, c.y, c.width, c.height);
				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight);
				case DRAW_TRIANGLES:
					var c = data.readDrawTriangles();
					drawTriangles(c.vertices, c.indices, c.uvtData, c.culling);
				case END_FILL:
					var c = data.readEndFill();
					endFill();
				case LINE_BITMAP_STYLE:
					var c = data.readLineBitmapStyle();
					lineBitmapStyle(c.bitmap, c.matrix, c.repeat, c.smooth);
				case LINE_GRADIENT_STYLE:
					var c = data.readLineGradientStyle();
					lineGradientStyle(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
				case LINE_STYLE:
					var c = data.readLineStyle();
					lineStyle(c.thickness, c.color, c.alpha, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
				case LINE_TO:
					var c = data.readLineTo();
					lineTo(c.x, c.y);
				case MOVE_TO:
					var c = data.readMoveTo();
					moveTo(c.x, c.y);
				case OVERRIDE_MATRIX:
					var c = data.readOverrideMatrix();
					overrideMatrix(c.matrix);
				case WINDING_EVEN_ODD:
					var c = data.readWindingEvenOdd();
					windingEvenOdd();
				case WINDING_NON_ZERO:
					var c = data.readWindingNonZero();
					windingNonZero();
				default:
			}
		}

		data.destroy();
		return other;
	}

	public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool):Void
	{
		prepareWrite(COW_TYPES | COW_O | COW_B);

		types.push(BEGIN_BITMAP_FILL);
		o.push(bitmap);
		if (matrix != null)
		{
			o.push(matrix.a);
			o.push(matrix.b);
			o.push(matrix.c);
			o.push(matrix.d);
			o.push(matrix.tx);
			o.push(matrix.ty);
		}
		else
		{
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
		}
		b.push(repeat);
		b.push(smooth);
	}

	public function beginFill(color:Int, alpha:Float):Void
	{
		prepareWrite(COW_TYPES | COW_I | COW_F);

		types.push(BEGIN_FILL);
		i.push(color);
		f.push(alpha);
	}

	public function beginGradientFill(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:SpreadMethod,
			interpolationMethod:InterpolationMethod, focalPointRatio:Float):Void
	{
		prepareWrite(COW_TYPES | COW_O | COW_II | COW_FF | COW_F);

		types.push(BEGIN_GRADIENT_FILL);
		o.push(type);
		ii.push(colors);
		ff.push(alphas);
		ii.push(ratios);
		if (matrix != null)
		{
			o.push(matrix.a);
			o.push(matrix.b);
			o.push(matrix.c);
			o.push(matrix.d);
			o.push(matrix.tx);
			o.push(matrix.ty);
		}
		else
		{
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
		}
		o.push(spreadMethod);
		o.push(interpolationMethod);
		f.push(focalPointRatio);
	}

	public function beginShaderFill(shaderBuffer:ShaderBuffer):Void
	{
		prepareWrite(COW_TYPES | COW_O);

		types.push(BEGIN_SHADER_FILL);
		o.push(shaderBuffer);
	}

	public function clear():Void
	{
		types = empty.types;

		b = empty.b;
		i = empty.i;
		f = empty.f;
		o = empty.o;
		ff = empty.ff;
		ii = empty.ii;

		copyOnWrite = COW_ALL;
	}

	public function copy():DrawCommandBuffer
	{
		var copy = new DrawCommandBuffer();
		copy.append(this);
		return copy;
	}

	public function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void
	{
		prepareWrite(COW_TYPES | COW_F);

		types.push(CUBIC_CURVE_TO);
		f.push(controlX1);
		f.push(controlY1);
		f.push(controlX2);
		f.push(controlY2);
		f.push(anchorX);
		f.push(anchorY);
	}

	public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void
	{
		prepareWrite(COW_TYPES | COW_F);

		types.push(CURVE_TO);
		f.push(controlX);
		f.push(controlY);
		f.push(anchorX);
		f.push(anchorY);
	}

	public function destroy():Void
	{
		clear();

		types = null;

		b = null;
		i = null;
		f = null;
		o = null;
		ff = null;
		ii = null;
	}

	public function drawCircle(x:Float, y:Float, radius:Float):Void
	{
		prepareWrite(COW_TYPES | COW_F);

		types.push(DRAW_CIRCLE);
		f.push(x);
		f.push(y);
		f.push(radius);
	}

	public function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void
	{
		prepareWrite(COW_TYPES | COW_F);

		types.push(DRAW_ELLIPSE);
		f.push(x);
		f.push(y);
		f.push(width);
		f.push(height);
	}

	public function drawQuads(rects:Vector<Float>, indices:Vector<Int>, transforms:Vector<Float>):Void
	{
		prepareWrite(COW_TYPES | COW_O);

		types.push(DRAW_QUADS);
		o.push(rects);
		o.push(indices);
		o.push(transforms);
	}

	public function drawRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		prepareWrite(COW_TYPES | COW_F);

		types.push(DRAW_RECT);
		f.push(x);
		f.push(y);
		f.push(width);
		f.push(height);
	}

	public function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void
	{
		prepareWrite(COW_TYPES | COW_F | COW_O);

		types.push(DRAW_ROUND_RECT);
		f.push(x);
		f.push(y);
		f.push(width);
		f.push(height);
		f.push(ellipseWidth);
		o.push(ellipseHeight);
	}

	public function drawTriangles(vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling):Void
	{
		prepareWrite(COW_TYPES | COW_O);

		types.push(DRAW_TRIANGLES);
		o.push(vertices);
		o.push(indices);
		o.push(uvtData);
		o.push(culling);
	}

	public function endFill():Void
	{
		prepareWrite(COW_TYPES);

		types.push(END_FILL);
	}

	public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool):Void
	{
		prepareWrite(COW_TYPES | COW_O | COW_B);

		types.push(LINE_BITMAP_STYLE);
		o.push(bitmap);
		if (matrix != null)
		{
			o.push(matrix.a);
			o.push(matrix.b);
			o.push(matrix.c);
			o.push(matrix.d);
			o.push(matrix.tx);
			o.push(matrix.ty);
		}
		else
		{
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
		}
		b.push(repeat);
		b.push(smooth);
	}

	public function lineGradientStyle(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:SpreadMethod,
			interpolationMethod:InterpolationMethod, focalPointRatio:Float):Void
	{
		prepareWrite(COW_TYPES | COW_O | COW_II | COW_FF | COW_F);

		types.push(LINE_GRADIENT_STYLE);
		o.push(type);
		ii.push(colors);
		ff.push(alphas);
		ii.push(ratios);
		if (matrix != null)
		{
			o.push(matrix.a);
			o.push(matrix.b);
			o.push(matrix.c);
			o.push(matrix.d);
			o.push(matrix.tx);
			o.push(matrix.ty);
		}
		else
		{
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
		}
		o.push(spreadMethod);
		o.push(interpolationMethod);
		f.push(focalPointRatio);
	}

	public function lineStyle(thickness:Null<Float>, color:Int, alpha:Float, pixelHinting:Bool, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle,
			miterLimit:Float):Void
	{
		prepareWrite(COW_TYPES | COW_O | COW_I | COW_F | COW_B);

		types.push(LINE_STYLE);
		o.push(thickness);
		i.push(color);
		f.push(alpha);
		b.push(pixelHinting);
		o.push(scaleMode);
		o.push(caps);
		o.push(joints);
		f.push(miterLimit);
	}

	public function lineTo(x:Float, y:Float):Void
	{
		prepareWrite(COW_TYPES | COW_F);

		types.push(LINE_TO);
		f.push(x);
		f.push(y);
	}

	public function moveTo(x:Float, y:Float):Void
	{
		prepareWrite(COW_TYPES | COW_F);

		types.push(MOVE_TO);
		f.push(x);
		f.push(y);
	}

	private function prepareWrite(mask:Int):Void
	{
		if ((copyOnWrite & mask) != 0)
		{
			if ((copyOnWrite & COW_TYPES) != 0 && (mask & COW_TYPES) != 0) types = types.copy();
			if ((copyOnWrite & COW_B) != 0 && (mask & COW_B) != 0) b = b.copy();
			if ((copyOnWrite & COW_I) != 0 && (mask & COW_I) != 0) i = i.copy();
			if ((copyOnWrite & COW_F) != 0 && (mask & COW_F) != 0) f = f.copy();
			if ((copyOnWrite & COW_O) != 0 && (mask & COW_O) != 0) o = o.copy();
			if ((copyOnWrite & COW_FF) != 0 && (mask & COW_FF) != 0) ff = ff.copy();
			if ((copyOnWrite & COW_II) != 0 && (mask & COW_II) != 0) ii = ii.copy();

			copyOnWrite &= ~mask;
		}
	}

	public function overrideBlendMode(blendMode:BlendMode):Void
	{
		prepareWrite(COW_TYPES | COW_O);

		types.push(OVERRIDE_BLEND_MODE);
		o.push(blendMode);
	}

	public function overrideMatrix(matrix:Matrix):Void
	{
		prepareWrite(COW_TYPES | COW_O);

		types.push(OVERRIDE_MATRIX);
		if (matrix != null)
		{
			o.push(matrix.a);
			o.push(matrix.b);
			o.push(matrix.c);
			o.push(matrix.d);
			o.push(matrix.tx);
			o.push(matrix.ty);
		}
		else
		{
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
			o.push(null);
		}
	}

	public function windingEvenOdd():Void
	{
		prepareWrite(COW_TYPES);

		types.push(WINDING_EVEN_ODD);
	}

	public function windingNonZero():Void
	{
		prepareWrite(COW_TYPES);

		types.push(WINDING_NON_ZERO);
	}

	// Get & Set Methods
	private function get_length():Int
	{
		return types.length;
	}
}
#end
