package openfl.display._internal;

#if !flash
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CanvasRenderer;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
// TODO: Avoid use of private APIs
import lime._internal.graphics.ImageCanvasUtil;
#end

@:access(lime.graphics.ImageBuffer)
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
		#if (js && html5)
		if (!tilemap.__renderable || tilemap.__group.__tiles.length == 0) return;

		var alpha = renderer.__getAlpha(tilemap.__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;

		renderer.__setBlendMode(tilemap.__worldBlendMode);
		renderer.__pushMaskObject(tilemap);

		var rect = Rectangle.__pool.get();
		rect.setTo(0, 0, tilemap.__width, tilemap.__height);
		renderer.__pushMaskRect(rect, tilemap.__renderTransform);

		if (!renderer.__allowSmoothing || !tilemap.smoothing)
		{
			context.imageSmoothingEnabled = false;
		}

		renderTileContainer(tilemap, tilemap.__group, renderer, tilemap.__renderTransform, tilemap.__tileset, (renderer.__allowSmoothing && tilemap.smoothing),
			tilemap.tileAlphaEnabled, alpha, tilemap.tileBlendModeEnabled, tilemap.__worldBlendMode, null, null, rect);

		if (!renderer.__allowSmoothing || !tilemap.smoothing)
		{
			context.imageSmoothingEnabled = true;
		}

		renderer.__popMaskRect();
		renderer.__popMaskObject(tilemap);

		Rectangle.__pool.release(rect);
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private static function renderTileContainer(tilemap:Tilemap, group:TileContainer, renderer:CanvasRenderer, parentTransform:Matrix, defaultTileset:Tileset, smooth:Bool,
			alphaEnabled:Bool, worldAlpha:Float, blendModeEnabled:Bool, defaultBlendMode:BlendMode, cacheBitmapData:BitmapData, source:Dynamic,
			rect:Rectangle, containerX:Float = 0.0, containerY:Float = 0.0):Void
	{
		#if (js && html5)
		var context = renderer.context;
		var roundPixels = renderer.__roundPixels;

		var tileTransform = Matrix.__pool.get();

		var tiles = group.__tiles;
		var length = group.__length;

		var tile,
			tileset,
			alpha,
			visible,
			blendMode = null,
			id,
			tileData,
			tileRect,
			bitmapData;
		var actualTileX, actualTileY, tileWidth, tileHeight;

		var tilemapWidth = tilemap.__width / Math.abs(tilemap.__scaleX);
		var tilemapHeight = tilemap.__height / Math.abs(tilemap.__scaleY);

		for (i in 0...length)
		{
			tile = tiles[i];

			id = tile.id;
			tileset = tile.tileset != null ? tile.tileset : defaultTileset;
			alpha = tile.alpha * worldAlpha;
			visible = tile.visible;

			if(tile.__length == 0 && !tile.offscreenRendering)
			{
				if (id == -1)
				{
					tileRect = tile.__rect;
					if (tileRect == null || tileRect.width <= 0 || tileRect.height <= 0)
					{
						continue;
					}

					tileWidth = tileRect.width;
					tileHeight = tileRect.height;
				}else{
					tileData = tileset.__data[id];
					if (tileData == null)
					{
						continue;
					}

					tileWidth = tileData.width;
					tileHeight = tileData.height;
				}

				actualTileX = containerX + tile.x;
				actualTileY = containerY + tile.y;

				if(actualTileX + tileWidth < 0 || actualTileX > tilemapWidth || actualTileY + tileHeight < 0 || actualTileY > tilemapHeight)
				{
					continue;
				}
			}

			tileTransform.setTo(1, 0, 0, 1, -tile.originX, -tile.originY);
			tileTransform.concat(tile.matrix);
			tileTransform.concat(parentTransform);

			if (roundPixels)
			{
				tileTransform.tx = Math.round(tileTransform.tx);
				tileTransform.ty = Math.round(tileTransform.ty);
			}

			if (!visible || alpha <= 0) continue;

			if (!alphaEnabled) alpha = 1;

			if (blendModeEnabled)
			{
				blendMode = (tile.__blendMode != null) ? tile.__blendMode : defaultBlendMode;
			}

			if (tile.__length > 0)
			{
				renderTileContainer(tilemap, cast tile, renderer, tileTransform, tileset, smooth, alphaEnabled, alpha, blendModeEnabled, blendMode, cacheBitmapData,
					source, rect, containerX + tile.x, containerY + tile.y);
			}
			else
			{
				if (tileset == null) continue;

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
				if (bitmapData == null || bitmapData.image == null) continue;

				if (bitmapData != cacheBitmapData)
				{
					if (bitmapData.image.buffer.__srcImage == null)
					{
						ImageCanvasUtil.convertToCanvas(bitmapData.image);
					}

					source = bitmapData.image.src;
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

		Matrix.__pool.release(tileTransform);
		#end
	}

	public static function renderDrawable(tilemap:Tilemap, renderer:CanvasRenderer):Void
	{
		renderer.__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

		if (tilemap.__cacheBitmap != null && !tilemap.__isCacheBitmapRender)
		{
			CanvasBitmap.render(tilemap.__cacheBitmap, renderer);
		}
		else
		{
			CanvasDisplayObject.render(tilemap, renderer);
			CanvasTilemap.render(tilemap, renderer);
		}

		renderer.__renderEvent(tilemap);
	}

	public static function renderDrawableMask(tilemap:Tilemap, renderer:CanvasRenderer):Void {}
}
#end
