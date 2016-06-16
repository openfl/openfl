package openfl._internal.renderer.cairo;


import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoFormat;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.geom.Matrix)


class CairoBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		var cairo = renderSession.cairo;
		
		if (bitmap.bitmapData != null && bitmap.bitmapData.__isValid) {
			
			renderSession.maskManager.pushObject (bitmap);
			
			var transform = bitmap.__worldTransform;
			
			if (renderSession.roundPixels) {
				
				var matrix = transform.__toMatrix3 ();
				matrix.tx = Math.round (matrix.tx);
				matrix.ty = Math.round (matrix.ty);
				cairo.matrix = matrix;
				
			} else {
				
				cairo.matrix = transform.__toMatrix3 ();
				
			}
			
			var surface = bitmap.bitmapData.getSurface ();
			
			if (surface != null) {
				
				var pattern = CairoPattern.createForSurface (surface);
				pattern.filter = bitmap.smoothing ? CairoFilter.GOOD : CairoFilter.NEAREST;
				
				cairo.source = pattern;
				
				if (bitmap.__worldAlpha == 1) {
					
					cairo.paint ();
					
				} else {
					
					cairo.paintWithAlpha (bitmap.__worldAlpha);
					
				}
				
			}
			
			renderSession.maskManager.popObject (bitmap);
			
		}
		
	}
	
	
}
