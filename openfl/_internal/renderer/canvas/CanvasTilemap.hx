package openfl._internal.renderer.canvas;


import lime.graphics.utils.ImageCanvasUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)


class CanvasTilemap {
	
	
	public static inline function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		if (!tilemap.__renderable || tilemap.__tiles.length == 0 || tilemap.__worldAlpha <= 0) return;
		
		var context = renderSession.context;
		
		renderSession.maskManager.pushObject (tilemap);
		
		context.globalAlpha = tilemap.__worldAlpha;
		var transform = tilemap.__worldTransform;
		var roundPixels = renderSession.roundPixels;
		
		if (!tilemap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = false;
			//untyped (context).webkitImageSmoothingEnabled = false;
			untyped (context).msImageSmoothingEnabled = false;
			untyped (context).imageSmoothingEnabled = false;
			
		}
		
		var defaultTileset = tilemap.tileset;
		var cacheBitmapData = null;
		var source = null;
		
		var tiles, count, tile, tileset, tileData, bitmapData, tileTransform;
		
		tiles = tilemap.__tiles;
		count = tiles.length;
		
		for (i in 0...count) {
			
			tile = tiles[i];
			tileset = (tile.tileset != null) ? tile.tileset : defaultTileset;
			
			if (tileset == null) continue;
			
			tileData = tileset.__data[tile.id];
			bitmapData = tileset.bitmapData;
			
			if (bitmapData == null) continue;
			
			if (bitmapData != cacheBitmapData) {
				
				if (bitmapData.image.buffer.__srcImage == null) {
					
					ImageCanvasUtil.convertToCanvas (bitmapData.image);
					
				}
				
				source = bitmapData.image.src;
				cacheBitmapData = bitmapData;
				
			}
			
			tileTransform = transform.clone ();
			tileTransform.concat (tile.matrix);
			
			if (roundPixels) {
				
				context.setTransform (tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, Std.int (tileTransform.tx), Std.int (tileTransform.ty));
				
			} else {
				
				context.setTransform (tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, tileTransform.tx, tileTransform.ty);
				
			}
			
			context.drawImage (source, tileData.x, tileData.y, tileData.width, tileData.height, 0, 0, tileData.width, tileData.height);
			
		}
		
		if (!tilemap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = true;
			//untyped (context).webkitImageSmoothingEnabled = true;
			untyped (context).msImageSmoothingEnabled = true;
			untyped (context).imageSmoothingEnabled = true;
			
		}
		
		renderSession.maskManager.popObject (tilemap);
		
		#end
		
	}
	
	
}