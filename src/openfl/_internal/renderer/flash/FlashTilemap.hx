package openfl._internal.renderer.flash;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.display.Tile)
@:access(openfl.display.TileContainer)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)


class FlashTilemap {
	
	
	private static var alphaColorTransform = new ColorTransform ();
	private static var bitmap = new Bitmap ();
	private static var destPoint = new Point ();
	private static var sourceRect = new Rectangle ();
	
	
	public static inline function render (tilemap:Tilemap):Void {
		
		// TODO: Do not render if top-level group is not dirty
		
		#if flash
		if (tilemap.stage == null || !tilemap.visible || tilemap.alpha <= 0 || tilemap.__group.__tiles.length == 0) return;
		
		var bitmapData = tilemap.bitmapData;
		
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, 0);
		
		renderTileContainer (tilemap.__group, bitmapData, new Matrix (), tilemap.__tileset, tilemap.smoothing, tilemap.tileAlphaEnabled, 1, tilemap.tileColorTransformEnabled, null, null);
		
		bitmapData.unlock ();
		#end
		
	}
	
	
	private static function renderTileContainer (group:TileContainer, bitmapData:BitmapData, parentTransform:Matrix, defaultTileset:Tileset, smooth:Bool, alphaEnabled:Bool, worldAlpha:Float, colorTransformEnabled:Bool, defaultColorTransform:ColorTransform, cacheBitmapData:BitmapData):Void {
		
		#if flash
		var tileTransform = new Matrix ();
		
		var tiles = group.__tiles;
		var length = group.__length;
		
		var tile, tileset, alpha, visible, colorTransform = null, id, tileData, tileRect, sourceBitmapData, cacheAlpha;
		
		for (i in 0...length) {
			
			tile = tiles[i];
			
			tileTransform.setTo (1, 0, 0, 1, -tile.originX, -tile.originY);
			tileTransform.concat (tile.matrix);
			tileTransform.concat (parentTransform);
			
			// if (roundPixels) {
				
			// 	tileTransform.tx = Math.round (tileTransform.tx);
			// 	tileTransform.ty = Math.round (tileTransform.ty);
				
			// }
			
			tileset = tile.tileset != null ? tile.tileset : defaultTileset;
			
			alpha = tile.alpha * worldAlpha;
			visible = tile.visible;
			if (!visible || alpha <= 0) continue;
			
			if (colorTransformEnabled) {
				
				if (tile.colorTransform != null) {
					
					if (defaultColorTransform == null) {
						
						colorTransform = tile.colorTransform;
						
					} else {
						
						colorTransform = new ColorTransform ();
						colorTransform.redMultiplier = defaultColorTransform.redMultiplier * tile.colorTransform.redMultiplier;
						colorTransform.greenMultiplier = defaultColorTransform.greenMultiplier * tile.colorTransform.greenMultiplier;
						colorTransform.blueMultiplier = defaultColorTransform.blueMultiplier * tile.colorTransform.blueMultiplier;
						colorTransform.alphaMultiplier = defaultColorTransform.alphaMultiplier * tile.colorTransform.alphaMultiplier;
						colorTransform.redOffset = defaultColorTransform.redOffset + tile.colorTransform.redOffset;
						colorTransform.greenOffset = defaultColorTransform.greenOffset + tile.colorTransform.greenOffset;
						colorTransform.blueOffset = defaultColorTransform.blueOffset + tile.colorTransform.blueOffset;
						colorTransform.alphaOffset = defaultColorTransform.alphaOffset + tile.colorTransform.alphaOffset;
						
					}
					
				} else {
					
					colorTransform = defaultColorTransform;
					
				}
				
			}
			
			if (!alphaEnabled) alpha = 1;
			
			if (tile.__length > 0) {
				
				renderTileContainer (cast tile, bitmapData, tileTransform, tileset, smooth, alphaEnabled, alpha, colorTransformEnabled, colorTransform, cacheBitmapData);
				
			} else {
				
				if (tileset == null) continue;
				
				id = tile.id;
				
				if (id == -1) {
					
					tileRect = tile.rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0) continue;
					
				} else {
					
					tileData = tileset.__data[id];
					if (tileData == null) continue;
					
					sourceRect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
					tileRect = sourceRect;
					
				}
				
				sourceBitmapData = tileset.__bitmapData;
				if (sourceBitmapData == null) continue;
				
				if (colorTransform != null) {
					
					cacheAlpha = colorTransform.alphaMultiplier;
					colorTransform.alphaMultiplier *= alpha;
					
					bitmap.bitmapData = sourceBitmapData;
					bitmap.smoothing = smooth;
					bitmap.scrollRect = sourceRect;
					
					bitmapData.draw (bitmap, tileTransform, colorTransform, null, null, smooth);
					
					colorTransform.alphaMultiplier = cacheAlpha;
					
				} else if (alpha == 1 && tileTransform.a == 1 && tileTransform.b == 0 && tileTransform.c == 0 && tileTransform.d == 1) {
					
					destPoint.x = tileTransform.tx;
					destPoint.y = tileTransform.ty;
					
					bitmapData.copyPixels (sourceBitmapData, sourceRect, destPoint, null, null, true);
					
				} else if (alphaEnabled) {
					
					alphaColorTransform.alphaMultiplier = alpha;
					
					bitmap.bitmapData = sourceBitmapData;
					bitmap.smoothing = smooth;
					bitmap.scrollRect = sourceRect;
					
					bitmapData.draw (bitmap, tileTransform, alphaColorTransform, null, null, smooth);
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}