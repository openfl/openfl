package openfl._internal.renderer.cairo;


import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoFormat;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
import lime.math.Matrix3;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.geom.Matrix)


class CairoTilemap {
	
	
	public static inline function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (!tilemap.__renderable || tilemap.__tiles.length == 0 || tilemap.__worldAlpha <= 0) return;
		
		var cairo = renderSession.cairo;
		
		renderSession.maskManager.pushObject (tilemap);
		
		var transform = tilemap.__worldTransform;
		
		if (renderSession.roundPixels) {
			
			var matrix = transform.__toMatrix3 ();
			matrix.tx = Math.round (matrix.tx);
			matrix.ty = Math.round (matrix.ty);
			cairo.matrix = matrix;
			
		} else {
			
			cairo.matrix = transform.__toMatrix3 ();
			
		}
		
		var defaultTileset = tilemap.tileset;
		var cacheBitmapData = null;
		var surface = null;
		var pattern = null;
		
		var tiles, count, tile, tileset, tileData, bitmapData;
		
		tiles = tilemap.__tiles;
		count = tiles.length;
		
		var matrix = new Matrix3 ();
		
		for (i in 0...count) {
			
			tile = tiles[i];
			tileset = (tile.tileset != null) ? tile.tileset : defaultTileset;
			
			if (tileset == null) continue;
			
			tileData = tileset.__data[tile.id];
			bitmapData = tileset.bitmapData;
			
			if (bitmapData == null) continue;
			
			if (bitmapData != cacheBitmapData) {
				
				surface = bitmapData.getSurface ();
				pattern = CairoPattern.createForSurface (surface);
				pattern.filter = tilemap.smoothing ? CairoFilter.GOOD : CairoFilter.NEAREST;
				
				cairo.source = pattern;
				cacheBitmapData = bitmapData;
				
			}
			
			matrix.tx = tileData.x - tile.x;
			matrix.ty = tileData.y - tile.y;
			pattern.matrix = matrix;
			
			cairo.rectangle (tile.x, tile.y, tileData.width, tileData.height);
			
			// TODO: Handle tile scale and rotation?
			
			if (tilemap.__worldAlpha == 1) {
				
				cairo.paint ();
				
			} else {
				
				cairo.paintWithAlpha (tilemap.__worldAlpha);
				
			}
			
		}
		
		renderSession.maskManager.popObject (tilemap);
		
	}
	
	
}
