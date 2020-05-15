package openfl.display._internal;

#if openfl_html5
import openfl.display._CanvasRenderer;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.display._Tilemap;
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
		if (!(tilemap._ : _Tilemap).__renderable || ((tilemap._ : _Tilemap).__group._ : _TileContainer).__tiles.length == 0) return;

		var alpha = (renderer._ : _CanvasRenderer).__getAlpha((tilemap._ : _Tilemap).__worldAlpha);
		if (alpha <= 0) return;

		var context = renderer.context;

		(renderer._ : _CanvasRenderer).__setBlendMode((tilemap._ : _Tilemap).__worldBlendMode);
		(renderer._ : _CanvasRenderer).__pushMaskObject(tilemap);

		var rect = _Rectangle.__pool.get();
		rect.setTo(0, 0, (tilemap._ : _Tilemap).__width, (tilemap._ : _Tilemap).__height);
		(renderer._ : _CanvasRenderer).__pushMaskRect(rect, (tilemap._ : _Tilemap).__renderTransform);

		if (!(renderer._ : _CanvasRenderer).__allowSmoothing || !tilemap.smoothing)
		{
			context.imageSmoothingEnabled = false;
		}

		renderTileContainer((tilemap._ : _Tilemap).__group, renderer, (tilemap._ : _Tilemap).__renderTransform, (tilemap._ : _Tilemap).__tileset,
			((renderer._ : _CanvasRenderer).__allowSmoothing && tilemap.smoothing), tilemap.tileAlphaEnabled, alpha, tilemap.tileBlendModeEnabled,
			(tilemap._ : _Tilemap).__worldBlendMode, null, null, rect);

		if (!(renderer._ : _CanvasRenderer).__allowSmoothing || !tilemap.smoothing)
		{
			context.imageSmoothingEnabled = true;
		}

			(renderer._ : _CanvasRenderer).__popMaskRect();
		(renderer._ : _CanvasRenderer).__popMaskObject(tilemap);

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
		var roundPixels = (renderer._ : _CanvasRenderer).__roundPixels;

		var tileTransform = _Matrix.__pool.get();

		var tiles = (group._ : _TileContainer).__tiles;
		var length = (group._ : _TileContainer).__length;

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
				blendMode = ((tile._ : _Tile).__blendMode != null) ? (tile._ : _Tile).__blendMode : defaultBlendMode;
			}

			if ((tile._ : _Tile).__length > 0)
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
					tileRect = (tile._ : _Tile).__rect;
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
					source = (bitmapData._ : _BitmapData).__getElement();
					cacheBitmapData = bitmapData;
				}

				context.globalAlpha = alpha;

				if (blendModeEnabled)
				{
					(renderer._ : _CanvasRenderer).__setBlendMode(blendMode);
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
