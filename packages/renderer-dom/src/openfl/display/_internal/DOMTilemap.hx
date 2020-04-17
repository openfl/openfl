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
		if (tilemap.__renderData.canvas != null)
		{
			renderer.element.removeChild(tilemap.__renderData.canvas);
			tilemap.__renderData.canvas = null;
			tilemap.__renderData.style = null;
		}
		#end
	}

	public static inline function render(tilemap:Tilemap, renderer:DOMRenderer):Void
	{
		// TODO: Support GL-based Tilemap?

		#if openfl_html5
		if (tilemap.stage != null && tilemap.__worldVisible && tilemap.__renderable && tilemap.__group.__tiles.length > 0)
		{
			if (tilemap.__renderData.canvas == null)
			{
				tilemap.__renderData.canvas = cast Browser.document.createElement("canvas");
				tilemap.__renderData.context = tilemap.__renderData.canvas.getContext("2d");
				renderer.__initializeElement(tilemap, tilemap.__renderData.canvas);
			}

			tilemap.__renderData.canvas.width = tilemap.__width;
			tilemap.__renderData.canvas.height = tilemap.__height;

			renderer.__canvasRenderer.context = tilemap.__renderData.context;

			CanvasTilemap.render(tilemap, renderer.__canvasRenderer);

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
}
#end
