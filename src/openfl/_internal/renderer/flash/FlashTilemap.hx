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
	
	
	private static var defaultColorTransform = new ColorTransform ();
	private static var destPoint = new Point ();
	private static var sourceRect = new Rectangle ();
	
	
	public static inline function render (tilemap:Tilemap):Void {
		
		#if flash
		if (tilemap.stage == null || !tilemap.visible || tilemap.alpha <= 0) return;
		
		tilemap.__updateTileArray ();
		
		if (tilemap.__tileArray == null || tilemap.__tileArray.length == 0) return;
		
		var defaultTileset = tilemap.__tileset;
		var bitmapData = tilemap.bitmapData;
		
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, 0);
		
		var smoothing = tilemap.smoothing;
		
		var alpha, visible, colorTransform;
		var tileset, id, tileData, sourceBitmapData;
		
		var tileArray = tilemap.__tileArray;
		var tileMatrix, cacheAlpha;
		
		for (tile in tileArray) {
			
			alpha = tile.alpha;
			visible = tile.visible;
			if (!visible || alpha <= 0) continue;
			
			tileset = tile.tileset;
			if (tileset == null) tileset = defaultTileset;
			if (tileset == null) continue;
			
			id = tile.id;
			
			if (id == -1) {
				
				// TODO: Support arbitrary source rect
				//tile.getRect (tileRect);
				continue;
				
			} else {
				
				tileData = tileset.__data[id];
				if (tileData == null) continue;
				
				//tileRect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
				
			}
			
			sourceBitmapData = tileData.__bitmapData;
			if (sourceBitmapData == null) continue;
			
			colorTransform = tile.colorTransform;
			tileMatrix = tile.matrix;
			
			if (alpha == 1 && colorTransform == null && tileMatrix.a == 1 && tileMatrix.b == 0 && tileMatrix.c == 0 && tileMatrix.d == 1) {
				
				destPoint.x = tileMatrix.tx;
				destPoint.y = tileMatrix.ty;
				
				bitmapData.copyPixels (sourceBitmapData, sourceBitmapData.rect, destPoint, null, null, true);
				
			} else if (colorTransform != null) {
				
				cacheAlpha = colorTransform.alphaMultiplier;
				colorTransform.alphaMultiplier *= alpha;
				
				bitmapData.draw (sourceBitmapData, tileMatrix, colorTransform, null, null, smoothing);
				
				colorTransform.alphaMultiplier = cacheAlpha;
				
			} else {
				
				defaultColorTransform.alphaMultiplier = alpha;
				
				bitmapData.draw (sourceBitmapData, tileMatrix, defaultColorTransform, null, null, smoothing);
				
			}
			
		}
		
		bitmapData.unlock ();
		#end
		
	}
	
	
}