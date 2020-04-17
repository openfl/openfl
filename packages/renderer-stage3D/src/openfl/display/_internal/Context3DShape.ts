import * as internal from "../../../_internal/utils/InternalAccess";
import DisplayObject from "../../../display/DisplayObject";
import DisplayObjectShader from "../../../display/DisplayObjectShader";
import PixelSnapping from "../../../display/PixelSnapping";
import Context3DVertexBufferFormat from "../../../display3D/Context3DVertexBufferFormat";
import Context3DGraphics from "./Context3DGraphics";
import Context3DRenderer from "./Context3DRenderer";

export default class Context3DShape
{
	public static render(shape: DisplayObject, renderer: Context3DRenderer): void
	{
		if (!(<internal.DisplayObject><any>shape).__renderable || (<internal.DisplayObject><any>shape).__worldAlpha <= 0) return;

		var graphics = (<internal.DisplayObject><any>shape).__graphics;

		if (graphics != null)
		{
			renderer.__setBlendMode((<internal.DisplayObject><any>shape).__worldBlendMode);
			renderer.__pushMaskObject(shape);
			// renderer.filterManager.pushObject (shape);

			Context3DGraphics.render(graphics, renderer);

			if ((<internal.Graphics><any>graphics).__bitmap != null && (<internal.Graphics><any>graphics).__visible)
			{
				// #if!disable_batcher
				// var bitmapData = (<internal.Graphics><any>graphics).__bitmap;
				// var transform = renderer.__getDisplayTransformTempMatrix((<internal.Graphics><any>graphics).__worldTransform, AUTO);
				// var alpha = renderer.__getAlpha((<internal.DisplayObject><any>shape).__worldAlpha);
				// Context3DBitmapData.pushQuadsToBatcher(bitmapData, renderer.batcher, transform, alpha, shape);
				// #else
				var context = renderer.context3D;
				var scale9Grid = (<internal.DisplayObject><any>shape).__worldScale9Grid;

				var shader = renderer.__initDisplayShader((<internal.DisplayObject><any>shape).__worldShader as DisplayObjectShader);
				renderer.setShader(shader);
				renderer.applyBitmapData((<internal.Graphics><any>graphics).__bitmap, true);
				renderer.applyMatrix(renderer.__getMatrix((<internal.Graphics><any>graphics).__worldTransform, PixelSnapping.AUTO));
				renderer.applyAlpha(renderer.__getAlpha((<internal.DisplayObject><any>shape).__worldAlpha));
				renderer.applyColorTransform((<internal.DisplayObject><any>shape).__worldColorTransform);
				renderer.updateShader();

				var vertexBuffer = (<internal.Graphics><any>graphics).__bitmap.getVertexBuffer(context, scale9Grid, shape);
				if ((<internal.Shader><any>shader).__position != null) context.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				if ((<internal.Shader><any>shader).__textureCoord != null) context.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
				var indexBuffer = (<internal.Graphics><any>graphics).__bitmap.getIndexBuffer(context, scale9Grid);
				context.drawTriangles(indexBuffer);

				// #if gl_stats
				// Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				// #end

				renderer.__clearShader();
				// #end
			}

			// renderer.filterManager.popObject (shape);
			renderer.__popMaskObject(shape);
		}
	}

	public static renderMask(shape: DisplayObject, renderer: Context3DRenderer): void
	{
		var graphics = (<internal.DisplayObject><any>shape).__graphics;

		if (graphics != null)
		{
			// TODO: Support invisible shapes

			Context3DGraphics.renderMask(graphics, renderer);

			if ((<internal.Graphics><any>graphics).__bitmap != null)
			{
				// #if!disable_batcher
				// renderer.batcher.flush();
				// #end

				var context = renderer.context3D;

				var shader = renderer.__maskShader;
				renderer.setShader(shader);
				renderer.applyBitmapData((<internal.Graphics><any>graphics).__bitmap, true);
				renderer.applyMatrix(renderer.__getMatrix((<internal.Graphics><any>graphics).__worldTransform, PixelSnapping.AUTO));
				renderer.updateShader();

				var vertexBuffer = (<internal.Graphics><any>graphics).__bitmap.getVertexBuffer(context);
				if ((<internal.Shader><any>shader).__position != null) context.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				if ((<internal.Shader><any>shader).__textureCoord != null) context.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
				var indexBuffer = (<internal.Graphics><any>graphics).__bitmap.getIndexBuffer(context);
				context.drawTriangles(indexBuffer);

				// #if gl_stats
				// Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				// #end

				renderer.__clearShader();
			}
		}
	}
}
