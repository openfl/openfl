package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class CanvasBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if js
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		var context = renderSession.context;
		
		if (bitmap.bitmapData != null && bitmap.bitmapData.__isValid) {
			
			if (bitmap.__mask != null) {
				
				renderSession.maskManager.pushMask (bitmap.__mask);
				
			}
			
			bitmap.bitmapData.__sync ();
			
			context.globalAlpha = bitmap.__worldAlpha;
			var transform = bitmap.__worldTransform;
			var scrollRect = bitmap.scrollRect;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
			}
			
			if (!bitmap.smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = false;
				untyped (context).webkitImageSmoothingEnabled = false;
				context.imageSmoothingEnabled = false;
				
			}
			
			if (scrollRect == null) {
				
				context.drawImage (bitmap.bitmapData.__image.src, 0, 0);
				
			} else {
				
				context.drawImage (bitmap.bitmapData.__image.src, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				
			}
			
			if (!bitmap.smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				untyped (context).webkitImageSmoothingEnabled = true;
				context.imageSmoothingEnabled = true;
				
			}
			
			if (bitmap.__mask != null) {
				
				renderSession.maskManager.popMask ();
				
			}
			
		}
		#end
		
	}
	
	
}