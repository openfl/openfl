package openfl._internal.renderer.dom;


import openfl._internal.renderer.canvas.CanvasTilemap;
import openfl.display.Tilemap;
import openfl.geom.Matrix;

#if (js && html5)
import js.Browser;
#end

@:access(openfl.display.Tilemap)
@:access(openfl.geom.Matrix)


class DOMTilemap {
	
	
	public static function clear (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (tilemap.__canvas != null) {
			
			renderSession.element.removeChild (tilemap.__canvas);
			tilemap.__canvas = null;
			tilemap.__style = null;
			
		}
		#end
		
	}
	
	
	public static inline function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (tilemap.stage != null && tilemap.__worldVisible && tilemap.__renderable && tilemap.__tiles.length > 0) {
			
			if (tilemap.__canvas == null) {
				
				tilemap.__canvas = cast Browser.document.createElement ("canvas");
				tilemap.__context = tilemap.__canvas.getContext ("2d");
				DOMRenderer.initializeElement (tilemap, tilemap.__canvas, renderSession);
				
			}
			
			tilemap.__canvas.width = tilemap.__width;
			tilemap.__canvas.height = tilemap.__height;
			
			tilemap.__context.globalAlpha = tilemap.__worldAlpha;
			
			renderSession.context = tilemap.__context;
			
			CanvasTilemap.render (tilemap, renderSession);
			
			renderSession.context = null;
			
			DOMRenderer.updateClip (tilemap, renderSession);
			DOMRenderer.applyStyle (tilemap, renderSession, true, false, true);
			
		} else {
			
			clear (tilemap, renderSession);
			
		}
		#end
		
	}
	
	
	
}