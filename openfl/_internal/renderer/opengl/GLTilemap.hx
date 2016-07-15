package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;
import openfl.display.Tile;
import openfl.filters.ShaderFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.display.Tile)


class GLTilemap {
	
	
	public static function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (!tilemap.__renderable || tilemap.__tiles.length == 0 || tilemap.__worldAlpha <= 0) return;
		
		var gl = renderSession.gl;
		var shader;
		
		if (tilemap.filters != null && Std.is (tilemap.filters[0], ShaderFilter)) {
			
			shader = cast (tilemap.filters[0], ShaderFilter).shader;
			
		} else {
			
			shader = renderSession.shaderManager.defaultShader;
			
		}
		
		renderSession.blendModeManager.setBlendMode (tilemap.blendMode);
		renderSession.shaderManager.setShader (shader);
		renderSession.maskManager.pushObject (tilemap);
		
		var renderer:GLRenderer = cast renderSession.renderer;
		
		gl.uniform1f (shader.data.uAlpha.index, tilemap.__worldAlpha);
		gl.uniformMatrix4fv (shader.data.uMatrix.index, false, renderer.getMatrix (tilemap.__worldTransform));
		
		var defaultTileset = tilemap.tileset;
		
		var tiles, count, bufferData, buffer, startIndex, offset, uvs, uv;
		var tileWidth = 0, tileHeight = 0;
		var tile, tileset, tileData, tileMatrix, x, y, x2, y2, x3, y3, x4, y4;
		
		tiles = tilemap.__tiles;
		count = tiles.length;
		
		bufferData = tilemap.__bufferData;
		
		if (bufferData == null || tilemap.__dirty || bufferData.length != count * 24) {
			
			startIndex = 0;
			
			if (bufferData == null) {
				
				bufferData = new Float32Array (count * 24);
				
			} else if (bufferData.length != count * 24) {
				
				if (!tilemap.__dirty) {
					
					startIndex = Std.int (bufferData.length / 24);
					
				}
				
				var data = new Float32Array (count * 24);
				data.set (bufferData);
				bufferData = data;
				
			}
			
			for (i in startIndex...count) {
				
				updateTileUV (tiles[i], tilemap, i * 24, bufferData);
				
			}
			
			tilemap.__bufferData = bufferData;
			
		}
		
		if (tilemap.__buffer == null) {
			
			tilemap.__buffer = gl.createBuffer ();
			
		}
		
		gl.bindBuffer (gl.ARRAY_BUFFER, tilemap.__buffer);
		
		for (i in 0...count) {
			
			tile = tiles[i];
			tileset = (tile.tileset != null) ? tile.tileset : defaultTileset;
			
			if (tileset == null) continue;
			
			tileData = tileset.__data[tile.id];
			tileWidth = tileData.width;
			tileHeight = tileData.height;
			
			offset = i * 24;
			
			// TODO: Handle all cases where tileset may change for the tile?
			
			if (tile.__sourceDirty) {
				
				updateTileUV (tile, tilemap, offset, bufferData);
				
			}
			
			if (tile.__transformDirty) {
				
				tileMatrix = tile.matrix;
				
				x = tile.__transform[0] = tileMatrix.__transformX (0, 0);
				y = tile.__transform[1] = tileMatrix.__transformY (0, 0);
				x2 = tile.__transform[2] = tileMatrix.__transformX (tileWidth, 0);
				y2 = tile.__transform[3] = tileMatrix.__transformY (tileWidth, 0);
				x3 = tile.__transform[4] = tileMatrix.__transformX (0, tileHeight);
				y3 = tile.__transform[5] = tileMatrix.__transformY (0, tileHeight);
				x4 = tile.__transform[6] = tileMatrix.__transformX (tileWidth, tileHeight);
				y4 = tile.__transform[7] = tileMatrix.__transformY (tileWidth, tileHeight);
				
				tile.__transformDirty = false;
				
			} else {
				
				x = tile.__transform[0];
				y = tile.__transform[1];
				x2 = tile.__transform[2];
				y2 = tile.__transform[3];
				x3 = tile.__transform[4];
				y3 = tile.__transform[5];
				x4 = tile.__transform[6];
				y4 = tile.__transform[7];
				
			}
			
			bufferData[offset + 0] = x;
			bufferData[offset + 1] = y;
			bufferData[offset + 4] = x2;
			bufferData[offset + 5] = y2;
			bufferData[offset + 8] = x3;
			bufferData[offset + 9] = y3;
			
			bufferData[offset + 12] = x3;
			bufferData[offset + 13] = y3;
			bufferData[offset + 16] = x2;
			bufferData[offset + 17] = y2;
			bufferData[offset + 20] = x4;
			bufferData[offset + 21] = y4;
			
		}
		
		gl.bufferData (gl.ARRAY_BUFFER, bufferData, gl.DYNAMIC_DRAW);
		
		gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		
		var cacheBitmapData = null;
		var lastIndex = 0;
		
		for (i in 0...count) {
			
			tile = tiles[i];
			tileset = (tile.tileset != null) ? tile.tileset : defaultTileset;
			
			if (tileset == null) {
				
				cacheBitmapData = null;
				continue;
				
			}
			
			if (tileset.bitmapData != cacheBitmapData || i == count - 1) {
				
				if (cacheBitmapData != null) {
					
					gl.bindTexture (gl.TEXTURE_2D, cacheBitmapData.getTexture (gl));
					gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i + 1) * 6);
					
				}
				
				cacheBitmapData = tileset.bitmapData;
				lastIndex = i;
				
			}
			
		}
		
		tilemap.__dirty = false;
		renderSession.maskManager.popObject (tilemap);
		
	}
	
	
	private static inline function updateTileUV (tile:Tile, tilemap:Tilemap, tileOffset:Int, bufferData:Float32Array):Void {
		
		var tileset = (tile.tileset != null) ? tile.tileset : tilemap.tileset;
		
		if (tileset == null) return;
		
		var tileData = tileset.__data[tile.id];
		
		var x = tileData.__uvX;
		var y = tileData.__uvY;
		var x2 = tileData.__uvWidth;
		var y2 = tileData.__uvHeight;
		
		bufferData[tileOffset + 2] = x;
		bufferData[tileOffset + 3] = y;
		bufferData[tileOffset + 6] = x2;
		bufferData[tileOffset + 7] = y;
		bufferData[tileOffset + 10] = x;
		bufferData[tileOffset + 11] = y2;
		
		bufferData[tileOffset + 14] = x;
		bufferData[tileOffset + 15] = y2;
		bufferData[tileOffset + 18] = x2;
		bufferData[tileOffset + 19] = y;
		bufferData[tileOffset + 22] = x2;
		bufferData[tileOffset + 23] = y2;
		
		tile.__sourceDirty = false;
		
	}
	
	
}