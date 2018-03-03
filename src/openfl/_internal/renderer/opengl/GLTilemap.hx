package openfl._internal.renderer.opengl;


import lime.graphics.opengl.WebGLContext;
import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectShader;
import openfl.display.TileGroup;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.display.Tile;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.display.Tile)
@:access(openfl.display.TileArray)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLTilemap {
	
	
	private static var bufferLength:Int;
	private static var bufferPosition:Int;
	private static var cacheColorTransform:ColorTransform;
	private static var currentBitmapData:BitmapData;
	private static var currentShader:DisplayObjectShader;
	private static var lastFlushedPosition:Int;
	private static var lastUsedBitmapData:BitmapData;
	private static var lastUsedShader:DisplayObjectShader;
	
	
	public static function buildBuffer (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (!tilemap.__renderable || tilemap.__group.__tiles.length == 0 || tilemap.__worldAlpha <= 0) return;
		
		bufferLength = 0;
		bufferPosition = 0;
		
		var rect = Rectangle.__pool.get ();
		var matrix = Matrix.__pool.get ();
		var parentTransform = Matrix.__pool.get ();
		
		var stride = 4;
		if (tilemap.tileAlphaEnabled) stride++;
		if (tilemap.tileColorTransformEnabled) stride += 8;
		
		buildBufferTileGroup (tilemap, tilemap.__group, renderSession, parentTransform, stride, tilemap.__tileset, tilemap.tileAlphaEnabled, tilemap.__worldAlpha, tilemap.tileColorTransformEnabled, tilemap.__worldColorTransform, null, rect, matrix);
		
		tilemap.__bufferLength = bufferLength;
		
		Rectangle.__pool.release (rect);
		Matrix.__pool.release (matrix);
		Matrix.__pool.release (parentTransform);
		
	}
	
	
	private static function buildBufferTileGroup (tilemap:Tilemap, group:TileGroup, renderSession:RenderSession, parentTransform:Matrix, stride:Int, defaultTileset:Tileset, alphaEnabled:Bool, worldAlpha:Float, colorTransformEnabled:Bool, defaultColorTransform:ColorTransform, cacheBitmapData:BitmapData, rect:Rectangle, matrix:Matrix):Void {
		
		var tileTransform = Matrix.__pool.get ();
		var roundPixels = renderSession.roundPixels;
		
		var tiles = group.__tiles;
		var length = group.__length;
		
		resizeBuffer (tilemap, bufferPosition + (length * stride * 6));
		var __bufferData = tilemap.__bufferData;
		
		var cacheLength, cacheBufferPosition;
		var tile, tileset, alpha, visible, colorTransform = null, id, tileData, tileRect, bitmapData;
		var tileWidth, tileHeight, uvX, uvY, uvHeight, uvWidth, offset;
		var x, y, x2, y2, x3, y3, x4, y4;
		
		var alphaPosition = 4;
		var ctPosition = alphaEnabled ? 5 : 4;
		
		for (tile in tiles) {
			
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
			
			if (colorTransformEnabled) {
				
				if (tile.colorTransform != null) {
					
					if (defaultColorTransform == null) {
						
						colorTransform = tile.colorTransform;
						
					} else {
						
						if (cacheColorTransform == null) {
							
							cacheColorTransform = new ColorTransform ();
							
						}
						
						colorTransform = cacheColorTransform;
						colorTransform.redMultiplier = defaultColorTransform.redMultiplier * tile.colorTransform.redMultiplier;
						colorTransform.greenMultiplier = defaultColorTransform.greenMultiplier * tile.colorTransform.greenMultiplier;
						colorTransform.blueMultiplier = defaultColorTransform.blueMultiplier * tile.colorTransform.blueMultiplier;
						colorTransform.alphaMultiplier = defaultColorTransform.alphaMultiplier * tile.colorTransform.alphaMultiplier;
						colorTransform.redOffset = defaultColorTransform.redOffset + tile.colorTransform.redOffset;
						colorTransform.greenOffset = defaultColorTransform.greenOffset + tile.colorTransform.greenOffset;
						colorTransform.blueOffset = defaultColorTransform.blueOffset + tile.colorTransform.blueOffset;
						colorTransform.alphaOffset = defaultColorTransform.alphaOffset + tile.colorTransform.alphaOffset;
						
					}
					
				} else {
					
					colorTransform = defaultColorTransform;
					
				}
				
			}
			
			if (!alphaEnabled) alpha = 1;
			
			if (tile.__length > 0) {
				
				cacheLength = bufferLength;
				cacheBufferPosition = bufferPosition;
				
				buildBufferTileGroup (tilemap, cast tile, renderSession, tileTransform, stride, tileset, alphaEnabled, alpha, colorTransformEnabled, colorTransform, cacheBitmapData, rect, matrix);
				
				resizeBuffer (tilemap, cacheLength + (bufferPosition - cacheBufferPosition));
				__bufferData = tilemap.__bufferData;
				
			} else {
				
				if (tileset == null) continue;
				
				id = tile.id;
				
				bitmapData = tileset.__bitmapData;
				if (bitmapData == null) continue;
				
				if (id == -1) {
					
					tileRect = tile.rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0) continue;
					
					uvX = tileRect.x / bitmapData.width;
					uvY = tileRect.y / bitmapData.height;
					uvWidth = tileRect.right / bitmapData.width;
					uvHeight = tileRect.bottom / bitmapData.height;
					
				} else {
					
					tileData = tileset.__data[id];
					if (tileData == null) continue;
					
					rect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
					tileRect = rect;
					
					uvX = tileData.__uvX;
					uvY = tileData.__uvY;
					uvWidth = tileData.__uvWidth;
					uvHeight = tileData.__uvHeight;
					
				}
				
				tileWidth = tileRect.width;
				tileHeight = tileRect.height;
				
				x = tileTransform.__transformX (0, 0);
				y = tileTransform.__transformY (0, 0);
				x2 = tileTransform.__transformX (tileWidth, 0);
				y2 = tileTransform.__transformY (tileWidth, 0);
				x3 = tileTransform.__transformX (0, tileHeight);
				y3 = tileTransform.__transformY (0, tileHeight);
				x4 = tileTransform.__transformX (tileWidth, tileHeight);
				y4 = tileTransform.__transformY (tileWidth, tileHeight);
				
				offset = bufferPosition;
				
				__bufferData[offset + 0] = x;
				__bufferData[offset + 1] = y;
				__bufferData[offset + 2] = uvX;
				__bufferData[offset + 3] = uvY;
				
				__bufferData[offset + stride + 0] = x2;
				__bufferData[offset + stride + 1] = y2;
				__bufferData[offset + stride + 2] = uvWidth;
				__bufferData[offset + stride + 3] = uvY;
				
				__bufferData[offset + (stride * 2) + 0] = x3;
				__bufferData[offset + (stride * 2) + 1] = y3;
				__bufferData[offset + (stride * 2) + 2] = uvX;
				__bufferData[offset + (stride * 2) + 3] = uvHeight;
				
				__bufferData[offset + (stride * 3) + 0] = x3;
				__bufferData[offset + (stride * 3) + 1] = y3;
				__bufferData[offset + (stride * 3) + 2] = uvX;
				__bufferData[offset + (stride * 3) + 3] = uvHeight;
				
				__bufferData[offset + (stride * 4) + 0] = x2;
				__bufferData[offset + (stride * 4) + 1] = y2;
				__bufferData[offset + (stride * 4) + 2] = uvWidth;
				__bufferData[offset + (stride * 4) + 3] = uvY;
				
				__bufferData[offset + (stride * 5) + 0] = x4;
				__bufferData[offset + (stride * 5) + 1] = y4;
				__bufferData[offset + (stride * 5) + 2] = uvWidth;
				__bufferData[offset + (stride * 5) + 3] = uvHeight;
				
				if (alphaEnabled) {
					
					for (i in 0...6) {
						
						__bufferData[offset + (stride * i) + alphaPosition] = alpha;
						
					}
					
				}
				
				if (colorTransformEnabled) {
					
					if (colorTransform != null) {
						
						for (i in 0...6) {
							
							__bufferData[offset + (stride * i) + ctPosition] = colorTransform.redMultiplier;
							__bufferData[offset + (stride * i) + ctPosition + 1] = colorTransform.greenMultiplier;
							__bufferData[offset + (stride * i) + ctPosition + 2] = colorTransform.blueMultiplier;
							__bufferData[offset + (stride * i) + ctPosition + 3] = colorTransform.alphaMultiplier;
							
							__bufferData[offset + (stride * i) + ctPosition + 4] = colorTransform.redOffset;
							__bufferData[offset + (stride * i) + ctPosition + 5] = colorTransform.greenOffset;
							__bufferData[offset + (stride * i) + ctPosition + 6] = colorTransform.blueOffset;
							__bufferData[offset + (stride * i) + ctPosition + 7] = colorTransform.alphaOffset;
							
						}
						
					} else {
						
						for (i in 0...6) {
							
							__bufferData[offset + (stride * i) + ctPosition] = 1;
							__bufferData[offset + (stride * i) + ctPosition + 1] = 1;
							__bufferData[offset + (stride * i) + ctPosition + 2] = 1;
							__bufferData[offset + (stride * i) + ctPosition + 3] = 1;
							
							__bufferData[offset + (stride * i) + ctPosition + 4] = 0;
							__bufferData[offset + (stride * i) + ctPosition + 5] = 0;
							__bufferData[offset + (stride * i) + ctPosition + 6] = 0;
							__bufferData[offset + (stride * i) + ctPosition + 7] = 0;
							
						}
						
					}
					
				}
				
				bufferPosition += (stride * 6);
				
			}
			
		}
		
		bufferLength = bufferPosition;
		Matrix.__pool.release (tileTransform);
		
	}
	
	
	private static function flush (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (currentShader == null) {
			
			var shaderManager:GLShaderManager = cast renderSession.shaderManager;
			currentShader = shaderManager.defaultDisplayShader;
			
		}
		
		var updatedBuffer = true; // TODO: cache
		
		if (bufferPosition > lastFlushedPosition && currentBitmapData != null && currentShader != null) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			var shaderManager:GLShaderManager = cast renderSession.shaderManager;
			var gl:WebGLContext = renderSession.gl;
			
			var shader = shaderManager.initDisplayShader (currentShader);
			shaderManager.setDisplayShader (shader);
			shaderManager.applyBitmapData (currentBitmapData, renderSession.allowSmoothing && tilemap.smoothing);
			shaderManager.applyMatrix (renderer.getMatrix (tilemap.__renderTransform));
			
			if (tilemap.tileAlphaEnabled) {
				
				shaderManager.useAlphaArray ();
				
			} else {
				
				shaderManager.applyAlpha (tilemap.__worldAlpha);
				
			}
			
			if (tilemap.tileColorTransformEnabled) {
				
				shaderManager.applyHasColorTransform (true);
				shaderManager.useColorTransformArray ();
				
			} else {
				
				shaderManager.applyColorTransform (tilemap.__worldColorTransform);
				
			}
			
			shaderManager.updateShader ();
			
			var stride = 4;
			if (tilemap.tileAlphaEnabled) stride++;
			if (tilemap.tileColorTransformEnabled) stride += 8;
			
			if (tilemap.__buffer == null || tilemap.__bufferContext != gl) {
				
				tilemap.__bufferContext = cast gl;
				tilemap.__buffer = gl.createBuffer ();
				
			}
			
			gl.bindBuffer (gl.ARRAY_BUFFER, tilemap.__buffer);
			
			if (updatedBuffer) {
				
				gl.bufferData (gl.ARRAY_BUFFER, tilemap.__bufferData, gl.DYNAMIC_DRAW);
				
			}
			
			gl.vertexAttribPointer (shader.data.openfl_Position.index, 2, gl.FLOAT, false, stride * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, stride * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
			
			
			if (tilemap.tileAlphaEnabled) {
				
				gl.vertexAttribPointer (shader.data.alpha.index, 1, gl.FLOAT, false, stride * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
				
			}
			if (tilemap.tileColorTransformEnabled) {
				
				var position = tilemap.tileAlphaEnabled ? 5 : 4;
				
				gl.vertexAttribPointer (shader.data.colorMultipliers.index, 4, gl.FLOAT, false, stride * Float32Array.BYTES_PER_ELEMENT, position * Float32Array.BYTES_PER_ELEMENT);
				gl.vertexAttribPointer (shader.data.colorOffsets.index, 4, gl.FLOAT, false, stride * Float32Array.BYTES_PER_ELEMENT, (position + 4) * Float32Array.BYTES_PER_ELEMENT);
				
			}
			
			var start = lastFlushedPosition == 0 ? 0 : Std.int (lastFlushedPosition / stride);
			var length = Std.int ((bufferPosition - lastFlushedPosition) / stride);
			
			// trace ("DRAW");
			// trace (lastFlushedPosition);
			// trace (bufferLength);
			// trace (bufferPosition);
			// trace (start);
			// trace (length);
			// trace (currentShader == null);
			// trace (currentBitmapData == null);
			
			gl.drawArrays (gl.TRIANGLES, start, length);
			
			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			shaderManager.clear ();
			
		}
		
		lastFlushedPosition = bufferPosition;
		lastUsedBitmapData = currentBitmapData;
		lastUsedShader = currentShader;
		
	}
	
	
	public static function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (!tilemap.__renderable || tilemap.__worldAlpha <= 0) return;
		
		buildBuffer (tilemap, renderSession);
		
		if (tilemap.__bufferLength == 0) return;
		
		bufferLength = tilemap.__bufferLength;
		bufferPosition = 0;
		
		lastFlushedPosition = 0;
		lastUsedBitmapData = null;
		lastUsedShader = null;
		currentBitmapData = null;
		currentShader = null;
		
		var stride = 4;
		if (tilemap.tileAlphaEnabled) stride++;
		if (tilemap.tileColorTransformEnabled) stride += 8;
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var shaderManager:GLShaderManager = cast renderSession.shaderManager;
		var gl = renderSession.gl;
		
		renderSession.blendModeManager.setBlendMode (tilemap.__worldBlendMode);
		renderSession.maskManager.pushObject (tilemap);
		renderSession.filterManager.pushObject (tilemap);
		
		renderTileGroup (tilemap, renderSession, tilemap.__group, tilemap.__worldShader, stride, tilemap.__tileset, tilemap.__worldAlpha, null);
		flush (tilemap, renderSession);
		
		renderSession.filterManager.popObject (tilemap);
		renderSession.maskManager.popRect ();
		renderSession.maskManager.popObject (tilemap);
		
	}
	
	
	private static function renderTileGroup (tilemap:Tilemap, renderSession:RenderSession, group:TileGroup, defaultShader:DisplayObjectShader, stride:Int, defaultTileset:Tileset, worldAlpha:Float, cacheBitmapData:BitmapData):Void {
		
		var tiles = group.__tiles;
		var length = group.__length;
		
		var tile, tileset, alpha, visible, id, tileData, tileRect, shader, bitmapData;
		var tileWidth, tileHeight, uvX, uvY, uvHeight, uvWidth, offset;
		
		for (tile in tiles) {
			
			tileset = tile.tileset != null ? tile.tileset : defaultTileset;
			
			alpha = tile.alpha * worldAlpha;
			visible = tile.visible;
			if (!visible || alpha <= 0) continue;
			
			shader = tile.shader != null ? tile.shader : defaultShader;
			
			if (tile.__length > 0) {
				
				renderTileGroup (tilemap, renderSession, cast tile, shader, stride, tileset, alpha, cacheBitmapData);
				
			} else {
				
				if (tileset == null) continue;
				
				id = tile.id;
				
				bitmapData = tileset.__bitmapData;
				if (bitmapData == null) continue;
				
				if (id == -1) {
					
					tileRect = tile.rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0) continue;
					
				} else {
					
					tileData = tileset.__data[id];
					if (tileData == null) continue;
					
				}
				
				if ((shader != currentShader && currentShader != null) || (bitmapData != currentBitmapData && currentBitmapData != null)) {
					
					flush (tilemap, renderSession);
					
				}
				
				currentBitmapData = bitmapData;
				currentShader = shader;
				bufferPosition += (stride * 6);
				
			}
			
		}
		
	}
	
	
	public static function renderMask (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		// tilemap.__updateTileArray ();
		
		// if (tilemap.__tileArray == null || tilemap.__tileArray.length == 0) return;
		
		// var renderer:GLRenderer = cast renderSession.renderer;
		// var gl = renderSession.gl;
		
		// var shader = GLMaskManager.maskShader;
		
		// var uMatrix = renderer.getMatrix (tilemap.__renderTransform);
		// var smoothing = (renderSession.allowSmoothing && tilemap.smoothing);
		
		// var tileArray = tilemap.__tileArray;
		// var defaultTileset = tilemap.__tileset;
		
		// tileArray.__updateGLBuffer (gl, defaultTileset, tilemap.__worldAlpha, tilemap.__worldColorTransform);
		
		// gl.vertexAttribPointer (shader.data.openfl_Position.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 0);
		// gl.vertexAttribPointer (shader.data.openfl_TexCoord.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		
		// var cacheBitmapData = null;
		// var lastIndex = 0;
		// var skipped = tileArray.__bufferSkipped;
		// var drawCount = tileArray.__length;
		
		// tileArray.position = 0;
		
		// var tileset, flush = false;
		
		// for (i in 0...(drawCount + 1)) {
			
		// 	if (skipped[i]) {
				
		// 		continue;
				
		// 	}
			
		// 	tileArray.position = (i < drawCount ? i : drawCount - 1);
			
		// 	tileset = tileArray.tileset;
		// 	if (tileset == null) tileset = defaultTileset;
		// 	if (tileset == null) continue;
			
		// 	if (tileset.__bitmapData != cacheBitmapData && cacheBitmapData != null) {
				
		// 		flush = true;
				
		// 	}
			
		// 	if (flush) {
				
		// 		shader.data.texture0.input = cacheBitmapData;
		// 		renderSession.shaderManager.updateShader ();
				
		// 		gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);
				
		// 		#if gl_stats
		// 			GLStats.incrementDrawCall (DrawCallContext.STAGE);
		// 		#end
				
		// 		flush = false;
		// 		lastIndex = i;
				
		// 	}
			
		// 	cacheBitmapData = tileset.__bitmapData;
			
		// 	if (i == drawCount && tileset.__bitmapData != null) {
				
		// 		shader.data.texture0.input = tileset.__bitmapData;
		// 		renderSession.shaderManager.updateShader ();
		// 		gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);
				
		// 		#if gl_stats
		// 			GLStats.incrementDrawCall (DrawCallContext.STAGE);
		// 		#end
				
		// 	}
			
		// }
		
	}
	
	
	private static function resizeBuffer (tilemap:Tilemap, length:Int):Void {
		
		if (tilemap.__bufferData == null) {
			
			tilemap.__bufferData = new Float32Array (length);
			
		} else if (length > tilemap.__bufferData.length) {
			
			var buffer = new Float32Array (length);
			buffer.set (tilemap.__bufferData);
			tilemap.__bufferData = buffer;
			
		}
		
		tilemap.__bufferLength = length;
		
	}
	
	
}