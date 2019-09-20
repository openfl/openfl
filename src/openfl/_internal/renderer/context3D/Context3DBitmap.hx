package openfl._internal.renderer.context3D;

import openfl.display.Bitmap;
import openfl.geom.Matrix;
#if gl_stats
import openfl._internal.renderer.context3D.stats.Context3DStats;
import openfl._internal.renderer.context3D.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Shader)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DBitmap
{
	public static function render(bitmap:Bitmap, renderer:Context3DRenderer):Void
	{
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;

		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid)
		{
			var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);
			if (!alphaMask) renderer.__pushMaskObject(bitmap);

			var snapToPixel = renderer.__roundPixels || renderer.__shouldSnapToPixel(bitmap);
			var transform = renderer.__getDisplayTransformTempMatrix(bitmap.__renderTransform, snapToPixel);
			renderer.batcher.setVertices(transform, 0, 0, bitmap.width, bitmap.height);
			renderer.batcher.useDefaultUvs();
			renderer.batcher.pushQuad(bitmap.bitmapData, bitmap.__worldBlendMode, bitmap.__worldAlpha, bitmap.__worldColorTransform);

			if (!alphaMask) renderer.__popMaskObject(bitmap);

			// var context = renderer.context3D;

			// // TODO: Do we need to make sure this bitmap is cacheAsBitmap?
			// var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);

			// // TODO: Support more cases
			// if (alphaMask && bitmap.mask.__type != BITMAP)
			// {
			// 	alphaMask = false;
			// }

			// renderer.__setBlendMode(bitmap.__worldBlendMode);
			// if (!alphaMask) renderer.__pushMaskObject(bitmap);
			// // renderer.filterManager.pushObject (bitmap);

			// var shader = renderer.__initDisplayShader(!alphaMask ? cast bitmap.__worldShader : renderer.__alphaMaskShader);
			// renderer.setShader(shader);
			// renderer.applyBitmapData(bitmap.__bitmapData, renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled));
			// renderer.applyMatrix(renderer.__getMatrix(bitmap.__renderTransform, bitmap.pixelSnapping));
			// renderer.applyAlpha(bitmap.__worldAlpha);
			// renderer.applyColorTransform(bitmap.__worldColorTransform);

			// if (alphaMask)
			// {
			// 	// renderer.__updateCacheBitmap(bitmap.mask, false);
			// 	// renderer.__currentShader.__alphaTexture.input = bitmap.mask.__cacheBitmapDataTexture;

			// 	// TODO: Use update cache bitmap always (filters) but keep cacheAsBitmap on a plain bitmap cheap?
			// 	var maskBitmap:Bitmap = cast bitmap.mask;
			// 	renderer.__currentShader.__alphaTexture.input = maskBitmap.__bitmapData;
			// 	if (renderer.__currentShader.__alphaTextureMatrix.value == null) renderer.__currentShader.__alphaTextureMatrix.value = [];
			// 	var matrix = renderer.__currentShader.__alphaTextureMatrix.value;

			// 	var transform = Matrix.__pool.get();
			// 	transform.copyFrom(bitmap.__renderTransform);
			// 	transform.invert();
			// 	transform.concat(maskBitmap.__renderTransform);

			// 	matrix[0] = transform.a * (bitmap.__bitmapData.width / maskBitmap.__bitmapData.width);
			// 	matrix[1] = transform.b;
			// 	matrix[4] = transform.c;
			// 	matrix[5] = transform.d * (bitmap.__bitmapData.height / maskBitmap.__bitmapData.height);
			// 	matrix[12] = transform.tx;
			// 	matrix[13] = transform.ty;
			// 	matrix[15] = 0.0;

			// 	Matrix.__pool.release(transform);
			// }

			// renderer.updateShader();

			// var vertexBuffer = bitmap.__bitmapData.getVertexBuffer(context);
			// if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
			// if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			// var indexBuffer = bitmap.__bitmapData.getIndexBuffer(context);
			// context.drawTriangles(indexBuffer);

			// #if gl_stats
			// Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			// #end

			// renderer.__clearShader();

			// // renderer.filterManager.popObject (bitmap);
			// if (!alphaMask) renderer.__popMaskObject(bitmap);
		}
	}

	public static function renderMask(bitmap:Bitmap, renderer:Context3DRenderer):Void
	{
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid)
		{
			var context = renderer.context3D;

			var shader = renderer.__maskShader;
			renderer.setShader(shader);
			renderer.applyBitmapData(Context3DMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix(renderer.__getMatrix(bitmap.__renderTransform, bitmap.pixelSnapping));
			renderer.updateShader();

			var vertexBuffer = bitmap.__bitmapData.getVertexBuffer(context);
			if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = bitmap.__bitmapData.getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			#if gl_stats
			Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			#end

			renderer.__clearShader();
		}
	}
}
