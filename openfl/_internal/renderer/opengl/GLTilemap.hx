package openfl._internal.renderer.opengl;


import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.display.Tile;
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
@:access(openfl.display.TileArray)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLTilemap {
	
	
	private static var __skippedTiles = new Map<Int, Bool> ();
	
	
	public static function render (tilemap:Tilemap, renderSession:RenderSession):Void {
		
		if (!tilemap.__renderable || tilemap.__worldAlpha <= 0) return;
		
		tilemap.__updateTileArray ();
		
		if (tilemap.__tileArray == null) return;
		
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
		
		var tileArray = tilemap.__tileArray;
		var defaultTileset = tilemap.tileset;
		
		tileArray.__updateGLBuffer (gl, defaultTileset, tilemap.__worldAlpha);
		
		gl.vertexAttribPointer (shader.data.aPosition.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
		
		var cacheBitmapData = null;
		var lastIndex = 0;
		var skipped = tileArray.__bufferSkipped;
		var drawCount = tileArray.__length;
		
		tileArray.position = 0;
		
		var tileset;
		
		for (i in 0...(drawCount + 1)) {
			
			if (skipped[i]) {
				
				continue;
				
			}
			
			tileset = tileArray.tileset;
			if (tileset == null) tileset = defaultTileset;
			
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
		
		renderSession.filterManager.popObject (tilemap);
		renderSession.maskManager.popRect ();
		renderSession.maskManager.popObject (tilemap);
		
		Rectangle.__pool.release (rect);
		
	}
	
	
}