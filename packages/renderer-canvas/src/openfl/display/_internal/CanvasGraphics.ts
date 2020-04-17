import DrawCommandBuffer from "../../../_internal/renderer/DrawCommandBuffer";
import DrawCommandReader from "../../../_internal/renderer/DrawCommandReader";
import DrawCommandType from "../../../_internal/renderer/DrawCommandType";
import * as internal from "../../../_internal/utils/InternalAccess";
import BitmapData from "../../../display/BitmapData";
import BlendMode from "../../../display/BlendMode";
import CapsStyle from "../../../display/CapsStyle";
import GradientType from "../../../display/GradientType";
import Graphics from "../../../display/Graphics";
import InterpolationMethod from "../../../display/InterpolationMethod";
import SpreadMethod from "../../../display/SpreadMethod";
import TriangleCulling from "../../../display/TriangleCulling";
import Context3DTextureFilter from "../../../display3D/Context3DTextureFilter";
import Context3DWrapMode from "../../../display3D/Context3DWrapMode";
import Matrix from "../../../geom/Matrix";
import Point from "../../../geom/Point";
import Rectangle from "../../../geom/Rectangle";
import Vector from "../../../Vector";
import CanvasRenderer from "./CanvasRenderer";
// import openfl._internal.backend.lime_standalone.ImageCanvasUtil;

enum CanvasWindingRule
{
	NONZERO = "nonzero",
	EVENODD = "evenodd"
}

export default class CanvasGraphics
{
	private static readonly SIN45: number = 0.70710678118654752440084436210485;
	private static readonly TAN22: number = 0.4142135623730950488016887242097;

	private static allowSmoothing: boolean;
	private static bitmapFill: BitmapData;
	private static bitmapStroke: BitmapData;
	private static bitmapRepeat: boolean;
	private static bounds: Rectangle;
	private static fillCommands: DrawCommandBuffer = new DrawCommandBuffer();
	private static graphics: Graphics;
	private static hasFill: boolean;
	private static hasStroke: boolean;
	private static hitTesting: boolean;
	private static inversePendingMatrix: Matrix;
	private static pendingMatrix: Matrix;
	private static strokeCommands: DrawCommandBuffer = new DrawCommandBuffer();
	private static windingRule: CanvasWindingRule;
	private static worldAlpha: number;
	private static context: CanvasRenderingContext2D;
	private static hitTestCanvas: HTMLCanvasElement = document.createElement("canvas");
	private static hitTestContext: CanvasRenderingContext2D = CanvasGraphics.hitTestCanvas.getContext("2d");

	private static closePath(strokeBefore: boolean = false): void
	{
		if (this.context.strokeStyle == null)
		{
			return;
		}

		if (!strokeBefore)
		{
			this.context.closePath();
		}

		this.context.stroke();

		if (strokeBefore)
		{
			this.context.closePath();
		}

		this.context.beginPath();
	}

	private static createBitmapFill(bitmap: BitmapData, bitmapRepeat: boolean, smooth: boolean): CanvasPattern
	{
		this.setSmoothing(smooth);
		return this.context.createPattern((<internal.BitmapData><any>bitmap).__getElement(), bitmapRepeat ? "repeat" : "no-repeat");
	}

	private static createGradientPattern(type: GradientType, colors: Array<number>, alphas: Array<number>, ratios: Array<number>, matrix: Matrix,
		spreadMethod: SpreadMethod, interpolationMethod: InterpolationMethod, focalPointRatio: number): CanvasPattern
	{
		var gradientFill = null,
			point = null,
			point2 = null,
			releaseMatrix = false;

		if (matrix == null)
		{
			matrix = (<internal.Matrix><any>Matrix).__pool.get();
			releaseMatrix = true;
		}

		switch (type)
		{
			case GradientType.RADIAL:
				point = (<internal.Point><any>Point).__pool.get();
				point.setTo(1638.4, 0);
				(<internal.Matrix><any>matrix).__transformPoint(point);

				gradientFill = this.context.createRadialGradient(matrix.tx, matrix.ty, 0, matrix.tx, matrix.ty, Math.abs((point.x - matrix.tx) / 2));
				break;

			case GradientType.LINEAR:
				point = (<internal.Point><any>Point).__pool.get();
				point.setTo(-819.2, 0);
				(<internal.Matrix><any>matrix).__transformPoint(point);

				point2 = (<internal.Point><any>Point).__pool.get();
				point2.setTo(819.2, 0);
				(<internal.Matrix><any>matrix).__transformPoint(point2);

				gradientFill = this.context.createLinearGradient(point.x, point.y, point2.x, point2.y);
				break;
		}

		var rgb, alpha, r, g, b, ratio;

		for (let i = 0; i < colors.length; i++)
		{
			rgb = colors[i];
			alpha = alphas[i];
			r = (rgb & 0xFF0000) >>> 16;
			g = (rgb & 0x00FF00) >>> 8;
			b = (rgb & 0x0000FF);

			ratio = ratios[i] / 0xFF;
			if (ratio < 0) ratio = 0;
			if (ratio > 1) ratio = 1;

			gradientFill.addColorStop(ratio, "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")");
		}

		if (point != null) (<internal.Point><any>Point).__pool.release(point);
		if (point2 != null) (<internal.Point><any>Point).__pool.release(point2);
		if (releaseMatrix) (<internal.Matrix><any>Matrix).__pool.release(matrix);

		return gradientFill;
	}

	private static createTempPatternCanvas(bitmap: BitmapData, repeat: boolean, width: number, height: number): HTMLCanvasElement
	{
		// TODO: Don't create extra canvas elements like this

		var canvas: HTMLCanvasElement = document.createElement("canvas");
		var context = canvas.getContext("2d");

		canvas.width = width;
		canvas.height = height;

		context.fillStyle = context.createPattern((<internal.BitmapData><any>bitmap).__getElement(), repeat ? "repeat" : "no-repeat");
		context.beginPath();
		context.moveTo(0, 0);
		context.lineTo(0, height);
		context.lineTo(width, height);
		context.lineTo(width, 0);
		context.lineTo(0, 0);
		context.closePath();
		if (!this.hitTesting) context.fill(this.windingRule);
		return canvas;
	}

	private static drawRoundRect(x: number, y: number, width: number, height: number, ellipseWidth: number, ellipseHeight: null | number): void
	{
		if (ellipseHeight == null) ellipseHeight = ellipseWidth;

		ellipseWidth *= 0.5;
		ellipseHeight *= 0.5;

		if (ellipseWidth > width / 2) ellipseWidth = width / 2;
		if (ellipseHeight > height / 2) ellipseHeight = height / 2;

		var xe = x + width,
			ye = y + height,
			cx1 = -ellipseWidth + (ellipseWidth * this.SIN45),
			cx2 = -ellipseWidth + (ellipseWidth * this.TAN22),
			cy1 = -ellipseHeight + (ellipseHeight * this.SIN45),
			cy2 = -ellipseHeight + (ellipseHeight * this.TAN22);

		var context = this.context;
		context.moveTo(xe, ye - ellipseHeight);
		context.quadraticCurveTo(xe, ye + cy2, xe + cx1, ye + cy1);
		context.quadraticCurveTo(xe + cx2, ye, xe - ellipseWidth, ye);
		context.lineTo(x + ellipseWidth, ye);
		context.quadraticCurveTo(x - cx2, ye, x - cx1, ye + cy1);
		context.quadraticCurveTo(x, ye + cy2, x, ye - ellipseHeight);
		context.lineTo(x, y + ellipseHeight);
		context.quadraticCurveTo(x, y - cy2, x - cx1, y - cy1);
		context.quadraticCurveTo(x - cx2, y, x + ellipseWidth, y);
		context.lineTo(xe - ellipseWidth, y);
		context.quadraticCurveTo(xe + cx2, y, xe + cx1, y - cy1);
		context.quadraticCurveTo(xe, y - cy2, xe, y + ellipseHeight);
		context.lineTo(xe, ye - ellipseHeight);
	}

	private static endFill(): void
	{
		this.context.beginPath();
		this.playCommands(this.fillCommands, false);
		this.fillCommands.clear();
	}

	private static endStroke(): void
	{
		this.context.beginPath();
		this.playCommands(this.strokeCommands, true);
		this.context.closePath();
		this.strokeCommands.clear();
	}

	public static hitTest(graphics: Graphics, x: number, y: number): boolean
	{
		this.bounds = (<internal.Graphics><any>graphics).__bounds;
		CanvasGraphics.graphics = graphics;

		if ((<internal.Graphics><any>graphics).__commands.length == 0 || this.bounds == null || this.bounds.width <= 0 || this.bounds.height <= 0)
		{
			return false;
		}
		else
		{
			this.hitTesting = true;

			var transform = (<internal.Graphics><any>graphics).__renderTransform;

			var px = (<internal.Matrix><any>transform).__transformX(x, y);
			var py = (<internal.Matrix><any>transform).__transformY(x, y);

			x = px;
			y = py;

			x -= (<internal.Matrix><any>transform).__transformX(this.bounds.x, this.bounds.y);
			y -= (<internal.Matrix><any>transform).__transformY(this.bounds.x, this.bounds.y);

			var cacheCanvas = (<internal.Graphics><any>graphics).__renderData.canvas;
			var cacheContext = (<internal.Graphics><any>graphics).__renderData.context;
			(<internal.Graphics><any>graphics).__renderData.canvas = this.hitTestCanvas;
			(<internal.Graphics><any>graphics).__renderData.context = this.hitTestContext;

			this.context = (<internal.Graphics><any>graphics).__renderData.context;
			this.context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);

			this.fillCommands.clear();
			this.strokeCommands.clear();

			this.hasFill = false;
			this.hasStroke = false;
			this.bitmapFill = null;
			this.bitmapRepeat = false;

			this.windingRule = CanvasWindingRule.EVENODD;

			var data = new DrawCommandReader((<internal.Graphics><any>graphics).__commands);

			for (let type of (<internal.Graphics><any>graphics).__commands.types)
			{
				switch (type)
				{
					case DrawCommandType.CUBIC_CURVE_TO:
						var c = data.readCubicCurveTo();
						this.fillCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						this.strokeCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
						break;

					case DrawCommandType.CURVE_TO:
						var c2 = data.readCurveTo();
						this.fillCommands.curveTo(c2.controlX, c2.controlY, c2.anchorX, c2.anchorY);
						this.strokeCommands.curveTo(c2.controlX, c2.controlY, c2.anchorX, c2.anchorY);
						break;

					case DrawCommandType.LINE_TO:
						var c3 = data.readLineTo();
						this.fillCommands.lineTo(c3.x, c3.y);
						this.strokeCommands.lineTo(c3.x, c3.y);
						break;

					case DrawCommandType.MOVE_TO:
						var c4 = data.readMoveTo();
						this.fillCommands.moveTo(c4.x, c4.y);
						this.strokeCommands.moveTo(c4.x, c4.y);
						break;

					case DrawCommandType.LINE_GRADIENT_STYLE:
						var c5 = data.readLineGradientStyle();
						this.strokeCommands.lineGradientStyle(c5.type, c5.colors, c5.alphas, c5.ratios, c5.matrix, c5.spreadMethod, c5.interpolationMethod,
							c5.focalPointRatio);
						break;

					case DrawCommandType.LINE_BITMAP_STYLE:
						var c6 = data.readLineBitmapStyle();
						this.strokeCommands.lineBitmapStyle(c6.bitmap, c6.matrix, c6.repeat, c6.smooth);
						break;

					case DrawCommandType.LINE_STYLE:
						var c7 = data.readLineStyle();
						this.strokeCommands.lineStyle(c7.thickness, c7.color, 1, c7.pixelHinting, c7.scaleMode, c7.caps, c7.joints, c7.miterLimit);
						break;

					case DrawCommandType.END_FILL:
						data.readEndFill();
						this.endFill();

						if (this.hasFill && this.context.isPointInPath(x, y, this.windingRule))
						{
							data.destroy();
							(<internal.Graphics><any>graphics).__renderData.canvas = cacheCanvas;
							(<internal.Graphics><any>graphics).__renderData.context = cacheContext;
							return true;
						}

						this.endStroke();

						if (this.hasStroke && this.context.isPointInStroke(x, y))
						{
							data.destroy();
							(<internal.Graphics><any>graphics).__renderData.canvas = cacheCanvas;
							(<internal.Graphics><any>graphics).__renderData.context = cacheContext;
							return true;
						}

						this.hasFill = false;
						this.bitmapFill = null;
						break;

					case DrawCommandType.BEGIN_BITMAP_FILL:
					case DrawCommandType.BEGIN_FILL:
					case DrawCommandType.BEGIN_GRADIENT_FILL:
					case DrawCommandType.BEGIN_SHADER_FILL:
						this.endFill();

						if (this.hasFill && this.context.isPointInPath(x, y, this.windingRule))
						{
							data.destroy();
							(<internal.Graphics><any>graphics).__renderData.canvas = cacheCanvas;
							(<internal.Graphics><any>graphics).__renderData.context = cacheContext;
							return true;
						}

						this.endStroke();

						if (this.hasStroke && this.context.isPointInStroke(x, y))
						{
							data.destroy();
							(<internal.Graphics><any>graphics).__renderData.canvas = cacheCanvas;
							(<internal.Graphics><any>graphics).__renderData.context = cacheContext;
							return true;
						}

						if (type == DrawCommandType.BEGIN_BITMAP_FILL)
						{
							var c8 = data.readBeginBitmapFill();
							this.fillCommands.beginBitmapFill(c8.bitmap, c8.matrix, c8.repeat, c8.smooth);
							this.strokeCommands.beginBitmapFill(c8.bitmap, c8.matrix, c8.repeat, c8.smooth);
						}
						else if (type == DrawCommandType.BEGIN_GRADIENT_FILL)
						{
							var c9 = data.readBeginGradientFill();
							this.fillCommands.beginGradientFill(c9.type, c9.colors, c9.alphas, c9.ratios, c9.matrix, c9.spreadMethod, c9.interpolationMethod,
								c9.focalPointRatio);
							this.strokeCommands.beginGradientFill(c9.type, c9.colors, c9.alphas, c9.ratios, c9.matrix, c9.spreadMethod, c9.interpolationMethod,
								c9.focalPointRatio);
						}
						else if (type == DrawCommandType.BEGIN_SHADER_FILL)
						{
							var c10 = data.readBeginShaderFill();
							this.fillCommands.beginShaderFill(c10.shaderBuffer);
							this.strokeCommands.beginShaderFill(c10.shaderBuffer);
						}
						else
						{
							var c11 = data.readBeginFill();
							this.fillCommands.beginFill(c11.color, 1);
							this.strokeCommands.beginFill(c11.color, 1);
						}
						break;

					case DrawCommandType.DRAW_CIRCLE:
						var c12 = data.readDrawCircle();
						this.fillCommands.drawCircle(c12.x, c12.y, c12.radius);
						this.strokeCommands.drawCircle(c12.x, c12.y, c12.radius);
						break;

					case DrawCommandType.DRAW_ELLIPSE:
						var c13 = data.readDrawEllipse();
						this.fillCommands.drawEllipse(c13.x, c13.y, c13.width, c13.height);
						this.strokeCommands.drawEllipse(c13.x, c13.y, c13.width, c13.height);
						break;

					case DrawCommandType.DRAW_RECT:
						var c14 = data.readDrawRect();
						this.fillCommands.drawRect(c14.x, c14.y, c14.width, c14.height);
						this.strokeCommands.drawRect(c14.x, c14.y, c14.width, c14.height);
						break;

					case DrawCommandType.DRAW_ROUND_RECT:
						var c15 = data.readDrawRoundRect();
						this.fillCommands.drawRoundRect(c15.x, c15.y, c15.width, c15.height, c15.ellipseWidth, c15.ellipseHeight);
						this.strokeCommands.drawRoundRect(c15.x, c15.y, c15.width, c15.height, c15.ellipseWidth, c15.ellipseHeight);
						break;

					case DrawCommandType.WINDING_EVEN_ODD:
						this.windingRule = CanvasWindingRule.EVENODD;
						break;

					case DrawCommandType.WINDING_NON_ZERO:
						this.windingRule = CanvasWindingRule.NONZERO;
						break;

					default:
						data.skip(type);
				}
			}

			var hitTest = false;

			if (this.fillCommands.length > 0)
			{
				this.endFill();
			}

			if (this.hasFill && this.context.isPointInPath(x, y, this.windingRule))
			{
				hitTest = true;
			}

			if (this.strokeCommands.length > 0)
			{
				this.endStroke();
			}

			if (this.hasStroke && this.context.isPointInStroke(x, y))
			{
				hitTest = true;
			}

			data.destroy();

			(<internal.Graphics><any>graphics).__renderData.canvas = cacheCanvas;
			(<internal.Graphics><any>graphics).__renderData.context = cacheContext;
			return hitTest;
		}

		return false;
	}

	private static isCCW(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number): boolean
	{
		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
	}

	private static normalizeUVT(uvt: Vector<number>, skipT: boolean = false): NormalizedUVT
	{
		var max: number = Number.NEGATIVE_INFINITY;
		var tmp = Number.NEGATIVE_INFINITY;
		var len = uvt.length;

		for (let t = 1; t < len + 1; t++)
		{
			if (skipT && t % 3 == 0)
			{
				continue;
			}

			tmp = uvt[t - 1];

			if (max < tmp)
			{
				max = tmp;
			}
		}

		if (!skipT)
		{
			return { max: max, uvt: uvt };
		}

		var result = new Vector<number>();

		for (let t = 1; t < len + 1; t++)
		{
			if (skipT && t % 3 == 0)
			{
				continue;
			}

			result.push(uvt[t - 1]);
		}

		return { max: max, uvt: result };
	}

	private static playCommands(commands: DrawCommandBuffer, stroke: boolean = false): void
	{
		this.bounds = (<internal.Graphics><any>this.graphics).__bounds;

		var offsetX = this.bounds.x;
		var offsetY = this.bounds.y;

		var positionX = 0.0;
		var positionY = 0.0;

		var closeGap = false;
		var startX = 0.0;
		var startY = 0.0;
		var setStart = false;

		this.windingRule = CanvasWindingRule.EVENODD;
		this.setSmoothing(true);

		var hasPath: boolean = false;

		var data = new DrawCommandReader(commands);

		var x,
			y,
			width,
			height,
			kappa = .5522848,
			ox,
			oy,
			xe,
			ye,
			xm,
			ym,
			r,
			g,
			b;
		var optimizationUsed,
			canOptimizeMatrix,
			st: number,
			sr: number,
			sb: number,
			sl: number,
			stl = null,
			sbr = null;

		for (let type of commands.types)
		{
			switch (type)
			{
				case DrawCommandType.CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					hasPath = true;
					this.context.bezierCurveTo(c.controlX1
						- offsetX, c.controlY1
					- offsetY, c.controlX2
					- offsetX, c.controlY2
					- offsetY, c.anchorX
					- offsetX,
						c.anchorY
						- offsetY);
					break;

				case DrawCommandType.CURVE_TO:
					var c2 = data.readCurveTo();
					hasPath = true;
					this.context.quadraticCurveTo(c2.controlX - offsetX, c2.controlY - offsetY, c2.anchorX - offsetX, c2.anchorY - offsetY);
					break;

				case DrawCommandType.DRAW_CIRCLE:
					var c3 = data.readDrawCircle();
					hasPath = true;
					this.context.moveTo(c3.x - offsetX + c3.radius, c3.y - offsetY);
					this.context.arc(c3.x - offsetX, c3.y - offsetY, c3.radius, 0, Math.PI * 2, true);
					break;

				case DrawCommandType.DRAW_ELLIPSE:
					var c4 = data.readDrawEllipse();
					hasPath = true;
					x = c4.x;
					y = c4.y;
					width = c4.width;
					height = c4.height;
					x -= offsetX;
					y -= offsetY;

					ox = (width / 2) * kappa; // control point offset horizontal
					oy = (height / 2) * kappa; // control point offset vertical
					xe = x + width; // x-end
					ye = y + height; // y-end
					xm = x + width / 2; // x-middle
					ym = y + height / 2; // y-middle

					this.context.moveTo(x, ym);
					this.context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
					this.context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
					this.context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
					this.context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
					break;

				case DrawCommandType.DRAW_ROUND_RECT:
					var c5 = data.readDrawRoundRect();
					hasPath = true;
					this.drawRoundRect(c5.x - offsetX, c5.y - offsetY, c5.width, c5.height, c5.ellipseWidth, c5.ellipseHeight);
					break;

				case DrawCommandType.LINE_TO:
					var c6 = data.readLineTo();
					hasPath = true;
					this.context.lineTo(c6.x - offsetX, c6.y - offsetY);

					positionX = c6.x;
					positionY = c6.y;

					if (positionX == startX && positionY == startY)
					{
						closeGap = true;
					}
					break;

				case DrawCommandType.MOVE_TO:
					var c7 = data.readMoveTo();
					this.context.moveTo(c7.x - offsetX, c7.y - offsetY);

					positionX = c7.x;
					positionY = c7.y;

					if (setStart && c7.x != startX && c7.y != startY)
					{
						closeGap = true;
					}

					startX = c7.x;
					startY = c7.y;
					setStart = true;
					break;

				case DrawCommandType.LINE_STYLE:
					var c8 = data.readLineStyle();
					if (stroke && this.hasStroke)
					{
						this.closePath(true);
					}

					this.context.moveTo(positionX - offsetX, positionY - offsetY);

					if (c8.thickness == null)
					{
						this.hasStroke = false;
					}
					else
					{
						this.context.lineWidth = (c8.thickness > 0 ? c8.thickness : 1);

						this.context.lineJoin = (c8.joints == null ? "round" : String(c8.joints).toLowerCase()) as CanvasLineJoin;

						switch (c8.caps)
						{
							case null:
								this.context.lineCap = "round";
								break;
							case CapsStyle.NONE:
								this.context.lineCap = "butt";
								break;
							default:
								this.context.lineCap = c8.caps.toLowerCase() as CanvasLineCap;
						}

						this.context.miterLimit = c8.miterLimit;

						if (c8.alpha == 1)
						{
							this.context.strokeStyle = "#" + (c8.color & 0x00FFFFFF).toString(16);
						}
						else
						{
							r = (c8.color & 0xFF0000) >>> 16;
							g = (c8.color & 0x00FF00) >>> 8;
							b = (c8.color & 0x0000FF);

							this.context.strokeStyle = "rgba(" + r + ", " + g + ", " + b + ", " + c8.alpha + ")";
						}

						this.setSmoothing(true);
						this.hasStroke = true;
					}
					break;

				case DrawCommandType.LINE_GRADIENT_STYLE:
					var c9 = data.readLineGradientStyle();
					if (stroke && this.hasStroke)
					{
						this.closePath();
					}

					this.context.moveTo(positionX - offsetX, positionY - offsetY);
					this.context.strokeStyle = this.createGradientPattern(c9.type, c9.colors, c9.alphas, c9.ratios, c9.matrix, c9.spreadMethod, c9.interpolationMethod,
						c9.focalPointRatio);

					this.setSmoothing(true);
					this.hasStroke = true;
					break;

				case DrawCommandType.LINE_BITMAP_STYLE:
					var c10 = data.readLineBitmapStyle();
					if (stroke && this.hasStroke)
					{
						this.closePath();
					}

					this.context.moveTo(positionX - offsetX, positionY - offsetY);
					this.context.strokeStyle = this.createBitmapFill(c10.bitmap, c10.repeat, c10.smooth);

					this.hasStroke = true;
					break;

				case DrawCommandType.BEGIN_BITMAP_FILL:
					var c11 = data.readBeginBitmapFill();
					this.bitmapFill = c11.bitmap;
					this.context.fillStyle = this.createBitmapFill(c11.bitmap, c11.repeat, c11.smooth);
					this.hasFill = true;

					if (c11.matrix != null)
					{
						this.pendingMatrix = c11.matrix;
						this.inversePendingMatrix = c11.matrix.clone();
						this.inversePendingMatrix.invert();
					}
					else
					{
						this.pendingMatrix = null;
						this.inversePendingMatrix = null;
					}
					break;

				case DrawCommandType.BEGIN_FILL:
					var c12 = data.readBeginFill();
					if (c12.alpha < 0.005)
					{
						this.hasFill = false;
					}
					else
					{
						if (c12.alpha == 1)
						{
							this.context.fillStyle = "#" + (c12.color & 0xFFFFFF).toString(16);
						}
						else
						{
							r = (c12.color & 0xFF0000) >>> 16;
							g = (c12.color & 0x00FF00) >>> 8;
							b = (c12.color & 0x0000FF);

							this.context.fillStyle = "rgba(" + r + ", " + g + ", " + b + ", " + c12.alpha + ")";
						}

						this.bitmapFill = null;
						this.setSmoothing(true);
						this.hasFill = true;
					}
					break;

				case DrawCommandType.BEGIN_GRADIENT_FILL:
					var c13 = data.readBeginGradientFill();
					this.context.fillStyle = this.createGradientPattern(c13.type, c13.colors, c13.alphas, c13.ratios, c13.matrix, c13.spreadMethod, c13.interpolationMethod,
						c13.focalPointRatio);

					this.bitmapFill = null;
					this.setSmoothing(true);
					this.hasFill = true;
					break;

				case DrawCommandType.BEGIN_SHADER_FILL:
					var c14 = data.readBeginShaderFill();
					var shaderBuffer = c14.shaderBuffer;

					if (shaderBuffer.inputCount > 0)
					{
						this.bitmapFill = shaderBuffer.inputs[0];
						this.context.fillStyle = this.createBitmapFill(this.bitmapFill, shaderBuffer.inputWrap[0] != Context3DWrapMode.CLAMP, shaderBuffer.inputFilter[0] != Context3DTextureFilter.NEAREST);
						this.hasFill = true;

						this.pendingMatrix = null;
						this.inversePendingMatrix = null;
					}
					break;

				case DrawCommandType.DRAW_QUADS:
					var c15 = data.readDrawQuads();
					var rects = c15.rects;
					var indices = c15.indices;
					var transforms = c15.transforms;

					var hasIndices = (indices != null);
					var transformABCD = false, transformXY = false;

					var length = hasIndices ? indices.length : Math.floor(rects.length / 4);
					if (length == 0) return;

					if (transforms != null)
					{
						if (transforms.length >= length * 6)
						{
							transformABCD = true;
							transformXY = true;
						}
						else if (transforms.length >= length * 4)
						{
							transformABCD = true;
						}
						else if (transforms.length >= length * 2)
						{
							transformXY = true;
						}
					}

					var tileRect = (<internal.Rectangle><any>Rectangle).__pool.get();
					var tileTransform = (<internal.Matrix><any>Matrix).__pool.get();

					var transform = (<internal.Graphics><any>this.graphics).__renderTransform;
					// roundPixels = (<internal.DisplayObjectRenderer><any>renderer).__roundPixels;
					var alpha = CanvasGraphics.worldAlpha;

					var ri, ti;

					this.context.save(); // TODO: Restore transform without save/restore

					for (let i = 0; i < length; i++)
					{
						ri = (hasIndices ? (indices[i] * 4) : i * 4);
						if (ri < 0) continue;
						tileRect.setTo(rects[ri], rects[ri + 1], rects[ri + 2], rects[ri + 3]);

						if (tileRect.width <= 0 || tileRect.height <= 0)
						{
							continue;
						}

						if (transformABCD && transformXY)
						{
							ti = i * 6;
							tileTransform.setTo(transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], transforms[ti + 4],
								transforms[ti + 5]);
						}
						else if (transformABCD)
						{
							ti = i * 4;
							tileTransform.setTo(transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], tileRect.x, tileRect.y);
						}
						else if (transformXY)
						{
							ti = i * 2;
							tileTransform.tx = transforms[ti];
							tileTransform.ty = transforms[ti + 1];
						}
						else
						{
							tileTransform.tx = tileRect.x;
							tileTransform.ty = tileRect.y;
						}

						tileTransform.tx += positionX - offsetX;
						tileTransform.ty += positionY - offsetY;
						tileTransform.concat(transform);

						// if (roundPixels) {

						// 	tileTransform.tx = Math.round (tileTransform.tx);
						// 	tileTransform.ty = Math.round (tileTransform.ty);

						// }

						this.context.setTransform(tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, tileTransform.tx, tileTransform.ty);

						if (this.bitmapFill != null)
						{
							this.context.drawImage((<internal.BitmapData><any>this.bitmapFill).__getElement(), tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width,
								tileRect.height);
						}
						else
						{
							this.context.fillRect(0, 0, tileRect.width, tileRect.height);
						}
					}

					(<internal.Rectangle><any>Rectangle).__pool.release(tileRect);
					(<internal.Matrix><any>Matrix).__pool.release(tileTransform);

					this.context.restore();
					break;

				case DrawCommandType.DRAW_TRIANGLES:
					var c16 = data.readDrawTriangles();

					var v = c16.vertices;
					var ind = c16.indices;
					var uvt = c16.uvtData;
					var pattern: HTMLCanvasElement = null;
					var colorFill = this.bitmapFill == null;

					if (colorFill && uvt != null)
					{
						break;
					}

					if (!colorFill)
					{
						// TODO move this to Graphics?

						if (uvt == null)
						{
							uvt = new Vector<number>();

							for (let i = 0; i < v.length / 2; i++)
							{
								uvt.push(v[i * 2] - offsetX / this.bitmapFill.width);
								uvt.push(v[i * 2 + 1] - offsetY / this.bitmapFill.height);
							}
						}

						var skipT = uvt.length != v.length;
						var normalizedUVT = this.normalizeUVT(uvt, skipT);
						var maxUVT = normalizedUVT.max;
						uvt = normalizedUVT.uvt;

						if (maxUVT > 1)
						{
							pattern = this.createTempPatternCanvas(this.bitmapFill, this.bitmapRepeat, Math.floor(this.bounds.width), Math.floor(this.bounds.height));
						}
						else
						{
							pattern = this.createTempPatternCanvas(this.bitmapFill, this.bitmapRepeat, this.bitmapFill.width, this.bitmapFill.height);
						}
					}

					var i = 0;
					var l = ind.length;

					var a_: number, b_: number, c_: number;
					var iax: number, iay: number, ibx: number, iby: number, icx: number, icy: number;
					var x1: number, y1: number, x2: number, y2: number, x3: number, y3: number;
					var uvx1: number, uvy1: number, uvx2: number, uvy2: number, uvx3: number, uvy3: number;
					var denom: number;
					var t1: number, t2: number, t3: number, t4: number;
					var dx: number, dy: number;

					while (i < l)
					{
						a_ = i;
						b_ = i + 1;
						c_ = i + 2;

						iax = ind[a_] * 2;
						iay = ind[a_] * 2 + 1;
						ibx = ind[b_] * 2;
						iby = ind[b_] * 2 + 1;
						icx = ind[c_] * 2;
						icy = ind[c_] * 2 + 1;

						x1 = v[iax] - offsetX;
						y1 = v[iay] - offsetY;
						x2 = v[ibx] - offsetX;
						y2 = v[iby] - offsetY;
						x3 = v[icx] - offsetX;
						y3 = v[icy] - offsetY;

						switch (c16.culling)
						{
							case TriangleCulling.POSITIVE:
								if (!this.isCCW(x1, y1, x2, y2, x3, y3))
								{
									i += 3;
									continue;
								}
								break;

							case TriangleCulling.NEGATIVE:
								if (this.isCCW(x1, y1, x2, y2, x3, y3))
								{
									i += 3;
									continue;
								}
								break;

							default:
						}

						if (colorFill)
						{
							this.context.beginPath();
							this.context.moveTo(x1, y1);
							this.context.lineTo(x2, y2);
							this.context.lineTo(x3, y3);
							this.context.closePath();
							if (!this.hitTesting) this.context.fill(this.windingRule);
							i += 3;
							continue;
						}

						uvx1 = uvt[iax] * pattern.width;
						uvx2 = uvt[ibx] * pattern.width;
						uvx3 = uvt[icx] * pattern.width;
						uvy1 = uvt[iay] * pattern.height;
						uvy2 = uvt[iby] * pattern.height;
						uvy3 = uvt[icy] * pattern.height;

						denom = uvx1 * (uvy3 - uvy2) - uvx2 * uvy3 + uvx3 * uvy2 + (uvx2 - uvx3) * uvy1;

						if (denom == 0)
						{
							i += 3;
							this.context.restore();
							continue;
						}

						this.context.save();
						this.context.beginPath();
						this.context.moveTo(x1, y1);
						this.context.lineTo(x2, y2);
						this.context.lineTo(x3, y3);
						this.context.closePath();
						this.context.clip();

						t1 = -(uvy1 * (x3 - x2) - uvy2 * x3 + uvy3 * x2 + (uvy2 - uvy3) * x1) / denom;
						t2 = (uvy2 * y3 + uvy1 * (y2 - y3) - uvy3 * y2 + (uvy3 - uvy2) * y1) / denom;
						t3 = (uvx1 * (x3 - x2) - uvx2 * x3 + uvx3 * x2 + (uvx2 - uvx3) * x1) / denom;
						t4 = -(uvx2 * y3 + uvx1 * (y2 - y3) - uvx3 * y2 + (uvx3 - uvx2) * y1) / denom;
						dx = (uvx1 * (uvy3 * x2 - uvy2 * x3) + uvy1 * (uvx2 * x3 - uvx3 * x2) + (uvx3 * uvy2 - uvx2 * uvy3) * x1) / denom;
						dy = (uvx1 * (uvy3 * y2 - uvy2 * y3) + uvy1 * (uvx2 * y3 - uvx3 * y2) + (uvx3 * uvy2 - uvx2 * uvy3) * y1) / denom;

						this.context.transform(t1, t2, t3, t4, dx, dy);
						this.context.drawImage(pattern, 0, 0, pattern.width, pattern.height);
						this.context.restore();

						i += 3;
					}

				case DrawCommandType.DRAW_RECT:
					var c17 = data.readDrawRect();
					optimizationUsed = false;

					if (this.bitmapFill != null && !this.hitTesting)
					{
						st = 0;
						sr = 0;
						sb = 0;
						sl = 0;

						canOptimizeMatrix = true;

						if (this.pendingMatrix != null)
						{
							if (this.pendingMatrix.b != 0 || this.pendingMatrix.c != 0)
							{
								canOptimizeMatrix = false;
							}
							else
							{
								if (stl == null) stl = (<internal.Point><any>Point).__pool.get();
								if (sbr == null) sbr = (<internal.Point><any>Point).__pool.get();

								stl.setTo(c17.x, c17.y);
								(<internal.Matrix><any>this.inversePendingMatrix).__transformPoint(stl);

								sbr.setTo(c17.x + c17.width, c17.y + c17.height);
								(<internal.Matrix><any>this.inversePendingMatrix).__transformPoint(sbr);

								st = stl.y;
								sl = stl.x;
								sb = sbr.y;
								sr = sbr.x;
							}
						}
						else
						{
							st = c17.y;
							sl = c17.x;
							sb = c17.y + c17.height;
							sr = c17.x + c17.width;
						}

						if (canOptimizeMatrix && st >= 0 && sl >= 0 && sr <= this.bitmapFill.width && sb <= this.bitmapFill.height)
						{
							optimizationUsed = true;
							if (!this.hitTesting) this.context.drawImage((<internal.BitmapData><any>this.bitmapFill).__getElement(), sl, st, sr - sl, sb - st, c17.x - offsetX, c17.y - offsetY, c17.width,
								c17.height);
						}
					}

					if (!optimizationUsed)
					{
						hasPath = true;
						this.context.rect(c17.x - offsetX, c17.y - offsetY, c17.width, c17.height);
					}
					break;

				case DrawCommandType.WINDING_EVEN_ODD:
					this.windingRule = CanvasWindingRule.EVENODD;
					break;

				case DrawCommandType.WINDING_NON_ZERO:
					this.windingRule = CanvasWindingRule.NONZERO;

				default:
					data.skip(type);
			}
		}

		if (stl != null) (<internal.Point><any>Point).__pool.release(stl);
		if (sbr != null) (<internal.Point><any>Point).__pool.release(sbr);

		data.destroy();

		if (hasPath)
		{
			if (stroke && this.hasStroke)
			{
				if (this.hasFill && closeGap)
				{
					this.context.lineTo(startX - offsetX, startY - offsetY);
					this.closePath(false);
				}
				else if (closeGap && positionX == startX && positionY == startY)
				{
					this.closePath(false);
				}

				if (!this.hitTesting) this.context.stroke();
			}

			if (!stroke)
			{
				if (this.hasFill || this.bitmapFill != null)
				{
					this.context.translate(-this.bounds.x, -this.bounds.y);

					if (this.pendingMatrix != null)
					{
						this.context.transform(this.pendingMatrix.a, this.pendingMatrix.b, this.pendingMatrix.c, this.pendingMatrix.d, this.pendingMatrix.tx, this.pendingMatrix.ty);
						if (!this.hitTesting) this.context.fill(this.windingRule);
						this.context.transform(this.inversePendingMatrix.a, this.inversePendingMatrix.b, this.inversePendingMatrix.c, this.inversePendingMatrix.d,
							this.inversePendingMatrix.tx, this.inversePendingMatrix.ty);
					}
					else
					{
						if (!this.hitTesting) this.context.fill(this.windingRule);
					}

					this.context.translate(this.bounds.x, this.bounds.y);
					this.context.closePath();
				}
			}
		}
	}

	public static render(graphics: Graphics, renderer: CanvasRenderer): void
	{
		(<internal.Graphics><any>graphics).__update((<internal.DisplayObjectRenderer><any>renderer).__worldTransform);

		if ((<internal.Graphics><any>graphics).__softwareDirty)
		{
			this.hitTesting = false;

			CanvasGraphics.graphics = graphics;
			CanvasGraphics.allowSmoothing = (<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing;
			CanvasGraphics.worldAlpha = renderer.__getAlpha((<internal.DisplayObject><any>(<internal.Graphics><any>graphics).__owner).__worldAlpha);
			this.bounds = (<internal.Graphics><any>graphics).__bounds;

			var width = (<internal.Graphics><any>graphics).__width;
			var height = (<internal.Graphics><any>graphics).__height;

			if (!(<internal.Graphics><any>graphics).__visible || (<internal.Graphics><any>graphics).__commands.length == 0 || this.bounds == null || width < 1 || height < 1)
			{
				(<internal.Graphics><any>graphics).__renderData.canvas = null;
				(<internal.Graphics><any>graphics).__renderData.context = null;
				(<internal.Graphics><any>graphics).__bitmap = null;
			}
			else
			{
				if ((<internal.Graphics><any>graphics).__renderData.canvas == null)
				{
					(<internal.Graphics><any>graphics).__renderData.canvas = document.createElement("canvas");
					(<internal.Graphics><any>graphics).__renderData.context = (<internal.Graphics><any>graphics).__renderData.canvas.getContext("2d");
				}

				this.context = (<internal.Graphics><any>graphics).__renderData.context;
				var transform = (<internal.Graphics><any>graphics).__renderTransform;
				var canvas = (<internal.Graphics><any>graphics).__renderData.canvas;

				var scale = renderer.pixelRatio;
				var scaledWidth = Math.floor(width * scale);
				var scaledHeight = Math.floor(height * scale);

				renderer.__setBlendModeContext(this.context, BlendMode.NORMAL);

				if (renderer.__domRenderer != null)
				{
					if (canvas.width == scaledWidth && canvas.height == scaledHeight)
					{
						this.context.clearRect(0, 0, scaledWidth, scaledHeight);
					}
					else
					{
						canvas.width = scaledWidth;
						canvas.height = scaledHeight;
						canvas.style.width = width + "px";
						canvas.style.height = height + "px";
					}

					var transform = (<internal.Graphics><any>graphics).__renderTransform;
					this.context.setTransform(transform.a * scale, transform.b * scale, transform.c * scale, transform.d * scale, transform.tx * scale,
						transform.ty * scale);
				}
				else
				{
					if (canvas.width == scaledWidth && canvas.height == scaledHeight)
					{
						this.context.closePath();
						this.context.setTransform(1, 0, 0, 1, 0, 0);
						this.context.clearRect(0, 0, scaledWidth, scaledHeight);
					}
					else
					{
						canvas.width = width;
						canvas.height = height;
					}

					this.context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				}

				this.fillCommands.clear();
				this.strokeCommands.clear();

				this.hasFill = false;
				this.hasStroke = false;
				this.bitmapFill = null;
				this.bitmapRepeat = false;

				var hasLineStyle = false;
				var initStrokeX = 0.0;
				var initStrokeY = 0.0;

				this.windingRule = CanvasWindingRule.EVENODD;

				var data = new DrawCommandReader((<internal.Graphics><any>graphics).__commands);

				for (let type of (<internal.Graphics><any>graphics).__commands.types)
				{
					switch (type)
					{
						case DrawCommandType.CUBIC_CURVE_TO:
							var c = data.readCubicCurveTo();
							this.fillCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);

							if (hasLineStyle)
							{
								this.strokeCommands.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
							}
							else
							{
								initStrokeX = c.anchorX;
								initStrokeY = c.anchorY;
							}
							break;

						case DrawCommandType.CURVE_TO:
							var c2 = data.readCurveTo();
							this.fillCommands.curveTo(c2.controlX, c2.controlY, c2.anchorX, c2.anchorY);

							if (hasLineStyle)
							{
								this.strokeCommands.curveTo(c2.controlX, c2.controlY, c2.anchorX, c2.anchorY);
							}
							else
							{
								initStrokeX = c2.anchorX;
								initStrokeY = c2.anchorY;
							}
							break;

						case DrawCommandType.LINE_TO:
							var c3 = data.readLineTo();
							this.fillCommands.lineTo(c3.x, c3.y);

							if (hasLineStyle)
							{
								this.strokeCommands.lineTo(c3.x, c3.y);
							}
							else
							{
								initStrokeX = c3.x;
								initStrokeY = c3.y;
							}
							break;

						case DrawCommandType.MOVE_TO:
							var c4 = data.readMoveTo();
							this.fillCommands.moveTo(c4.x, c4.y);

							if (hasLineStyle)
							{
								this.strokeCommands.moveTo(c4.x, c4.y);
							}
							else
							{
								initStrokeX = c4.x;
								initStrokeY = c4.y;
							}
							break;

						case DrawCommandType.END_FILL:
							data.readEndFill();
							this.endFill();
							this.endStroke();
							this.hasFill = false;
							hasLineStyle = false;
							this.bitmapFill = null;
							initStrokeX = 0;
							initStrokeY = 0;
							break;

						case DrawCommandType.LINE_GRADIENT_STYLE:
							var c5 = data.readLineGradientStyle();

							if (!hasLineStyle && (initStrokeX != 0 || initStrokeY != 0))
							{
								this.strokeCommands.moveTo(initStrokeX, initStrokeY);
								initStrokeX = 0;
								initStrokeY = 0;
							}

							hasLineStyle = true;
							this.strokeCommands.lineGradientStyle(c5.type, c5.colors, c5.alphas, c5.ratios, c5.matrix, c5.spreadMethod, c5.interpolationMethod,
								c5.focalPointRatio);
							break;

						case DrawCommandType.LINE_BITMAP_STYLE:
							var c6 = data.readLineBitmapStyle();

							if (!hasLineStyle && (initStrokeX != 0 || initStrokeY != 0))
							{
								this.strokeCommands.moveTo(initStrokeX, initStrokeY);
								initStrokeX = 0;
								initStrokeY = 0;
							}

							hasLineStyle = true;
							this.strokeCommands.lineBitmapStyle(c6.bitmap, c6.matrix, c6.repeat, c6.smooth);
							break;

						case DrawCommandType.LINE_STYLE:
							var c7 = data.readLineStyle();

							if (!hasLineStyle && c7.thickness != null)
							{
								if (initStrokeX != 0 || initStrokeY != 0)
								{
									this.strokeCommands.moveTo(initStrokeX, initStrokeY);
									initStrokeX = 0;
									initStrokeY = 0;
								}
							}

							hasLineStyle = c7.thickness != null;
							this.strokeCommands.lineStyle(c7.thickness, c7.color, c7.alpha, c7.pixelHinting, c7.scaleMode, c7.caps, c7.joints, c7.miterLimit);
							break;

						case DrawCommandType.BEGIN_BITMAP_FILL:
						case DrawCommandType.BEGIN_FILL:
						case DrawCommandType.BEGIN_GRADIENT_FILL:
						case DrawCommandType.BEGIN_SHADER_FILL:
							this.endFill();
							this.endStroke();

							if (type == DrawCommandType.BEGIN_BITMAP_FILL)
							{
								var c8 = data.readBeginBitmapFill();
								this.fillCommands.beginBitmapFill(c8.bitmap, c8.matrix, c8.repeat, c8.smooth);
								this.strokeCommands.beginBitmapFill(c8.bitmap, c8.matrix, c8.repeat, c8.smooth);
							}
							else if (type == DrawCommandType.BEGIN_GRADIENT_FILL)
							{
								var c9 = data.readBeginGradientFill();
								this.fillCommands.beginGradientFill(c9.type, c9.colors, c9.alphas, c9.ratios, c9.matrix, c9.spreadMethod, c9.interpolationMethod,
									c9.focalPointRatio);
								this.strokeCommands.beginGradientFill(c9.type, c9.colors, c9.alphas, c9.ratios, c9.matrix, c9.spreadMethod, c9.interpolationMethod,
									c9.focalPointRatio);
							}
							else if (type == DrawCommandType.BEGIN_SHADER_FILL)
							{
								var c10 = data.readBeginShaderFill();
								this.fillCommands.beginShaderFill(c10.shaderBuffer);
								this.strokeCommands.beginShaderFill(c10.shaderBuffer);
							}
							else
							{
								var c11 = data.readBeginFill();
								this.fillCommands.beginFill(c11.color, c11.alpha);
								this.strokeCommands.beginFill(c11.color, c11.alpha);
							}
							break;

						case DrawCommandType.DRAW_CIRCLE:
							var c12 = data.readDrawCircle();
							this.fillCommands.drawCircle(c12.x, c12.y, c12.radius);

							if (hasLineStyle)
							{
								this.strokeCommands.drawCircle(c12.x, c12.y, c12.radius);
							}
							break;

						case DrawCommandType.DRAW_ELLIPSE:
							var c13 = data.readDrawEllipse();
							this.fillCommands.drawEllipse(c13.x, c13.y, c13.width, c13.height);

							if (hasLineStyle)
							{
								this.strokeCommands.drawEllipse(c13.x, c13.y, c13.width, c13.height);
							}
							break;

						case DrawCommandType.DRAW_RECT:
							var c14 = data.readDrawRect();
							this.fillCommands.drawRect(c14.x, c14.y, c14.width, c14.height);

							if (hasLineStyle)
							{
								this.strokeCommands.drawRect(c14.x, c14.y, c14.width, c14.height);
							}
							break;

						case DrawCommandType.DRAW_ROUND_RECT:
							var c15 = data.readDrawRoundRect();
							this.fillCommands.drawRoundRect(c15.x, c15.y, c15.width, c15.height, c15.ellipseWidth, c15.ellipseHeight);

							if (hasLineStyle)
							{
								this.strokeCommands.drawRoundRect(c15.x, c15.y, c15.width, c15.height, c15.ellipseWidth, c15.ellipseHeight);
							}
							break;

						case DrawCommandType.DRAW_QUADS:
							var c16 = data.readDrawQuads();
							this.fillCommands.drawQuads(c16.rects, c16.indices, c16.transforms);
							break;

						case DrawCommandType.DRAW_TRIANGLES:
							var c17 = data.readDrawTriangles();
							this.fillCommands.drawTriangles(c17.vertices, c17.indices, c17.uvtData, c17.culling);
							break;

						case DrawCommandType.OVERRIDE_BLEND_MODE:
							var c18 = data.readOverrideBlendMode();
							renderer.__setBlendModeContext(this.context, c18.blendMode);
							break;

						case DrawCommandType.WINDING_EVEN_ODD:
							data.readWindingEvenOdd();
							this.fillCommands.windingEvenOdd();
							this.windingRule = CanvasWindingRule.EVENODD;
							break;

						case DrawCommandType.WINDING_NON_ZERO:
							data.readWindingNonZero();
							this.fillCommands.windingNonZero();
							this.windingRule = CanvasWindingRule.NONZERO;
							break;

						default:
							data.skip(type);
					}
				}

				if (this.fillCommands.length > 0)
				{
					this.endFill();
				}

				if (this.strokeCommands.length > 0)
				{
					this.endStroke();
				}

				data.destroy();
				(<internal.Graphics><any>graphics).__bitmap = BitmapData.fromCanvas((<internal.Graphics><any>graphics).__renderData.canvas);
			}

			(<internal.Graphics><any>graphics).__softwareDirty = false;
			(<internal.Graphics><any>graphics).__dirty = false;
		}
	}

	public static renderMask(graphics: Graphics, renderer: CanvasRenderer): void
	{
		// TODO: Move to normal render method, browsers appear to support more than
		// one path in clipping now

		if ((<internal.Graphics><any>graphics).__commands.length != 0)
		{
			this.context = renderer.context;

			this.context.beginPath();

			var positionX = 0.0;
			var positionY = 0.0;

			var offsetX = 0;
			var offsetY = 0;

			var data = new DrawCommandReader((<internal.Graphics><any>graphics).__commands);

			var x, y, width, height, kappa = .5522848, ox, oy, xe, ye, xm, ym;

			for (let type of (<internal.Graphics><any>graphics).__commands.types)
			{
				switch (type)
				{
					case DrawCommandType.CUBIC_CURVE_TO:
						var c = data.readCubicCurveTo();
						this.context.bezierCurveTo(c.controlX1
							- offsetX, c.controlY1
						- offsetY, c.controlX2
						- offsetX, c.controlY2
						- offsetY, c.anchorX
						- offsetX,
							c.anchorY
							- offsetY);
						positionX = c.anchorX;
						positionY = c.anchorY;
						break;

					case DrawCommandType.CURVE_TO:
						var c2 = data.readCurveTo();
						this.context.quadraticCurveTo(c2.controlX - offsetX, c2.controlY - offsetY, c2.anchorX - offsetX, c2.anchorY - offsetY);
						positionX = c2.anchorX;
						positionY = c2.anchorY;
						break;

					case DrawCommandType.DRAW_CIRCLE:
						var c3 = data.readDrawCircle();
						this.context.arc(c3.x - offsetX, c3.y - offsetY, c3.radius, 0, Math.PI * 2, true);
						break;

					case DrawCommandType.DRAW_ELLIPSE:
						var c4 = data.readDrawEllipse();
						x = c4.x;
						y = c4.y;
						width = c4.width;
						height = c4.height;
						x -= offsetX;
						y -= offsetY;

						ox = (width / 2) * kappa; // control point offset horizontal
						oy = (height / 2) * kappa; // control point offset vertical
						xe = x + width; // x-end
						ye = y + height; // y-end
						xm = x + width / 2; // x-middle
						ym = y + height / 2; // y-middle

						// closePath (false);
						// beginPath ();
						this.context.moveTo(x, ym);
						this.context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
						this.context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
						this.context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
						this.context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
						// closePath (false);
						break;

					case DrawCommandType.DRAW_RECT:
						var c5 = data.readDrawRect();
						// context.beginPath();
						this.context.rect(c5.x - offsetX, c5.y - offsetY, c5.width, c5.height);
						// context.closePath();
						break;

					case DrawCommandType.DRAW_ROUND_RECT:
						var c6 = data.readDrawRoundRect();
						this.drawRoundRect(c6.x - offsetX, c6.y - offsetY, c6.width, c6.height, c6.ellipseWidth, c6.ellipseHeight);
						break;

					case DrawCommandType.LINE_TO:
						var c7 = data.readLineTo();
						this.context.lineTo(c7.x - offsetX, c7.y - offsetY);
						positionX = c7.x;
						positionY = c7.y;
						break;

					case DrawCommandType.MOVE_TO:
						var c8 = data.readMoveTo();
						this.context.moveTo(c8.x - offsetX, c8.y - offsetY);
						positionX = c8.x;
						positionY = c8.y;
						break;

					default:
						data.skip(type);
				}
			}

			this.context.closePath();

			data.destroy();
		}
	}

	private static setSmoothing(smooth: boolean): void
	{
		if (!this.allowSmoothing)
		{
			smooth = false;
		}

		if (this.context.imageSmoothingEnabled != smooth)
		{
			this.context.imageSmoothingEnabled = smooth;
		}
	}
}

type NormalizedUVT =
	{
		max: number,
		uvt: Vector<number>
	}
