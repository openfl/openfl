package openfl._internal.renderer.cairo;


import openfl.display.CairoRenderer;
import openfl.display.DisplayObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class CairoShape {
	
	
	public static function render (shape:DisplayObject, renderer:CairoRenderer):Void {
		
		#if lime_cairo
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CairoGraphics.render (graphics, renderer, shape.__renderTransform);
			
			var bounds = graphics.__bounds;
			
			if (graphics.__cairo != null && graphics.__visible /*&& graphics.__commands.length > 0*/ && bounds != null && graphics.__width >= 1 && graphics.__height >= 1) {
				
				var cairo = renderer.cairo;
				
				renderer.__setBlendMode (shape.__worldBlendMode);
				renderer.__pushMaskObject (shape);
				
				renderer.applyMatrix (graphics.__worldTransform, cairo);
				
				cairo.setSourceSurface (graphics.__cairo.target, 0, 0);
				cairo.paintWithAlpha (shape.__worldAlpha);
				
				renderer.__popMaskObject (shape);
				
			}
			
		}
		#end
		
	}
	
	
}