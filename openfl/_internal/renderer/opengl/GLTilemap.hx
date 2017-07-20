package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.display.Tile;
import openfl.display.TileArray;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.display.Tile)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLTilemap {
	
	
	private static var __skippedTiles = new Map<Int, Bool> ();
	
	
	public static function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (!tilemap.__renderable || tilemap.__tiles.length == 0 || tilemap.__worldAlpha <= 0) return;
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var gl = renderSession.gl;
		
		renderSession.blendModeManager.setBlendMode (tilemap.__worldBlendMode);
		renderSession.maskManager.pushObject (tilemap);
		
		var shader = renderSession.filterManager.pushObject (tilemap);
		
		var rect = Rectangle.__pool.get ();
		rect.setTo (0, 0, tilemap.__width, tilemap.__height);
		renderSession.maskManager.pushRect (rect, tilemap.__renderTransform);
		
		shader.data.uMatrix.value = renderer.getMatrix (tilemap.__renderTransform);
		shader.data.uImage0.smoothing = (renderSession.allowSmoothing && tilemap.smoothing);
		
		var defaultTileset = tilemap.tileset;
		var worldAlpha = tilemap.__worldAlpha;
		var alphaDirty = (tilemap.__worldAlpha != tilemap.__cacheAlpha);
		
		var tiles, count, bufferData, buffer, startIndex, offset, uvs, uv;
		var tileWidth = 0, tileHeight = 0;
		var tile, alpha, visible, tileset, tileData, tileMatrix, x, y, x2, y2, x3, y3, x4, y4;
		
		tiles = tilemap.__tiles;
		count = tiles.length;
		
		bufferData = tilemap.__bufferData;
		
		if (bufferData == null || tilemap.__dirty || bufferData.length != count * 30) {
			
			startIndex = 0;
			
			if (bufferData == null) {
				
				bufferData = new Float32Array (count * 30);
				
			} else if (bufferData.length != count * 30) {
				
				if (!tilemap.__dirty) {
					
					startIndex = Std.int (bufferData.length / 30);
					
				}
				
				var data = new Float32Array (count * 30);
				
				if (bufferData.length <= data.length) {
					
					data.set (bufferData);
					
				} else {
					
					data.set (bufferData.subarray (0, data.length));
					
				}
				
				bufferData = data;
				
			}
			
			for (i in startIndex...count) {
				
				__updateTileAlpha (tiles[i], worldAlpha, i * 30, bufferData);
				
				tileset = (tiles[i].tileset != null) ? tiles[i].tileset : tilemap.tileset;
				
				if (tileset != null) {
					
					__updateTileUV (tiles[i], tileset, i * 30, bufferData);
					
				}
				
			}
			
			tilemap.__bufferData = bufferData;
			
		}
		
		if (tilemap.__buffer == null || tilemap.__bufferContext != gl) {
			
			tilemap.__bufferContext = gl;
			tilemap.__buffer = gl.createBuffer ();
			
		}
		
		gl.bindBuffer (gl.ARRAY_BUFFER, tilemap.__buffer);
		
		tileMatrix = Matrix.__pool.get ();
		var drawCount = 0;
		
		for (i in 0...count) {
			
			offset = i * 30;
			
			tile = tiles[i];
			
			if (tile.__type == TILE_ARRAY) {
				
				tileset = (tile.tileset != null) ? tile.tileset : defaultTileset;
				__updateTileArrayBuffer (cast tile, tileset, gl, worldAlpha);
				drawCount = i;
				continue;
				
			}
			
			alpha = tile.alpha;
			visible = tile.visible;
			
			if (!visible || alpha <= 0) {
				
				__skipTile (tile, i, offset, bufferData);
				continue;
				
			}
			
			tileset = (tile.tileset != null) ? tile.tileset : defaultTileset;
			
			if (tileset == null) {
				
				__skipTile (tile, i, offset, bufferData);
				continue;
				
			}
			
			tileData = tileset.__data[tile.id];
			
			if (tileData == null) {
				
				__skipTile (tile, i, offset, bufferData);
				continue;
				
			}
			
			tileWidth = tileData.width;
			tileHeight = tileData.height;
			
			// TODO: Handle all cases where tileset may change for the tile?
			
			if (alphaDirty || tile.__alphaDirty) {
				
				__updateTileAlpha (tile, worldAlpha, offset, bufferData);
				
			}
			
			if (tile.__sourceDirty) {
				
				__updateTileUV (tile, tileset, offset, bufferData);
				
			}
			
			if (tile.__transformDirty) {
				
				tileMatrix.setTo (1, 0, 0, 1, -tile.originX, -tile.originY);
				tileMatrix.concat (tile.matrix);
				
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
			bufferData[offset + 5] = x2;
			bufferData[offset + 6] = y2;
			bufferData[offset + 10] = x3;
			bufferData[offset + 11] = y3;
			
			bufferData[offset + 15] = x3;
			bufferData[offset + 16] = y3;
			bufferData[offset + 20] = x2;
			bufferData[offset + 21] = y2;
			bufferData[offset + 25] = x4;
			bufferData[offset + 26] = y4;
			
			drawCount = i;
			
			__skippedTiles.set (i, false);
			
		}
		
		gl.bufferData (gl.ARRAY_BUFFER, bufferData.byteLength, bufferData, gl.DYNAMIC_DRAW);
		
		gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
		
		var cacheBitmapData = null;
		var lastIndex = 0;
		
		for (i in 0...(drawCount + 1)) {
			
			if (__skippedTiles.get (i)) {
				
				continue;
				
			}
			
			tile = tiles[i];
			tileset = (tile.tileset != null) ? tile.tileset : defaultTileset;
			
			if (tile.__type == TILE_ARRAY) {
				
				var tileArray:TileArrayData = cast tile;
				gl.bindBuffer (gl.ARRAY_BUFFER, tileArray.__buffer);
				gl.bufferData (gl.ARRAY_BUFFER, tileArray.__bufferData.byteLength, tileArray.__bufferData, gl.DYNAMIC_DRAW);
				
				gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
				gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
				
				cacheBitmapData = tileset.bitmapData;
				shader.data.uImage0.input = cacheBitmapData;
				renderSession.shaderManager.setShader (shader);
				
				gl.drawArrays (gl.TRIANGLES, 0, tileArray.__length * 6);
				
				if (i != drawCount) {
					
					gl.bindBuffer (gl.ARRAY_BUFFER, tilemap.__buffer);
					gl.bufferData (gl.ARRAY_BUFFER, bufferData.byteLength, bufferData, gl.DYNAMIC_DRAW);
					
					gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
					gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
					gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
					
				}
				
				continue;
				
			}
			
			if (tileset.bitmapData != cacheBitmapData) {
				
				if (cacheBitmapData != null) {
					
					shader.data.uImage0.input = cacheBitmapData;
					renderSession.shaderManager.setShader (shader);
					
					gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);
					
				}
				
				cacheBitmapData = tileset.bitmapData;
				lastIndex = i;
				
			}
			
			if (i == drawCount && tileset.bitmapData != null) {
				
				shader.data.uImage0.input = tileset.bitmapData;
				renderSession.shaderManager.setShader (shader);
				
				gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i + 1 - lastIndex) * 6);
				
			}
			
		}
		
		gl.disableVertexAttribArray (shader.data.aAlpha.index);
		
		tilemap.__dirty = false;
		tilemap.__cacheAlpha = worldAlpha;
		
		renderSession.filterManager.popObject (tilemap);
		renderSession.maskManager.popRect ();
		renderSession.maskManager.popObject (tilemap);
		
		Rectangle.__pool.release (rect);
		Matrix.__pool.release (tileMatrix);
		
	}
	
	
	private static function __skipTile (tile:Tile, i:Int, tileOffset:Int, bufferData:Float32Array):Void {
		
		var tileOffset = i * 30;
		
		bufferData[tileOffset + 4] = 0;
		bufferData[tileOffset + 9] = 0;
		bufferData[tileOffset + 14] = 0;
		bufferData[tileOffset + 19] = 0;
		bufferData[tileOffset + 24] = 0;
		bufferData[tileOffset + 29] = 0;
		
		__skippedTiles.set (i, true);
		tile.__alphaDirty = true;
		
	}
	
	
	private static function __updateTileAlpha (tile:Tile, worldAlpha:Float, tileOffset:Int, bufferData:Float32Array):Void {
		
		var alpha = worldAlpha * tile.alpha;
		
		bufferData[tileOffset + 4] = alpha;
		bufferData[tileOffset + 9] = alpha;
		bufferData[tileOffset + 14] = alpha;
		bufferData[tileOffset + 19] = alpha;
		bufferData[tileOffset + 24] = alpha;
		bufferData[tileOffset + 29] = alpha;
		
		tile.__alphaDirty = false;
		
	}
	
	
	private static function __updateTileArrayBuffer (tileArray:TileArray, tileset:Tileset, gl:GLRenderContext, worldAlpha:Float):Void {
		
		if ((tileArray:TileArrayData).__buffer == null || (tileArray:TileArrayData).__bufferContext != gl) {
			
			(tileArray:TileArrayData).__bufferContext = gl;
			(tileArray:TileArrayData).__buffer = gl.createBuffer ();
			
		}
		
		var bufferData = (tileArray:TileArrayData).__bufferData;
		var bufferLength = tileArray.length * 30;
		
		if (bufferData == null || bufferLength != bufferData.length) {
			
			bufferData = new Float32Array (bufferLength);
			(tileArray:TileArrayData).__bufferData = bufferData;
			
		}
		
		var tile, tileOffset;
		var id, x, y, x2, y2, x3, y3, x4, y4, alpha;
		var tileWidth = 0, tileHeight = 0, tileMatrix;
		
		var parentAlpha = worldAlpha * tileArray.alpha;
		var parentMatrix = tileArray.matrix;
		
		var bitmapWidth = tileset.bitmapData.width;
		var bitmapHeight = tileset.bitmapData.height;
		var rect:Rectangle;
		
		for (i in 0...tileArray.length) {
			
			tile = tileArray[i];
			tileOffset = i * 30;
			id = tile.id;
			
			if (id > -1) {
				
				var tileData = tileset.__data[tile.id];
				if (tileData == null) continue;
				
				tileWidth = tileData.width;
				tileHeight = tileData.height;
				
				x = tileData.__uvX;
				y = tileData.__uvY;
				x2 = tileData.__uvWidth;
				y2 = tileData.__uvHeight;
				
			} else {
				
				rect = tile.rect;
				
				x = rect.x / bitmapWidth;
				y = rect.y / bitmapHeight;
				x2 = rect.right / bitmapWidth;
				y2 = rect.bottom / bitmapHeight;
				
				tileWidth = Std.int (rect.width);
				tileHeight = Std.int (rect.height);
				
			}
			
			bufferData[tileOffset + 2] = x;
			bufferData[tileOffset + 3] = y;
			bufferData[tileOffset + 7] = x2;
			bufferData[tileOffset + 8] = y;
			bufferData[tileOffset + 12] = x;
			bufferData[tileOffset + 13] = y2;
			
			bufferData[tileOffset + 17] = x;
			bufferData[tileOffset + 18] = y2;
			bufferData[tileOffset + 22] = x2;
			bufferData[tileOffset + 23] = y;
			bufferData[tileOffset + 27] = x2;
			bufferData[tileOffset + 28] = y2;
			
			alpha = parentAlpha * tile.alpha;
			
			bufferData[tileOffset + 4] = alpha;
			bufferData[tileOffset + 9] = alpha;
			bufferData[tileOffset + 14] = alpha;
			bufferData[tileOffset + 19] = alpha;
			bufferData[tileOffset + 24] = alpha;
			bufferData[tileOffset + 29] = alpha;
			
			tileMatrix = tile.matrix;
			tileMatrix.concat (parentMatrix);
			
			x = tileMatrix.__transformX (0, 0);
			y = tileMatrix.__transformY (0, 0);
			x2 = tileMatrix.__transformX (tileWidth, 0);
			y2 = tileMatrix.__transformY (tileWidth, 0);
			x3 = tileMatrix.__transformX (0, tileHeight);
			y3 = tileMatrix.__transformY (0, tileHeight);
			x4 = tileMatrix.__transformX (tileWidth, tileHeight);
			y4 = tileMatrix.__transformY (tileWidth, tileHeight);
			
			bufferData[tileOffset + 0] = x;
			bufferData[tileOffset + 1] = y;
			bufferData[tileOffset + 5] = x2;
			bufferData[tileOffset + 6] = y2;
			bufferData[tileOffset + 10] = x3;
			bufferData[tileOffset + 11] = y3;
			
			bufferData[tileOffset + 15] = x3;
			bufferData[tileOffset + 16] = y3;
			bufferData[tileOffset + 20] = x2;
			bufferData[tileOffset + 21] = y2;
			bufferData[tileOffset + 25] = x4;
			bufferData[tileOffset + 26] = y4;
			
		}
		
	}
	
	
	private static function __updateTileUV (tile:Tile, tileset:Tileset, tileOffset:Int, bufferData:Float32Array):Void {
		
		var tileData = tileset.__data[tile.id];
		
		if (tileData == null) return;
		
		var x = tileData.__uvX;
		var y = tileData.__uvY;
		var x2 = tileData.__uvWidth;
		var y2 = tileData.__uvHeight;
		
		bufferData[tileOffset + 2] = x;
		bufferData[tileOffset + 3] = y;
		bufferData[tileOffset + 7] = x2;
		bufferData[tileOffset + 8] = y;
		bufferData[tileOffset + 12] = x;
		bufferData[tileOffset + 13] = y2;
		
		bufferData[tileOffset + 17] = x;
		bufferData[tileOffset + 18] = y2;
		bufferData[tileOffset + 22] = x2;
		bufferData[tileOffset + 23] = y;
		bufferData[tileOffset + 27] = x2;
		bufferData[tileOffset + 28] = y2;
		
		tile.__sourceDirty = false;
		
	}
	
	
}