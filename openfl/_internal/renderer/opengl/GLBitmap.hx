package openfl._internal.renderer.opengl;


import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class GLBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0 || bitmap.bitmapData == null || !bitmap.bitmapData.__isValid) return;
		
		renderSession.spriteBatch.renderBitmapData(bitmap.bitmapData, bitmap.smoothing, bitmap.__renderMatrix, bitmap.__worldColorTransform, bitmap.__worldAlpha, bitmap.__blendMode, bitmap.pixelSnapping);
	}
	
	
}