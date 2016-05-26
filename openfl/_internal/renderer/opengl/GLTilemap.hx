package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;
import openfl.filters.ShaderFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;

@:access(openfl.display.Tilemap)
@:access(openfl.display.TilemapLayer)
@:access(openfl.display.Tileset)


class GLTilemap {
	
	
	public static function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (tilemap.__layers == null || tilemap.__layers.length == 0) return;
		
		var gl = renderSession.gl;
		var shader;
		
		if (tilemap.filters != null && Std.is (tilemap.filters[0], ShaderFilter)) {
			
			shader = cast (tilemap.filters[0], ShaderFilter).shader;
			
		} else {
			
			shader = renderSession.shaderManager.defaultShader;
			
		}
		
		renderSession.blendModeManager.setBlendMode (tilemap.blendMode);
		renderSession.shaderManager.setShader (shader);
		
		var renderer:GLRenderer = cast renderSession.renderer;
		
		if (tilemap.__mask != null) {
			
			renderSession.maskManager.pushMask (tilemap.__mask);
			
		}
		
		var scrollRect = tilemap.scrollRect;
		
		if (scrollRect != null) {
			
			renderSession.maskManager.pushRect (scrollRect, tilemap.__worldTransform);
			
		}
		
		gl.uniform1f (shader.data.uAlpha.index, tilemap.__worldAlpha);
		gl.uniformMatrix4fv (shader.data.uMatrix.index, false, renderer.getMatrix (tilemap.__worldTransform));
		
		var tiles, count, bufferData, buffer, previousLength, offset, uvs, uv;
		var cacheTileID = -1, tileWidth = 0, tileHeight = 0;
		var tile, tileMatrix, x, y, x2, y2, x3, y3, x4, y4;
		
		for (layer in tilemap.__layers) {
			
			if (layer.__tiles.length == 0 || layer.tileset == null || layer.tileset.bitmapData == null) continue;
			
			gl.bindTexture (gl.TEXTURE_2D, layer.tileset.bitmapData.getTexture (gl));
			
			tiles = layer.__tiles;
			count = tiles.length;
			uvs = layer.tileset.__uvs;
			
			bufferData = layer.__bufferData;
			
			if (bufferData == null || bufferData.length != count * 24) {
				
				previousLength = 0;
				
				if (bufferData == null) {
					
					bufferData = new Float32Array (count * 24);
					
				} else {
					
					previousLength = Std.int (bufferData.length / 24);
					
					var data = new Float32Array (count * 24);
					
					for (i in 0...bufferData.length) {
						
						data[i] = bufferData[i];
						
					}
					
					bufferData = data;
					
				}
				
				for (i in previousLength...count) {
					
					uv = uvs[tiles[i].id];
					
					x = uv.x;
					y = uv.y;
					x2 = uv.width;
					y2 = uv.height;
					
					offset = i * 24;
					
					bufferData[offset + 2] = x;
					bufferData[offset + 3] = y;
					bufferData[offset + 6] = x2;
					bufferData[offset + 7] = y;
					bufferData[offset + 10] = x;
					bufferData[offset + 11] = y2;
					
					bufferData[offset + 14] = x;
					bufferData[offset + 15] = y2;
					bufferData[offset + 18] = x2;
					bufferData[offset + 19] = y;
					bufferData[offset + 22] = x2;
					bufferData[offset + 23] = y2;
					
				}
				
				layer.__bufferData = bufferData;
				
			}
			
			if (layer.__buffer == null) {
				
				layer.__buffer = gl.createBuffer ();
				
			}
			
			gl.bindBuffer (gl.ARRAY_BUFFER, layer.__buffer);
			
			for (i in 0...count) {
				
				tile = tiles[i];
				
				if (tile.id != cacheTileID) {
					
					tileWidth = Std.int (layer.tileset.__rects[tile.id].width);
					tileHeight = Std.int (layer.tileset.__rects[tile.id].height);
					cacheTileID = tile.id;
					
				}
				
				offset = i * 24;
				
				// TODO: Use dirty flag on tiles?
				
				tileMatrix = tile.matrix;
				
				x = tileMatrix.__transformX (0, 0);
				y = tileMatrix.__transformY (0, 0);
				x2 = tileMatrix.__transformX (tileWidth, 0);
				y2 = tileMatrix.__transformY (tileWidth, 0);
				x3 = tileMatrix.__transformX (0, tileHeight);
				y3 = tileMatrix.__transformY (0, tileHeight);
				x4 = tileMatrix.__transformX (tileWidth, tileHeight);
				y4 = tileMatrix.__transformY (tileWidth, tileHeight);
				
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
			
			gl.drawArrays (gl.TRIANGLES, 0, tiles.length * 6);
			
		}
		
		if (scrollRect != null) {
			
			renderSession.maskManager.popRect ();
			
		}
		
		if (tilemap.__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		
	}
	
	
}
