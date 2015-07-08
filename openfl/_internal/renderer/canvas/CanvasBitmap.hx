package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class CanvasBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		var context = renderSession.context;
		
		if (bitmap.bitmapData != null && bitmap.bitmapData.__isValid) {
			
			context.globalAlpha = bitmap.__worldAlpha;
			var transform = bitmap.__renderMatrix;
			var scrollRect = bitmap.scrollRect;
			
			if (scrollRect != null) {
				
				renderSession.maskManager.pushRect (scrollRect, transform);
				
			}
			
			if (bitmap.__mask != null) {
				
				renderSession.maskManager.pushMask (bitmap.__mask);
				
			}
			
			bitmap.bitmapData.__sync ();
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
			}
			
			if (!bitmap.smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = false;
				untyped (context).webkitImageSmoothingEnabled = false;
				untyped (context).imageSmoothingEnabled = false;
				
			}
			
			context.drawImage (bitmap.bitmapData.__image.src, 0, 0);
			
			if (!bitmap.smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				untyped (context).webkitImageSmoothingEnabled = true;
				untyped (context).imageSmoothingEnabled = true;
				
			}
			
			if (bitmap.__mask != null) {
				
				renderSession.maskManager.popMask ();
				
			}
			
			if (scrollRect != null) {
				
				renderSession.maskManager.popRect ();
				
			}
			
		}
		#end
		
	}
	
	
}