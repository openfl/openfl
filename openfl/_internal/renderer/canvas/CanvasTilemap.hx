package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;

@:access(openfl.display.BitmapData)
@:access(openfl.display.Tilemap)
@:access(openfl.display.TilemapLayer)
@:access(openfl.display.Tileset)


class CanvasTilemap {
	
	
	public static inline function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!tilemap.__renderable || tilemap.__worldAlpha <= 0) return;
		
		var context = renderSession.context;
		
		if (tilemap.__mask != null) {
			
			renderSession.maskManager.pushMask (tilemap.__mask);
			
		}
		
		context.globalAlpha = tilemap.__worldAlpha;
		var transform = tilemap.__renderTransform;
		
		if (renderSession.roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
		if (!tilemap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = false;
			//untyped (context).webkitImageSmoothingEnabled = false;
			untyped (context).msImageSmoothingEnabled = false;
			untyped (context).imageSmoothingEnabled = false;
			
		}
		
		var tileRect = null;
		var cacheTileID = -1;
		
		var tiles, count, tile, source, rects;
		
		for (layer in tilemap.__layers) {
			
			if (layer.__tiles.length == 0 || layer.tileset == null || layer.tileset.bitmapData == null) continue;
			
			layer.tileset.bitmapData.__sync ();
			source = layer.tileset.bitmapData.image.src;
			
			tiles = layer.__tiles;
			count = tiles.length;
			rects = layer.tileset.__rects;
			
			for (i in 0...count) {
				
				tile = tiles[i];
				
				if (tile.id != cacheTileID) {
					
					tileRect = rects[tile.id];
					cacheTileID = tile.id;
					
				}
				
				context.drawImage (source, tileRect.x, tileRect.y, tileRect.width, tileRect.height, tile.x, tile.y, tileRect.width, tileRect.height);
				
			}
			
		}
		
		if (!tilemap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = true;
			//untyped (context).webkitImageSmoothingEnabled = true;
			untyped (context).msImageSmoothingEnabled = true;
			untyped (context).imageSmoothingEnabled = true;
			
		}
		
		if (tilemap.__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		#end
		
	}
	
	
}