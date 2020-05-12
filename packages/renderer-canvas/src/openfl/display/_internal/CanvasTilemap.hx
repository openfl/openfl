package openfl.display._internal;

#if openfl_html5
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
#if !lime
import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
#else
import lime._internal.graphics.ImageCanvasUtil;
#end

@:access(lime.graphics.ImageBuffer)
@:access(openfl.display._internal)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Tile)
@:access(openfl.display.TileContainer)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Tileset)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasTilemap
{
	public static inline function render(tilemap:Tilemap, renderer:CanvasRenderer):Void
	{
		#if openfl_html5
		if (!tilemap._.__renderable || tilemap._.__group._.__tiles.length == 0) return;

		var alpha = renderer._.__getAlpha(tilemap._.__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;

		renderer._.__setBlendMode(tilemap._.__worldBlendMode);
		renderer._.__pushMaskObject(tilemap);

		var rect = _Rectangle.__pool.get();
		rect.setTo(0, 0, tilemap._.__width, tilemap._.__height);
		renderer._.__pushMaskRect(rect, tilemap._.__renderTransform);

		if (!renderer._.__allowSmoothing || !tilemap.smoothing)
		{
			context.imageSmoothingEnabled = false;
		}

		renderTileContainer(tilemap._.__group, renderer, tilemap._.__renderTransform, tilemap._.__tileset, (renderer._.__allowSmoothing && tilemap.smoothing),
			tilemap.tileAlphaEnabled, alpha, tilemap.tileBlendModeEnabled, tilemap._.__worldBlendMode, null, null, rect);

		if (!renderer._.__allowSmoothing || !tilemap.smoothing)
		{
			context.imageSmoothingEnabled = true;
		}

		renderer._.__popMaskRect();
		renderer._.__popMaskObject(tilemap);

		_Rectangle.__pool.release(rect);
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	public static function renderTileContainer(group:TileContainer, renderer:CanvasRenderer, parentTransform:Matrix, defaultTileset:Tileset, smooth:Bool,
			alphaEnabled:Bool, worldAlpha:Float, blendModeEnabled:Bool, defaultBlendMode:BlendMode, cacheBitmapData:BitmapData, source:Dynamic,
			rect:Rectangle):Void
	{
		#if (lime && openfl_html5)
		var context = renderer.context;
		var roundPixels = renderer._.__roundPixels;

		var tileTransform = _Matrix.__pool.get();

		var tiles = group._.__tiles;
		var length = group._.__length;

		var tile,
			tileset,
			alpha,
			visible,
			blendMode = null,
			id,
			tileData,
			tileRect,
			bitmapData;

		for (i in 0...length)
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
				blendMode = (tile._.__blendMode != null) ? tile._.__blendMode : defaultBlendMode;
			}

			if (tile._.__length > 0)
			{
				renderTileContainer(cast tile, renderer, tileTransform, tileset, smooth, alphaEnabled, alpha, blendModeEnabled, blendMode, cacheBitmapData,
					source, rect);
			}
			else
			{
				if (tileset == null) continue;

				id = tile.id;

				if (id == -1)
				{
					tileRect = tile._.__rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0) continue;
				}
				else
				{
					tileData = tileset._.__data[id];
					if (tileData == null) continue;

					rect.setTo(tileData.x, tileData.y, tileData.width, tileData.height);
					tileRect = rect;
				}

				bitmapData = tileset._.__bitmapData;
				if (bitmapData == null) continue;

				if (bitmapData != cacheBitmapData)
				{
					source = bitmapData._.__getElement();
					cacheBitmapData = bitmapData;
				}

				context.globalAlpha = alpha;

				if (blendModeEnabled)
				{
					renderer._.__setBlendMode(blendMode);
				}

				renderer.setTransform(tileTransform, context);
				context.drawImage(source, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width, tileRect.height);
			}
		}

		_Matrix.__pool.release(tileTransform);
		#end
	}
}
#end
