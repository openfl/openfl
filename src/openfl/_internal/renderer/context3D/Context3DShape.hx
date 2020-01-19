package openfl._internal.renderer.context3D;

#if openfl_gl
import openfl.display.DisplayObject;
#if gl_stats
import openfl._internal.renderer.context3D.stats.Context3DStats;
import openfl._internal.renderer.context3D.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.Shader)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DShape
{
	public static function render(shape:DisplayObject, renderer:Context3DRenderer):Void
	{
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;

		var graphics = shape.__graphics;

		if (graphics != null)
		{
			renderer.__setBlendMode(shape.__worldBlendMode);
			renderer.__pushMaskObject(shape);
			// renderer.filterManager.pushObject (shape);

			Context3DGraphics.render(graphics, renderer);

			if (graphics.__bitmap != null && graphics.__visible)
			{
				#if !disable_batcher
				var bitmapData = graphics.__bitmap;
				var transform = renderer.__getDisplayTransformTempMatrix(graphics.__worldTransform, AUTO);
				var alpha = renderer.__getAlpha(shape.__worldAlpha);
				Context3DBitmapData.pushQuadsToBatcher(bitmapData, renderer.batcher, transform, alpha, shape);
				#else
				var context = renderer.context3D;
				var scale9Grid = shape.__worldScale9Grid;

				var shader = renderer.__initDisplayShader(cast shape.__worldShader);
				renderer.setShader(shader);
				renderer.applyBitmapData(graphics.__bitmap, true);
				renderer.applyMatrix(renderer.__getMatrix(graphics.__worldTransform, AUTO));
				renderer.applyAlpha(renderer.__getAlpha(shape.__worldAlpha));
				renderer.applyColorTransform(shape.__worldColorTransform);
				renderer.updateShader();

				var vertexBuffer = graphics.__bitmap.getVertexBuffer(context, scale9Grid, shape);
				if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics.__bitmap.getIndexBuffer(context, scale9Grid);
				context.drawTriangles(indexBuffer);

				#if gl_stats
				Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				#end

				renderer.__clearShader();
				#end
			}

			// renderer.filterManager.popObject (shape);
			renderer.__popMaskObject(shape);
		}
	}

	public static function renderMask(shape:DisplayObject, renderer:Context3DRenderer):Void
	{
		var graphics = shape.__graphics;

		if (graphics != null)
		{
			// TODO: Support invisible shapes

			Context3DGraphics.renderMask(graphics, renderer);

			if (graphics.__bitmap != null)
			{
				#if !disable_batcher
				renderer.batcher.flush();
				#end

				var context = renderer.context3D;

				var shader = renderer.__maskShader;
				renderer.setShader(shader);
				renderer.applyBitmapData(graphics.__bitmap, true);
				renderer.applyMatrix(renderer.__getMatrix(graphics.__worldTransform, AUTO));
				renderer.updateShader();

				var vertexBuffer = graphics.__bitmap.getVertexBuffer(context);
				if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics.__bitmap.getIndexBuffer(context);
				context.drawTriangles(indexBuffer);

				#if gl_stats
				Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				#end

				renderer.__clearShader();
			}
		}
	}
}
#end
