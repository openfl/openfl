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
		
		if (!tilemap.__renderable || tilemap.__tiles.length == 0 || tilemap.__worldAlpha <= 0) return;
		
		var cairo = renderSession.cairo;
		
		renderSession.maskManager.pushObject (tilemap);
		
		var rect = Rectangle.__pool.get ();
		rect.setTo (0, 0, tilemap.__width, tilemap.__height);
		renderSession.maskManager.pushRect (rect, tilemap.__renderTransform);
		
		var transform = tilemap.__renderTransform;
		var roundPixels = renderSession.roundPixels;
		
		var defaultTileset = tilemap.tileset;
		var cacheBitmapData = null;
		var surface = null;
		var pattern = null;
		
		var tiles, count, tile, alpha, visible, tileset, tileData, bitmapData;
		
		tiles = tilemap.__tiles;
		count = tiles.length;
		
		var matrix = new Matrix3 ();
		var tileTransform = Matrix.__pool.get ();
		
		for (i in 0...count) {
			
			tile = tiles[i];
			
			alpha = tile.alpha;
			visible = tile.visible;
			
			if (!visible || alpha <= 0) continue;
			
			tileset = (tile.tileset != null) ? tile.tileset : defaultTileset;
			
			if (tileset == null) continue;
			
			tileData = tileset.__data[tile.id];
			
			if (tileData == null) continue;
			
			bitmapData = tileset.bitmapData;
			
			if (bitmapData == null) continue;
			
			if (bitmapData != cacheBitmapData) {
				
				surface = bitmapData.getSurface ();
				pattern = CairoPattern.createForSurface (surface);
				pattern.filter = (renderSession.allowSmoothing && tilemap.smoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;
				
				cairo.source = pattern;
				cacheBitmapData = bitmapData;
				
			}
			
			tileTransform.setTo (1, 0, 0, 1, -tile.originX, -tile.originY);
			tileTransform.concat (tile.matrix);
			tileTransform.concat (transform);
			
			if (roundPixels) {
				
				tileTransform.tx = Math.round (tileTransform.tx);
				tileTransform.ty = Math.round (tileTransform.ty);
				
			}
			
			cairo.matrix = tileTransform.__toMatrix3 ();
			
			matrix.tx = tileData.x;
			matrix.ty = tileData.y;
			pattern.matrix = matrix;
			cairo.source = pattern;
			
			cairo.save ();
			
			cairo.newPath ();
			cairo.rectangle (0, 0, tileData.width, tileData.height);
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
		Matrix.__pool.release (tileTransform);
		
	}
	
	
}
