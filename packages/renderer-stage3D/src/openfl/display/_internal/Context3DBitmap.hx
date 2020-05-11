package openfl.display._internal;

#if openfl_gl
import openfl.display.Bitmap;
import openfl.geom.Matrix;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display._internal)
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
		if (!bitmap._.__renderable || bitmap._.__worldAlpha <= 0) return;

		if (bitmap._.__bitmapData != null && bitmap._.__bitmapData._.__isValid)
		{
			#if !disable_batcher
			var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);
			if (!alphaMask) renderer._.__pushMaskObject(bitmap);

			var bitmapData = bitmap.bitmapData;
			var transform = renderer._.__getDisplayTransformTempMatrix(bitmap._.__renderTransform, bitmap.pixelSnapping);
			var alpha = renderer._.__getAlpha(bitmap._.__worldAlpha);
			Context3DBitmapData.pushQuadsToBatcher(bitmapData, renderer.batcher, transform, alpha, bitmap);

			if (!alphaMask) renderer._.__popMaskObject(bitmap);
			#else
			var context = renderer.context3D;

			// TODO: Do we need to make sure this bitmap is cacheAsBitmap?
			var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);

			// TODO: Support more cases
			if (alphaMask && bitmap.mask._.__type != BITMAP)
			{
				alphaMask = false;
			}

			renderer._.__setBlendMode(bitmap._.__worldBlendMode);
			if (!alphaMask) renderer._.__pushMaskObject(bitmap);
			// renderer.filterManager.pushObject (bitmap);

			var shader = renderer._.__initDisplayShader(!alphaMask ? cast bitmap._.__worldShader : renderer._.__alphaMaskShader);
			renderer.setShader(shader);
			renderer.applyBitmapData(bitmap._.__bitmapData, renderer._.__allowSmoothing && (bitmap.smoothing || renderer._.__upscaled));
			renderer.applyMatrix(renderer._.__getMatrix(bitmap._.__renderTransform, bitmap.pixelSnapping));
			renderer.applyAlpha(renderer._.__getAlpha(bitmap._.__worldAlpha));
			renderer.applyColorTransform(bitmap._.__worldColorTransform);

			if (alphaMask)
			{
				// renderer._.__updateCacheBitmap(bitmap.mask, false);
				// renderer._.__currentShader._.__alphaTexture.input = bitmap.mask._.__renderData.cacheBitmapDataTexture;

				// TODO: Use update cache bitmap always (filters) but keep cacheAsBitmap on a plain bitmap cheap?
				var maskBitmap:Bitmap = cast bitmap.mask;
				renderer._.__currentShader._.__alphaTexture.input = maskBitmap._.__bitmapData;
				if (renderer._.__currentShader._.__alphaTextureMatrix.value == null) renderer._.__currentShader._.__alphaTextureMatrix.value = [];
				var matrix = renderer._.__currentShader._.__alphaTextureMatrix.value;

				var transform = _Matrix.__pool.get();
				transform.copyFrom(bitmap._.__renderTransform);
				transform.invert();
				transform.concat(maskBitmap._.__renderTransform);

				matrix[0] = transform.a * (bitmap._.__bitmapData.width / maskBitmap._.__bitmapData.width);
				matrix[1] = transform.b;
				matrix[4] = transform.c;
				matrix[5] = transform.d * (bitmap._.__bitmapData.height / maskBitmap._.__bitmapData.height);
				matrix[12] = transform.tx;
				matrix[13] = transform.ty;
				matrix[15] = 0.0;

				_Matrix.__pool.release(transform);
			}

			renderer.updateShader();

			var vertexBuffer = bitmap._.__bitmapData.getVertexBuffer(context);
			if (shader._.__position != null) context.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader._.__textureCoord != null) context.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = bitmap._.__bitmapData.getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			#if gl_stats
			Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			#end

			renderer._.__clearShader();

			// renderer.filterManager.popObject (bitmap);
			if (!alphaMask) renderer._.__popMaskObject(bitmap);
			#end
		}
	}

	public static function render2(bitmap:Bitmap, renderer:Context3DRenderer):Void
	{
		if (!bitmap._.__renderable || bitmap._.__worldAlpha <= 0) return;

		if (bitmap._.__bitmapData != null && bitmap._.__bitmapData._.__isValid)
		{
			#if !disable_batcher
			renderer.batcher.flush();
			#end
			// var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);
			// if (!alphaMask) renderer._.__pushMaskObject(bitmap);

			// var bitmapData = bitmap.bitmapData;
			// var transform = renderer._.__getDisplayTransformTempMatrix(bitmap._.__renderTransform, bitmap.pixelSnapping);
			// var alpha = renderer._.__getAlpha(bitmap._.__worldAlpha);
			// bitmapData.pushQuadsToBatcher(renderer.batcher, transform, alpha, bitmap);

			// if (!alphaMask) renderer._.__popMaskObject(bitmap);

			var context = renderer.context3D;

			// TODO: Do we need to make sure this bitmap is cacheAsBitmap?
			var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);

			// TODO: Support more cases
			if (alphaMask && bitmap.mask._.__type != BITMAP)
			{
				alphaMask = false;
			}

			renderer._.__setBlendMode(bitmap._.__worldBlendMode);
			if (!alphaMask) renderer._.__pushMaskObject(bitmap);
			// renderer.filterManager.pushObject (bitmap);

			var shader = renderer._.__initDisplayShader(!alphaMask ? cast bitmap._.__worldShader : renderer._.__alphaMaskShader);
			renderer.setShader(shader);
			renderer.applyBitmapData(bitmap._.__bitmapData, renderer._.__allowSmoothing && (bitmap.smoothing || renderer._.__upscaled));
			renderer.applyMatrix(renderer._.__getMatrix(bitmap._.__renderTransform, bitmap.pixelSnapping));
			renderer.applyAlpha(renderer._.__getAlpha(bitmap._.__worldAlpha));
			renderer.applyColorTransform(bitmap._.__worldColorTransform);

			if (alphaMask)
			{
				// renderer._.__updateCacheBitmap(bitmap.mask, false);
				// renderer._.__currentShader._.__alphaTexture.input = bitmap.mask._.__renderData.cacheBitmapDataTexture;

				// TODO: Use update cache bitmap always (filters) but keep cacheAsBitmap on a plain bitmap cheap?
				var maskBitmap:Bitmap = cast bitmap.mask;
				renderer._.__currentShader._.__alphaTexture.input = maskBitmap._.__bitmapData;
				if (renderer._.__currentShader._.__alphaTextureMatrix.value == null) renderer._.__currentShader._.__alphaTextureMatrix.value = [];
				var matrix = renderer._.__currentShader._.__alphaTextureMatrix.value;

				var transform = _Matrix.__pool.get();
				transform.copyFrom(bitmap._.__renderTransform);
				transform.invert();
				transform.concat(maskBitmap._.__renderTransform);

				matrix[0] = transform.a * (bitmap._.__bitmapData.width / maskBitmap._.__bitmapData.width);
				matrix[1] = transform.b;
				matrix[4] = transform.c;
				matrix[5] = transform.d * (bitmap._.__bitmapData.height / maskBitmap._.__bitmapData.height);
				matrix[12] = transform.tx;
				matrix[13] = transform.ty;
				matrix[15] = 0.0;

				_Matrix.__pool.release(transform);
			}

			renderer.updateShader();

			var vertexBuffer = bitmap._.__bitmapData.getVertexBuffer(context);
			if (shader._.__position != null) context.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader._.__textureCoord != null) context.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = bitmap._.__bitmapData.getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			#if gl_stats
			Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			#end

			renderer._.__clearShader();

			// renderer.filterManager.popObject (bitmap);
			if (!alphaMask) renderer._.__popMaskObject(bitmap);
		}
	}

	public static function renderMask(bitmap:Bitmap, renderer:Context3DRenderer):Void
	{
		if (bitmap._.__bitmapData != null && bitmap._.__bitmapData._.__isValid)
		{
			var context = renderer.context3D;

			var shader = renderer._.__maskShader;
			renderer.setShader(shader);
			renderer.applyBitmapData(Context3DMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix(renderer._.__getMatrix(bitmap._.__renderTransform, bitmap.pixelSnapping));
			renderer.updateShader();

			var vertexBuffer = bitmap._.__bitmapData.getVertexBuffer(context);
			if (shader._.__position != null) context.setVertexBufferAt(shader._.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader._.__textureCoord != null) context.setVertexBufferAt(shader._.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = bitmap._.__bitmapData.getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			#if gl_stats
			Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			#end

			renderer._.__clearShader();
		}
	}
}
#end
