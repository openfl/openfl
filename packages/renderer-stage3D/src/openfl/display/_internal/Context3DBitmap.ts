import DisplayObjectType from "../../../_internal/renderer/DisplayObjectType";
import * as internal from "../../../_internal/utils/InternalAccess";
import Bitmap from "../../../display/Bitmap";
import Context3DVertexBufferFormat from "../../../display3D/Context3DVertexBufferFormat";
import Matrix from "../../../geom/Matrix";
import Context3DBitmapData from "./Context3DBitmapData";
import Context3DMaskShader from "./Context3DMaskShader";
import Context3DRenderer from "./Context3DRenderer";

export default class Context3DBitmap
{
	public static render(bitmap: Bitmap, renderer: Context3DRenderer): void
	{
		if (!(<internal.DisplayObject><any>bitmap).__renderable || (<internal.DisplayObject><any>bitmap).__worldAlpha <= 0) return;

		if ((<internal.Bitmap><any>bitmap).__bitmapData != null && (<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__isValid)
		{
			// #if!disable_batcher
			// var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);
			// if (!alphaMask) renderer.__pushMaskObject(bitmap);

			// var bitmapData = bitmap.bitmapData;
			// var transform = renderer.__getDisplayTransformTempMatrix((<internal.DisplayObject><any>bitmap).__renderTransform, bitmap.pixelSnapping);
			// var alpha = renderer.__getAlpha((<internal.DisplayObject><any>bitmap).__worldAlpha);
			// Context3DBitmapData.pushQuadsToBatcher(bitmapData, renderer.batcher, transform, alpha, bitmap);

			// if (!alphaMask) renderer.__popMaskObject(bitmap);
			// #else
			var context = renderer.context3D;

			// TODO: Do we need to make sure this bitmap is cacheAsBitmap?
			var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);

			// TODO: Support more cases
			if (alphaMask && (<internal.DisplayObject><any>bitmap.mask).__type != DisplayObjectType.BITMAP)
			{
				alphaMask = false;
			}

			renderer.__setBlendMode((<internal.DisplayObject><any>bitmap).__worldBlendMode);
			if (!alphaMask) renderer.__pushMaskObject(bitmap);
			// renderer.filterManager.pushObject (bitmap);

			var shader = renderer.__initDisplayShader(!alphaMask ? (<internal.DisplayObject><any>bitmap).__worldShader : renderer.__alphaMaskShader);
			renderer.setShader(shader);
			renderer.applyBitmapData((<internal.Bitmap><any>bitmap).__bitmapData, (<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing && (bitmap.smoothing || renderer.__upscaled));
			renderer.applyMatrix(renderer.__getMatrix((<internal.DisplayObject><any>bitmap).__renderTransform, bitmap.pixelSnapping));
			renderer.applyAlpha(renderer.__getAlpha((<internal.DisplayObject><any>bitmap).__worldAlpha));
			renderer.applyColorTransform((<internal.DisplayObject><any>bitmap).__worldColorTransform);

			if (alphaMask)
			{
				// renderer.__updateCacheBitmap(bitmap.mask, false);
				// (<internal.Shader><any>renderer.__currentShader).__alphaTexture.input = (<internal.DisplayObject><any>bitmap.mask).__renderData.cacheBitmapDataTexture;

				// TODO: Use update cache bitmap always (filters) but keep cacheAsBitmap on a plain bitmap cheap?
				var maskBitmap: Bitmap = bitmap.mask as Bitmap;
				(<internal.Shader><any>renderer.__currentShader).__alphaTexture.input = (<internal.Bitmap><any>maskBitmap).__bitmapData;
				if ((<internal.Shader><any>renderer.__currentShader).__alphaTextureMatrix.value == null) (<internal.Shader><any>renderer.__currentShader).__alphaTextureMatrix.value = [];
				var matrix = (<internal.Shader><any>renderer.__currentShader).__alphaTextureMatrix.value;

				var transform = (<internal.Matrix><any>Matrix).__pool.get();
				transform.copyFrom((<internal.DisplayObject><any>bitmap).__renderTransform);
				transform.invert();
				transform.concat((<internal.DisplayObject><any>maskBitmap).__renderTransform);

				matrix[0] = transform.a * ((<internal.Bitmap><any>bitmap).__bitmapData.width / (<internal.Bitmap><any>maskBitmap).__bitmapData.width);
				matrix[1] = transform.b;
				matrix[4] = transform.c;
				matrix[5] = transform.d * ((<internal.Bitmap><any>bitmap).__bitmapData.height / (<internal.Bitmap><any>maskBitmap).__bitmapData.height);
				matrix[12] = transform.tx;
				matrix[13] = transform.ty;
				matrix[15] = 0.0;

				(<internal.Matrix><any>Matrix).__pool.release(transform);
			}

			renderer.updateShader();

			var vertexBuffer = (<internal.Bitmap><any>bitmap).__bitmapData.getVertexBuffer(context);
			if ((<internal.Shader><any>shader).__position != null) context.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if ((<internal.Shader><any>shader).__textureCoord != null) context.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			var indexBuffer = (<internal.Bitmap><any>bitmap).__bitmapData.getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			// #if gl_stats
			// Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			// #end

			renderer.__clearShader();

			// renderer.filterManager.popObject (bitmap);
			if (!alphaMask) renderer.__popMaskObject(bitmap);
			// #end
		}
	}

	public static render2(bitmap: Bitmap, renderer: Context3DRenderer): void
	{
		if (!(<internal.DisplayObject><any>bitmap).__renderable || (<internal.DisplayObject><any>bitmap).__worldAlpha <= 0) return;

		if ((<internal.Bitmap><any>bitmap).__bitmapData != null && (<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__isValid)
		{
			// #if!disable_batcher
			renderer.batcher.flush();
			// #end
			// alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);
			// if (!alphaMask) renderer.__pushMaskObject(bitmap);

			// bitmapData = bitmap.bitmapData;
			// transform = renderer.__getDisplayTransformTempMatrix((<internal.DisplayObject><any>bitmap).__renderTransform, bitmap.pixelSnapping);
			// alpha = renderer.__getAlpha((<internal.DisplayObject><any>bitmap).__worldAlpha);
			// bitmapData.pushQuadsToBatcher(renderer.batcher, transform, alpha, bitmap);

			// if (!alphaMask) renderer.__popMaskObject(bitmap);

			var context = renderer.context3D;

			// TODO: Do we need to make sure this bitmap is cacheAsBitmap?
			var alphaMask = (bitmap.mask != null && bitmap.mask.cacheAsBitmap);

			// TODO: Support more cases
			if (alphaMask && (<internal.DisplayObject><any>bitmap.mask).__type != DisplayObjectType.BITMAP)
			{
				alphaMask = false;
			}

			renderer.__setBlendMode((<internal.DisplayObject><any>bitmap).__worldBlendMode);
			if (!alphaMask) renderer.__pushMaskObject(bitmap);
			// renderer.filterManager.pushObject (bitmap);

			var shader = renderer.__initDisplayShader(!alphaMask ? (<internal.DisplayObject><any>bitmap).__worldShader : renderer.__alphaMaskShader);
			renderer.setShader(shader);
			renderer.applyBitmapData((<internal.Bitmap><any>bitmap).__bitmapData, (<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing && (bitmap.smoothing || renderer.__upscaled));
			renderer.applyMatrix(renderer.__getMatrix((<internal.DisplayObject><any>bitmap).__renderTransform, bitmap.pixelSnapping));
			renderer.applyAlpha(renderer.__getAlpha((<internal.DisplayObject><any>bitmap).__worldAlpha));
			renderer.applyColorTransform((<internal.DisplayObject><any>bitmap).__worldColorTransform);

			if (alphaMask)
			{
				// renderer.__updateCacheBitmap(bitmap.mask, false);
				// (<internal.Shader><any>renderer.__currentShader).__alphaTexture.input = (<internal.DisplayObject><any>bitmap.mask).__renderData.cacheBitmapDataTexture;

				// TODO: Use update cache bitmap always (filters) but keep cacheAsBitmap on a plain bitmap cheap?
				var maskBitmap: Bitmap = bitmap.mask as Bitmap;
				(<internal.Shader><any>renderer.__currentShader).__alphaTexture.input = (<internal.Bitmap><any>maskBitmap).__bitmapData;
				if ((<internal.Shader><any>renderer.__currentShader).__alphaTextureMatrix.value == null) (<internal.Shader><any>renderer.__currentShader).__alphaTextureMatrix.value = [];
				var matrix = (<internal.Shader><any>renderer.__currentShader).__alphaTextureMatrix.value;

				var transform = (<internal.Matrix><any>Matrix).__pool.get();
				transform.copyFrom((<internal.DisplayObject><any>bitmap).__renderTransform);
				transform.invert();
				transform.concat((<internal.DisplayObject><any>maskBitmap).__renderTransform);

				matrix[0] = transform.a * ((<internal.Bitmap><any>bitmap).__bitmapData.width / (<internal.Bitmap><any>maskBitmap).__bitmapData.width);
				matrix[1] = transform.b;
				matrix[4] = transform.c;
				matrix[5] = transform.d * ((<internal.Bitmap><any>bitmap).__bitmapData.height / (<internal.Bitmap><any>maskBitmap).__bitmapData.height);
				matrix[12] = transform.tx;
				matrix[13] = transform.ty;
				matrix[15] = 0.0;

				(<internal.Matrix><any>Matrix).__pool.release(transform);
			}

			renderer.updateShader();

			var vertexBuffer = (<internal.Bitmap><any>bitmap).__bitmapData.getVertexBuffer(context);
			if ((<internal.Shader><any>shader).__position != null) context.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if ((<internal.Shader><any>shader).__textureCoord != null) context.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			var indexBuffer = (<internal.Bitmap><any>bitmap).__bitmapData.getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			renderer.__clearShader();

			// renderer.filterManager.popObject (bitmap);
			if (!alphaMask) renderer.__popMaskObject(bitmap);
		}
	}

	public static renderMask(bitmap: Bitmap, renderer: Context3DRenderer): void
	{
		if ((<internal.Bitmap><any>bitmap).__bitmapData != null && (<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__isValid)
		{
			var context = renderer.context3D;

			var shader = renderer.__maskShader;
			renderer.setShader(shader);
			renderer.applyBitmapData(Context3DMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix(renderer.__getMatrix((<internal.DisplayObject><any>bitmap).__renderTransform, bitmap.pixelSnapping));
			renderer.updateShader();

			var vertexBuffer = (<internal.Bitmap><any>bitmap).__bitmapData.getVertexBuffer(context);
			if ((<internal.Shader><any>shader).__position != null) context.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if ((<internal.Shader><any>shader).__textureCoord != null) context.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			var indexBuffer = (<internal.Bitmap><any>bitmap).__bitmapData.getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			renderer.__clearShader();
		}
	}
}
