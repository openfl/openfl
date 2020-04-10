import * as internal from "../../../_internal/utils/InternalAccess";
import BitmapData from "../../../display/BitmapData";
import BlendMode from "../../../display/BlendMode";
import TileContainer from "../../../display/TileContainer";
import Tilemap from "../../../display/Tilemap";
import Tileset from "../../../display/Tileset";
import Matrix from "../../../geom/Matrix";
import Rectangle from "../../../geom/Rectangle";
// import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
import CanvasRenderer from "./CanvasRenderer";

export default class CanvasTilemap
{
	public static render(tilemap: Tilemap, renderer: CanvasRenderer): void
	{
		if (!(<internal.DisplayObject><any>tilemap).__renderable || (<internal.TileContainer><any>(<internal.Tilemap><any>tilemap).__group).__tiles.length == 0) return;

		var alpha = renderer.__getAlpha((<internal.DisplayObject><any>tilemap).__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;

		renderer.__setBlendMode((<internal.DisplayObject><any>tilemap).__worldBlendMode);
		renderer.__pushMaskObject(tilemap);

		var rect = (<internal.Rectangle><any>Rectangle).__pool.get();
		rect.setTo(0, 0, (<internal.Tilemap><any>tilemap).__width, (<internal.Tilemap><any>tilemap).__height);
		renderer.__pushMaskRect(rect, (<internal.DisplayObject><any>tilemap).__renderTransform);

		if (!(<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing || !tilemap.smoothing)
		{
			context.imageSmoothingEnabled = false;
		}

		this.renderTileContainer((<internal.Tilemap><any>tilemap).__group, renderer, (<internal.DisplayObject><any>tilemap).__renderTransform, (<internal.Tilemap><any>tilemap).__tileset, ((<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing && tilemap.smoothing),
			tilemap.tileAlphaEnabled, alpha, tilemap.tileBlendModeEnabled, (<internal.DisplayObject><any>tilemap).__worldBlendMode, null, null, rect);

		if (!(<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing || !tilemap.smoothing)
		{
			context.imageSmoothingEnabled = true;
		}

		renderer.__popMaskRect();
		renderer.__popMaskObject(tilemap);

		(<internal.Rectangle><any>Rectangle).__pool.release(rect);
	}

	private static renderTileContainer(group: TileContainer, renderer: CanvasRenderer, parentTransform: Matrix, defaultTileset: Tileset, smooth: boolean,
		alphaEnabled: boolean, worldAlpha: number, blendModeEnabled: boolean, defaultBlendMode: BlendMode, cacheBitmapData: BitmapData, source: CanvasImageSource,
		rect: Rectangle): void
	{
		var context = renderer.context;
		var roundPixels = (<internal.DisplayObjectRenderer><any>renderer).__roundPixels;

		var tileTransform = (<internal.Matrix><any>Matrix).__pool.get();

		var tiles = (<internal.TileContainer><any>group).__tiles;
		var length = (<internal.TileContainer><any>group).__length;

		var tile,
			tileset,
			alpha,
			visible,
			blendMode = null,
			id,
			tileData,
			tileRect,
			bitmapData;

		for (let i = 0; i < length; i++)
		{
			tile = tiles[i];

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
			if (!visible || alpha <= 0) continue;

			if (!alphaEnabled) alpha = 1;

			if (blendModeEnabled)
			{
				blendMode = (tile.__blendMode != null) ? tile.__blendMode : defaultBlendMode;
			}

			if (tile.__length > 0)
			{
				this.renderTileContainer(tile, renderer, tileTransform, tileset, smooth, alphaEnabled, alpha, blendModeEnabled, blendMode, cacheBitmapData,
					source, rect);
			}
			else
			{
				if (tileset == null) continue;

				id = tile.id;

				if (id == -1)
				{
					tileRect = tile.__rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0) continue;
				}
				else
				{
					tileData = tileset.__data[id];
					if (tileData == null) continue;

					rect.setTo(tileData.x, tileData.y, tileData.width, tileData.height);
					tileRect = rect;
				}

				bitmapData = tileset.__bitmapData;
				if (bitmapData == null) continue;

				if (bitmapData != cacheBitmapData)
				{
					source = bitmapData.__getElement();
					cacheBitmapData = bitmapData;
				}

				context.globalAlpha = alpha;

				if (blendModeEnabled)
				{
					renderer.__setBlendMode(blendMode);
				}

				renderer.setTransform(tileTransform, context);
				context.drawImage(source, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width, tileRect.height);
			}
		}

		(<internal.Matrix><any>Matrix).__pool.release(tileTransform);
	}
}
