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
		
		tilemap.__updateTileArray ();
		
		if (tilemap.__tileArray == null || tilemap.__tileArray.length == 0) return;
		
		var defaultTileset = tilemap.tileset;
		var bitmapData = tilemap.bitmapData;
		
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, 0);
		
		var smoothing = tilemap.smoothing;
		
		var alpha, visible, tileset, id, tileData, sourceBitmapData;
		
		var tileArray = tilemap.__tileArray;
		var count = tileArray.length;
		
		if (count > 0) {
			
			tileArray.position = 0;
			
			for (i in 0...count) {
				
				alpha = tileArray.alpha;
				visible = tileArray.visible;
				if (!visible || alpha <= 0) continue;
				
				tileset = tileArray.tileset;
				if (tileset == null) tileset = defaultTileset;
				if (tileset == null) continue;
				
				id = tileArray.id;
				
				if (id == -1) {
					
					// TODO: Support arbitrary source rect
					//tileArray.getRect (tileRect);
					continue;
					
				} else {
					
					tileData = tileset.__data[id];
					if (tileData == null) continue;
					
					//tileRect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
					
				}
				
				sourceBitmapData = tileData.__bitmapData;
				if (sourceBitmapData == null) continue;
				
				tileArray.getMatrix(tileMatrix);
				
				if (alpha == 1 && tileMatrix.a == 1 && tileMatrix.b == 0 && tileMatrix.c == 0 && tileMatrix.d == 1) {
					
					destPoint.x = tileMatrix.tx;
					destPoint.y = tileMatrix.ty;
					
					bitmapData.copyPixels (sourceBitmapData, sourceBitmapData.rect, destPoint, null, null, true);
					
				} else {
					
					colorTransform.alphaMultiplier = alpha;
					
					bitmapData.draw (sourceBitmapData, tileMatrix, colorTransform, null, null, smoothing);
					
				}
				
				tileArray.position++;
				
			}
			
		}
		
		bitmapData.unlock ();
		#end
		
	}
	
	
}