package openfl.display._internal;

#if openfl_gl
import lime.utils.Float32Array;
import openfl.display._Context3DRenderer;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Shader;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.display3D.Context3D;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl.display._internal)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Shader)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.display.Tile)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DTilemap
{
	public static var cacheColorTransform:ColorTransform;

	public static function buildBufferTileContainer(tilemap:Tilemap, group:TileContainer, renderer:OpenGLRenderer, parentTransform:Matrix,
			defaultTileset:Tileset, alphaEnabled:Bool, worldAlpha:Float, colorTransformEnabled:Bool, defaultColorTransform:ColorTransform,
			cacheBitmapData:BitmapData, rect:Rectangle, matrix:Matrix):Void
	{
		var tileTransform = _Matrix.__pool.get();
		var roundPixels = (renderer._ : _Context3DRenderer).__roundPixels;

		var tiles = (group._ : _TileContainer).__tiles;
		var length = (group._ : _TileContainer).__length;

		var tile,
			tileset,
			alpha,
			visible,
			colorTransform = null,
			id,
			tileData,
			tileRect,
			bitmapData;
		var tileWidth, tileHeight, uvX, uvY, uvHeight, uvWidth, vertexOffset;

		for (tile in tiles)
		{
			tileTransform.setTo(1, 0, 0, 1, -tile.originX, -tile.originY);
			tileTransform.concat(tile.matrix);
			tileTransform.concat(parentTransform);

			if (roundPixels)
			{
				tileTransform.tx = Math.round(tileTransform.tx);
				tileTransform.ty = Math.round(tileTransform.ty);
			}

			tileset = tile.tileset != null ? tile.tileset : defaultTileset;

			alpha = tile.alpha * worldAlpha;
			visible = tile.visible;
			(tile._ : _Tile).__dirty = false;

			if (!visible || alpha <= 0) continue;

			if (colorTransformEnabled)
			{
				if (tile.colorTransform != null)
				{
					if (defaultColorTransform == null)
					{
						colorTransform = tile.colorTransform;
					}
					else
					{
						if (cacheColorTransform == null)
						{
							cacheColorTransform = new ColorTransform();
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
				}
				else
				{
					colorTransform = defaultColorTransform;
				}
			}

			if (!alphaEnabled) alpha = 1;

			if ((tile._ : _Tile).__length > 0)
			{
				buildBufferTileContainer(tilemap, cast tile, renderer, tileTransform, tileset, alphaEnabled, alpha, colorTransformEnabled, colorTransform,
					cacheBitmapData, rect, matrix);
			}
			else
			{
				if (tileset == null) continue;

				id = tile.id;

				bitmapData = tileset._.__bitmapData;
				if (bitmapData == null) continue;

				if (id == -1)
				{
					tileRect = (tile._ : _Tile).__rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0) continue;

					uvX = tileRect.x / (bitmapData._ : _BitmapData).__renderData.textureWidth;
					uvY = tileRect.y / (bitmapData._ : _BitmapData).__renderData.textureHeight;
					uvWidth = tileRect.right / (bitmapData._ : _BitmapData).__renderData.textureWidth;
					uvHeight = tileRect.bottom / (bitmapData._ : _BitmapData).__renderData.textureHeight;
				}
				else
				{
					tileData = tileset._.__data[id];
					if (tileData == null) continue;

					rect.setTo(tileData.x, tileData.y, tileData.width, tileData.height);
					tileRect = rect;

					uvX = tileData.__uvX;
					uvY = tileData.__uvY;
					uvWidth = tileData.__uvWidth;
					uvHeight = tileData.__uvHeight;
				}

				tileWidth = tileRect.width;
				tileHeight = tileRect.height;

				(renderer._ : _Context3DRenderer).batcher.setVertices(tileTransform, 0, 0, tileWidth, tileHeight);
				(renderer._ : _Context3DRenderer).batcher.setUvs(uvX, uvY, uvWidth, uvHeight);

				var blendMode = (tilemap._ : _Tilemap).__worldBlendMode;
				if (tilemap.tileBlendModeEnabled)
				{
					blendMode = ((tile._ : _Tile).__blendMode != null) ? (tile._ : _Tile).__blendMode : blendMode;
				}

					(renderer._ : _Context3DRenderer).batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);
			}
		}

			(group._ : _TileContainer).__dirty = false;
		_Matrix.__pool.release(tileTransform);
	}

	public static function render(tilemap:Tilemap, renderer:OpenGLRenderer):Void
	{
		if (!(tilemap._ : _Tilemap).__renderable || (tilemap._ : _Tilemap).__worldAlpha <= 0) return;

		if (!(tilemap._ : _Tilemap).__renderable
			|| ((tilemap._ : _Tilemap).__group._ : _TileContainer).__tiles.length == 0 || (tilemap._ : _Tilemap).__worldAlpha <= 0) return;

		var rect = _Rectangle.__pool.get();
		var matrix = _Matrix.__pool.get();
		var parentTransform = (tilemap._ : _Tilemap).__renderTransform;
		var worldAlpha = ((tilemap._ : _Tilemap).__filters == null) ? (tilemap._ : _Tilemap).__worldAlpha : 1.0;

		buildBufferTileContainer(tilemap, (tilemap._ : _Tilemap).__group, renderer, parentTransform, (tilemap._ : _Tilemap).__tileset,
			tilemap.tileAlphaEnabled, worldAlpha, tilemap.tileColorTransformEnabled, (tilemap._ : _Tilemap).__worldColorTransform, null, rect, matrix);

		_Rectangle.__pool.release(rect);
		_Matrix.__pool.release(matrix);
	}

	public static function renderMask(tilemap:Tilemap, renderer:OpenGLRenderer):Void
	{
		// (tilemap._ : _Tilemap).__updateTileArray ();

		// if ((tilemap._ : _Tilemap).__tileArray == null || (tilemap._ : _Tilemap).__tileArray.length == 0) return;

		// var renderer:OpenGLRenderer = cast renderer.renderer;

		// var shader = (renderer._ : _Context3DRenderer).__maskShader;

		// var uMatrix = (renderer._ : _Context3DRenderer).__getMatrix ((tilemap._ : _Tilemap).__renderTransform);
		// var smoothing = ((renderer._ : _Context3DRenderer).__allowSmoothing && tilemap.smoothing);

		// var tileArray = (tilemap._ : _Tilemap).__tileArray;
		// var defaultTileset = (tilemap._ : _Tilemap).__tileset;

		// tileArray._.__updateGLBuffer (gl, defaultTileset, (tilemap._ : _Tilemap).__worldAlpha, (tilemap._ : _Tilemap).__worldColorTransform);

		// gl.vertexAttribPointer (shader.openfl_Position.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 0);
		// gl.vertexAttribPointer (shader.openfl_TextureCoord.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);

		// var cacheBitmapData = null;
		// var lastIndex = 0;
		// var skipped = tileArray._.__bufferSkipped;
		// var drawCount = tileArray._.__length;

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

		// 	if (tileset._.__bitmapData != cacheBitmapData && cacheBitmapData != null) {

		// 		flush = true;

		// 	}

		// 	if (flush) {

		// 		shader.openfl_Texture.input = cacheBitmapData;
		// 		renderer.shaderManager.updateShader ();

		// 		gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);

		// 		#if gl_stats
		// 			Context3DStats.incrementDrawCall (DrawCallContext.STAGE);
		// 		#end

		// 		flush = false;
		// 		lastIndex = i;

		// 	}

		// 	cacheBitmapData = tileset._.__bitmapData;

		// 	if (i == drawCount && tileset._.__bitmapData != null) {

		// 		shader.openfl_Texture.input = tileset._.__bitmapData;
		// 		renderer.shaderManager.updateShader ();
		// 		gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);

		// 		#if gl_stats
		// 			Context3DStats.incrementDrawCall (DrawCallContext.STAGE);
		// 		#end

		// 	}

		// }
	}
}
#end
