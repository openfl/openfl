package openfl._internal.renderer.canvas;


import lime.graphics.utils.ImageCanvasUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.TileGroup;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Tile)
@:access(openfl.display.TileGroup)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class CanvasTilemap {
	
	
	public static inline function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!tilemap.__renderable || tilemap.__group.__tiles.length == 0 || tilemap.__worldAlpha <= 0) return;
		
		renderSession.blendModeManager.setBlendMode (tilemap.__worldBlendMode);
		renderSession.maskManager.pushObject (tilemap);
		
		var rect = Rectangle.__pool.get ();
		rect.setTo (0, 0, tilemap.__width, tilemap.__height);
		renderSession.maskManager.pushRect (rect, tilemap.__renderTransform);
		
		if (!renderSession.allowSmoothing || !tilemap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = false;
			//untyped (context).webkitImageSmoothingEnabled = false;
			untyped (context).msImageSmoothingEnabled = false;
			untyped (context).imageSmoothingEnabled = false;
			
		}
		
		renderTileGroup (tilemap.__group, renderSession, tilemap.__renderTransform, tilemap.__tileset, (renderSession.allowSmoothing && tilemap.smoothing), tilemap.tileAlphaEnabled, tilemap.__worldAlpha, null, null, rect);
		
		if (!renderSession.allowSmoothing || !tilemap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = true;
			//untyped (context).webkitImageSmoothingEnabled = true;
			untyped (context).msImageSmoothingEnabled = true;
			untyped (context).imageSmoothingEnabled = true;
			
		}
		
		renderSession.maskManager.popRect ();
		renderSession.maskManager.popObject (tilemap);
		
		Rectangle.__pool.release (rect);
		#end
		
	}
	
	
	private static function renderTileGroup (group:TileGroup, renderSession:RenderSession, parentTransform:Matrix, defaultTileset:Tileset, smooth:Bool, alphaEnabled:Bool, worldAlpha:Float, cacheBitmapData:BitmapData, source:Dynamic, rect:Rectangle):Void {
		
		#if (js && html5)
		var context = renderSession.context;
		var roundPixels = renderSession.roundPixels;
		
		var tileTransform = Matrix.__pool.get ();
		
		var tiles = group.__tiles;
		var length = group.__length;
		
		var tile, tileset, alpha, visible, id, tileData, tileRect, bitmapData;
		
		for (i in 0...length) {
			
			tile = tiles[i];
			
			tileTransform.setTo (1, 0, 0, 1, -tile.originX, -tile.originY);
			tileTransform.concat (tile.matrix);
			tileTransform.concat (parentTransform);
			
			if (roundPixels) {
				
				tileTransform.tx = Math.round (tileTransform.tx);
				tileTransform.ty = Math.round (tileTransform.ty);
				
			}
			
			tileset = tile.tileset != null ? tile.tileset : defaultTileset;
			
			alpha = tile.alpha * worldAlpha;
			visible = tile.visible;
			if (!visible || alpha <= 0) continue;
			
			if (!alphaEnabled) alpha = 1;
			
			if (tile.__length > 0) {
				
				renderTileGroup (cast tile, renderSession, tileTransform, tileset, smooth, alphaEnabled, alpha, cacheBitmapData, source, rect);
				
			} else {
				
				if (tileset == null) continue;
				
				id = tile.id;
				
				if (id == -1) {
					
					tileRect = tile.rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0) continue;
					
				} else {
					
					tileData = tileset.__data[id];
					if (tileData == null) continue;
					
					rect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
					tileRect = rect;
					
				}
				
				bitmapData = tileset.__bitmapData;
				if (bitmapData == null) continue;
				
				if (bitmapData != cacheBitmapData) {
					
					if (bitmapData.image.buffer.__srcImage == null) {
						
						ImageCanvasUtil.convertToCanvas (bitmapData.image);
						
					}
					
					source = bitmapData.image.src;
					cacheBitmapData = bitmapData;
					
				}
				
				context.globalAlpha = alpha;
				
				context.setTransform (tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, tileTransform.tx, tileTransform.ty);
				context.drawImage (source, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width, tileRect.height);
				
			}
			
		}
		
		Matrix.__pool.release (tileTransform);
		#end
		
	}
	
	
}