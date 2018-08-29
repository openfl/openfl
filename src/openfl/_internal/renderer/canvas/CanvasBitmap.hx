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
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid && bitmap.__bitmapData.__canBeDrawnToCanvas ()) {
			
			renderSession.blendModeManager.setBlendMode (bitmap.__worldBlendMode);
			renderSession.maskManager.pushObject (bitmap, false);

			if (!renderSession.allowSmoothing || !bitmap.smoothing) {
				
				CanvasSmoothing.setEnabled(context, false);
				
			}
			
			context.globalAlpha = bitmap.__worldAlpha;
			bitmap.__bitmapData.__drawToCanvas (context, bitmap.__renderTransform, renderSession.roundPixels || bitmap.__snapToPixel (), renderSession.pixelRatio, bitmap.__scrollRect, true);

			if (!renderSession.allowSmoothing || !bitmap.smoothing) {
				
				CanvasSmoothing.setEnabled(context, true);
				
			}
			
			renderSession.maskManager.popObject (bitmap, false);
			
		}
		#end
		
	}
	
	
}