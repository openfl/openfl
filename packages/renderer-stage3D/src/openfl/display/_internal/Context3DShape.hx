package openfl.display._internal;

#if openfl_gl
import openfl.display.DisplayObject;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
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
		if (!shape._.__renderable || shape._.__worldAlpha <= 0) return;

		var graphics = shape._.__graphics;

		if (graphics != null)
		{
			renderer._.__setBlendMode(shape._.__worldBlendMode);
			renderer._.__pushMaskObject(shape);
			// renderer.filterManager.pushObject (shape);

			Context3DGraphics.render(graphics, renderer);

			if (graphics._.__bitmap != null && graphics._.__visible)
			{
				#if !disable_batcher
				var bitmapData = graphics._.__bitmap;
				var transform = renderer._.__getDisplayTransformTempMatrix(graphics._.__worldTransform, AUTO);
				var alpha = renderer._.__getAlpha(shape._.__worldAlpha);
				Context3DBitmapData.pushQuadsToBatcher(bitmapData, renderer.batcher, transform, alpha, shape);
				#else
				var context = renderer.context3D;
				var scale9Grid = shape._.__worldScale9Grid;

				var shader = renderer._.__initDisplayShader(cast shape._.__worldShader);
				renderer.setShader(shader);
				renderer.applyBitmapData(graphics._.__bitmap, true);
				renderer.applyMatrix(renderer._.__getMatrix(graphics._.__worldTransform, AUTO));
				renderer.applyAlpha(renderer._.__getAlpha(shape._.__worldAlpha));
				renderer.applyColorTransform(shape._.__worldColorTransform);
				renderer.updateShader();

				var vertexBuffer = graphics._.__bitmap.getVertexBuffer(context, scale9Grid, shape);
				if (shader._.__position != null) context.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader._.__textureCoord != null) context.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics._.__bitmap.getIndexBuffer(context, scale9Grid);
				context.drawTriangles(indexBuffer);

				#if gl_stats
				Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				#end

				renderer._.__clearShader();
				#end
			}

			// renderer.filterManager.popObject (shape);
			renderer._.__popMaskObject(shape);
		}
	}

	public static function renderMask(shape:DisplayObject, renderer:Context3DRenderer):Void
	{
		var graphics = shape._.__graphics;

		if (graphics != null)
		{
			// TODO: Support invisible shapes

			Context3DGraphics.renderMask(graphics, renderer);

			if (graphics._.__bitmap != null)
			{
				#if !disable_batcher
				renderer.batcher.flush();
				#end

				var context = renderer.context3D;

				var shader = renderer._.__maskShader;
				renderer.setShader(shader);
				renderer.applyBitmapData(graphics._.__bitmap, true);
				renderer.applyMatrix(renderer._.__getMatrix(graphics._.__worldTransform, AUTO));
				renderer.updateShader();

				var vertexBuffer = graphics._.__bitmap.getVertexBuffer(context);
				if (shader._.__position != null) context.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader._.__textureCoord != null) context.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics._.__bitmap.getIndexBuffer(context);
				context.drawTriangles(indexBuffer);

				#if gl_stats
				Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				#end

				renderer._.__clearShader();
			}
		}
	}
}
#end
