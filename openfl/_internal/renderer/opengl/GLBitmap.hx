package openfl._internal.renderer.opengl;


import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

@:access(openfl.display.Bitmap)


class GLBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		renderSession.spriteBatch2.renderBitmapData(bitmap.bitmapData, bitmap.__worldTransform, bitmap.__worldColorTransform, bitmap.__worldAlpha, bitmap.blendMode);
	}
	
	
}