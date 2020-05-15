package openfl.display._internal;

#if openfl_html5
import js.Browser;
import openfl.display._internal.CanvasTilemap;
import openfl.display.Tilemap;

@:access(openfl.display.TileContainer)
@:access(openfl.display.Tilemap)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMTilemap
{
	public static function clear(tilemap:Tilemap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if ((tilemap._ : _Tilemap).__renderData.canvas != null)
		{
			renderer.element.removeChild((tilemap._ : _Tilemap).__renderData.canvas);
			(tilemap._ : _Tilemap).__renderData.canvas = null;
			(tilemap._ : _Tilemap).__renderData.style = null;
		}
		#end
	}

	public static inline function render(tilemap:Tilemap, renderer:DOMRenderer):Void
	{
		// TODO: Support GL-based Tilemap?

		#if openfl_html5
		if (tilemap.stage != null
			&& (tilemap._ : _Tilemap).__worldVisible
				&& (tilemap._ : _Tilemap).__renderable && ((tilemap._ : _Tilemap).__group._ : _TileContainer).__tiles.length > 0)
		{
			if ((tilemap._ : _Tilemap).__renderData.canvas == null)
			{
				(tilemap._ : _Tilemap).__renderData.canvas = cast Browser.document.createElement("canvas");
				(tilemap._ : _Tilemap).__renderData.context = (tilemap._ : _Tilemap).__renderData.canvas.getContext("2d");
				(renderer._ : _DOMRenderer).__initializeElement(tilemap, (tilemap._ : _Tilemap).__renderData.canvas);
			}

				(tilemap._ : _Tilemap).__renderData.canvas.width = (tilemap._ : _Tilemap).__width;
			(tilemap._ : _Tilemap).__renderData.canvas.height = (tilemap._ : _Tilemap).__height;

			(renderer._ : _DOMRenderer).__canvasRenderer.context = (tilemap._ : _Tilemap).__renderData.context;

			CanvasTilemap.render(tilemap, (renderer._ : _DOMRenderer).__canvasRenderer);

			(renderer._ : _DOMRenderer).__canvasRenderer.context = null;

			(renderer._ : _DOMRenderer).__updateClip(tilemap);
			(renderer._ : _DOMRenderer).__applyStyle(tilemap, true, false, true);
		}
		else
		{
			clear(tilemap, renderer);
		}
		#end
	}
}
#end
