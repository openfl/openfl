package openfl.display._internal;

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
	private static var empty:DrawCommandBuffer = new DrawCommandBuffer();

	public var length(get, never):Int;
	public var types:Array<DrawCommandType>;

	private var b:Array<Bool>;
	private var copyOnWrite:Bool;
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

			copyOnWrite = true;
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
			this.copyOnWrite = other.copyOnWrite = true;

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
		prepareWrite();

		types.push(BEGIN_BITMAP_FILL);
		o.push(bitmap);
		o.push(matrix);
		b.push(repeat);
		b.push(smooth);
	}

	public function beginFill(color:Int, alpha:Float):Void
	{
		prepareWrite();

		types.push(BEGIN_FILL);
		i.push(color);
		f.push(alpha);
	}

	public function beginGradientFill(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:SpreadMethod,
			interpolationMethod:InterpolationMethod, focalPointRatio:Float):Void
	{
		prepareWrite();

		types.push(BEGIN_GRADIENT_FILL);
		o.push(type);
		ii.push(colors);
		ff.push(alphas);
		ii.push(ratios);
		o.push(matrix);
		o.push(spreadMethod);
		o.push(interpolationMethod);
		f.push(focalPointRatio);
	}

	public function beginShaderFill(shaderBuffer:ShaderBuffer):Void
	{
		prepareWrite();

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

		copyOnWrite = true;
	}

	public function copy():DrawCommandBuffer
	{
		var copy = new DrawCommandBuffer();
		copy.append(this);
		return copy;
	}

	public function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void
	{
		prepareWrite();

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
		prepareWrite();

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
		prepareWrite();

		types.push(DRAW_CIRCLE);
		f.push(x);
		f.push(y);
		f.push(radius);
	}

	public function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void
	{
		prepareWrite();

		types.push(DRAW_ELLIPSE);
		f.push(x);
		f.push(y);
		f.push(width);
		f.push(height);
	}

	public function drawQuads(rects:Vector<Float>, indices:Vector<Int>, transforms:Vector<Float>):Void
	{
		prepareWrite();

		types.push(DRAW_QUADS);
		o.push(rects);
		o.push(indices);
		o.push(transforms);
	}

	public function drawRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		prepareWrite();

		types.push(DRAW_RECT);
		f.push(x);
		f.push(y);
		f.push(width);
		f.push(height);
	}

	public function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float>):Void
	{
		prepareWrite();

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
		prepareWrite();

		types.push(DRAW_TRIANGLES);
		o.push(vertices);
		o.push(indices);
		o.push(uvtData);
		o.push(culling);
	}

	public function endFill():Void
	{
		prepareWrite();

		types.push(END_FILL);
	}

	public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool):Void
	{
		prepareWrite();

		types.push(LINE_BITMAP_STYLE);
		o.push(bitmap);
		o.push(matrix);
		b.push(repeat);
		b.push(smooth);
	}

	public function lineGradientStyle(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:SpreadMethod,
			interpolationMethod:InterpolationMethod, focalPointRatio:Float):Void
	{
		prepareWrite();

		types.push(LINE_GRADIENT_STYLE);
		o.push(type);
		ii.push(colors);
		ff.push(alphas);
		ii.push(ratios);
		o.push(matrix);
		o.push(spreadMethod);
		o.push(interpolationMethod);
		f.push(focalPointRatio);
	}

	public function lineStyle(thickness:Null<Float>, color:Int, alpha:Float, pixelHinting:Bool, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle,
			miterLimit:Float):Void
	{
		prepareWrite();

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
		prepareWrite();

		types.push(LINE_TO);
		f.push(x);
		f.push(y);
	}

	public function moveTo(x:Float, y:Float):Void
	{
		prepareWrite();

		types.push(MOVE_TO);
		f.push(x);
		f.push(y);
	}

	private function prepareWrite():Void
	{
		if (copyOnWrite)
		{
			types = types.copy();
			b = b.copy();
			i = i.copy();
			f = f.copy();
			o = o.copy();
			ff = ff.copy();
			ii = ii.copy();

			copyOnWrite = false;
		}
	}

	public function overrideBlendMode(blendMode:BlendMode):Void
	{
		prepareWrite();

		types.push(OVERRIDE_BLEND_MODE);
		o.push(blendMode);
	}

	public function overrideMatrix(matrix:Matrix):Void
	{
		prepareWrite();

		types.push(OVERRIDE_MATRIX);
		o.push(matrix);
	}

	public function windingEvenOdd():Void
	{
		prepareWrite();

		types.push(WINDING_EVEN_ODD);
	}

	public function windingNonZero():Void
	{
		prepareWrite();

		types.push(WINDING_NON_ZERO);
	}

	// Get & Set Methods
	private function get_length():Int
	{
		return types.length;
	}
}
