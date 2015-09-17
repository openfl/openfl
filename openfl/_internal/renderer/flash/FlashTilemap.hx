package openfl._internal.renderer.flash;


import openfl.display.BitmapData;
import openfl.display.Tilemap;
import openfl.geom.Point;

@:access(openfl.display.Tilemap)
@:access(openfl.display.TilemapLayer)
@:access(openfl.display.Tileset)


class FlashTilemap {
	
	
	public static inline function render (tilemap:Tilemap):Void {
		
		#if flash
		var bitmapData = tilemap.bitmapData;
		
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, 0);
		
		var sourceBitmapData, tiles, count, tile;
		var cacheTileID = -1;
		var sourceRect = null;
		var destPoint = new Point ();
		
		for (layer in tilemap.__layers) {
			
			if (layer.__tiles.length == 0 || layer.tileset == null || layer.tileset.bitmapData == null) continue;
			
			sourceBitmapData = layer.tileset.bitmapData;
			
			tiles = layer.__tiles;
			count = tiles.length;
			
			for (i in 0...count) {
				
				tile = tiles[i];
				
				if (tile.id != cacheTileID) {
					
					sourceRect = layer.tileset.__rects[tile.id];
					cacheTileID = tile.id;
					
				}
				
				destPoint.x = tile.x;
				destPoint.y = tile.y;
				
				bitmapData.copyPixels (sourceBitmapData, sourceRect, destPoint, null, null, true);
				
			}
			
		}
		
		bitmapData.unlock ();
		
		#end
		
	}
	
	
}