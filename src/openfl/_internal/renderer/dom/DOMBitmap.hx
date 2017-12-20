package openfl._internal.renderer.dom;


import lime.graphics.ImageBuffer;
import lime.graphics.utils.ImageCanvasUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

#if (js && html5)
import js.Browser;
#end

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class DOMBitmap {
	
	
	public static function clear (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if (js && html5)
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
		#end
		
	}
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (bitmap.stage != null && bitmap.__worldVisible && bitmap.__renderable && bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid && bitmap.__bitmapData.readable) {
			
			renderSession.maskManager.pushObject (bitmap);
			
			if (bitmap.__bitmapData.image.buffer.__srcImage != null) {
				
				renderImage (bitmap, renderSession);
				
			} else {
				
				renderCanvas (bitmap, renderSession);
				
			}
			
			renderSession.maskManager.popObject (bitmap);
			
		} else {
			
			clear (bitmap, renderSession);
			
		}
		#end
		
	}
	
	
	private static function renderCanvas (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (bitmap.__image != null) {
			
			renderSession.element.removeChild (bitmap.__image);
			bitmap.__image = null;
			
		}
		
		if (bitmap.__canvas == null) {
			
			bitmap.__canvas = cast Browser.document.createElement ("canvas");
			bitmap.__context = bitmap.__canvas.getContext ("2d");
			bitmap.__imageVersion = -1;
			
			if (!renderSession.allowSmoothing || !bitmap.smoothing) {
				
				untyped (bitmap.__context).mozImageSmoothingEnabled = false;
				//untyped (bitmap.__context).webkitImageSmoothingEnabled = false;
				untyped (bitmap.__context).msImageSmoothingEnabled = false;
				untyped (bitmap.__context).imageSmoothingEnabled = false;
				
			}
			
			DOMRenderer.initializeElement (bitmap, bitmap.__canvas, renderSession);
			
		}
		
		if (bitmap.__imageVersion != bitmap.__bitmapData.image.version) {
			
			ImageCanvasUtil.convertToCanvas (bitmap.__bitmapData.image);
			
			// Next line is workaround, to fix rendering bug in Chrome 59 (https://vimeo.com/222938554)
			bitmap.__canvas.width = bitmap.__bitmapData.width + 1;
			
			bitmap.__canvas.width = bitmap.__bitmapData.width;
			bitmap.__canvas.height = bitmap.__bitmapData.height;
			
			bitmap.__context.drawImage (bitmap.__bitmapData.image.buffer.__srcCanvas, 0, 0);
			bitmap.__imageVersion = bitmap.__bitmapData.image.version;
			
		}
		
		DOMRenderer.updateClip (bitmap, renderSession);
		DOMRenderer.applyStyle (bitmap, renderSession, true, true, true);
		#end
		
	}
	
	
	private static function renderImage (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (bitmap.__canvas != null) {
			
			renderSession.element.removeChild (bitmap.__canvas);
			bitmap.__canvas = null;
			
		}
		
		if (bitmap.__image == null) {
			
			bitmap.__image = cast Browser.document.createElement ("img");
			bitmap.__image.crossOrigin = "Anonymous";
			bitmap.__image.src = bitmap.__bitmapData.image.buffer.__srcImage.src;
			DOMRenderer.initializeElement (bitmap, bitmap.__image, renderSession);
			
		}
		
		DOMRenderer.updateClip (bitmap, renderSession);
		DOMRenderer.applyStyle (bitmap, renderSession, true, true, true);
		#end
		
	}
	
	
}
