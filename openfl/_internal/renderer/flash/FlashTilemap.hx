package openfl._internal.renderer.flash;


import openfl.display.BitmapData;
import openfl.display.Tilemap;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.display.Tilemap)


class FlashTilemap {
	
	
	public static inline function render (tilemap:Tilemap):Void {
		
		#if flash
		var bitmapData = tilemap.bitmapData;
		
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, 0);
		
		var tiles, count, tile, tileData, sourceBitmapData;
		var sourceRect = new Rectangle ();
		var destPoint = new Point ();
		
		if (tilemap.__tiles.length > 0) {
			
			tiles = tilemap.__tiles;
			count = tiles.length;
			
			for (i in 0...count) {
				
				tile = tiles[i];
				tileData = tile.tileData;
				sourceBitmapData = tileData.bitmapData;
				
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
		#end
		
	}
	
	
}