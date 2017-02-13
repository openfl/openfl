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
	
	
	private static var colorTransform = new ColorTransform ();
	private static var destPoint = new Point ();
	private static var sourceRect = new Rectangle ();
	private static var tileMatrix = new Matrix ();
	
	
	public static inline function render (tilemap:Tilemap):Void {
		
		#if flash
		if (tilemap.stage == null || !tilemap.visible || tilemap.alpha <= 0) return;
		
		var bitmapData = tilemap.bitmapData;
		
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, 0);
		
		var smoothing = tilemap.smoothing;
		
		var tiles, count, tile, alpha, visible, tileset, tileData, sourceBitmapData;
		
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
				
				tileMatrix.setTo (1, 0, 0, 1, -tile.originX, -tile.originY);
				tileMatrix.concat (tile.matrix);
				
				if (sourceBitmapData == null || alpha == 0) continue;
				
				if (alpha == 1 && tileMatrix.a == 1 && tileMatrix.b == 0 && tileMatrix.c == 0 && tileMatrix.d == 1) {
					
					destPoint.x = tile.x - tile.originX;
					destPoint.y = tile.y - tile.originY;
					
					bitmapData.copyPixels (sourceBitmapData, sourceBitmapData.rect, destPoint, null, null, true);
					
				} else {
					
					colorTransform.alphaMultiplier = alpha;
					
					bitmapData.draw (sourceBitmapData, tileMatrix, colorTransform, null, null, smoothing);
					
				}
				
			}
			
		}
		
		bitmapData.unlock ();
		#end
		
	}
	
	
}