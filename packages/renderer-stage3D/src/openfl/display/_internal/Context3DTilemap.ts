import * as internal from "../../../_internal/utils/InternalAccess";
import BitmapData from "../../../display/BitmapData";
import BlendMode from "../../../display/BlendMode";
import Shader from "../../../display/Shader";
import TileContainer from "../../../display/TileContainer";
import Tilemap from "../../../display/Tilemap";
import Tileset from "../../../display/Tileset";
import Context3D from "../../../display3D/Context3D";
import ColorTransform from "../../../geom/ColorTransform";
import Matrix from "../../../geom/Matrix";
import Rectangle from "../../../geom/Rectangle";
import Context3DRenderer from "./Context3DRenderer";

export default class Context3DTilemap
{
	public static cacheColorTransform: ColorTransform;

	public static buildBufferTileContainer(tilemap: Tilemap, group: TileContainer, renderer: Context3DRenderer, parentTransform: Matrix,
		defaultTileset: Tileset, alphaEnabled: boolean, worldAlpha: number, colorTransformEnabled: boolean, defaultColorTransform: ColorTransform,
		cacheBitmapData: BitmapData, rect: Rectangle, matrix: Matrix): void
	{
		var tileTransform = (<internal.Matrix><any>Matrix).__pool.get();
		var roundPixels = (<internal.DisplayObjectRenderer><any>renderer).__roundPixels;

		var tiles = (<internal.TileContainer><any>group).__tiles;
		var length = (<internal.TileContainer><any>group).__length;

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
			tile.__dirty = false;

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
						if (this.cacheColorTransform == null)
						{
							this.cacheColorTransform = new ColorTransform();
						}

						colorTransform = this.cacheColorTransform;
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

			if (tile.__length > 0)
			{
				this.buildBufferTileContainer(tilemap, tile as TileContainer, renderer, tileTransform, tileset, alphaEnabled, alpha, colorTransformEnabled, colorTransform,
					cacheBitmapData, rect, matrix);
			}
			else
			{
				if (tileset == null) continue;

				id = tile.id;

				bitmapData = tileset.__bitmapData;
				if (bitmapData == null) continue;

				if (id == -1)
				{
					tileRect = tile.__rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0) continue;

					uvX = tileRect.x / bitmapData.__renderData.textureWidth;
					uvY = tileRect.y / bitmapData.__renderData.textureHeight;
					uvWidth = tileRect.right / bitmapData.__renderData.textureWidth;
					uvHeight = tileRect.bottom / bitmapData.__renderData.textureHeight;
				}
				else
				{
					tileData = tileset.__data[id];
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

				renderer.batcher.setVertices(tileTransform, 0, 0, tileWidth, tileHeight);
				renderer.batcher.setUvs(uvX, uvY, uvWidth, uvHeight);

				var blendMode = (<internal.DisplayObject><any>tilemap).__worldBlendMode;
				if (tilemap.tileBlendModeEnabled)
				{
					blendMode = (tile.__blendMode != null) ? tile.__blendMode : blendMode;
				}

				renderer.batcher.pushQuad(bitmapData, blendMode, alpha, colorTransform);
			}
		}

		(<internal.Tile><any>group).__dirty = false;
		(<internal.Matrix><any>Matrix).__pool.release(tileTransform);
	}

	public static render(tilemap: Tilemap, renderer: Context3DRenderer): void
	{
		if (!(<internal.DisplayObject><any>tilemap).__renderable || (<internal.DisplayObject><any>tilemap).__worldAlpha <= 0) return;

		if (!(<internal.DisplayObject><any>tilemap).__renderable || (<internal.TileContainer><any>(<internal.Tilemap><any>tilemap).__group).__tiles.length == 0 || (<internal.DisplayObject><any>tilemap).__worldAlpha <= 0) return;

		var rect = (<internal.Rectangle><any>Rectangle).__pool.get();
		var matrix = (<internal.Matrix><any>Matrix).__pool.get();
		var parentTransform = (<internal.DisplayObject><any>tilemap).__renderTransform;
		var worldAlpha = ((<internal.DisplayObject><any>tilemap).__filters == null) ? (<internal.DisplayObject><any>tilemap).__worldAlpha : 1.0;

		this.buildBufferTileContainer(tilemap, (<internal.Tilemap><any>tilemap).__group, renderer, parentTransform, (<internal.Tilemap><any>tilemap).__tileset, tilemap.tileAlphaEnabled, worldAlpha,
			tilemap.tileColorTransformEnabled, (<internal.DisplayObject><any>tilemap).__worldColorTransform, null, rect, matrix);

		(<internal.Rectangle><any>Rectangle).__pool.release(rect);
		(<internal.Matrix><any>Matrix).__pool.release(matrix);
	}

	public static renderMask(tilemap: Tilemap, renderer: Context3DRenderer): void
	{
		// (<internal.Tilemap><any>tilemap).__updateTileArray ();

		// if ((<internal.Tilemap><any>tilemap).__tileArray == null || (<internal.Tilemap><any>tilemap).__tileArray.length == 0) return;

		// renderer:Context3DRenderer = cast renderer.renderer;

		// shader = (<internal.DisplayObjectRenderer><any>renderer).__maskShader;

		// uMatrix = (<internal.DisplayObjectRenderer><any>renderer).__getMatrix ((<internal.Tilemap><any>tilemap).__renderTransform);
		// smoothing = ((<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing && tilemap.smoothing);

		// tileArray = (<internal.Tilemap><any>tilemap).__tileArray;
		// defaultTileset = (<internal.Tilemap><any>tilemap).__tileset;

		// tileArray.__updateGLBuffer (gl, defaultTileset, (<internal.Tilemap><any>tilemap).__worldAlpha, (<internal.Tilemap><any>tilemap).__worldColorTransform);

		// gl.vertexAttribPointer (shader.openfl_Position.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 0);
		// gl.vertexAttribPointer (shader.openfl_TextureCoord.index, 2, gl.FLOAT, false, 25 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);

		// cacheBitmapData = null;
		// lastIndex = 0;
		// skipped = tileArray.__bufferSkipped;
		// drawCount = tileArray.__length;

		// tileArray.position = 0;

		// tileset, flush = false;

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

		// 		shader.openfl_Texture.input = cacheBitmapData;
		// 		renderer.shaderManager.updateShader ();

		// 		gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);

		// 		#if gl_stats
		// 			Context3DStats.incrementDrawCall (DrawCallContext.STAGE);
		// 		#end

		// 		flush = false;
		// 		lastIndex = i;

		// 	}

		// 	cacheBitmapData = tileset.__bitmapData;

		// 	if (i == drawCount && tileset.__bitmapData != null) {

		// 		shader.openfl_Texture.input = tileset.__bitmapData;
		// 		renderer.shaderManager.updateShader ();
		// 		gl.drawArrays (gl.TRIANGLES, lastIndex * 6, (i - lastIndex) * 6);

		// 		#if gl_stats
		// 			Context3DStats.incrementDrawCall (DrawCallContext.STAGE);
		// 		#end

		// 	}

		// }
	}
}
