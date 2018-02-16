package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.display.Tile;
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
	
	
	private static var __skippedTiles = new Map<Int, Bool> ();
	
	
	public static function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (!tilemap.__renderable || tilemap.__worldAlpha <= 0) return;
		
		tilemap.__updateTileArray ();
		
		if (tilemap.__tileArray == null || tilemap.__tileArray.length == 0) return;
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var gl = renderSession.gl;
		
		renderSession.blendModeManager.setBlendMode (tilemap.__worldBlendMode);
		renderSession.maskManager.pushObject (tilemap);
		
		renderSession.filterManager.pushObject (tilemap);
		
		var shader = renderSession.shaderManager.initShader (tilemap.shader);
		
		var uMatrix = renderer.getMatrix (tilemap.__renderTransform);
		var smoothing = (renderSession.allowSmoothing && tilemap.smoothing);
		
		var useColorTransform = true || !tilemap.__worldColorTransform.__isDefault ();
		
		var rect = Rectangle.__pool.get ();
		rect.setTo (0, 0, tilemap.__width, tilemap.__height);
		renderSession.maskManager.pushRect (rect, tilemap.__renderTransform);
		
		var tileArray = tilemap.__tileArray;
		var defaultShader = shader;
		var defaultTileset = tilemap.__tileset;
		
		tileArray.__updateGLBuffer (gl, defaultTileset, tilemap.__worldAlpha, tilemap.__worldColorTransform);
		
		gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
			
		if (true || useColorTransform) {
			
			gl.vertexAttribPointer (shader.data.aColorMultipliers0.index, 4, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
			gl.vertexAttribPointer (shader.data.aColorMultipliers1.index, 4, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 9 * Float32Array.BYTES_PER_ELEMENT);
			gl.vertexAttribPointer (shader.data.aColorMultipliers2.index, 4, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 13 * Float32Array.BYTES_PER_ELEMENT);
			gl.vertexAttribPointer (shader.data.aColorMultipliers3.index, 4, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 17 * Float32Array.BYTES_PER_ELEMENT);
			gl.vertexAttribPointer (shader.data.aColorOffsets.index, 4, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 21 * Float32Array.BYTES_PER_ELEMENT);
			
		}
		
		var cacheShader = null;
		var cacheBitmapData = null;
		var lastIndex = 0;
		var skipped = tileArray.__bufferSkipped;
		var drawCount = tileArray.__length;
		
		tileArray.position = 0;
		
		var shader = null, tileset, flush = false;
		
		for (i in 0...(drawCount + 1)) {
			
			if (skipped[i]) {
				
				continue;
				
			}
			
			tileArray.position = (i < drawCount ? i : drawCount - 1);
			
			shader = tileArray.shader;
			if (shader == null) shader = defaultShader;
			
			if (shader != cacheShader && cacheShader != null) {
				
				flush = true;
				
			}
			
			tileset = tileArray.tileset;
			if (tileset == null) tileset = defaultTileset;
			if (tileset == null) continue;
			
			if (tileset.__bitmapData != cacheBitmapData && cacheBitmapData != null) {
				
				flush = true;
				
			}
			
			if (flush) {
				
				cacheShader.data.uImage0.input = cacheBitmapData;
				renderSession.shaderManager.updateShader (cacheShader);
				
				gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
				flush = false;
				lastIndex = i;
				
			}
			
			if (shader != cacheShader) {
				
				renderSession.shaderManager.setShader (shader);
				
				shader.data.uMatrix.value = uMatrix;
				shader.data.uImage0.smoothing = smoothing;
				
				if (shader.data.uColorTransform.value == null) shader.data.uColorTransform.value = [];
				shader.data.uColorTransform.value[0] = useColorTransform;
				
				// gl.bindBuffer (gl.ARRAY_BUFFER, tileArray.__buffer);
				
				// gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
				// gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
				// gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
				
				cacheShader = shader;
				
			}
			
			cacheBitmapData = tileset.__bitmapData;
			
			if (i == drawCount && tileset.__bitmapData != null) {
				
				shader.data.uImage0.input = tileset.__bitmapData;
				renderSession.shaderManager.updateShader (shader);
				gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
			}
			
		}
		
		renderSession.filterManager.popObject (tilemap);
		renderSession.maskManager.popRect ();
		renderSession.maskManager.popObject (tilemap);
		
		Rectangle.__pool.release (rect);
		
	}
	
	
	public static function renderMask (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		tilemap.__updateTileArray ();
		
		if (tilemap.__tileArray == null || tilemap.__tileArray.length == 0) return;
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var gl = renderSession.gl;
		
		var shader = GLMaskManager.maskShader;
		
		var uMatrix = renderer.getMatrix (tilemap.__renderTransform);
		var smoothing = (renderSession.allowSmoothing && tilemap.smoothing);
		
		var tileArray = tilemap.__tileArray;
		var defaultTileset = tilemap.__tileset;
		
		tileArray.__updateGLBuffer (gl, defaultTileset, tilemap.__worldAlpha, tilemap.__worldColorTransform);
		
		gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		
		var cacheBitmapData = null;
		var lastIndex = 0;
		var skipped = tileArray.__bufferSkipped;
		var drawCount = tileArray.__length;
		
		tileArray.position = 0;
		
		var tileset, flush = false;
		
		for (i in 0...(drawCount + 1)) {
			
			if (skipped[i]) {
				
				continue;
				
			}
			
			tileArray.position = (i < drawCount ? i : drawCount - 1);
			
			tileset = tileArray.tileset;
			if (tileset == null) tileset = defaultTileset;
			if (tileset == null) continue;
			
			if (tileset.__bitmapData != cacheBitmapData && cacheBitmapData != null) {
				
				flush = true;
				
			}
			
			if (flush) {
				
				shader.data.uImage0.input = cacheBitmapData;
				renderSession.shaderManager.updateShader (shader);
				
				gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
				flush = false;
				lastIndex = i;
				
			}
			
			cacheBitmapData = tileset.__bitmapData;
			
			if (i == drawCount && tileset.__bitmapData != null) {
				
				shader.data.uImage0.input = tileset.__bitmapData;
				renderSession.shaderManager.updateShader (shader);
				gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);
				
				#if gl_stats
					GLStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
			}
			
		}
		
	}
	
	
}