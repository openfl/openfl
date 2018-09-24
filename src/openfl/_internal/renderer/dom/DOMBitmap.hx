package openfl._internal.renderer.dom;


import lime._internal.graphics.ImageCanvasUtil; // TODO
import lime.graphics.ImageBuffer;
import openfl.display.Bitmap;
import openfl.display.DOMRenderer;

#if (js && html5)
import js.Browser;
#end

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class DOMBitmap {
	
	
	public static function clear (bitmap:Bitmap, renderer:DOMRenderer):Void {
		
		#if (js && html5)
		if (bitmap.__image != null) {
			
			renderer.element.removeChild (bitmap.__image);
			bitmap.__image = null;
			bitmap.__style = null;
			
		}
		
		if (bitmap.__canvas != null) {
			
			renderer.element.removeChild (bitmap.__canvas);
			bitmap.__canvas = null;
			bitmap.__style = null;
			
		}
		#end
		
	}
	
	
	public static inline function render (bitmap:Bitmap, renderer:DOMRenderer):Void {
		
		#if (js && html5)
		if (bitmap.stage != null && bitmap.__worldVisible && bitmap.__renderable && bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid && bitmap.__bitmapData.readable) {
			
			renderer.__pushMaskObject (bitmap);
			
			if (bitmap.__bitmapData.image.buffer.__srcImage != null) {
				
				renderImage (bitmap, renderer);
				
			} else {
				
				renderCanvas (bitmap, renderer);
				
			}
			
			renderer.__popMaskObject (bitmap);
			
		} else {
			
			clear (bitmap, renderer);
			
		}
		#end
		
	}
	
	
	private static function renderCanvas (bitmap:Bitmap, renderer:DOMRenderer):Void {
		
		#if (js && html5)
		if (bitmap.__image != null) {
			
			renderer.element.removeChild (bitmap.__image);
			bitmap.__image = null;
			
		}
		
		if (bitmap.__canvas == null) {
			
			bitmap.__canvas = cast Browser.document.createElement ("canvas");
			bitmap.__context = bitmap.__canvas.getContext ("2d");
			bitmap.__imageVersion = -1;
			
			if (!renderer.__allowSmoothing || !bitmap.smoothing) {
				
				bitmap.__context.imageSmoothingEnabled = false;
				
			}
			
			renderer.__initializeElement (bitmap, bitmap.__canvas);
			
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
		
		renderer.__updateClip (bitmap);
		renderer.__applyStyle (bitmap, true, true, true);
		#end
		
	}
	
	
	private static function renderImage (bitmap:Bitmap, renderer:DOMRenderer):Void {
		
		#if (js && html5)
		if (bitmap.__canvas != null) {
			
			renderer.element.removeChild (bitmap.__canvas);
			bitmap.__canvas = null;
			
		}
		
		if (bitmap.__image == null) {
			
			bitmap.__image = cast Browser.document.createElement ("img");
			bitmap.__image.crossOrigin = "Anonymous";
			bitmap.__image.src = bitmap.__bitmapData.image.buffer.__srcImage.src;
			renderer.__initializeElement (bitmap, bitmap.__image);
			
		}
		
		renderer.__updateClip (bitmap);
		renderer.__applyStyle (bitmap, true, true, true);
		#end
		
	}
	
	
}
