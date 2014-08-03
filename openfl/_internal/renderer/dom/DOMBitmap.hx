package openfl._internal.renderer.dom;


import lime.graphics.ImageBuffer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

#if js
import js.Browser;
#end

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class DOMBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if js
		if (bitmap.stage != null && bitmap.__worldVisible && bitmap.__renderable && bitmap.bitmapData != null && bitmap.bitmapData.__isValid) {
			
			if (bitmap.bitmapData.__image.buffer.__srcImage != null) {
				
				renderImage (bitmap, renderSession);
				
			} else {
				
				renderCanvas (bitmap, renderSession);
				
			}
			
		} else {
			
			if (bitmap.__image != null) {
				
				renderSession.element.removeChild (bitmap.__image);
				bitmap.__image = null;
				bitmap.__style = null;
				
			}
			
			if (bitmap.__canvas != null) {
				
				renderSession.element.removeChild (bitmap.__canvas);
				bitmap.__canvas = null;
				bitmap.__style = null;
				
			}
			
		}
		#end
		
	}
	
	
	private static function renderCanvas (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if js
		if (bitmap.__image != null) {
			
			renderSession.element.removeChild (bitmap.__image);
			bitmap.__image = null;
			
		}
		
		if (bitmap.__canvas == null) {
			
			bitmap.__canvas = cast Browser.document.createElement ("canvas");	
			bitmap.__context = bitmap.__canvas.getContext ("2d");
			
			if (!bitmap.smoothing) {
				
				untyped (bitmap.__context).mozImageSmoothingEnabled = false;
				untyped (bitmap.__context).webkitImageSmoothingEnabled = false;
				bitmap.__context.imageSmoothingEnabled = false;
				
			}
			
			DOMRenderer.initializeElement (bitmap, bitmap.__canvas, renderSession);
			
		}
		
		bitmap.bitmapData.__sync ();
		
		bitmap.__canvas.width = bitmap.bitmapData.width;
		bitmap.__canvas.height = bitmap.bitmapData.height;
		
		bitmap.__context.globalAlpha = bitmap.__worldAlpha;
		bitmap.__context.drawImage (bitmap.bitmapData.__image.buffer.__srcCanvas, 0, 0);
		
		DOMRenderer.applyStyle (bitmap, renderSession, true, false, true);
		#end
		
	}
	
	
	private static function renderImage (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if js
		if (bitmap.__canvas != null) {
			
			renderSession.element.removeChild (bitmap.__canvas);
			bitmap.__canvas = null;
			
		}
		
		if (bitmap.__image == null) {
			
			bitmap.__image = cast Browser.document.createElement ("img");
			bitmap.__image.src = bitmap.bitmapData.__image.buffer.__srcImage.src;
			DOMRenderer.initializeElement (bitmap, bitmap.__image, renderSession);
			
		}
		
		DOMRenderer.applyStyle (bitmap, renderSession, true, true, true);
		#end
		
	}
	
	
}