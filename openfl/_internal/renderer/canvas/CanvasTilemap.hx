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
		var roundPixels = renderSession.roundPixels;
		
		if (!renderSession.allowSmoothing || !tilemap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = false;
			//untyped (context).webkitImageSmoothingEnabled = false;
			untyped (context).msImageSmoothingEnabled = false;
			untyped (context).imageSmoothingEnabled = false;
			
		}
		
		var defaultTileset = tilemap.tileset;
		var cacheBitmapData = null;
		var source = null;
		
		var alpha, visible, tileset, id, tileData, bitmapData;
		
		var tileArray = tilemap.__tileArray;
		var count = tileArray.length;
		
		tileArray.position = 0;
		
		var tileTransform = Matrix.__pool.get ();
		var tileRect = Rectangle.__pool.get ();
		
		for (i in 0...count) {
			
			alpha = tileArray.alpha;
			visible = tileArray.visible;
			if (!visible || alpha <= 0) continue;
			
			tileset = tileArray.tileset;
			if (tileset == null) tileset = defaultTileset;
			if (tileset == null) continue;
			
			id = tileArray.id;
			
			if (id == -1) {
				
				tileArray.getRect (tileRect);
				
			} else {
				
				tileData = tileset.__data[id];
				if (tileData == null) continue;
				
				tileRect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
				
			}
			
			bitmapData = tileset.bitmapData;
			if (bitmapData == null) continue;
			
			if (bitmapData != cacheBitmapData) {
				
				if (bitmapData.image.buffer.__srcImage == null) {
					
					ImageCanvasUtil.convertToCanvas (bitmapData.image);
					
				}
				
				source = bitmapData.image.src;
				cacheBitmapData = bitmapData;
				
			}
			
			context.globalAlpha = tilemap.__worldAlpha * alpha;
			
			tileArray.getMatrix(tileTransform);
			tileTransform.concat (transform);
			
			if (roundPixels) {
				
				context.setTransform (tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, Std.int (tileTransform.tx), Std.int (tileTransform.ty));
				
			} else {
				
				context.setTransform (tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, tileTransform.tx, tileTransform.ty);
				
			}
			
			context.drawImage (source, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width, tileRect.height);
			
			tileArray.position++;
			
		}
		
		if (!renderSession.allowSmoothing || !tilemap.smoothing) {
			
			untyped (context).mozImageSmoothingEnabled = true;
			//untyped (context).webkitImageSmoothingEnabled = true;
			untyped (context).msImageSmoothingEnabled = true;
			untyped (context).imageSmoothingEnabled = true;
			
		}
		
		renderSession.maskManager.popRect ();
		renderSession.maskManager.popObject (tilemap);
		
		Rectangle.__pool.release (rect);
		Rectangle.__pool.release (tileRect);
		Matrix.__pool.release (tileTransform);
		
		#end
		
	}
	
	
}