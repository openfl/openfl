package openfl.display._internal;

#if openfl_gl
import openfl.display.DisplayObject;
import openfl.display._Context3DRenderer;
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
	public static function render(shape:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (!(shape._ : _DisplayObject).__renderable || (shape._ : _DisplayObject).__worldAlpha <= 0) return;

		var graphics = (shape._ : _DisplayObject).__graphics;

		if (graphics != null)
		{
			(renderer._ : _Context3DRenderer).__setBlendMode((shape._ : _DisplayObject).__worldBlendMode);
			(renderer._ : _Context3DRenderer).__pushMaskObject(shape);
			// renderer.filterManager.pushObject (shape);

			Context3DGraphics.render(graphics, renderer);

			if (graphics._.__bitmap != null && graphics._.__visible)
			{
				#if !disable_batcher
				var bitmapData = graphics._.__bitmap;
				var transform = (renderer._ : _Context3DRenderer).__getDisplayTransformTempMatrix(graphics._.__worldTransform, AUTO);
				var alpha = (renderer._ : _Context3DRenderer).__getAlpha((shape._ : _DisplayObject).__worldAlpha);
				Context3DBitmapData.pushQuadsToBatcher(bitmapData, (renderer._ : _Context3DRenderer).batcher, transform, alpha, shape);
				#else
				var context = (renderer._ : _Context3DRenderer).context3D;
				var scale9Grid = (shape._ : _DisplayObject).__worldScale9Grid;

				var shader = (renderer._ : _Context3DRenderer).__initDisplayShader(cast(shape._ : _DisplayObject).__worldShader);
				renderer.setShader(shader);
				renderer.applyBitmapData(graphics._.__bitmap, true);
				renderer.applyMatrix((renderer._ : _Context3DRenderer).__getMatrix(graphics._.__worldTransform, AUTO));
				renderer.applyAlpha((renderer._ : _Context3DRenderer).__getAlpha((shape._ : _DisplayObject).__worldAlpha));
				renderer.applyColorTransform((shape._ : _DisplayObject).__worldColorTransform);
				renderer.updateShader();

				var vertexBuffer = graphics._.__bitmap.getVertexBuffer(context, scale9Grid, shape);
				if (shader._.__position != null) context.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader._.__textureCoord != null) context.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics._.__bitmap.getIndexBuffer(context, scale9Grid);
				context.drawTriangles(indexBuffer);

				#if gl_stats
				Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				#end

				(renderer._ : _Context3DRenderer).__clearShader();
				#end
			}

			// renderer.filterManager.popObject (shape);
			(renderer._ : _Context3DRenderer).__popMaskObject(shape);
		}
	}

	public static function renderMask(shape:DisplayObject, renderer:OpenGLRenderer):Void
	{
		var graphics = (shape._ : _DisplayObject).__graphics;

		if (graphics != null)
		{
			// TODO: Support invisible shapes

			Context3DGraphics.renderMask(graphics, renderer);

			if (graphics._.__bitmap != null)
			{
				#if !disable_batcher
				(renderer._ : _Context3DRenderer).batcher.flush();
				#end

				var context = (renderer._ : _Context3DRenderer).context3D;

				var shader = (renderer._ : _Context3DRenderer).__maskShader;
				renderer.setShader(shader);
				renderer.applyBitmapData(graphics._.__bitmap, true);
				renderer.applyMatrix((renderer._ : _Context3DRenderer).__getMatrix(graphics._.__worldTransform, AUTO));
				renderer.updateShader();

				var vertexBuffer = graphics._.__bitmap.getVertexBuffer(context);
				if (shader._.__position != null) context.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader._.__textureCoord != null) context.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics._.__bitmap.getIndexBuffer(context);
				context.drawTriangles(indexBuffer);

				#if gl_stats
				Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				#end

				(renderer._ : _Context3DRenderer).__clearShader();
			}
		}
	}
}
#end
