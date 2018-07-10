package openfl._internal.renderer.canvas;


import openfl.display.Bitmap;
import openfl.display.CanvasRenderer;

#if (lime >= "7.0.0")
import lime._internal.graphics.ImageCanvasUtil; // TODO
#else
import lime.graphics.utils.ImageCanvasUtil;
#end

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class CanvasBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderer:CanvasRenderer):Void {
		
		#if (js && html5)
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		var context = renderer.context;
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid && bitmap.__bitmapData.readable) {
			
			renderer.__setBlendMode (bitmap.__worldBlendMode);
			renderer.__pushMaskObject (bitmap, false);
			
			ImageCanvasUtil.convertToCanvas (bitmap.__bitmapData.image);
			
			context.globalAlpha = bitmap.__worldAlpha;
			var scrollRect = bitmap.__scrollRect;
			
			renderer.setTransform (bitmap.__renderTransform, context);
			
			if (!renderer.__allowSmoothing || !bitmap.smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = false;
				//untyped (context).webkitImageSmoothingEnabled = false;
				untyped (context).msImageSmoothingEnabled = false;
				untyped (context).imageSmoothingEnabled = false;
				
			}
			
			if (scrollRect == null) {
				
				context.drawImage (bitmap.__bitmapData.image.src, 0, 0, bitmap.__bitmapData.image.width, bitmap.__bitmapData.image.height);
				
			} else {
				
				context.drawImage (bitmap.__bitmapData.image.src, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				
			}
			
			if (!renderer.__allowSmoothing || !bitmap.smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				//untyped (context).webkitImageSmoothingEnabled = true;
				untyped (context).msImageSmoothingEnabled = true;
				untyped (context).imageSmoothingEnabled = true;
				
			}
			
			renderer.__popMaskObject (bitmap, false);
			
		}
		#end
		
	}
	
	
}