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
@:allow(openfl.display._internal)
@:access(openfl.display._internal)
@SuppressWarnings("checkstyle:FieldDocComment")
class DrawCommandReader
{
	public var buffer:DrawCommandBuffer;

	private var bPos:Int;
	private var iiPos:Int;
	private var iPos:Int;
	private var ffPos:Int;
	private var fPos:Int;
	private var oPos:Int;
	private var prev:DrawCommandType;
	private var tsPos:Int;

	public function new(buffer:DrawCommandBuffer)
	{
		this.buffer = buffer;

		bPos = iPos = fPos = oPos = ffPos = iiPos = tsPos = 0;
		prev = UNKNOWN;
	}

	@:noCompletion private inline function advance():Void
	{
		switch (prev)
		{
			case BEGIN_BITMAP_FILL:
				oPos += 2; // bitmap, matrix
				bPos += 2; // repeat, smooth

			case BEGIN_FILL:
				iPos += 1; // color
				fPos += 1; // alpha

			case BEGIN_GRADIENT_FILL:
				oPos += 4; // type, matrix, spreadMethod, interpolationMethod
				iiPos += 2; // colors, ratios
				ffPos += 1; // alphas
				fPos += 1; // focalPointRatio

			case BEGIN_SHADER_FILL:
				oPos += 1; // shaderBuffer

			case CUBIC_CURVE_TO:
				fPos += 6; // controlX1, controlY1, controlX2, controlY2, anchorX, anchorY

			case CURVE_TO:
				fPos += 4; // controlX, controlY, anchorX, anchorY

			case DRAW_CIRCLE:
				fPos += 3; // x, y, radius

			case DRAW_ELLIPSE:
				fPos += 4; // x, y, width, height

			case DRAW_QUADS:
				oPos += 3; // rects, indices, transforms

			case DRAW_RECT:
				fPos += 4; // x, y, width, height

			case DRAW_ROUND_RECT:
				fPos += 5; // x, y, width, height, ellipseWidth
				oPos += 1; // ellipseHeight

			case DRAW_TRIANGLES:
				oPos += 4; // vertices, indices, uvtData, culling

			case END_FILL:

			// no parameters

			case LINE_BITMAP_STYLE:
				oPos += 2; // bitmap, matrix
				bPos += 2; // repeat, smooth

			case LINE_GRADIENT_STYLE:
				oPos += 4; // type, matrix, spreadMethod, interpolationMethod
				iiPos += 2; // colors, ratios
				ffPos += 1; // alphas
				fPos += 1; // focalPointRatio

			case LINE_STYLE:
				oPos += 4; // thickness, scaleMode, caps, joints
				iPos += 1; // color
				fPos += 2; // alpha, miterLimit
				bPos += 1; // pixelHinting

			case LINE_TO:
				fPos += 2; // x, y

			case MOVE_TO:
				fPos += 2; // x, y

			case OVERRIDE_BLEND_MODE:
				oPos += 1; // blendMode

			case OVERRIDE_MATRIX:
				oPos += 1; // matrix

			case WINDING_EVEN_ODD, WINDING_NON_ZERO:

			// no parameters

			default:
		}
	}

	@:noCompletion private inline function bool(index:Int):Bool
	{
		return buffer.b[bPos + index];
	}

	public function destroy():Void
	{
		buffer = null;
		reset();
	}

	@:noCompletion private inline function fArr(index:Int):Array<Float>
	{
		return buffer.ff[ffPos + index];
	}

	@:noCompletion private inline function float(index:Int):Float
	{
		return buffer.f[fPos + index];
	}

	@:noCompletion private inline function iArr(index:Int):Array<Int>
	{
		return buffer.ii[iiPos + index];
	}

	@:noCompletion private inline function int(index:Int):Int
	{
		return buffer.i[iPos + index];
	}

	@:noCompletion
	@SuppressWarnings("checkstyle:Dynamic")
	private inline function obj(index:Int):Dynamic
	{
		return buffer.o[oPos + index];
	}

	public inline function readBeginBitmapFill():BeginBitmapFillView
	{
		advance();
		prev = BEGIN_BITMAP_FILL;
		return new BeginBitmapFillView(this);
	}

	public inline function readBeginFill():BeginFillView
	{
		advance();
		prev = BEGIN_FILL;
		return new BeginFillView(this);
	}

	public inline function readBeginGradientFill():BeginGradientFillView
	{
		advance();
		prev = BEGIN_GRADIENT_FILL;
		return new BeginGradientFillView(this);
	}

	public inline function readBeginShaderFill():BeginShaderFillView
	{
		advance();
		prev = BEGIN_SHADER_FILL;
		return new BeginShaderFillView(this);
	}

	public inline function readCubicCurveTo():CubicCurveToView
	{
		advance();
		prev = CUBIC_CURVE_TO;
		return new CubicCurveToView(this);
	}

	public inline function readCurveTo():CurveToView
	{
		advance();
		prev = CURVE_TO;
		return new CurveToView(this);
	}

	public inline function readDrawCircle():DrawCircleView
	{
		advance();
		prev = DRAW_CIRCLE;
		return new DrawCircleView(this);
	}

	public inline function readDrawEllipse():DrawEllipseView
	{
		advance();
		prev = DRAW_ELLIPSE;
		return new DrawEllipseView(this);
	}

	public inline function readDrawQuads():DrawQuadsView
	{
		advance();
		prev = DRAW_QUADS;
		return new DrawQuadsView(this);
	}

	public inline function readDrawRect():DrawRectView
	{
		advance();
		prev = DRAW_RECT;
		return new DrawRectView(this);
	}

	public inline function readDrawRoundRect():DrawRoundRectView
	{
		advance();
		prev = DRAW_ROUND_RECT;
		return new DrawRoundRectView(this);
	}

	public inline function readDrawTriangles():DrawTrianglesView
	{
		advance();
		prev = DRAW_TRIANGLES;
		return new DrawTrianglesView(this);
	}

	public inline function readEndFill():EndFillView
	{
		advance();
		prev = END_FILL;
		return new EndFillView(this);
	}

	public inline function readLineBitmapStyle():LineBitmapStyleView
	{
		advance();
		prev = LINE_BITMAP_STYLE;
		return new LineBitmapStyleView(this);
	}

	public inline function readLineGradientStyle():LineGradientStyleView
	{
		advance();
		prev = LINE_GRADIENT_STYLE;
		return new LineGradientStyleView(this);
	}

	public inline function readLineStyle():LineStyleView
	{
		advance();
		prev = LINE_STYLE;
		return new LineStyleView(this);
	}

	public inline function readLineTo():LineToView
	{
		advance();
		prev = LINE_TO;
		return new LineToView(this);
	}

	public inline function readMoveTo():MoveToView
	{
		advance();
		prev = MOVE_TO;
		return new MoveToView(this);
	}

	public inline function readOverrideBlendMode():OverrideBlendModeView
	{
		advance();
		prev = OVERRIDE_BLEND_MODE;
		return new OverrideBlendModeView(this);
	}

	public inline function readOverrideMatrix():OverrideMatrixView
	{
		advance();
		prev = OVERRIDE_MATRIX;
		return new OverrideMatrixView(this);
	}

	public inline function readWindingEvenOdd():WindingEvenOddView
	{
		advance();
		prev = WINDING_EVEN_ODD;
		return new WindingEvenOddView(this);
	}

	public inline function readWindingNonZero():WindingNonZeroView
	{
		advance();
		prev = WINDING_NON_ZERO;
		return new WindingNonZeroView(this);
	}

	public function reset():Void
	{
		bPos = iPos = fPos = oPos = ffPos = iiPos = tsPos = 0;
	}

	public inline function skip(type:DrawCommandType):Void
	{
		advance();
		prev = type;
	}
}

abstract BeginBitmapFillView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var bitmap(get, never):BitmapData;

	private inline function get_bitmap():BitmapData
	{
		return cast this.obj(0);
	}

	public var matrix(get, never):Matrix;

	private inline function get_matrix():Matrix
	{
		return cast this.obj(1);
	}

	public var repeat(get, never):Bool;

	private inline function get_repeat():Bool
	{
		return this.bool(0);
	}

	public var smooth(get, never):Bool;

	private inline function get_smooth():Bool
	{
		return this.bool(1);
	}
}

abstract BeginFillView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var color(get, never):Int;

	private inline function get_color():Int
	{
		return this.int(0);
	}

	public var alpha(get, never):Float;

	private inline function get_alpha():Float
	{
		return this.float(0);
	}
}

abstract BeginGradientFillView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var type(get, never):GradientType;

	private inline function get_type():GradientType
	{
		return cast this.obj(0);
	}

	public var colors(get, never):Array<Int>;

	private inline function get_colors():Array<Int>
	{
		return cast this.iArr(0);
	}

	public var alphas(get, never):Array<Float>;

	private inline function get_alphas():Array<Float>
	{
		return cast this.fArr(0);
	}

	public var ratios(get, never):Array<Int>;

	private inline function get_ratios():Array<Int>
	{
		return cast this.iArr(1);
	}

	public var matrix(get, never):Matrix;

	private inline function get_matrix():Matrix
	{
		return cast this.obj(1);
	}

	public var spreadMethod(get, never):SpreadMethod;

	private inline function get_spreadMethod():SpreadMethod
	{
		return cast this.obj(2);
	}

	public var interpolationMethod(get, never):InterpolationMethod;

	private inline function get_interpolationMethod():InterpolationMethod
	{
		return cast this.obj(3);
	}

	public var focalPointRatio(get, never):Float;

	private inline function get_focalPointRatio():Float
	{
		return cast this.float(0);
	}
}

abstract BeginShaderFillView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var shaderBuffer(get, never):ShaderBuffer;

	private inline function get_shaderBuffer():ShaderBuffer
	{
		return cast this.obj(0);
	}
}

abstract CubicCurveToView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var controlX1(get, never):Float;

	private inline function get_controlX1():Float
	{
		return this.float(0);
	}

	public var controlY1(get, never):Float;

	private inline function get_controlY1():Float
	{
		return this.float(1);
	}

	public var controlX2(get, never):Float;

	private inline function get_controlX2():Float
	{
		return this.float(2);
	}

	public var controlY2(get, never):Float;

	private inline function get_controlY2():Float
	{
		return this.float(3);
	}

	public var anchorX(get, never):Float;

	private inline function get_anchorX():Float
	{
		return this.float(4);
	}

	public var anchorY(get, never):Float;

	private inline function get_anchorY():Float
	{
		return this.float(5);
	}
}

abstract CurveToView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var controlX(get, never):Float;

	private inline function get_controlX():Float
	{
		return this.float(0);
	}

	public var controlY(get, never):Float;

	private inline function get_controlY():Float
	{
		return this.float(1);
	}

	public var anchorX(get, never):Float;

	private inline function get_anchorX():Float
	{
		return this.float(2);
	}

	public var anchorY(get, never):Float;

	private inline function get_anchorY():Float
	{
		return this.float(3);
	}
}

abstract DrawCircleView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var x(get, never):Float;

	private inline function get_x():Float
	{
		return this.float(0);
	}

	public var y(get, never):Float;

	private inline function get_y():Float
	{
		return this.float(1);
	}

	public var radius(get, never):Float;

	private inline function get_radius():Float
	{
		return this.float(2);
	}
}

abstract DrawEllipseView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var x(get, never):Float;

	private inline function get_x():Float
	{
		return this.float(0);
	}

	public var y(get, never):Float;

	private inline function get_y():Float
	{
		return this.float(1);
	}

	public var width(get, never):Float;

	private inline function get_width():Float
	{
		return this.float(2);
	}

	public var height(get, never):Float;

	private inline function get_height():Float
	{
		return this.float(3);
	}
}

abstract DrawQuadsView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var rects(get, never):Vector<Float>;

	private inline function get_rects():Vector<Float>
	{
		return cast this.obj(0);
	}

	public var indices(get, never):Vector<Int>;

	private inline function get_indices():Vector<Int>
	{
		return cast this.obj(1);
	}

	public var transforms(get, never):Vector<Float>;

	private inline function get_transforms():Vector<Float>
	{
		return cast this.obj(2);
	}
}

abstract DrawRectView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var x(get, never):Float;

	private inline function get_x():Float
	{
		return this.float(0);
	}

	public var y(get, never):Float;

	private inline function get_y():Float
	{
		return this.float(1);
	}

	public var width(get, never):Float;

	private inline function get_width():Float
	{
		return this.float(2);
	}

	public var height(get, never):Float;

	private inline function get_height():Float
	{
		return this.float(3);
	}
}

abstract DrawRoundRectView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var x(get, never):Float;

	private inline function get_x():Float
	{
		return this.float(0);
	}

	public var y(get, never):Float;

	private inline function get_y():Float
	{
		return this.float(1);
	}

	public var width(get, never):Float;

	private inline function get_width():Float
	{
		return this.float(2);
	}

	public var height(get, never):Float;

	private inline function get_height():Float
	{
		return this.float(3);
	}

	public var ellipseWidth(get, never):Float;

	private inline function get_ellipseWidth():Float
	{
		return this.float(4);
	}

	public var ellipseHeight(get, never):Null<Float>;

	private inline function get_ellipseHeight():Null<Float>
	{
		return this.obj(0);
	}
}

abstract DrawTrianglesView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var vertices(get, never):Vector<Float>;

	private inline function get_vertices():Vector<Float>
	{
		return cast this.obj(0);
	}

	public var indices(get, never):Vector<Int>;

	private inline function get_indices():Vector<Int>
	{
		return cast this.obj(1);
	}

	public var uvtData(get, never):Vector<Float>;

	private inline function get_uvtData():Vector<Float>
	{
		return cast this.obj(2);
	}

	public var culling(get, never):TriangleCulling;

	private inline function get_culling():TriangleCulling
	{
		return cast this.obj(3);
	}
}

abstract EndFillView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}
}

abstract LineBitmapStyleView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var bitmap(get, never):BitmapData;

	private inline function get_bitmap():BitmapData
	{
		return cast this.obj(0);
	}

	public var matrix(get, never):Matrix;

	private inline function get_matrix():Matrix
	{
		return cast this.obj(1);
	}

	public var repeat(get, never):Bool;

	private inline function get_repeat():Bool
	{
		return cast this.bool(0);
	}

	public var smooth(get, never):Bool;

	private inline function get_smooth():Bool
	{
		return cast this.bool(1);
	}
}

abstract LineGradientStyleView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var type(get, never):GradientType;

	private inline function get_type():GradientType
	{
		return cast this.obj(0);
	}

	public var colors(get, never):Array<Int>;

	private inline function get_colors():Array<Int>
	{
		return cast this.iArr(0);
	}

	public var alphas(get, never):Array<Float>;

	private inline function get_alphas():Array<Float>
	{
		return cast this.fArr(0);
	}

	public var ratios(get, never):Array<Int>;

	private inline function get_ratios():Array<Int>
	{
		return cast this.iArr(1);
	}

	public var matrix(get, never):Matrix;

	private inline function get_matrix():Matrix
	{
		return cast this.obj(1);
	}

	public var spreadMethod(get, never):SpreadMethod;

	private inline function get_spreadMethod():SpreadMethod
	{
		return cast this.obj(2);
	}

	public var interpolationMethod(get, never):InterpolationMethod;

	private inline function get_interpolationMethod():InterpolationMethod
	{
		return cast this.obj(3);
	}

	public var focalPointRatio(get, never):Float;

	private inline function get_focalPointRatio():Float
	{
		return cast this.float(0);
	}
}

abstract LineStyleView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var thickness(get, never):Null<Float>;

	private inline function get_thickness():Null<Float>
	{
		return cast this.obj(0);
	}

	public var color(get, never):Int;

	private inline function get_color():Int
	{
		return cast this.int(0);
	}

	public var alpha(get, never):Float;

	private inline function get_alpha():Float
	{
		return cast this.float(0);
	}

	public var pixelHinting(get, never):Bool;

	private inline function get_pixelHinting():Bool
	{
		return cast this.bool(0);
	}

	public var scaleMode(get, never):LineScaleMode;

	private inline function get_scaleMode():LineScaleMode
	{
		return cast this.obj(1);
	}

	public var caps(get, never):CapsStyle;

	private inline function get_caps():CapsStyle
	{
		return cast this.obj(2);
	}

	public var joints(get, never):JointStyle;

	private inline function get_joints():JointStyle
	{
		return cast this.obj(3);
	}

	public var miterLimit(get, never):Float;

	private inline function get_miterLimit():Float
	{
		return cast this.float(1);
	}
}

abstract LineToView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var x(get, never):Float;

	private inline function get_x():Float
	{
		return this.float(0);
	}

	public var y(get, never):Float;

	private inline function get_y():Float
	{
		return this.float(1);
	}
}

abstract MoveToView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var x(get, never):Float;

	private inline function get_x():Float
	{
		return this.float(0);
	}

	public var y(get, never):Float;

	private inline function get_y():Float
	{
		return this.float(1);
	}
}

abstract OverrideBlendModeView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var blendMode(get, never):BlendMode;

	private inline function get_blendMode():BlendMode
	{
		return cast this.obj(0);
	}
}

abstract OverrideMatrixView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}

	public var matrix(get, never):Matrix;

	private inline function get_matrix():Matrix
	{
		return cast this.obj(0);
	}
}

abstract WindingEvenOddView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}
}

abstract WindingNonZeroView(DrawCommandReader)
{
	public inline function new(d:DrawCommandReader)
	{
		this = d;
	}
}
