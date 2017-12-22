package openfl._internal.renderer.cairo;


import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoFormat;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
import lime.math.Matrix3;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class CairoTilemap {
	
	
	public static inline function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (!tilemap.__renderable || tilemap.__worldAlpha <= 0) return;
		
		tilemap.__updateTileArray ();
		
		if (tilemap.__tileArray == null || tilemap.__tileArray.length == 0) return;
		
		var cairo = renderSession.cairo;
		
		renderSession.blendModeManager.setBlendMode (tilemap.__worldBlendMode);
		renderSession.maskManager.pushObject (tilemap);
		
		var rect = Rectangle.__pool.get ();
		rect.setTo (0, 0, tilemap.__width, tilemap.__height);
		renderSession.maskManager.pushRect (rect, tilemap.__renderTransform);
		
		var transform = tilemap.__renderTransform;
		var roundPixels = renderSession.roundPixels;
		
		var defaultTileset = tilemap.__tileset;
		var cacheBitmapData = null;
		var surface = null;
		var pattern = null;
		
		var alpha, visible, tileset, id, tileData, bitmapData;
		
		var tileArray = tilemap.__tileArray;
		
		var matrix = new Matrix3 ();
		var tileTransform, tileRect = null;
		
		for (tile in tileArray) {
			
			alpha = tile.alpha;
			visible = tile.visible;
			if (!visible || alpha <= 0) continue;
			
			tileset = tile.tileset;
			if (tileset == null) tileset = defaultTileset;
			if (tileset == null) continue;
			
			id = tile.id;
			
			if (id == -1) {
				
				tileRect = tile.rect;
				if (tileRect.width <= 0 || tileRect.height <= 0) continue;
				
			} else {
				
				tileData = tileset.__data[id];
				if (tileData == null) continue;
				
				rect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
				tile.rect = rect;
				tileRect = rect;
				
			}
			
			bitmapData = tileset.bitmapData;
			if (bitmapData == null) continue;
			
			if (bitmapData != cacheBitmapData) {
				
				surface = bitmapData.getSurface ();
				pattern = CairoPattern.createForSurface (surface);
				pattern.filter = (renderSession.allowSmoothing && tilemap.smoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;
				
				cairo.source = pattern;
				cacheBitmapData = bitmapData;
				
			}
			
			tileTransform = tile.matrix;
			tileTransform.concat (transform);
			
			if (roundPixels) {
				
				tileTransform.tx = Math.round (tileTransform.tx);
				tileTransform.ty = Math.round (tileTransform.ty);
				
			}
			
			cairo.matrix = tileTransform.__toMatrix3 ();
			
			matrix.tx = tileRect.x;
			matrix.ty = tileRect.y;
			pattern.matrix = matrix;
			cairo.source = pattern;
			
			cairo.save ();
			
			cairo.newPath ();
			cairo.rectangle (0, 0, tileRect.width, tileRect.height);
			cairo.clip ();
			
			if (tilemap.__worldAlpha == 1 && alpha == 1) {
				
				cairo.paint ();
				
			} else {
				
				cairo.paintWithAlpha (tilemap.__worldAlpha * alpha);
				
			}
			
			cairo.restore ();
			
		}
		
		renderSession.maskManager.popRect ();
		renderSession.maskManager.popObject (tilemap);
		
		Rectangle.__pool.release (rect);
		
	}
	
	
}
