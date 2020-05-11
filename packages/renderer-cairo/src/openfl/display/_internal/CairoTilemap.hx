package openfl.display._internal;

#if openfl_cairo
import lime.math.Matrix3;
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
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
class CairoTilemap
{
	public static function render(tilemap:Tilemap, renderer:CairoRenderer):Void
	{
		if (!tilemap._.__renderable || tilemap._.__group._.__tiles.length == 0) return;

		var alpha = renderer._.__getAlpha(tilemap._.__worldAlpha);
		if (alpha <= 0) return;

		renderer._.__setBlendMode(tilemap._.__worldBlendMode);
		renderer._.__pushMaskObject(tilemap);

		var rect = _Rectangle.__pool.get();
		rect.setTo(0, 0, tilemap._.__width, tilemap._.__height);
		renderer._.__pushMaskRect(rect, tilemap._.__renderTransform);

		renderTileContainer(tilemap._.__group, renderer, tilemap._.__renderTransform, tilemap._.__tileset, (renderer._.__allowSmoothing && tilemap.smoothing),
			tilemap.tileAlphaEnabled, alpha, tilemap.tileBlendModeEnabled, tilemap._.__worldBlendMode, null, null, null, rect,
			#if lime new Matrix3() #else null #end);

		renderer._.__popMaskRect();
		renderer._.__popMaskObject(tilemap);

		_Rectangle.__pool.release(rect);
	}

	@SuppressWarnings("checkstyle:Dynamic")
	public static function renderTileContainer(group:TileContainer, renderer:CairoRenderer, parentTransform:Matrix, defaultTileset:Tileset, smooth:Bool,
			alphaEnabled:Bool, worldAlpha:Float, blendModeEnabled:Bool, defaultBlendMode:BlendMode, cacheBitmapData:BitmapData,
			surface:#if lime CairoSurface #else Dynamic #end, pattern:#if lime CairoPattern #else Dynamic #end, rect:Rectangle,
			matrix:#if lime Matrix3 #else Dynamic #end):Void
	{
		var cairo = renderer.cairo;

		var tileTransform = _Matrix.__pool.get();

		var tiles = group._.__tiles;

		var tile,
			tileset,
			alpha,
			visible,
			blendMode = null,
			id,
			tileData,
			tileRect,
			bitmapData;

		for (tile in tiles)
		{
			tileTransform.setTo(1, 0, 0, 1, -tile.originX, -tile.originY);
			tileTransform.concat(tile.matrix);
			tileTransform.concat(parentTransform);

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
					surface, pattern, rect, matrix);
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
					surface = bitmapData.getSurface();
					pattern = CairoPattern.createForSurface(surface);
					pattern.filter = smooth ? CairoFilter.GOOD : CairoFilter.NEAREST;

					cairo.source = pattern;
					cacheBitmapData = bitmapData;
				}

				if (blendModeEnabled)
				{
					renderer._.__setBlendMode(blendMode);
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

		_Matrix.__pool.release(tileTransform);
	}
}
#end
