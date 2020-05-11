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
		if (tilemap._.__renderData.canvas != null)
		{
			renderer.element.removeChild(tilemap._.__renderData.canvas);
			tilemap._.__renderData.canvas = null;
			tilemap._.__renderData.style = null;
		}
		#end
	}

	public static inline function render(tilemap:Tilemap, renderer:DOMRenderer):Void
	{
		// TODO: Support GL-based Tilemap?

		#if openfl_html5
		if (tilemap.stage != null && tilemap._.__worldVisible && tilemap._.__renderable && tilemap._.__group._.__tiles.length > 0)
		{
			if (tilemap._.__renderData.canvas == null)
			{
				tilemap._.__renderData.canvas = cast Browser.document.createElement("canvas");
				tilemap._.__renderData.context = tilemap._.__renderData.canvas.getContext("2d");
				renderer._.__initializeElement(tilemap, tilemap._.__renderData.canvas);
			}

			tilemap._.__renderData.canvas.width = tilemap._.__width;
			tilemap._.__renderData.canvas.height = tilemap._.__height;

			renderer._.__canvasRenderer.context = tilemap._.__renderData.context;

			CanvasTilemap.render(tilemap, renderer._.__canvasRenderer);

			renderer._.__canvasRenderer.context = null;

			renderer._.__updateClip(tilemap);
			renderer._.__applyStyle(tilemap, true, false, true);
		}
		else
		{
			clear(tilemap, renderer);
		}
		#end
	}
}
#end
