package openfl._internal.renderer.cairo;


import openfl.display.DisplayObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class CairoShape {
	
	
	public static function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if lime_cairo
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CairoGraphics.render (graphics, renderSession, shape.__renderTransform);
			
			var bounds = graphics.__bounds;
			
			if (graphics.__cairo != null && graphics.__visible /*&& graphics.__commands.length > 0*/ && bounds != null && graphics.__width >= 1 && graphics.__height >= 1) {
				
				renderSession.blendModeManager.setBlendMode (shape.__worldBlendMode);
				renderSession.maskManager.pushObject (shape);
				
				var cairo = renderSession.cairo;
				
				if (renderSession.roundPixels) {
					
					var matrix = graphics.__worldTransform.__toMatrix3 ();
					matrix.tx = Math.round (matrix.tx);
					matrix.ty = Math.round (matrix.ty);
					cairo.matrix = matrix;
					
				} else {
					
					cairo.matrix = graphics.__worldTransform.__toMatrix3 ();
					
				}
				
				cairo.setSourceSurface (graphics.__cairo.target, 0, 0);
				cairo.paintWithAlpha (shape.__worldAlpha);
				
				renderSession.maskManager.popObject (shape);
				
			}
			
		}
		#end
		
	}
	
	
}