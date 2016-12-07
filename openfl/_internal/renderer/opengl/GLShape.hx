package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.cairo.CairoRenderer;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.filters.ShaderFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.Matrix)


class GLShape {
	
	private static var maskMatrix:Matrix = new Matrix();

	public static inline function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		if (!shape.__renderable || shape.__worldAlpha <= 0 || shape.__renderedAsCachedBitmap) return;
		
		var graphics = shape.__graphics;
	
		var mask:DisplayObject;
		var maskGraphics:Graphics = null;
		var gl = renderSession.gl;
		var stdRender = true;

		// Render cache as bitmap
		if ( shape.cacheAsBitmap ) {
			
			renderSession.updateCachedBitmap( shape );

			renderSession.maskManager.pushObject (shape);

			if (shape.__cachedBitmap != null) {

				if (renderSession.filterManager.useCPUFilters && shape.filters != null && shape.filters.length > 0) {
				
					renderFilterBitmap( shape, renderSession );

					stdRender = shape.filters[0].__preserveOriginal;

				} 

				if (stdRender)
					renderCacheAsBitmap( shape, renderSession );
			
			}

			renderSession.maskManager.popObject (shape);

        } else {

			//// Render mask
			if (shape.mask != null) {
				mask = shape.__mask;
				maskGraphics = shape.__mask.__graphics;

				#if (js && html5)
				CanvasGraphics.render (maskGraphics, renderSession, shape.__renderTransform);
				#elseif lime_cairo
				CairoGraphics.render (maskGraphics, renderSession, shape.__renderTransform);
				#end

				if (graphics.__bitmap != null && graphics.__visible) {
					
					var renderer:GLRenderer = cast renderSession.renderer;
					var gl = renderSession.gl;
					
					var shader;
					var targetBitmap = graphics.__bitmap;
					var transform = graphics.__worldTransform;

                    renderSession.blendModeManager.setBlendMode (shape.blendMode);
                    renderSession.maskManager.pushObject (shape);
                
                    var shader = renderSession.filterManager.pushObject (shape);
                
                    shader.data.uImage0.input = graphics.__bitmap;
                    shader.data.uImage0.smoothing = renderSession.allowSmoothing;
                    shader.data.uMatrix.value = renderer.getMatrix (graphics.__worldTransform);
                
                    renderSession.shaderManager.setShader (shader);
                
                    gl.bindBuffer (gl.ARRAY_BUFFER, graphics.__bitmap.getBuffer (gl, shape.__worldAlpha));
                    gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
                    gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
                    gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
                
                    gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
                
                    renderSession.filterManager.popObject (shape);
                    renderSession.maskManager.popObject (shape);
               
                }

            }
            
        }

    }


	private static inline function renderFilterBitmap (shape:DisplayObject, renderSession:RenderSession):Void {

		var shapeTransform = shape.__graphics == null ? shape.__worldTransform.clone() : shape.__graphics.__worldTransform.clone();
		var targetBitmap = renderSession.filterManager.renderFilters( shape, shape.__cachedBitmap );
		var transform = new Matrix();
		var pt = new Point ( shapeTransform.tx, shapeTransform.ty );
		pt = transform.deltaTransformPoint( pt );
		transform.translate( pt.x, pt.y );
		transform.translate( -shape.__filterBounds.x + shape.__filterOffset.x , -shape.__filterBounds.y + shape.__filterOffset.y );
		transform.translate( -shape.__cacheAsBitmapMatrix.tx, -shape.__cacheAsBitmapMatrix.ty );
	
		renderBitmapTexture( targetBitmap, transform, shape, renderSession );
	}

	private static inline function renderCacheAsBitmap (shape:DisplayObject, renderSession:RenderSession):Void {

		var shapeTransform = shape.__graphics == null ? shape.__worldTransform.clone() : shape.__graphics.__worldTransform.clone();
		var targetBitmap = shape.__cachedBitmap;
		var transform = new Matrix();
		var pt = new Point ( shapeTransform.tx, shapeTransform.ty );
		pt = transform.deltaTransformPoint( pt );
		transform.translate( pt.x, pt.y );
		transform.translate( -shape.__cacheAsBitmapMatrix.tx, -shape.__cacheAsBitmapMatrix.ty );

		renderBitmapTexture( targetBitmap, transform, shape, renderSession );
	}

	private static inline function renderBitmapTexture (targetBitmap:BitmapData, transform:Matrix, shape:DisplayObject, renderSession:RenderSession):Void {
						
		var gl = renderSession.gl;
		var renderer:GLRenderer = cast renderSession.renderer;
		var shader = renderSession.shaderManager.defaultShader;

		shader.data.uImage0.input = targetBitmap;
		shader.data.uImage0.smoothing = renderSession.allowSmoothing;
		shader.data.uMatrix.value = renderer.getMatrix (transform);
		
		renderSession.blendModeManager.setBlendMode (shape.blendMode);
		renderSession.shaderManager.setShader (shader);
		renderSession.maskManager.pushObject (shape);

		if (renderSession.allowSmoothing) {
			
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			
		} else {
			
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			
		}
							
		
		gl.bindBuffer (gl.ARRAY_BUFFER, targetBitmap.getBuffer (gl, shape.__worldAlpha));
		gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
						
	}

}