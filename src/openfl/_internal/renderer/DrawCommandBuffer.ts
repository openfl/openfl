import DrawCommandType from "../../_internal/renderer/DrawCommandType";
import DrawCommandReader from "../../_internal/renderer/DrawCommandReader";
import ShaderBuffer from "../../_internal/renderer/ShaderBuffer";
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

export default class DrawCommandBuffer
{
	private static empty: DrawCommandBuffer = new DrawCommandBuffer();

	public types: Array<DrawCommandType>;

	public b: Array<boolean>;
	private copyOnWrite: boolean;
	public f: Array<number>;
	public ff: Array<Array<number>>;
	public i: Array<number>;
	public ii: Array<Array<number>>;
	public o: Array<Object>;

	public constructor()
	{
		if (DrawCommandBuffer.empty == null)
		{
			this.types = [];

			this.b = [];
			this.i = [];
			this.f = [];
			this.o = [];
			this.ff = [];
			this.ii = [];

			this.copyOnWrite = true;
		}
		else
		{
			this.clear();
		}
	}

	public append(other: DrawCommandBuffer): DrawCommandBuffer
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

		for (let type of other.types)
		{
			switch (type)
			{
				case DrawCommandType.BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					this.beginBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth);
					break;
				case DrawCommandType.BEGIN_FILL:
					var c2 = data.readBeginFill();
					this.beginFill(c2.color, c2.alpha);
					break;
				case DrawCommandType.BEGIN_GRADIENT_FILL:
					var c3 = data.readBeginGradientFill();
					this.beginGradientFill(c3.type, c3.colors, c3.alphas, c3.ratios, c3.matrix, c3.spreadMethod, c3.interpolationMethod, c3.focalPointRatio);
					break;
				case DrawCommandType.BEGIN_SHADER_FILL:
					var c4 = data.readBeginShaderFill();
					this.beginShaderFill(c4.shaderBuffer);
					break;
				case DrawCommandType.CUBIC_CURVE_TO:
					var c5 = data.readCubicCurveTo();
					this.cubicCurveTo(c5.controlX1, c5.controlY1, c5.controlX2, c5.controlY2, c5.anchorX, c5.anchorY);
					break;
				case DrawCommandType.CURVE_TO:
					var c6 = data.readCurveTo();
					this.curveTo(c6.controlX, c6.controlY, c6.anchorX, c6.anchorY);
					break;
				case DrawCommandType.DRAW_CIRCLE:
					var c7 = data.readDrawCircle();
					this.drawCircle(c7.x, c7.y, c7.radius);
					break;
				case DrawCommandType.DRAW_ELLIPSE:
					var c8 = data.readDrawEllipse();
					this.drawEllipse(c8.x, c8.y, c8.width, c8.height);
					break;
				case DrawCommandType.DRAW_QUADS:
					var c9 = data.readDrawQuads();
					this.drawQuads(c9.rects, c9.indices, c9.transforms);
					break;
				case DrawCommandType.DRAW_RECT:
					var c10 = data.readDrawRect();
					this.drawRect(c10.x, c10.y, c10.width, c10.height);
					break;
				case DrawCommandType.DRAW_ROUND_RECT:
					var c11 = data.readDrawRoundRect();
					this.drawRoundRect(c11.x, c11.y, c11.width, c11.height, c11.ellipseWidth, c11.ellipseHeight);
					break;
				case DrawCommandType.DRAW_TRIANGLES:
					var c12 = data.readDrawTriangles();
					this.drawTriangles(c12.vertices, c12.indices, c12.uvtData, c12.culling);
					break;
				case DrawCommandType.END_FILL:
					var c13 = data.readEndFill();
					this.endFill();
					break;
				case DrawCommandType.LINE_BITMAP_STYLE:
					var c14 = data.readLineBitmapStyle();
					this.lineBitmapStyle(c14.bitmap, c14.matrix, c14.repeat, c14.smooth);
					break;
				case DrawCommandType.LINE_GRADIENT_STYLE:
					var c15 = data.readLineGradientStyle();
					this.lineGradientStyle(c15.type, c15.colors, c15.alphas, c15.ratios, c15.matrix, c15.spreadMethod, c15.interpolationMethod, c15.focalPointRatio);
					break;
				case DrawCommandType.LINE_STYLE:
					var c16 = data.readLineStyle();
					this.lineStyle(c16.thickness, c16.color, c16.alpha, c16.pixelHinting, c16.scaleMode, c16.caps, c16.joints, c16.miterLimit);
					break;
				case DrawCommandType.LINE_TO:
					var c17 = data.readLineTo();
					this.lineTo(c17.x, c17.y);
					break;
				case DrawCommandType.MOVE_TO:
					var c18 = data.readMoveTo();
					this.moveTo(c18.x, c18.y);
					break;
				case DrawCommandType.OVERRIDE_MATRIX:
					var c19 = data.readOverrideMatrix();
					this.overrideMatrix(c19.matrix);
					break;
				case DrawCommandType.WINDING_EVEN_ODD:
					var c20 = data.readWindingEvenOdd();
					this.windingEvenOdd();
					break;
				case DrawCommandType.WINDING_NON_ZERO:
					var c21 = data.readWindingNonZero();
					this.windingNonZero();
					break;
				default:
			}
		}

		data.destroy();
		return other;
	}

	public beginBitmapFill(bitmap: BitmapData, matrix: Matrix, repeat: boolean, smooth: boolean): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.BEGIN_BITMAP_FILL);
		this.o.push(bitmap);
		this.o.push(matrix);
		this.b.push(repeat);
		this.b.push(smooth);
	}

	public beginFill(color: number, alpha: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.BEGIN_FILL);
		this.i.push(color);
		this.f.push(alpha);
	}

	public beginGradientFill(type: GradientType, colors: Array<number>, alphas: Array<number>, ratios: Array<number>, matrix: Matrix, spreadMethod: SpreadMethod,
		interpolationMethod: InterpolationMethod, focalPointRatio: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.BEGIN_GRADIENT_FILL);
		this.o.push(type);
		this.ii.push(colors);
		this.ff.push(alphas);
		this.ii.push(ratios);
		this.o.push(matrix);
		this.o.push(spreadMethod);
		this.o.push(interpolationMethod);
		this.f.push(focalPointRatio);
	}

	public beginShaderFill(shaderBuffer: ShaderBuffer): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.BEGIN_SHADER_FILL);
		this.o.push(shaderBuffer);
	}

	public clear(): void
	{
		var empty = DrawCommandBuffer.empty;
		this.types = empty.types;

		this.b = empty.b;
		this.i = empty.i;
		this.f = empty.f;
		this.o = empty.o;
		this.ff = empty.ff;
		this.ii = empty.ii;

		this.copyOnWrite = true;
	}

	public copy(): DrawCommandBuffer
	{
		var copy = new DrawCommandBuffer();
		copy.append(this);
		return copy;
	}

	public cubicCurveTo(controlX1: number, controlY1: number, controlX2: number, controlY2: number, anchorX: number, anchorY: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.CUBIC_CURVE_TO);
		this.f.push(controlX1);
		this.f.push(controlY1);
		this.f.push(controlX2);
		this.f.push(controlY2);
		this.f.push(anchorX);
		this.f.push(anchorY);
	}

	public curveTo(controlX: number, controlY: number, anchorX: number, anchorY: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.CURVE_TO);
		this.f.push(controlX);
		this.f.push(controlY);
		this.f.push(anchorX);
		this.f.push(anchorY);
	}

	public destroy(): void
	{
		this.clear();

		this.types = null;

		this.b = null;
		this.i = null;
		this.f = null;
		this.o = null;
		this.ff = null;
		this.ii = null;
	}

	public drawCircle(x: number, y: number, radius: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.DRAW_CIRCLE);
		this.f.push(x);
		this.f.push(y);
		this.f.push(radius);
	}

	public drawEllipse(x: number, y: number, width: number, height: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.DRAW_ELLIPSE);
		this.f.push(x);
		this.f.push(y);
		this.f.push(width);
		this.f.push(height);
	}

	public drawQuads(rects: Vector<number>, indices: Vector<number>, transforms: Vector<number>): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.DRAW_QUADS);
		this.o.push(rects);
		this.o.push(indices);
		this.o.push(transforms);
	}

	public drawRect(x: number, y: number, width: number, height: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.DRAW_RECT);
		this.f.push(x);
		this.f.push(y);
		this.f.push(width);
		this.f.push(height);
	}

	public drawRoundRect(x: number, y: number, width: number, height: number, ellipseWidth: number, ellipseHeight: null | number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.DRAW_ROUND_RECT);
		this.f.push(x);
		this.f.push(y);
		this.f.push(width);
		this.f.push(height);
		this.f.push(ellipseWidth);
		this.o.push(ellipseHeight);
	}

	public drawTriangles(vertices: Vector<number>, indices: Vector<number>, uvtData: Vector<number>, culling: TriangleCulling): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.DRAW_TRIANGLES);
		this.o.push(vertices);
		this.o.push(indices);
		this.o.push(uvtData);
		this.o.push(culling);
	}

	public endFill(): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.END_FILL);
	}

	public lineBitmapStyle(bitmap: BitmapData, matrix: Matrix, repeat: boolean, smooth: boolean): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.LINE_BITMAP_STYLE);
		this.o.push(bitmap);
		this.o.push(matrix);
		this.b.push(repeat);
		this.b.push(smooth);
	}

	public lineGradientStyle(type: GradientType, colors: Array<number>, alphas: Array<number>, ratios: Array<number>, matrix: Matrix, spreadMethod: SpreadMethod,
		interpolationMethod: InterpolationMethod, focalPointRatio: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.LINE_GRADIENT_STYLE);
		this.o.push(type);
		this.ii.push(colors);
		this.ff.push(alphas);
		this.ii.push(ratios);
		this.o.push(matrix);
		this.o.push(spreadMethod);
		this.o.push(interpolationMethod);
		this.f.push(focalPointRatio);
	}

	public lineStyle(thickness: null | number, color: number, alpha: number, pixelHinting: boolean, scaleMode: LineScaleMode, caps: CapsStyle, joints: JointStyle,
		miterLimit: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.LINE_STYLE);
		this.o.push(thickness);
		this.i.push(color);
		this.f.push(alpha);
		this.b.push(pixelHinting);
		this.o.push(scaleMode);
		this.o.push(caps);
		this.o.push(joints);
		this.f.push(miterLimit);
	}

	public lineTo(x: number, y: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.LINE_TO);
		this.f.push(x);
		this.f.push(y);
	}

	public moveTo(x: number, y: number): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.MOVE_TO);
		this.f.push(x);
		this.f.push(y);
	}

	private prepareWrite(): void
	{
		if (this.copyOnWrite)
		{
			this.types = this.types.slice();
			this.b = this.b.slice();
			this.i = this.i.slice();
			this.f = this.f.slice();
			this.o = this.o.slice();
			this.ff = this.ff.slice();
			this.ii = this.ii.slice();

			this.copyOnWrite = false;
		}
	}

	public overrideBlendMode(blendMode: BlendMode): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.OVERRIDE_BLEND_MODE);
		this.o.push(blendMode);
	}

	public overrideMatrix(matrix: Matrix): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.OVERRIDE_MATRIX);
		this.o.push(matrix);
	}

	public windingEvenOdd(): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.WINDING_EVEN_ODD);
	}

	public windingNonZero(): void
	{
		this.prepareWrite();

		this.types.push(DrawCommandType.WINDING_NON_ZERO);
	}

	// Get & Set Methods

	public get length(): number
	{
		return this.types.length;
	}
}
