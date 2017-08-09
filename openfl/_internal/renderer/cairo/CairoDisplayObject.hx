package openfl._internal.renderer.cairo;


import lime.math.color.ARGB;
import openfl.display.DisplayObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)


class CairoDisplayObject {
	
	
	public static function render (displayObject:DisplayObject, renderSession:RenderSession):Void {
		
		#if lime_cairo
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;
		
		if (displayObject.opaqueBackground != null && !displayObject.__cacheBitmapRender && displayObject.width > 0 && displayObject.height > 0) {
			
			renderSession.blendModeManager.setBlendMode (displayObject.__worldBlendMode);
			renderSession.maskManager.pushObject (displayObject);
			
			var cairo = renderSession.cairo;
			
			if (renderSession.roundPixels) {
				
				var matrix = displayObject.__renderTransform.__toMatrix3 ();
				matrix.tx = Math.round (matrix.tx);
				matrix.ty = Math.round (matrix.ty);
				cairo.matrix = matrix;
				
			} else {
				
				cairo.matrix = displayObject.__renderTransform.__toMatrix3 ();
				
			}
			
			var color:ARGB = (displayObject.opaqueBackground:ARGB);
			cairo.setSourceRGB (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF);
			cairo.rectangle (0, 0, displayObject.width, displayObject.height);
			cairo.fill ();
			
			renderSession.maskManager.popObject (displayObject);
			
		}
		
		if (displayObject.__graphics != null) {
			
			CairoShape.render (displayObject, renderSession);
			
		}
		#end
		
	}
	
	
}