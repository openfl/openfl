namespace openfl._internal.renderer;

import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CapsStyle;
import openfl.display.GradientType;
import openfl.display.InterpolationMethod;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.SpreadMethod;
import openfl.display.TriangleCulling;
import Matrix from "../geom/Matrix";
import Vector from "../Vector";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: allow(openfl._internal.renderer)
@SuppressWarnings("checkstyle:FieldDocComment")
class DrawCommandReader
{
	public buffer: DrawCommandBuffer;

	private bPos: number;
	private iiPos: number;
	private iPos: number;
	private ffPos: number;
	private fPos: number;
	private oPos: number;
	private prev: DrawCommandType;
	private tsPos: number;

	public constructor(buffer: DrawCommandBuffer)
	{
		this.buffer = buffer;

		bPos = iPos = fPos = oPos = ffPos = iiPos = tsPos = 0;
		prev = UNKNOWN;
	}

	protected inline advance(): void
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

	protected inline bool(index: number): boolean
	{
		return buffer.b[bPos + index];
	}

	public destroy(): void
	{
		buffer = null;
		reset();
	}

	protected inline fArr(index: number): Array<Float>
	{
		return buffer.ff[ffPos + index];
	}

	protected inline float(index: number): number
	{
		return buffer.f[fPos + index];
	}

	protected inline iArr(index: number): Array<Int>
	{
		return buffer.ii[iiPos + index];
	}

	protected inline int(index: number): number
	{
		return buffer.i[iPos + index];
	}

	/** @hidden */
	@SuppressWarnings("checkstyle:Dynamic")
	private inline obj(index: number): Dynamic
	{
		return buffer.o[oPos + index];
	}

	public inline readBeginBitmapFill(): BeginBitmapFillView
	{
		advance();
		prev = BEGIN_BITMAP_FILL;
		return new BeginBitmapFillView(this);
	}

	public inline readBeginFill(): BeginFillView
	{
		advance();
		prev = BEGIN_FILL;
		return new BeginFillView(this);
	}

	public inline readBeginGradientFill(): BeginGradientFillView
	{
		advance();
		prev = BEGIN_GRADIENT_FILL;
		return new BeginGradientFillView(this);
	}

	public inline readBeginShaderFill(): BeginShaderFillView
	{
		advance();
		prev = BEGIN_SHADER_FILL;
		return new BeginShaderFillView(this);
	}

	public inline readCubicCurveTo(): CubicCurveToView
	{
		advance();
		prev = CUBIC_CURVE_TO;
		return new CubicCurveToView(this);
	}

	public inline readCurveTo(): CurveToView
	{
		advance();
		prev = CURVE_TO;
		return new CurveToView(this);
	}

	public inline readDrawCircle(): DrawCircleView
	{
		advance();
		prev = DRAW_CIRCLE;
		return new DrawCircleView(this);
	}

	public inline readDrawEllipse(): DrawEllipseView
	{
		advance();
		prev = DRAW_ELLIPSE;
		return new DrawEllipseView(this);
	}

	public inline readDrawQuads(): DrawQuadsView
	{
		advance();
		prev = DRAW_QUADS;
		return new DrawQuadsView(this);
	}

	public inline readDrawRect(): DrawRectView
	{
		advance();
		prev = DRAW_RECT;
		return new DrawRectView(this);
	}

	public inline readDrawRoundRect(): DrawRoundRectView
	{
		advance();
		prev = DRAW_ROUND_RECT;
		return new DrawRoundRectView(this);
	}

	public inline readDrawTriangles(): DrawTrianglesView
	{
		advance();
		prev = DRAW_TRIANGLES;
		return new DrawTrianglesView(this);
	}

	public inline readEndFill(): EndFillView
	{
		advance();
		prev = END_FILL;
		return new EndFillView(this);
	}

	public inline readLineBitmapStyle(): LineBitmapStyleView
	{
		advance();
		prev = LINE_BITMAP_STYLE;
		return new LineBitmapStyleView(this);
	}

	public inline readLineGradientStyle(): LineGradientStyleView
	{
		advance();
		prev = LINE_GRADIENT_STYLE;
		return new LineGradientStyleView(this);
	}

	public inline readLineStyle(): LineStyleView
	{
		advance();
		prev = LINE_STYLE;
		return new LineStyleView(this);
	}

	public inline readLineTo(): LineToView
	{
		advance();
		prev = LINE_TO;
		return new LineToView(this);
	}

	public inline readMoveTo(): MoveToView
	{
		advance();
		prev = MOVE_TO;
		return new MoveToView(this);
	}

	public inline readOverrideBlendMode(): OverrideBlendModeView
	{
		advance();
		prev = OVERRIDE_BLEND_MODE;
		return new OverrideBlendModeView(this);
	}

	public inline readOverrideMatrix(): OverrideMatrixView
	{
		advance();
		prev = OVERRIDE_MATRIX;
		return new OverrideMatrixView(this);
	}

	public inline readWindingEvenOdd(): WindingEvenOddView
	{
		advance();
		prev = WINDING_EVEN_ODD;
		return new WindingEvenOddView(this);
	}

	public inline readWindingNonZero(): WindingNonZeroView
	{
		advance();
		prev = WINDING_NON_ZERO;
		return new WindingNonZeroView(this);
	}

	public reset(): void
	{
		bPos = iPos = fPos = oPos = ffPos = iiPos = tsPos = 0;
	}

	public inline skip(type: DrawCommandType): void
	{
		advance();
		prev = type;
	}
}

abstract BeginBitmapFillView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public bitmap(get, never): BitmapData;

	private inline get_bitmap(): BitmapData
	{
		return cast this.obj(0);
	}

	public matrix(get, never): Matrix;

	private inline get_matrix(): Matrix
	{
		return cast this.obj(1);
	}

	public repeat(get, never) : boolean;

	private inline get_repeat() : boolean
	{
		return this.bool(0);
	}

	public smooth(get, never) : boolean;

	private inline get_smooth() : boolean
	{
		return this.bool(1);
	}
}

abstract BeginFillView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public color(get, never) : number;

	private inline get_color() : number
	{
		return this.int(0);
	}

	public alpha(get, never) : number;

	private inline get_alpha() : number
	{
		return this.float(0);
	}
}

abstract BeginGradientFillView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public type(get, never): GradientType;

	private inline get_type(): GradientType
	{
		return cast this.obj(0);
	}

	public colors(get, never): Array<Int>;

	private inline get_colors(): Array < Int >
	{
		return cast this.iArr(0);
	}

	public alphas(get, never): Array<Float>;

	private inline get_alphas(): Array < Float >
	{
		return cast this.fArr(0);
	}

	public ratios(get, never): Array<Int>;

	private inline get_ratios(): Array < Int >
	{
		return cast this.iArr(1);
	}

	public matrix(get, never): Matrix;

	private inline get_matrix(): Matrix
	{
		return cast this.obj(1);
	}

	public spreadMethod(get, never): SpreadMethod;

	private inline get_spreadMethod(): SpreadMethod
	{
		return cast this.obj(2);
	}

	public interpolationMethod(get, never) : numbererpolationMethod;

	private inline get_interpolationMethod() : numbererpolationMethod
	{
		return cast this.obj(3);
	}

	public focalPointRatio(get, never) : number;

	private inline get_focalPointRatio() : number
	{
		return cast this.float(0);
	}
}

abstract BeginShaderFillView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public shaderBuffer(get, never): ShaderBuffer;

	private inline get_shaderBuffer(): ShaderBuffer
	{
		return cast this.obj(0);
	}
}

abstract CubicCurveToView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public controlX1(get, never) : number;

	private inline get_controlX1() : number
	{
		return this.float(0);
	}

	public controlY1(get, never) : number;

	private inline get_controlY1() : number
	{
		return this.float(1);
	}

	public controlX2(get, never) : number;

	private inline get_controlX2() : number
	{
		return this.float(2);
	}

	public controlY2(get, never) : number;

	private inline get_controlY2() : number
	{
		return this.float(3);
	}

	public anchorX(get, never) : number;

	private inline get_anchorX() : number
	{
		return this.float(4);
	}

	public anchorY(get, never) : number;

	private inline get_anchorY() : number
	{
		return this.float(5);
	}
}

abstract CurveToView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public controlX(get, never) : number;

	private inline get_controlX() : number
	{
		return this.float(0);
	}

	public controlY(get, never) : number;

	private inline get_controlY() : number
	{
		return this.float(1);
	}

	public anchorX(get, never) : number;

	private inline get_anchorX() : number
	{
		return this.float(2);
	}

	public anchorY(get, never) : number;

	private inline get_anchorY() : number
	{
		return this.float(3);
	}
}

abstract DrawCircleView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public x(get, never) : number;

	private inline get_x() : number
	{
		return this.float(0);
	}

	public y(get, never) : number;

	private inline get_y() : number
	{
		return this.float(1);
	}

	public radius(get, never) : number;

	private inline get_radius() : number
	{
		return this.float(2);
	}
}

abstract DrawEllipseView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public x(get, never) : number;

	private inline get_x() : number
	{
		return this.float(0);
	}

	public y(get, never) : number;

	private inline get_y() : number
	{
		return this.float(1);
	}

	public width(get, never) : number;

	private inline get_width() : number
	{
		return this.float(2);
	}

	public height(get, never) : number;

	private inline get_height() : number
	{
		return this.float(3);
	}
}

abstract DrawQuadsView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public rects(get, never): Vector<number>;

	private inline get_rects(): Vector < Float >
	{
		return cast this.obj(0);
	}

	public indices(get, never): Vector<Int>;

	private inline get_indices(): Vector < Int >
	{
		return cast this.obj(1);
	}

	public transforms(get, never): Vector<number>;

	private inline get_transforms(): Vector < Float >
	{
		return cast this.obj(2);
	}
}

abstract DrawRectView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public x(get, never) : number;

	private inline get_x() : number
	{
		return this.float(0);
	}

	public y(get, never) : number;

	private inline get_y() : number
	{
		return this.float(1);
	}

	public width(get, never) : number;

	private inline get_width() : number
	{
		return this.float(2);
	}

	public height(get, never) : number;

	private inline get_height() : number
	{
		return this.float(3);
	}
}

abstract DrawRoundRectView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public x(get, never) : number;

	private inline get_x() : number
	{
		return this.float(0);
	}

	public y(get, never) : number;

	private inline get_y() : number
	{
		return this.float(1);
	}

	public width(get, never) : number;

	private inline get_width() : number
	{
		return this.float(2);
	}

	public height(get, never) : number;

	private inline get_height() : number
	{
		return this.float(3);
	}

	public ellipseWidth(get, never) : number;

	private inline get_ellipseWidth() : number
	{
		return this.float(4);
	}

	public ellipseHeight(get, never): null | number;

	private inline get_ellipseHeight(): Null < Float >
	{
		return this.obj(0);
	}
}

abstract DrawTrianglesView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public vertices(get, never): Vector<number>;

	private inline get_vertices(): Vector < Float >
	{
		return cast this.obj(0);
	}

	public indices(get, never): Vector<Int>;

	private inline get_indices(): Vector < Int >
	{
		return cast this.obj(1);
	}

	public uvtData(get, never): Vector<number>;

	private inline get_uvtData(): Vector < Float >
	{
		return cast this.obj(2);
	}

	public culling(get, never): TriangleCulling;

	private inline get_culling(): TriangleCulling
	{
		return cast this.obj(3);
	}
}

abstract EndFillView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}
}

abstract LineBitmapStyleView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public bitmap(get, never): BitmapData;

	private inline get_bitmap(): BitmapData
	{
		return cast this.obj(0);
	}

	public matrix(get, never): Matrix;

	private inline get_matrix(): Matrix
	{
		return cast this.obj(1);
	}

	public repeat(get, never) : boolean;

	private inline get_repeat() : boolean
	{
		return cast this.bool(0);
	}

	public smooth(get, never) : boolean;

	private inline get_smooth() : boolean
	{
		return cast this.bool(1);
	}
}

abstract LineGradientStyleView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public type(get, never): GradientType;

	private inline get_type(): GradientType
	{
		return cast this.obj(0);
	}

	public colors(get, never): Array<Int>;

	private inline get_colors(): Array < Int >
	{
		return cast this.iArr(0);
	}

	public alphas(get, never): Array<Float>;

	private inline get_alphas(): Array < Float >
	{
		return cast this.fArr(0);
	}

	public ratios(get, never): Array<Int>;

	private inline get_ratios(): Array < Int >
	{
		return cast this.iArr(1);
	}

	public matrix(get, never): Matrix;

	private inline get_matrix(): Matrix
	{
		return cast this.obj(1);
	}

	public spreadMethod(get, never): SpreadMethod;

	private inline get_spreadMethod(): SpreadMethod
	{
		return cast this.obj(2);
	}

	public interpolationMethod(get, never) : numbererpolationMethod;

	private inline get_interpolationMethod() : numbererpolationMethod
	{
		return cast this.obj(3);
	}

	public focalPointRatio(get, never) : number;

	private inline get_focalPointRatio() : number
	{
		return cast this.float(0);
	}
}

abstract LineStyleView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public thickness(get, never): null | number;

	private inline get_thickness(): Null < Float >
	{
		return cast this.obj(0);
	}

	public color(get, never) : number;

	private inline get_color() : number
	{
		return cast this.int(0);
	}

	public alpha(get, never) : number;

	private inline get_alpha() : number
	{
		return cast this.float(0);
	}

	public pixelHinting(get, never) : boolean;

	private inline get_pixelHinting() : boolean
	{
		return cast this.bool(0);
	}

	public scaleMode(get, never): LineScaleMode;

	private inline get_scaleMode(): LineScaleMode
	{
		return cast this.obj(1);
	}

	public caps(get, never): CapsStyle;

	private inline get_caps(): CapsStyle
	{
		return cast this.obj(2);
	}

	public joints(get, never): JointStyle;

	private inline get_joints(): JointStyle
	{
		return cast this.obj(3);
	}

	public miterLimit(get, never) : number;

	private inline get_miterLimit() : number
	{
		return cast this.float(1);
	}
}

abstract LineToView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public x(get, never) : number;

	private inline get_x() : number
	{
		return this.float(0);
	}

	public y(get, never) : number;

	private inline get_y() : number
	{
		return this.float(1);
	}
}

abstract MoveToView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public x(get, never) : number;

	private inline get_x() : number
	{
		return this.float(0);
	}

	public y(get, never) : number;

	private inline get_y() : number
	{
		return this.float(1);
	}
}

abstract OverrideBlendModeView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public blendMode(get, never): BlendMode;

	private inline get_blendMode(): BlendMode
	{
		return cast this.obj(0);
	}
}

abstract OverrideMatrixView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}

	public matrix(get, never): Matrix;

	private inline get_matrix(): Matrix
	{
		return cast this.obj(0);
	}
}

abstract WindingEvenOddView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}
}

abstract WindingNonZeroView(DrawCommandReader)
{
	public inline new (d: DrawCommandReader)
	{
		this = d;
	}
}
