package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)


class GLBitmap {
	
	private static var IDENTITY:Matrix = new Matrix();
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		if (bitmap.bitmapData != null && bitmap.bitmapData.__isValid) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			var gl = renderSession.gl;
			
			renderSession.blendModeManager.setBlendMode (bitmap.blendMode);
			renderSession.maskManager.pushObject (bitmap);
			
			if (renderSession.filterManager.useCPUFilters && bitmap.cacheAsBitmap && bitmap.filters != null && bitmap.filters.length > 0) {

				var shader = renderSession.shaderManager.defaultShader;

				// Render filter bitmap and draw it
				renderSession.updateCachedBitmap( bitmap );
				var filterBitmapData = renderSession.filterManager.renderFilters( bitmap, bitmap.__cachedBitmap );
				var filterTransform = IDENTITY.clone();
				var b = bitmap.__filterBounds;
				filterTransform.scale( b.width / (b.width - b.x - b.x), b.height / (b.height - b.y - b.y) );
				filterTransform.translate( bitmap.__worldTransform.tx, bitmap.__worldTransform.ty );
				filterTransform.translate( -bitmap.__filterBounds.x, -bitmap.__filterBounds.y );
				filterTransform.translate( -bitmap.__cacheAsBitmapMatrix.tx, -bitmap.__cacheAsBitmapMatrix.ty );

				shader.data.uImage0.input = filterBitmapData;
				shader.data.uImage0.smoothing = renderSession.allowSmoothing && (bitmap.smoothing || renderSession.upscaled);
				shader.data.uMatrix.value = renderer.getMatrix (filterTransform);
				
				renderSession.shaderManager.setShader (shader);
				
				gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.__cachedBitmap.getBuffer (gl, bitmap.__worldAlpha));
				gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
				
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);

			} else {

				var shader = renderSession.filterManager.pushObject (bitmap);
				
				shader.data.uImage0.input = bitmap.bitmapData;
				shader.data.uImage0.smoothing = renderSession.allowSmoothing && (bitmap.smoothing || renderSession.upscaled);
				shader.data.uMatrix.value = renderer.getMatrix (bitmap.__renderTransform);
				
				renderSession.shaderManager.setShader (shader);
				
				gl.bindBuffer (gl.ARRAY_BUFFER, bitmap.bitmapData.getBuffer (gl, bitmap.__worldAlpha));
				gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
				
				gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
				
				renderSession.filterManager.popObject (bitmap);

			}
			renderSession.maskManager.popObject (bitmap);
			
		}
		
	}
	
	
}