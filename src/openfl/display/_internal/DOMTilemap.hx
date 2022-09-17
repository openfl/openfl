package openfl.display._internal;

import openfl.geom.Matrix;
import openfl.display._internal.CanvasDisplayObject;
import openfl.display._internal.CanvasTilemap;
import openfl.display.DOMRenderer;
import openfl.display.Tilemap;
#if (js && html5)
import js.Browser;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.TileContainer)
@:access(openfl.display.Tilemap)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMTilemap
{
	public static function clear(tilemap:Tilemap, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		DOMDisplayObject.clear(tilemap, renderer);

		if (tilemap.__canvas != null)
		{
			renderer.element.removeChild(tilemap.__canvas);
			tilemap.__canvas = null;
			tilemap.__style = null;
		}
		#end
	}

	public static inline function render(tilemap:Tilemap, renderer:DOMRenderer):Void
	{
		// TODO: Support GL or Image-based Tilemap?

		#if (js && html5)
		if (tilemap.stage != null && tilemap.__worldVisible && tilemap.__renderable && tilemap.__group.__tiles.length > 0)
		{
			if (tilemap.__canvas == null)
			{
				tilemap.__canvas = cast Browser.document.createElement("canvas");
				tilemap.__context = tilemap.__canvas.getContext("2d");
				renderer.__initializeElement(tilemap, tilemap.__canvas);
			}

			tilemap.__canvas.width = tilemap.__width;
			tilemap.__canvas.height = tilemap.__height;

			renderer.__canvasRenderer.context = tilemap.__context;
			var cacheRenderTransform = tilemap.__renderTransform;
			tilemap.__renderTransform = Matrix.__identity;

			CanvasDisplayObject.render(tilemap, renderer.__canvasRenderer);
			CanvasTilemap.render(tilemap, renderer.__canvasRenderer);

			tilemap.__renderTransform = cacheRenderTransform;
			renderer.__canvasRenderer.context = null;

			renderer.__updateClip(tilemap);
			renderer.__applyStyle(tilemap, true, false, true);
		}
		else
		{
			clear(tilemap, renderer);
		}
		#end
	}

	public static function renderDrawable(tilemap:Tilemap, renderer:DOMRenderer):Void
	{
		renderer.__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

		if (tilemap.__cacheBitmap != null && !tilemap.__isCacheBitmapRender)
		{
			renderer.__renderDrawableClear(tilemap);
			tilemap.__cacheBitmap.stage = tilemap.stage;

			DOMBitmap.render(tilemap.__cacheBitmap, renderer);
		}
		else
		{
			// DOMDisplayObject.render(tilemap, renderer);
			DOMTilemap.render(tilemap, renderer);
		}

		renderer.__renderEvent(tilemap);
	}

	public static function renderDrawableClear(tilemap:Tilemap, renderer:DOMRenderer):Void
	{
		DOMTilemap.clear(tilemap, renderer);
	}
}
