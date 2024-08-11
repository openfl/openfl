package openfl.display._internal;

#if !flash
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CairoRenderer;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
import lime.math.Matrix3;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
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
class CairoTilemap
{
	public static function render(tilemap:Tilemap, renderer:CairoRenderer):Void
	{
		if (!tilemap.__renderable || tilemap.__group.__tiles.length == 0) return;

		var alpha = renderer.__getAlpha(tilemap.__worldAlpha);
		if (alpha <= 0) return;

		renderer.__setBlendMode(tilemap.__worldBlendMode);
		renderer.__pushMaskObject(tilemap);

		var rect = Rectangle.__pool.get();
		rect.setTo(0, 0, tilemap.__width, tilemap.__height);
		renderer.__pushMaskRect(rect, tilemap.__renderTransform);

		renderTileContainer(tilemap, tilemap.__group, renderer, tilemap.__renderTransform, tilemap.__tileset, (renderer.__allowSmoothing && tilemap.smoothing),
			tilemap.tileAlphaEnabled, alpha, tilemap.tileBlendModeEnabled, tilemap.__worldBlendMode, null, null, null, rect,
			#if lime new Matrix3() #else null #end);

		renderer.__popMaskRect();
		renderer.__popMaskObject(tilemap);

		Rectangle.__pool.release(rect);
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private static function renderTileContainer(tilemap:Tilemap, group:TileContainer, renderer:CairoRenderer, parentTransform:Matrix, defaultTileset:Tileset, smooth:Bool,
			alphaEnabled:Bool, worldAlpha:Float, blendModeEnabled:Bool, defaultBlendMode:BlendMode, cacheBitmapData:BitmapData,
			surface:#if lime CairoSurface #else Dynamic #end, pattern:#if lime CairoPattern #else Dynamic #end, rect:Rectangle,
			matrix:#if lime Matrix3 #else Dynamic #end, containerX:Float = 0.0, containerY:Float = 0.0):Void
	{
		#if lime
		var cairo = renderer.cairo;

		var tileTransform = Matrix.__pool.get();

		var tiles = group.__tiles;

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

		for (tile in tiles)
		{
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

			if (!visible || alpha <= 0) continue;

			if (!alphaEnabled) alpha = 1;

			if (blendModeEnabled)
			{
				blendMode = (tile.__blendMode != null) ? tile.__blendMode : defaultBlendMode;
			}

			if (tile.__length > 0)
			{
				renderTileContainer(tilemap, cast tile, renderer, tileTransform, tileset, smooth, alphaEnabled, alpha, blendModeEnabled, blendMode, cacheBitmapData,
					surface, pattern, rect, matrix, containerX + tile.x, containerY + tile.y);
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
					surface = bitmapData.getSurface();
					pattern = CairoPattern.createForSurface(surface);
					pattern.filter = smooth ? CairoFilter.GOOD : CairoFilter.NEAREST;

					cairo.source = pattern;
					cacheBitmapData = bitmapData;
				}

				if (blendModeEnabled)
				{
					renderer.__setBlendMode(blendMode);
				}

				renderer.applyMatrix(tileTransform, cairo);

				matrix.tx = tileRect.x;
				matrix.ty = tileRect.y;
				pattern.matrix = matrix;
				cairo.source = pattern;

				cairo.save();

				cairo.newPath();
				cairo.rectangle(0, 0, tileRect.width, tileRect.height);
				cairo.clip();

				if (alpha == 1)
				{
					cairo.paint();
				}
				else
				{
					cairo.paintWithAlpha(alpha);
				}

				cairo.restore();
			}
		}

		Matrix.__pool.release(tileTransform);
		#end
	}

	public static inline function renderDrawable(tilemap:Tilemap, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		renderer.__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

		if (tilemap.__cacheBitmap != null && !tilemap.__isCacheBitmapRender)
		{
			CairoBitmap.render(tilemap.__cacheBitmap, renderer);
		}
		else
		{
			CairoDisplayObject.render(tilemap, renderer);
			CairoTilemap.render(tilemap, renderer);
		}

		renderer.__renderEvent(tilemap);
		#end
	}

	public static inline function renderDrawableMask(tilemap:Tilemap, renderer:CairoRenderer):Void {}
}
#end
