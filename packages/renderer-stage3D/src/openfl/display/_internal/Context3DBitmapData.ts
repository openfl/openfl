import * as internal from "../../../_internal/utils/InternalAccess";
import Context3D from "../../../display3D/Context3D";
import IndexBuffer3D from "../../../display3D/IndexBuffer3D";
import VertexBuffer3D from "../../../display3D/VertexBuffer3D";
import BitmapData from "../../../display/BitmapData";
import DisplayObject from "../../../display/DisplayObject";
import Matrix from "../../../geom/Matrix";
import Rectangle from "../../../geom/Rectangle";
import BatchRenderer from "./batcher/BatchRenderer";

export default class Context3DBitmapData
{
	public static readonly VERTEX_BUFFER_STRIDE: number = 14;

	public static getIndexBuffer(bitmapData: BitmapData, context: Context3D, scale9Grid: Rectangle = null): IndexBuffer3D
	{
		if ((<internal.BitmapData><any>bitmapData).__renderData.indexBuffer == null
			|| (<internal.BitmapData><any>bitmapData).__renderData.indexBufferContext != context
			|| (scale9Grid != null && (<internal.BitmapData><any>bitmapData).__renderData.indexBufferGrid == null)
			|| ((<internal.BitmapData><any>bitmapData).__renderData.indexBufferGrid != null && !(<internal.BitmapData><any>bitmapData).__renderData.indexBufferGrid.equals(scale9Grid)))
		{
			// TODO: Use shared buffer on context
			// TODO: Support for UVs other than scale-9 grid?

			(<internal.BitmapData><any>bitmapData).__renderData.indexBufferContext = context;
			(<internal.BitmapData><any>bitmapData).__renderData.indexBuffer = null;

			if (scale9Grid != null)
			{
				if ((<internal.BitmapData><any>bitmapData).__renderData.indexBufferGrid == null) (<internal.BitmapData><any>bitmapData).__renderData.indexBufferGrid = new Rectangle();
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferGrid.copyFrom(scale9Grid);

				var centerX = scale9Grid.width;
				var centerY = scale9Grid.height;
				if (centerX != 0 && centerY != 0)
				{
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData = new Uint16Array(54);

					//  0 ——— 1    4 ——— 5    8 ——— 9
					//  |  /  |    |  /  |    |  /  |
					//  2 ——— 3    6 ——— 7   10 ——— 11
					//
					// 12 ——— 13  16 ——— 18  20 ——— 21
					//  |  /  |    |  /  |    |  /  |
					// 14 ——— 15  17 ——— 19  22 ——— 23
					//
					// 24 ——— 25  28 ——— 29  32 ——— 33
					//  |  /  |    |  /  |    |  /  |
					// 26 ——— 27  30 ——— 31  34 ——— 35

					// top left
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[0] = 0;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[1] = 1;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[2] = 2;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[3] = 2;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[4] = 1;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[5] = 3;

					// top center
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[6] = 4;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[7] = 5;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[8] = 6;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[9] = 6;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[10] = 5;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[11] = 7;

					// top right
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[12] = 8;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[13] = 9;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[14] = 10;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[15] = 10;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[16] = 9;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[17] = 11;

					// middle left
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[18] = 12;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[19] = 13;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[20] = 14;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[21] = 14;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[22] = 13;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[23] = 15;

					// middle center
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[24] = 16;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[25] = 18;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[26] = 17;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[27] = 17;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[28] = 18;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[29] = 19;

					// middle right
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[30] = 20;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[31] = 21;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[32] = 22;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[33] = 22;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[34] = 21;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[35] = 23;

					// bottom left
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[36] = 24;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[37] = 25;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[38] = 26;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[39] = 26;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[40] = 25;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[41] = 27;

					// bottom center
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[42] = 28;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[43] = 29;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[44] = 30;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[45] = 30;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[46] = 29;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[47] = 31;

					// bottom right
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[48] = 32;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[49] = 33;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[50] = 34;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[51] = 34;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[52] = 33;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[53] = 35;

					(<internal.BitmapData><any>bitmapData).__renderData.indexBuffer = context.createIndexBuffer(54);
				}
				else if (centerX == 0 && centerY != 0)
				{
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData = new Uint16Array(18);

					// 3 ——— 2
					// |  /  |
					// 1 ——— 0
					// |  /  |
					// 5 ——— 4
					// |  /  |
					// 7 ——— 6

					// top
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[0] = 0;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[1] = 1;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[2] = 2;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[3] = 2;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[4] = 1;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[5] = 3;

					// middle
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[6] = 4;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[7] = 5;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[8] = 0;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[9] = 0;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[10] = 5;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[11] = 1;

					// bottom
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[12] = 6;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[13] = 7;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[14] = 4;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[15] = 4;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[16] = 7;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[17] = 5;

					(<internal.BitmapData><any>bitmapData).__renderData.indexBuffer = context.createIndexBuffer(18);
				}
				else if (centerX != 0 && centerY == 0)
				{
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData = new Uint16Array(18);

					// 3 ——— 2 ——— 5 ——— 7
					// |  /  |  /  |  /  |
					// 1 ——— 0 ——— 4 ——— 6

					// left
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[0] = 0;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[1] = 1;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[2] = 2;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[3] = 2;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[4] = 1;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[5] = 3;

					// center
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[6] = 4;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[7] = 0;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[8] = 5;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[9] = 5;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[10] = 0;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[11] = 2;

					// right
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[12] = 6;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[13] = 4;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[14] = 7;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[15] = 7;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[16] = 4;
					(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[17] = 5;

					(<internal.BitmapData><any>bitmapData).__renderData.indexBuffer = context.createIndexBuffer(18);
				}
			}
			else
			{
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferGrid = null;
			}

			if ((<internal.BitmapData><any>bitmapData).__renderData.indexBuffer == null)
			{
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData = new Uint16Array(6);
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[0] = 0;
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[1] = 1;
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[2] = 2;
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[3] = 2;
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[4] = 1;
				(<internal.BitmapData><any>bitmapData).__renderData.indexBufferData[5] = 3;
				(<internal.BitmapData><any>bitmapData).__renderData.indexBuffer = context.createIndexBuffer(6);
			}

			(<internal.BitmapData><any>bitmapData).__renderData.indexBuffer.uploadFromTypedArray((<internal.BitmapData><any>bitmapData).__renderData.indexBufferData);
		}

		return (<internal.BitmapData><any>bitmapData).__renderData.indexBuffer;
	}

	public static pushQuadsToBatcher(bitmapData: BitmapData, batcher: BatchRenderer, transform: Matrix, alpha: number, object: DisplayObject): void
	{
		var blendMode = (<internal.DisplayObject><any>object).__worldBlendMode;
		var colorTransform = (<internal.DisplayObject><any>object).__worldColorTransform;
		var scale9Grid = (<internal.DisplayObject><any>object).__worldScale9Grid;

		// 	#if openfl_power_of_two
		// var uvWidth = width / __textureWidth;
		// 	var uvHeight = height / __textureHeight;
		// 	#else
		var uvWidth = 1;
		var uvHeight = 1;
		// #end

		if (object != null && scale9Grid != null)
		{
			var vertexBufferWidth = object.width;
			var vertexBufferHeight = object.height;
			var vertexBufferScaleX = object.scaleX;
			var vertexBufferScaleY = object.scaleY;

			var centerX = scale9Grid.width;
			var centerY = scale9Grid.height;
			if (centerX != 0 && centerY != 0)
			{
				var left = scale9Grid.x;
				var top = scale9Grid.y;
				var right = vertexBufferWidth - centerX - left;
				var bottom = vertexBufferHeight - centerY - top;

				var uvLeft = left / vertexBufferWidth;
				var uvTop = top / vertexBufferHeight;
				var uvCenterX = scale9Grid.width / vertexBufferWidth;
				var uvCenterY = scale9Grid.height / vertexBufferHeight;
				var uvRight = right / bitmapData.width;
				var uvBottom = bottom / bitmapData.height;
				var uvOffsetU = 0.5 / vertexBufferWidth;
				var uvOffsetV = 0.5 / vertexBufferHeight;

				var renderedLeft = left / vertexBufferScaleX;
				var renderedTop = top / vertexBufferScaleY;
				var renderedRight = right / vertexBufferScaleX;
				var renderedBottom = bottom / vertexBufferScaleY;
				var renderedCenterX = (bitmapData.width - renderedLeft - renderedRight);
				var renderedCenterY = (bitmapData.height - renderedTop - renderedBottom);

				//  a         b          c         d
				// p  0 ——— 1    4 ——— 5    8 ——— 9
				//    |  /  |    |  /  |    |  /  |
				//    2 ——— 3    6 ——— 7   10 ——— 11
				// q
				//   12 ——— 13  16 ——— 18  20 ——— 21
				//    |  /  |    |  /  |    |  /  |
				//   14 ——— 15  17 ——— 19  22 ——— 23
				// r
				//   24 ——— 25  28 ——— 29  32 ——— 33
				//    |  /  |    |  /  |    |  /  |
				//   26 ——— 27  30 ——— 31  34 ——— 35
				// s

				var a = 0;
				var b = renderedLeft;
				var c = renderedLeft + renderedCenterX;
				var bc = renderedCenterX;
				var d = bitmapData.width;
				var cd = d - c;

				var p = 0;
				var q = renderedTop;
				var r = renderedTop + renderedCenterY;
				var qr = renderedCenterY;
				var s = bitmapData.height;
				var rs = s - r;

				batcher.setVs(0, (uvHeight * uvTop) - uvOffsetV);
				batcher.setVertices(transform, a, p, b, q);
				batcher.setUs(0, (uvWidth * uvLeft) - uvOffsetU);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, b, p, bc, q);
				batcher.setUs((uvWidth * uvLeft) + uvOffsetU, (uvWidth * (uvLeft + uvCenterX)) - uvOffsetU);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, c, p, cd, q);
				batcher.setUs((uvWidth * (uvLeft + uvCenterX)) + uvOffsetU, uvWidth);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);

				batcher.setVs((uvHeight * uvTop) + uvOffsetV, (uvHeight * (uvTop + uvCenterY)) - uvOffsetV);
				batcher.setVertices(transform, a, q, b, qr);
				batcher.setUs(0, (uvWidth * uvLeft) - uvOffsetU);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, b, q, bc, qr);
				batcher.setUs((uvWidth * uvLeft) + uvOffsetU, (uvWidth * (uvLeft + uvCenterX)) - uvOffsetU);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, c, q, cd, qr);
				batcher.setUs((uvWidth * (uvLeft + uvCenterX)) + uvOffsetU, uvWidth);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);

				batcher.setVs((uvHeight * (uvTop + uvCenterY)) + uvOffsetV, uvHeight);
				batcher.setVertices(transform, a, r, b, rs);
				batcher.setUs(0, (uvWidth * uvLeft) - uvOffsetU);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, b, r, bc, rs);
				batcher.setUs((uvWidth * uvLeft) + uvOffsetU, (uvWidth * (uvLeft + uvCenterX)) - uvOffsetU);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, c, r, cd, rs);
				batcher.setUs((uvWidth * (uvLeft + uvCenterX)) + uvOffsetU, uvWidth);
				batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);
			}
			else if (centerX == 0 && centerY != 0)
			{
				// TODO
				// 3 ——— 2
				// |  /  |
				// 1 ——— 0
				// |  /  |
				// 5 ——— 4
				// |  /  |
				// 7 ——— 6
			}
			else if (centerY == 0 && centerX != 0)
			{
				// TODO
				// 3 ——— 2 ——— 5 ——— 7
				// |  /  |  /  |  /  |
				// 1 ——— 0 ——— 4 ——— 6
			}
		}
		else
		{
			batcher.setVertices(transform, 0, 0, bitmapData.width, bitmapData.height);
			batcher.setUs(0, uvWidth);
			batcher.setVs(0, uvHeight);
			batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);
		}
	}

	public static getVertexBuffer(bitmapData: BitmapData, context: Context3D, scale9Grid: Rectangle = null,
		targetObject: DisplayObject = null): VertexBuffer3D
	{
		// TODO: Support for UVs other than scale-9 grid?
		// TODO: Better way of handling object transform?

		if ((<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer == null
			|| (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferContext != context
			|| (scale9Grid != null && (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferGrid == null)
			|| ((<internal.BitmapData><any>bitmapData).__renderData.vertexBufferGrid != null && !(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferGrid.equals(scale9Grid))
			|| (targetObject != null
				&& ((<internal.BitmapData><any>bitmapData).__renderData.vertexBufferWidth != targetObject.width
					|| (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferHeight != targetObject.height
					|| (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferScaleX != targetObject.scaleX
					|| (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferScaleY != targetObject.scaleY)))
		{
			(<internal.BitmapData><any>bitmapData).__renderData.uvRect = new Rectangle(0, 0, (<internal.BitmapData><any>bitmapData).__renderData.textureWidth, (<internal.BitmapData><any>bitmapData).__renderData.textureHeight);

			var uvWidth = bitmapData.width / (<internal.BitmapData><any>bitmapData).__renderData.textureWidth;
			var uvHeight = bitmapData.height / (<internal.BitmapData><any>bitmapData).__renderData.textureHeight;

			// __renderData.vertexBufferData = new Float32Array ([
			//
			// width, height, 0, uvWidth, uvHeight, alpha, (color transform, color offset...)
			// 0, height, 0, 0, uvHeight, alpha, (color transform, color offset...)
			// width, 0, 0, uvWidth, 0, alpha, (color transform, color offset...)
			// 0, 0, 0, 0, 0, alpha, (color transform, color offset...)
			//
			//
			// ]);

			// [ colorTransform.redMultiplier, 0, 0, 0, 0, colorTransform.greenMultiplier, 0, 0, 0, 0, colorTransform.blueMultiplier, 0, 0, 0, 0, colorTransform.alphaMultiplier ];
			// [ colorTransform.redOffset / 255, colorTransform.greenOffset / 255, colorTransform.blueOffset / 255, colorTransform.alphaOffset / 255 ]

			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferContext = context;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer = null;

			if (targetObject != null)
			{
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferWidth = targetObject.width;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferHeight = targetObject.height;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferScaleX = targetObject.scaleX;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferScaleY = targetObject.scaleY;
			}

			if (scale9Grid != null && targetObject != null)
			{
				if ((<internal.BitmapData><any>bitmapData).__renderData.vertexBufferGrid == null) (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferGrid = new Rectangle();
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferGrid.copyFrom(scale9Grid);

				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferWidth = targetObject.width;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferHeight = targetObject.height;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferScaleX = targetObject.scaleX;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferScaleY = targetObject.scaleY;

				var centerX = scale9Grid.width;
				var centerY = scale9Grid.height;
				if (centerX != 0 && centerY != 0)
				{
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData = new Float32Array(this.VERTEX_BUFFER_STRIDE * 36);

					var left = scale9Grid.x;
					var top = scale9Grid.y;
					var right = (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferWidth - centerX - left;
					var bottom = (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferHeight - centerY - top;

					var uvLeft = left / (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferWidth;
					var uvTop = top / (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferHeight;
					var uvCenterX = scale9Grid.width / (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferWidth;
					var uvCenterY = scale9Grid.height / (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferHeight;
					var uvRight = right / bitmapData.width;
					var uvBottom = bottom / bitmapData.height;
					var uvOffsetU = 0.5 / (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferWidth;
					var uvOffsetV = 0.5 / (<internal.BitmapData><any>bitmapData).__renderData.vertexBufferHeight;

					var renderedLeft = left / targetObject.scaleX;
					var renderedTop = top / targetObject.scaleY;
					var renderedRight = right / targetObject.scaleX;
					var renderedBottom = bottom / targetObject.scaleY;
					var renderedCenterX = (bitmapData.width - renderedLeft - renderedRight);
					var renderedCenterY = (bitmapData.height - renderedTop - renderedBottom);

					//  0 ——— 1    4 ——— 5    8 ——— 9
					//  |  /  |    |  /  |    |  /  |
					//  2 ——— 3    6 ——— 7   10 ——— 11
					//
					// 12 ——— 13  16 ——— 18  20 ——— 21
					//  |  /  |    |  /  |    |  /  |
					// 14 ——— 15  17 ——— 19  22 ——— 23
					//
					// 24 ——— 25  28 ——— 29  32 ——— 33
					//  |  /  |    |  /  |    |  /  |
					// 26 ——— 27  30 ——— 31  34 ——— 35

					this.setVertex(bitmapData, 0, 0, 0, 0, 0);
					this.setVertices(bitmapData, [3, 6, 13, 16], renderedLeft, renderedTop, uvWidth * uvLeft, uvHeight * uvTop);
					this.setVertices(bitmapData, [2, 12], 0, renderedTop, 0, uvHeight * uvTop);
					this.setVertices(bitmapData, [1, 4], renderedLeft, 0, uvWidth * uvLeft, 0);
					this.setVertices(bitmapData, [7, 10, 18, 20], renderedLeft + renderedCenterX, renderedTop, uvWidth * (uvLeft + uvCenterX), uvHeight * uvTop);
					this.setVertices(bitmapData, [5, 8], renderedLeft + renderedCenterX, 0, uvWidth * (uvLeft + uvCenterX), 0);
					this.setVertices(bitmapData, [11, 21], bitmapData.width, renderedTop, uvWidth, uvHeight * uvTop);
					this.setVertex(bitmapData, 9, bitmapData.width, 0, uvWidth, 0);
					this.setVertices(bitmapData, [15, 17, 25, 28], renderedLeft, renderedTop + renderedCenterY, uvWidth * uvLeft, uvHeight * (uvTop + uvCenterY));
					this.setVertices(bitmapData, [14, 24], 0, renderedTop + renderedCenterY, 0, uvHeight * (uvTop + uvCenterY));
					this.setVertices(bitmapData, [19, 22, 29, 32], renderedLeft + renderedCenterX, renderedTop + renderedCenterY, uvWidth * (uvLeft + uvCenterX),
						uvHeight * (uvTop + uvCenterY));
					this.setVertices(bitmapData, [23, 33], bitmapData.width, renderedTop + renderedCenterY, uvWidth, uvHeight * (uvTop + uvCenterY));
					this.setVertices(bitmapData, [27, 30], renderedLeft, bitmapData.height, uvWidth * uvLeft, uvHeight);
					this.setVertex(bitmapData, 26, 0, bitmapData.height, 0, uvHeight);
					this.setVertices(bitmapData, [31, 34], renderedLeft + renderedCenterX, bitmapData.height, uvWidth * (uvLeft + uvCenterX), uvHeight);
					this.setVertex(bitmapData, 35, bitmapData.width, bitmapData.height, uvWidth, uvHeight);

					this.setUOffsets(bitmapData, [1, 3, 5, 7, 13, 15, 18, 19, 25, 27, 29, 31], -uvOffsetU);
					this.setUOffsets(bitmapData, [4, 6, 8, 10, 16, 17, 20, 22, 28, 30, 32, 34], uvOffsetU);
					this.setVOffsets(bitmapData, [2, 3, 6, 7, 10, 11, 14, 15, 17, 19, 22, 23], -uvOffsetV);
					this.setVOffsets(bitmapData, [12, 13, 16, 18, 20, 21, 24, 25, 28, 29, 32, 33], uvOffsetV);

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer = context.createVertexBuffer(16, this.VERTEX_BUFFER_STRIDE);
				}
				else if (centerX == 0 && centerY != 0)
				{
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData = new Float32Array(this.VERTEX_BUFFER_STRIDE * 8);

					var top = scale9Grid.y;
					var bottom = bitmapData.height - centerY - top;

					var uvTop = top / bitmapData.height;
					var uvCenterY = centerY / bitmapData.height;
					var uvBottom = bottom / bitmapData.height;

					var renderedTop = top / targetObject.scaleY;
					var renderedBottom = bottom / targetObject.scaleY;
					var renderedCenterY = (targetObject.height / targetObject.scaleY) - renderedTop - renderedBottom;

					var renderedWidth = targetObject.width / targetObject.scaleX;

					// 3 ——— 2
					// |  /  |
					// 1 ——— 0
					// |  /  |
					// 5 ——— 4
					// |  /  |
					// 7 ——— 6

					// top <0-1-2> <2-1-3>
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[0] = renderedWidth;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[1] = renderedTop;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[3] = uvWidth;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[4] = uvHeight * uvTop;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 1] = renderedTop;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 4] = uvHeight * uvTop;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2] = renderedWidth;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth;

					// middle <4-5-0> <0-5-1>
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 4] = renderedWidth;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 4 + 1] = renderedTop + renderedCenterY;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 4 + 3] = uvWidth;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 4 + 4] = uvHeight * (uvTop + uvCenterY);

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 5 + 1] = renderedTop + renderedCenterY;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 5 + 4] = uvHeight * (uvTop + uvCenterY);

					// bottom <6-7-4> <4-7-5>
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 6] = renderedWidth;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 6 + 1] = bitmapData.height;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 6 + 3] = uvWidth;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 6 + 4] = uvHeight;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 7 + 1] = bitmapData.height;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 7 + 4] = uvHeight;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer = context.createVertexBuffer(8, this.VERTEX_BUFFER_STRIDE);
				}
				else if (centerY == 0 && centerX != 0)
				{
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData = new Float32Array(this.VERTEX_BUFFER_STRIDE * 8);

					var left = scale9Grid.x;
					var right = bitmapData.width - centerX - left;

					var uvLeft = left / bitmapData.width;
					var uvCenterX = centerX / bitmapData.width;
					var uvRight = right / bitmapData.width;

					var renderedLeft = left / targetObject.scaleX;
					var renderedRight = right / targetObject.scaleX;
					var renderedCenterX = (targetObject.width / targetObject.scaleX) - renderedLeft - renderedRight;

					var renderedHeight = targetObject.height / targetObject.scaleY;

					// 3 ——— 2 ——— 5 ——— 7
					// |  /  |  /  |  /  |
					// 1 ——— 0 ——— 4 ——— 6

					// top left <0-1-2> <2-1-3>
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[0] = renderedLeft;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[1] = renderedHeight;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[3] = uvWidth * uvLeft;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[4] = uvHeight;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 1] = renderedHeight;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 4] = uvHeight;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2] = renderedLeft;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth * uvLeft;

					// top center <4-0-5> <5-0-2>
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 4] = renderedLeft + renderedCenterX;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 4 + 1] = renderedHeight;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 4 + 3] = uvWidth * (uvLeft + uvCenterX);
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 4 + 4] = uvHeight;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 5] = renderedLeft + renderedCenterX;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 5 + 3] = uvWidth * (uvLeft + uvCenterX);

					// top right <6-4-7> <7-4-5>
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 6] = bitmapData.width;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 6 + 1] = renderedHeight;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 6 + 3] = uvWidth;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 6 + 4] = uvHeight;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 7] = bitmapData.width;
					(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 7 + 3] = uvWidth;

					(<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer = context.createVertexBuffer(8, this.VERTEX_BUFFER_STRIDE);
				}
			}
			else
			{
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferGrid = null;
			}

			if ((<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer == null)
			{
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData = new Float32Array(this.VERTEX_BUFFER_STRIDE * 4);

				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[0] = bitmapData.width;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[1] = bitmapData.height;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[3] = uvWidth;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[4] = uvHeight;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 1] = bitmapData.height;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 4] = uvHeight;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2] = bitmapData.width;
				(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth;

				(<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer = context.createVertexBuffer(3, this.VERTEX_BUFFER_STRIDE);
			}

			// for (i in 0...4) {

			// 	__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 5] = alpha;

			// 	if (colorTransform != null) {

			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 6] = colorTransform.redMultiplier;
			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 7] = colorTransform.greenMultiplier;
			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 8] = colorTransform.blueMultiplier;
			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 9] = colorTransform.alphaMultiplier;
			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 10] = colorTransform.redOffset / 255;
			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 11] = colorTransform.greenOffset / 255;
			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 12] = colorTransform.blueOffset / 255;
			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 13] = colorTransform.alphaOffset / 255;

			// 	}

			// }

			// __renderData.vertexBufferAlpha = alpha;
			// __renderData.vertexBufferColorTransform = colorTransform != null ? colorTransform.__clone () : null;

			(<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer.uploadFromTypedArray((<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData);
		}
		else
		{
			// dirty = false;

			// if (__renderData.vertexBufferAlpha != alpha) {

			// 	dirty = true;

			// 	for (i in 0...4) {

			// 		__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 5] = alpha;

			// 	}

			// 	__renderData.vertexBufferAlpha = alpha;

			// }

			// if ((__renderData.vertexBufferColorTransform == null && colorTransform != null) || (__renderData.vertexBufferColorTransform != null && !__renderData.vertexBufferColorTransform.__equals (colorTransform))) {

			// 	dirty = true;

			// 	if (colorTransform != null) {

			// 		if (__renderData.vertexBufferColorTransform == null) {
			// 			__renderData.vertexBufferColorTransform = colorTransform.__clone ();
			// 		} else {
			// 			__renderData.vertexBufferColorTransform.__copyFrom (colorTransform);
			// 		}

			// 		for (i in 0...4) {

			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 6] = colorTransform.redMultiplier;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 11] = colorTransform.greenMultiplier;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 16] = colorTransform.blueMultiplier;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 21] = colorTransform.alphaMultiplier;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 22] = colorTransform.redOffset / 255;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 23] = colorTransform.greenOffset / 255;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 24] = colorTransform.blueOffset / 255;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 25] = colorTransform.alphaOffset / 255;

			// 		}

			// 	} else {

			// 		for (i in 0...4) {

			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 6] = 1;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 11] = 1;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 16] = 1;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 21] = 1;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 22] = 0;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 23] = 0;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 24] = 0;
			// 			__renderData.vertexBufferData[VERTEX_BUFFER_STRIDE * i + 25] = 0;

			// 		}

			// 	}

			// }

			// context.__bindGLArrayBuffer (__renderData.vertexBuffer);

			// if (dirty) {

			// 	gl.bufferData (gl.ARRAY_BUFFER, __renderData.vertexBufferData.byteLength, __renderData.vertexBufferData, gl.STATIC_DRAW);

			// }
		}

		return (<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer;
	}

	public static setUVRect(bitmapData: BitmapData, context: Context3D, x: number, y: number, width: number, height: number): void
	{
		var buffer = this.getVertexBuffer(bitmapData, context);

		if (buffer != null
			&& (width != (<internal.BitmapData><any>bitmapData).__renderData.uvRect.width
				|| height != (<internal.BitmapData><any>bitmapData).__renderData.uvRect.height
				|| x != (<internal.BitmapData><any>bitmapData).__renderData.uvRect.x
				|| y != (<internal.BitmapData><any>bitmapData).__renderData.uvRect.y))
		{
			if ((<internal.BitmapData><any>bitmapData).__renderData.uvRect == null) (<internal.BitmapData><any>bitmapData).__renderData.uvRect = new Rectangle();
			(<internal.BitmapData><any>bitmapData).__renderData.uvRect.setTo(x, y, width, height);

			var uvX = (<internal.BitmapData><any>bitmapData).__renderData.textureWidth > 0 ? x / (<internal.BitmapData><any>bitmapData).__renderData.textureWidth : 0;
			var uvY = (<internal.BitmapData><any>bitmapData).__renderData.textureHeight > 0 ? y / (<internal.BitmapData><any>bitmapData).__renderData.textureHeight : 0;
			var uvWidth = (<internal.BitmapData><any>bitmapData).__renderData.textureWidth > 0 ? width / (<internal.BitmapData><any>bitmapData).__renderData.textureWidth : 0;
			var uvHeight = (<internal.BitmapData><any>bitmapData).__renderData.textureHeight > 0 ? height / (<internal.BitmapData><any>bitmapData).__renderData.textureHeight : 0;

			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[0] = width;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[1] = height;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[3] = uvX + uvWidth;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[4] = uvY + uvHeight;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 1] = height;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 3] = uvX;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 4] = uvY + uvHeight;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2] = width;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2 + 3] = uvX + uvWidth;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2 + 4] = uvY;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 3 + 3] = uvX;
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 3 + 4] = uvY;

			(<internal.BitmapData><any>bitmapData).__renderData.vertexBuffer.uploadFromTypedArray((<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData);
		}
	}

	public static setVertex(bitmapData: BitmapData, index: number, x: number, y: number, u: number, v: number): void
	{
		var i = index * this.VERTEX_BUFFER_STRIDE;
		(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[i + 0] = x;
		(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[i + 1] = y;
		(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[i + 3] = u;
		(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[i + 4] = v;
	}

	public static setVertices(bitmapData: BitmapData, indices: Array<number>, x: number, y: number, u: number, v: number): void
	{
		for (let index of indices)
		{
			this.setVertex(bitmapData, index, x, y, u, v);
		}
	}

	public static setUOffsets(bitmapData: BitmapData, indices: Array<number>, offset: number): void
	{
		for (let index of indices)
		{
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[index * this.VERTEX_BUFFER_STRIDE + 3] += offset;
		}
	}

	public static setVOffsets(bitmapData: BitmapData, indices: Array<number>, offset: number): void
	{
		for (let index of indices)
		{
			(<internal.BitmapData><any>bitmapData).__renderData.vertexBufferData[index * this.VERTEX_BUFFER_STRIDE + 4] += offset;
		}
	}
}
