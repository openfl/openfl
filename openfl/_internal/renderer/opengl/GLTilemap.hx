package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;

@:access(openfl.display.Tilemap)
@:access(openfl.display.TilemapLayer)
@:access(openfl.display.Tileset)


class GLTilemap {
	
	
	public static inline function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (tilemap.__layers == null || tilemap.__layers.length == 0) return;
		
		var gl = renderSession.gl;
		var shader:GLShader = cast renderSession.shaderManager.defaultShader;
		
		renderSession.blendModeManager.setBlendMode (tilemap.blendMode);
		renderSession.shaderManager.setShader (shader);
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var scrollRect = tilemap.scrollRect;
		
		if (scrollRect != null) {
			
			renderSession.maskManager.pushRect (scrollRect, tilemap.__renderTransform);
			
		}
		
		gl.uniform1f (shader.uniforms.get ("uAlpha"), tilemap.__worldAlpha);
		gl.uniformMatrix4fv (shader.uniforms.get ("uMatrix"), false, renderer.getMatrix (tilemap.__renderTransform));
		
		var tiles, count, bufferData, buffer, previousLength, offset, uvs, uv;
		var cacheTileID = -1, tileWidth = 0, tileHeight = 0;
		var tile, x, y, x2, y2;
		
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
				
				x = tile.x;
				y = tile.y;
				x2 = x + tileWidth;
				y2 = y + tileHeight;
				
				bufferData[offset + 0] = x;
				bufferData[offset + 1] = y;
				bufferData[offset + 4] = x2;
				bufferData[offset + 5] = y;
				bufferData[offset + 8] = x;
				bufferData[offset + 9] = y2;
				
				bufferData[offset + 12] = x;
				bufferData[offset + 13] = y2;
				bufferData[offset + 16] = x2;
				bufferData[offset + 17] = y;
				bufferData[offset + 20] = x2;
				bufferData[offset + 21] = y2;
				
			}
			
			gl.bufferData (gl.ARRAY_BUFFER, bufferData, gl.DYNAMIC_DRAW);
			
			gl.vertexAttribPointer (shader.attributes.get ("aPosition"), 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.attributes.get ("aTexCoord"), 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
			
			gl.drawArrays (gl.TRIANGLES, 0, tiles.length * 6);
			
		}
		
		if (scrollRect != null) {
			
			renderSession.maskManager.popRect ();
			
		}
		
	}
	
	
}