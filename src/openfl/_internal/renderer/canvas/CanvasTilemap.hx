package openfl._internal.renderer.canvas;


import lime.graphics.utils.ImageCanvasUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class CanvasTilemap {
	
	
	public static inline function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		if (!tilemap.__renderable || tilemap.__worldAlpha <= 0) return;
		
		tilemap.__updateTileArray ();
		
		if (tilemap.__tileArray == null || tilemap.__tileArray.length == 0) return;
		
		var context = renderSession.context;
		
		renderSession.blendModeManager.setBlendMode (tilemap.__worldBlendMode);
		renderSession.maskManager.pushObject (tilemap);
		
		var rect = Rectangle.__pool.get ();
		rect.setTo (0, 0, tilemap.__width, tilemap.__height);
		renderSession.maskManager.pushRect (rect, tilemap.__renderTransform);
		
		var transform = tilemap.__renderTransform;
		var roundPixels = renderSession.roundPixels || tilemap.__snapToPixel ();
		
		if (!renderSession.allowSmoothing || !tilemap.smoothing) {
			
			CanvasSmoothing.setEnabled(context, false);
			
		}
		
		var defaultTileset = tilemap.__tileset;
		var cacheBitmapData = null;
		var source = null;
		
		var alpha, visible, tileset, id, tileData, bitmapData;
		
		var tileArray = tilemap.__tileArray;
		
		var tileTransform;
		var tileRect = Rectangle.__pool.get ();
		
		for (tile in tileArray) {
			
			alpha = tile.alpha;
			visible = tile.visible;
			if (!visible || alpha <= 0) continue;
			
			tileset = tile.tileset;
			if (tileset == null) tileset = defaultTileset;
			if (tileset == null) continue;
			
			id = tile.id;
			
			if (id == -1) {
				
				tileRect.copyFrom (tile.rect);
				if (tileRect.width <= 0 || tileRect.height <= 0) continue;
				
			} else {
				
				tileData = tileset.__data[id];
				if (tileData == null) continue;
				
				tileRect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
				
			}
			
			bitmapData = tileset.bitmapData;
			if (bitmapData == null || !bitmapData.__prepareImage()) continue;
			
			if (bitmapData != cacheBitmapData) {
				
				if (bitmapData.image.buffer.__srcImage == null) {
					
					ImageCanvasUtil.convertToCanvas (bitmapData.image);
					
				}
				
				source = bitmapData.image.src;
				cacheBitmapData = bitmapData;
				
			}
			
			context.globalAlpha = tilemap.__worldAlpha * alpha;
			
			tileTransform = tile.matrix;
			tileTransform.concat (transform);
			var pixelRatio = renderSession.pixelRatio;
			
			if (roundPixels) {
				
				context.setTransform (tileTransform.a * pixelRatio, tileTransform.b, tileTransform.c, tileTransform.d * pixelRatio, Math.round (tileTransform.tx * pixelRatio), Math.round (tileTransform.ty * pixelRatio));
				
			} else {
				
				context.setTransform (tileTransform.a * pixelRatio, tileTransform.b, tileTransform.c, tileTransform.d * pixelRatio, tileTransform.tx * pixelRatio, tileTransform.ty * pixelRatio);
				
			}
			
			context.drawImage (source, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width, tileRect.height);
			
		}
		
		if (!renderSession.allowSmoothing || !tilemap.smoothing) {
			
			CanvasSmoothing.setEnabled(context, true);
			
		}
		
		renderSession.maskManager.popRect ();
		renderSession.maskManager.popObject (tilemap);
		
		Rectangle.__pool.release (rect);
		Rectangle.__pool.release (tileRect);
		
		#end
		
	}
	
	
}