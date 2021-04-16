package openfl.display._internal;

#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
@:access(openfl.display.BitmapData)
@:access(openfl.display.Shader)
@:access(openfl.display3D.Context3D)
class Context3DBitmapData
{
	public static function renderDrawable(bitmapData:BitmapData, renderer:OpenGLRenderer):Void
	{
		var context = renderer.__context3D;
		var gl = context.gl;

		renderer.__setBlendMode(NORMAL);

		var shader = renderer.__defaultDisplayShader;
		renderer.setShader(shader);
		renderer.applyBitmapData(bitmapData, renderer.__upscaled);
		renderer.applyMatrix(renderer.__getMatrix(bitmapData.__worldTransform, AUTO));
		renderer.applyAlpha(bitmapData.__worldAlpha);
		renderer.applyColorTransform(bitmapData.__worldColorTransform);
		renderer.updateShader();

		// alpha == 1, __worldColorTransform

		var vertexBuffer = bitmapData.getVertexBuffer(context);
		if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = bitmapData.getIndexBuffer(context);
		context.drawTriangles(indexBuffer);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		renderer.__clearShader();
	}

	public static function renderDrawableMask(bitmapData:BitmapData, renderer:OpenGLRenderer):Void
	{
		var context = renderer.__context3D;
		var gl = context.gl;

		var shader = renderer.__maskShader;
		renderer.setShader(shader);
		renderer.applyBitmapData(bitmapData, renderer.__upscaled);
		renderer.applyMatrix(renderer.__getMatrix(bitmapData.__worldTransform, AUTO));
		renderer.updateShader();

		var vertexBuffer = bitmapData.getVertexBuffer(context);
		if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = bitmapData.getIndexBuffer(context);
		context.drawTriangles(indexBuffer);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		renderer.__clearShader();
	}
}
