package openfl._internal.renderer.opengl;


import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.geom.Matrix;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)


class GLBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0 || bitmap.bitmapData == null || !bitmap.bitmapData.__isValid) return;
		
		renderSession.spriteBatch.renderBitmapData(bitmap.bitmapData, bitmap.smoothing, bitmap.__renderTransform, bitmap.__worldColorTransform, bitmap.__worldAlpha, bitmap.__blendMode, bitmap.pixelSnapping);
	}
	
	private static inline function flipMatrix (m:Matrix, height:Float):Void {
		
		var tx = m.tx;
		var ty = m.ty;
		m.tx = 0;
		m.ty = 0;
		m.scale (1, -1);
		m.translate (0, height);
		m.tx += tx;
		m.ty -= ty;
		
		
	}
	
}