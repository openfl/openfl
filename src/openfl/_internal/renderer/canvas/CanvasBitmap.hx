package openfl._internal.renderer.canvas;


import lime.graphics.utils.ImageCanvasUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class CanvasBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		var context = renderSession.context;
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid && bitmap.__bitmapData.__prepareImage()) {
			
			renderSession.blendModeManager.setBlendMode (bitmap.__worldBlendMode);
			renderSession.maskManager.pushObject (bitmap, false);
			
			ImageCanvasUtil.convertToCanvas (bitmap.__bitmapData.image);
			
			context.globalAlpha = bitmap.__worldAlpha;
			var transform = bitmap.__renderTransform;
			var scrollRect = bitmap.__scrollRect;
			var scale = renderSession.scale;
			@:privateAccess var sizeScale = scale / bitmap.__bitmapData.__scale;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a * sizeScale, transform.b, transform.c, transform.d * sizeScale, Std.int(transform.tx * scale), Std.int (transform.ty * scale));
				
			} else {
				
				context.setTransform (transform.a * sizeScale, transform.b, transform.c, transform.d * sizeScale, transform.tx * scale, transform.ty * scale);
				
			}
			
			if (!renderSession.allowSmoothing || !bitmap.smoothing) {
				
				CanvasSmoothing.setEnabled(context, false);
				
			}
			
			if (scrollRect == null) {
				
				context.drawImage (bitmap.__bitmapData.image.src, 0, 0);
				
			} else {
				
				context.drawImage (bitmap.__bitmapData.image.src, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				
			}
			
			if (!renderSession.allowSmoothing || !bitmap.smoothing) {
				
				CanvasSmoothing.setEnabled(context, true);
				
			}
			
			renderSession.maskManager.popObject (bitmap, false);
			
		}
		#end
		
	}
	
	
}