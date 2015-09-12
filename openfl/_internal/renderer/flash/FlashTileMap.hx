package openfl._internal.renderer.flash;


import openfl.display.BitmapData;
import openfl.display.TileMap;
import openfl.geom.Point;

@:access(openfl.display.TileLayer)
@:access(openfl.display.TileMap)
@:access(openfl.display.TileSet)


class FlashTileMap {
	
	
	public static inline function render (tileMap:TileMap):Void {
		
		#if flash
		var bitmapData = tileMap.bitmapData;
		
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, 0);
		
		var sourceBitmapData, tiles, count, tile;
		var cacheTileID = -1;
		var sourceRect = null;
		var destPoint = new Point ();
		
		for (layer in tileMap.__layers) {
			
			if (layer.__tiles.length == 0 || layer.tileSet == null || layer.tileSet.bitmapData == null) continue;
			
			sourceBitmapData = layer.tileSet.bitmapData;
			
			tiles = layer.__tiles;
			count = tiles.length;
			
			for (i in 0...count) {
				
				tile = tiles[i];
				
				if (tile.id != cacheTileID) {
					
					sourceRect = layer.tileSet.__rects[tile.id];
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