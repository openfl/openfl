import DrawCommandBuffer from "../../_internal/renderer/DrawCommandBuffer";
import DrawCommandType from "../../_internal/renderer/DrawCommandType";
import ShaderBuffer from "../../_internal/renderer/ShaderBuffer";
import * as internal from "../../_internal/utils/InternalAccess";
import BitmapData from "../../display/BitmapData";
import BlendMode from "../../display/BlendMode";
import CapsStyle from "../../display/CapsStyle";
import GradientType from "../../display/GradientType";
import InterpolationMethod from "../../display/InterpolationMethod";
import JointStyle from "../../display/JointStyle";
import LineScaleMode from "../../display/LineScaleMode";
import SpreadMethod from "../../display/SpreadMethod";
import TriangleCulling from "../../display/TriangleCulling";
import Matrix from "../../geom/Matrix";
import Vector from "../../Vector";

export default class DrawCommandReader
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

		this.bPos = this.iPos = this.fPos = this.oPos = this.ffPos = this.iiPos = this.tsPos = 0;
		this.prev = DrawCommandType.UNKNOWN;
	}

	protected advance(): void
	{
		switch (this.prev)
		{
			case DrawCommandType.BEGIN_BITMAP_FILL:
				this.oPos += 2; // bitmap, matrix
				this.bPos += 2; // repeat, smooth
				break;

			case DrawCommandType.BEGIN_FILL:
				this.iPos += 1; // color
				this.fPos += 1; // alpha
				break;

			case DrawCommandType.BEGIN_GRADIENT_FILL:
				this.oPos += 4; // type, matrix, spreadMethod, interpolationMethod
				this.iiPos += 2; // colors, ratios
				this.ffPos += 1; // alphas
				this.fPos += 1; // focalPointRatio
				break;

			case DrawCommandType.BEGIN_SHADER_FILL:
				this.oPos += 1; // shaderBuffer
				break;

			case DrawCommandType.CUBIC_CURVE_TO:
				this.fPos += 6; // controlX1, controlY1, controlX2, controlY2, anchorX, anchorY
				break;

			case DrawCommandType.CURVE_TO:
				this.fPos += 4; // controlX, controlY, anchorX, anchorY
				break;

			case DrawCommandType.DRAW_CIRCLE:
				this.fPos += 3; // x, y, radius
				break;

			case DrawCommandType.DRAW_ELLIPSE:
				this.fPos += 4; // x, y, width, height
				break;

			case DrawCommandType.DRAW_QUADS:
				this.oPos += 3; // rects, indices, transforms
				break;

			case DrawCommandType.DRAW_RECT:
				this.fPos += 4; // x, y, width, height
				break;

			case DrawCommandType.DRAW_ROUND_RECT:
				this.fPos += 5; // x, y, width, height, ellipseWidth
				this.oPos += 1; // ellipseHeight
				break;

			case DrawCommandType.DRAW_TRIANGLES:
				this.oPos += 4; // vertices, indices, uvtData, culling
				break;

			case DrawCommandType.END_FILL:
				break;

			// no parameters

			case DrawCommandType.LINE_BITMAP_STYLE:
				this.oPos += 2; // bitmap, matrix
				this.bPos += 2; // repeat, smooth
				break;

			case DrawCommandType.LINE_GRADIENT_STYLE:
				this.oPos += 4; // type, matrix, spreadMethod, interpolationMethod
				this.iiPos += 2; // colors, ratios
				this.ffPos += 1; // alphas
				this.fPos += 1; // focalPointRatio
				break;

			case DrawCommandType.LINE_STYLE:
				this.oPos += 4; // thickness, scaleMode, caps, joints
				this.iPos += 1; // color
				this.fPos += 2; // alpha, miterLimit
				this.bPos += 1; // pixelHinting
				break;

			case DrawCommandType.LINE_TO:
				this.fPos += 2; // x, y
				break;

			case DrawCommandType.MOVE_TO:
				this.fPos += 2; // x, y
				break;

			case DrawCommandType.OVERRIDE_BLEND_MODE:
				this.oPos += 1; // blendMode
				break;

			case DrawCommandType.OVERRIDE_MATRIX:
				this.oPos += 1; // matrix
				break;

			case DrawCommandType.WINDING_EVEN_ODD:
			case DrawCommandType.WINDING_NON_ZERO:

			// no parameters

			default:
		}
	}

	public bool(index: number): boolean
	{
		return this.buffer.b[this.bPos + index];
	}

	public destroy(): void
	{
		this.buffer = null;
		this.reset();
	}

	public fArr(index: number): Array<number>
	{
		return this.buffer.ff[this.ffPos + index];
	}

	public float(index: number): number
	{
		return this.buffer.f[this.fPos + index];
	}

	public iArr(index: number): Array<number>
	{
		return this.buffer.ii[this.iiPos + index];
	}

	public int(index: number): number
	{
		return this.buffer.i[this.iPos + index];
	}

	public obj(index: number): any
	{
		return this.buffer.o[this.oPos + index];
	}

	public readBeginBitmapFill(): BeginBitmapFillView
	{
		this.advance();
		this.prev = DrawCommandType.BEGIN_BITMAP_FILL;
		return new BeginBitmapFillView(this);
	}

	public readBeginFill(): BeginFillView
	{
		this.advance();
		this.prev = DrawCommandType.BEGIN_FILL;
		return new BeginFillView(this);
	}

	public readBeginGradientFill(): BeginGradientFillView
	{
		this.advance();
		this.prev = DrawCommandType.BEGIN_GRADIENT_FILL;
		return new BeginGradientFillView(this);
	}

	public readBeginShaderFill(): BeginShaderFillView
	{
		this.advance();
		this.prev = DrawCommandType.BEGIN_SHADER_FILL;
		return new BeginShaderFillView(this);
	}

	public readCubicCurveTo(): CubicCurveToView
	{
		this.advance();
		this.prev = DrawCommandType.CUBIC_CURVE_TO;
		return new CubicCurveToView(this);
	}

	public readCurveTo(): CurveToView
	{
		this.advance();
		this.prev = DrawCommandType.CURVE_TO;
		return new CurveToView(this);
	}

	public readDrawCircle(): DrawCircleView
	{
		this.advance();
		this.prev = DrawCommandType.DRAW_CIRCLE;
		return new DrawCircleView(this);
	}

	public readDrawEllipse(): DrawEllipseView
	{
		this.advance();
		this.prev = DrawCommandType.DRAW_ELLIPSE;
		return new DrawEllipseView(this);
	}

	public readDrawQuads(): DrawQuadsView
	{
		this.advance();
		this.prev = DrawCommandType.DRAW_QUADS;
		return new DrawQuadsView(this);
	}

	public readDrawRect(): DrawRectView
	{
		this.advance();
		this.prev = DrawCommandType.DRAW_RECT;
		return new DrawRectView(this);
	}

	public readDrawRoundRect(): DrawRoundRectView
	{
		this.advance();
		this.prev = DrawCommandType.DRAW_ROUND_RECT;
		return new DrawRoundRectView(this);
	}

	public readDrawTriangles(): DrawTrianglesView
	{
		this.advance();
		this.prev = DrawCommandType.DRAW_TRIANGLES;
		return new DrawTrianglesView(this);
	}

	public readEndFill(): EndFillView
	{
		this.advance();
		this.prev = DrawCommandType.END_FILL;
		return new EndFillView(this);
	}

	public readLineBitmapStyle(): LineBitmapStyleView
	{
		this.advance();
		this.prev = DrawCommandType.LINE_BITMAP_STYLE;
		return new LineBitmapStyleView(this);
	}

	public readLineGradientStyle(): LineGradientStyleView
	{
		this.advance();
		this.prev = DrawCommandType.LINE_GRADIENT_STYLE;
		return new LineGradientStyleView(this);
	}

	public readLineStyle(): LineStyleView
	{
		this.advance();
		this.prev = DrawCommandType.LINE_STYLE;
		return new LineStyleView(this);
	}

	public readLineTo(): LineToView
	{
		this.advance();
		this.prev = DrawCommandType.LINE_TO;
		return new LineToView(this);
	}

	public readMoveTo(): MoveToView
	{
		this.advance();
		this.prev = DrawCommandType.MOVE_TO;
		return new MoveToView(this);
	}

	public readOverrideBlendMode(): OverrideBlendModeView
	{
		this.advance();
		this.prev = DrawCommandType.OVERRIDE_BLEND_MODE;
		return new OverrideBlendModeView(this);
	}

	public readOverrideMatrix(): OverrideMatrixView
	{
		this.advance();
		this.prev = DrawCommandType.OVERRIDE_MATRIX;
		return new OverrideMatrixView(this);
	}

	public readWindingEvenOdd(): WindingEvenOddView
	{
		this.advance();
		this.prev = DrawCommandType.WINDING_EVEN_ODD;
		return new WindingEvenOddView(this);
	}

	public readWindingNonZero(): WindingNonZeroView
	{
		this.advance();
		this.prev = DrawCommandType.WINDING_NON_ZERO;
		return new WindingNonZeroView(this);
	}

	public reset(): void
	{
		this.bPos = this.iPos = this.fPos = this.oPos = this.ffPos = this.iiPos = this.tsPos = 0;
	}

	public skip(type: DrawCommandType): void
	{
		this.advance();
		this.prev = type;
	}
}

class BeginBitmapFillView
{
	readonly bitmap: BitmapData;
	readonly matrix: Matrix;
	readonly repeat: boolean;
	readonly smooth: boolean;

	public constructor(d: DrawCommandReader)
	{
		this.bitmap = d.obj(0);
		this.matrix = d.obj(1);
		this.repeat = d.bool(0);
		this.smooth = d.bool(1);
	}
}

class BeginFillView
{
	readonly color: number;
	readonly alpha: number;

	public constructor(d: DrawCommandReader)
	{
		this.color = d.int(0);
		this.alpha = d.float(0);
	}
}

class BeginGradientFillView
{
	readonly type: GradientType;
	readonly colors: Array<number>;
	readonly alphas: Array<number>;
	readonly ratios: Array<number>;
	readonly matrix: Matrix;
	readonly spreadMethod: SpreadMethod;
	readonly interpolationMethod: InterpolationMethod;
	readonly focalPointRatio: number;

	public constructor(d: DrawCommandReader)
	{
		this.type = d.obj(0);
		this.colors = d.iArr(0);
		this.alphas = d.fArr(0);
		this.ratios = d.iArr(1);
		this.matrix = d.obj(1);
		this.spreadMethod = d.obj(2);
		this.interpolationMethod = d.obj(3);
		this.focalPointRatio = d.float(0);
	}
}

class BeginShaderFillView
{
	readonly shaderBuffer: ShaderBuffer;

	public constructor(d: DrawCommandReader)
	{
		this.shaderBuffer = d.obj(0);
	}
}

class CubicCurveToView
{
	readonly controlX1: number;
	readonly controlY1: number;
	readonly controlX2: number;
	readonly controlY2: number;
	readonly anchorX: number;
	readonly anchorY: number;

	public constructor(d: DrawCommandReader)
	{
		this.controlX1 = d.float(0);
		this.controlY1 = d.float(1);
		this.controlX2 = d.float(2);
		this.controlY2 = d.float(3);
		this.anchorX = d.float(4);
		this.anchorY = d.float(5);
	}
}

class CurveToView
{
	readonly controlX: number;
	readonly controlY: number;
	readonly anchorX: number;
	readonly anchorY: number;

	public constructor(d: DrawCommandReader)
	{
		this.controlX = d.float(0);
		this.controlY = d.float(1);
		this.anchorX = d.float(2);
		this.anchorY = d.float(3);
	}
}

class DrawCircleView
{
	readonly x: number;
	readonly y: number;
	readonly radius: number;

	public constructor(d: DrawCommandReader)
	{
		this.x = d.float(0);
		this.y = d.float(1);
		this.radius = d.float(2);
	}
}

class DrawEllipseView
{
	readonly x: number;
	readonly y: number;
	readonly width: number;
	readonly height: number;

	public constructor(d: DrawCommandReader)
	{
		this.x = d.float(0);
		this.y = d.float(1);
		this.width = d.float(2);
		this.height = d.float(3);
	}
}

class DrawQuadsView
{
	readonly rects: Vector<number>;
	readonly indices: Vector<number>;
	readonly transforms: Vector<number>;

	public constructor(d: DrawCommandReader)
	{
		this.rects = d.obj(0);
		this.indices = d.obj(1);
		this.transforms = d.obj(2);
	}
}

class DrawRectView
{
	readonly x: number;
	readonly y: number;
	readonly width: number;
	readonly height: number;

	public constructor(d: DrawCommandReader)
	{
		this.x = d.float(0);
		this.y = d.float(1);
		this.width = d.float(2);
		this.height = d.float(3);
	}
}

class DrawRoundRectView
{
	readonly x: number;
	readonly y: number;
	readonly width: number;
	readonly height: number;
	readonly ellipseWidth: number;
	readonly ellipseHeight: null | number;

	public constructor(d: DrawCommandReader)
	{
		this.x = d.float(0);
		this.y = d.float(1);
		this.width = d.float(2);
		this.height = d.float(3);
		this.ellipseWidth = d.float(4);
		this.ellipseHeight = d.obj(0);
	}
}

class DrawTrianglesView
{
	readonly vertices: Vector<number>;
	readonly indices: Vector<number>;
	readonly uvtData: Vector<number>;
	readonly culling: TriangleCulling;

	public constructor(d: DrawCommandReader)
	{
		this.vertices = d.obj(0);
		this.indices = d.obj(1);
		this.uvtData = d.obj(2);
		this.culling = d.obj(3);
	}
}

class EndFillView
{
	public constructor(d: DrawCommandReader)
	{

	}
}

class LineBitmapStyleView
{
	readonly bitmap: BitmapData;
	readonly matrix: Matrix;
	readonly repeat: boolean;
	readonly smooth: boolean;

	public constructor(d: DrawCommandReader)
	{
		this.bitmap = d.obj(0);
		this.matrix = d.obj(1);
		this.repeat = d.bool(0);
		this.smooth = d.bool(1);
	}
}

class LineGradientStyleView
{
	readonly type: GradientType;
	readonly colors: Array<number>;
	readonly alphas: Array<number>;
	readonly ratios: Array<number>;
	readonly matrix: Matrix;
	readonly spreadMethod: SpreadMethod;
	readonly interpolationMethod: InterpolationMethod;
	readonly focalPointRatio: number;

	public constructor(d: DrawCommandReader)
	{
		this.type = d.obj(0);
		this.colors = d.iArr(0);
		this.alphas = d.fArr(0);
		this.ratios = d.iArr(1);
		this.matrix = d.obj(1);
		this.spreadMethod = d.obj(2);
		this.interpolationMethod = d.obj(3);
		this.focalPointRatio = d.float(0);
	}
}

class LineStyleView
{
	readonly thickness: null | number;
	readonly color: number;
	readonly alpha: number;
	readonly pixelHinting: boolean;
	readonly scaleMode: LineScaleMode;
	readonly caps: CapsStyle;
	readonly joints: JointStyle;
	readonly miterLimit: number;

	public constructor(d: DrawCommandReader)
	{
		this.thickness = d.obj(0);
		this.color = d.int(0);
		this.alpha = d.float(0);
		this.pixelHinting = d.bool(0);
		this.scaleMode = d.obj(1);
		this.caps = d.obj(2);
		this.joints = d.obj(3);
		this.miterLimit = d.float(1);
	}
}

class LineToView
{
	readonly x: number;
	readonly y: number;

	public constructor(d: DrawCommandReader)
	{
		this.x = d.float(0);
		this.y = d.float(1);
	}
}

class MoveToView
{
	readonly x: number;
	readonly y: number;

	public constructor(d: DrawCommandReader)
	{
		this.x = d.float(0);
		this.y = d.float(1);
	}
}

class OverrideBlendModeView
{
	readonly blendMode: BlendMode;

	public constructor(d: DrawCommandReader)
	{
		this.blendMode = d.obj(0);
	}
}

class OverrideMatrixView
{
	readonly matrix: Matrix;

	public constructor(d: DrawCommandReader)
	{
		this.matrix = d.obj(0);
	}
}

class WindingEvenOddView
{
	public constructor(d: DrawCommandReader)
	{

	}
}

class WindingNonZeroView
{
	public constructor(d: DrawCommandReader)
	{

	}
}
