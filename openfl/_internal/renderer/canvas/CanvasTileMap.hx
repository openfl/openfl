package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.display.TileMap;

@:access(openfl.display.TileLayer)
@:access(openfl.display.TileMap)
@:access(openfl.display.TileSet)


class CanvasTileMap {
	
	
	public static inline function render (tileMap:TileMap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!tileMap.__renderable || tileMap.__worldAlpha <= 0) return;
		
		var context = renderSession.context;
		
		if (tileMap.__mask != null) {
			
			renderSession.maskManager.pushMask (tileMap.__mask);
			
		}
		
		context.globalAlpha = tileMap.__worldAlpha;
		var transform = tileMap.__worldTransform;
		
		if (renderSession.roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
		if (!tileMap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = false;
			//untyped (context).webkitImageSmoothingEnabled = false;
			untyped (context).msImageSmoothingEnabled = false;
			untyped (context).imageSmoothingEnabled = false;
			
		}
		
		var tileWidth = 0.0;
		var tileHeight = 0.0;
		var cacheTileID = -1;
		
		var tiles, count, tile, source;
		
		for (layer in tileMap.__layers) {
			
			if (layer.__tiles.length == 0 || layer.tileSet == null || layer.tileSet.bitmapData == null) continue;
			
			source = layer.tileSet.bitmapData.image.src;
			
			tiles = layer.__tiles;
			count = tiles.length;
			
			for (i in 0...count) {
				
				tile = tiles[i];
				
				if (tile.id != cacheTileID) {
					
					tileWidth = layer.tileSet.__rects[tile.id].width;
					tileHeight = layer.tileSet.__rects[tile.id].height;
					cacheTileID = tile.id;
					
				}
				
				context.drawImage (source, 0, 0, tileWidth, tileHeight, tile.x, tile.y, tileWidth, tileHeight);
				
			}
			
		}
		
		if (!tileMap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = true;
			//untyped (context).webkitImageSmoothingEnabled = true;
			untyped (context).msImageSmoothingEnabled = true;
			untyped (context).imageSmoothingEnabled = true;
			
		}
		
		if (tileMap.__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		#end
		
	}
	
	
}