package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;

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
		var transform = tilemap.__worldTransform;
		
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
		
		var tileWidth = 0.0;
		var tileHeight = 0.0;
		var cacheTileID = -1;
		
		var tiles, count, tile, source;
		
		for (layer in tilemap.__layers) {
			
			if (layer.__tiles.length == 0 || layer.tileset == null || layer.tileset.bitmapData == null) continue;
			
			source = layer.tileset.bitmapData.image.src;
			
			tiles = layer.__tiles;
			count = tiles.length;
			
			for (i in 0...count) {
				
				tile = tiles[i];
				
				if (tile.id != cacheTileID) {
					
					tileWidth = layer.tileset.__rects[tile.id].width;
					tileHeight = layer.tileset.__rects[tile.id].height;
					cacheTileID = tile.id;
					
				}
				
				context.drawImage (source, 0, 0, tileWidth, tileHeight, tile.x, tile.y, tileWidth, tileHeight);
				
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