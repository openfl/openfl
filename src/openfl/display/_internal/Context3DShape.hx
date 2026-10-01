package openfl.display._internal;

#if !flash
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
import openfl.geom.Matrix;

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
	public static function render(shape:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;

		var graphics = shape.__graphics;

		if (graphics != null)
		{
			renderer.__setBlendMode(shape.__worldBlendMode);
			renderer.__pushMaskObject(shape);
			// renderer.filterManager.pushObject (shape);

			Context3DGraphics.render(graphics, renderer, renderer.__isCompositedWithAlpha(shape));

			if (graphics.__bitmap != null && graphics.__visible)
			{
				var context = renderer.__context3D;
				var shader = renderer.__initDisplayShader(shape.__worldShader);

				renderer.setShader(shader);
				renderer.applyBitmapData(graphics.__bitmap, true);
				// Flash's ALPHA only touches the pixels a shape covers and keeps coverage and fill alpha
				// apart at its edges: the coverage render gives that, or else at least the empty
				// texels of the texture must not cut the backdrop. A text field draws straight into its
				// bitmap, in colors that are always opaque, so the bitmap's own alpha is its coverage
				var alphaMask = renderer.__blendMode == BlendMode.ALPHA;
				var coverage = graphics.__managed ? graphics.__bitmap : graphics.__coverage;
				renderer.applyCoverage(alphaMask ? coverage : null);
				renderer.applyDiscardTransparent(alphaMask && coverage == null);

				var matrix = Matrix.__pool.get();
				matrix.scale(1 / graphics.__bitmapScaleX, 1 / graphics.__bitmapScaleY);

				matrix.concat(graphics.__worldTransform);

				renderer.applyMatrix(renderer.__getMatrix(matrix, AUTO));

				Matrix.__pool.release(matrix);

				renderer.applyAlpha(shape.__worldAlpha);
				renderer.applyColorTransform(shape.__worldColorTransform);
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

			// renderer.filterManager.popObject (shape);
			renderer.__popMaskObject(shape);
		}
	}

	public static function renderMask(shape:DisplayObject, renderer:OpenGLRenderer):Void
	{
		var graphics = shape.__graphics;

		if (graphics != null)
		{
			// TODO: Support invisible shapes

			Context3DGraphics.renderMask(graphics, renderer);

			if (graphics.__bitmap != null)
			{
				var context = renderer.__context3D;

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
