package openfl._internal.renderer.flash;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)


class FlashTilemap {
	
	
	public static inline function render (tilemap:Tilemap):Void {
		
		#if flash
		if (tilemap.stage == null || !tilemap.visible || tilemap.alpha <= 0) return;
		
		var bitmapData = tilemap.bitmapData;
		
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, 0);
		
		var smoothing = tilemap.smoothing;
		
		var tiles, count, tile, alpha, visible, tileset, tileData, sourceBitmapData, matrix;
		var sourceRect = new Rectangle ();
		var destPoint = new Point ();
		
		var colorTransform = new ColorTransform ();
		
		if (tilemap.__tiles.length > 0) {
			
			tiles = tilemap.__tiles;
			count = tiles.length;
			
			for (i in 0...count) {
				
				tile = tiles[i];
				
				alpha = tile.alpha;
				visible = tile.visible;
				
				if (!visible || alpha <= 0) continue;
				
				tileset = (tile.tileset != null) ? tile.tileset : tilemap.tileset;
				
				if (tileset == null) continue;
				
				tileData = tileset.__data[tile.id];
				
				if (tileData == null) continue;
				
				sourceBitmapData = tileData.__bitmapData;
				matrix = tile.matrix;
				
				if (sourceBitmapData == null || alpha == 0) continue;
				
				if (alpha == 1 && matrix.a == 1 && matrix.b == 0 && matrix.c == 0 && matrix.d == 1) {
					
					destPoint.x = tile.x;
					destPoint.y = tile.y;
					
					bitmapData.copyPixels (sourceBitmapData, sourceBitmapData.rect, destPoint, null, null, true);
					
				} else {
					
					colorTransform.alphaMultiplier = alpha;
					
					bitmapData.draw (sourceBitmapData, matrix, colorTransform, null, null, smoothing);
					
				}
				
			}
			
		}
		
		bitmapData.unlock ();
		#end
		
	}
	
	
}