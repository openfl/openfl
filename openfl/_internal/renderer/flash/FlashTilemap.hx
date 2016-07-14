package openfl._internal.renderer.flash;


import openfl.display.BitmapData;
import openfl.display.Tilemap;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.display.Tilemap)
@:access(openfl.display.TilemapData)
@:access(openfl.display.Tileset)


class FlashTilemap {
	
	
	public static inline function render (tilemap:Tilemap):Void {
		
		#if flash
		if (tilemap.stage == null || !tilemap.visible || tilemap.alpha <= 0) return;
		
		var tilemapData = tilemap.tilemapData;
		
		if (tilemapData != null) {
			
			var bitmapData = tilemapData.__bitmapData;
			
			bitmapData.lock ();
			bitmapData.fillRect (bitmapData.rect, 0);
			
			var tiles, count, tile, tileset, tileData, sourceBitmapData;
			var sourceRect = new Rectangle ();
			var destPoint = new Point ();
			
			if (tilemapData.__tiles.length > 0) {
				
				tiles = tilemapData.__tiles;
				count = tiles.length;
				
				for (i in 0...count) {
					
					tile = tiles[i];
					tileset = (tile.tileset != null ? tile.tileset : tilemapData.tileset);
					
					if (tileset == null) continue;
					
					tileData = tileset.__data[tile.id];
					sourceBitmapData = tileset.bitmapData;
					
					if (sourceBitmapData == null) continue;
					
					sourceRect.x = tileData.x;
					sourceRect.y = tileData.y;
					sourceRect.width = tileData.width;
					sourceRect.height = tileData.height;
					
					destPoint.x = tile.x;
					destPoint.y = tile.y;
					
					bitmapData.copyPixels (sourceBitmapData, sourceRect, destPoint, null, null, true);
					
				}
				
			}
			
			bitmapData.unlock ();
			
		}
		#end
		
	}
	
	
}