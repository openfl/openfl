import * as internal from "../../../_internal/utils/InternalAccess";
import Tilemap from "../../../display/Tilemap";
import CanvasTilemap from "../canvas/CanvasTilemap";
import DOMRenderer from "./DOMRenderer";

export default class DOMTilemap
{
	public static clear(tilemap: Tilemap, renderer: DOMRenderer): void
	{
		if ((<internal.DisplayObject><any>tilemap).__renderData.canvas != null)
		{
			renderer.element.removeChild((<internal.DisplayObject><any>tilemap).__renderData.canvas);
			(<internal.DisplayObject><any>tilemap).__renderData.canvas = null;
			(<internal.DisplayObject><any>tilemap).__renderData.style = null;
		}
	}

	public static render(tilemap: Tilemap, renderer: DOMRenderer): void
	{
		// TODO: Support GL-based Tilemap?

		if (tilemap.stage != null && (<internal.DisplayObject><any>tilemap).__worldVisible && (<internal.DisplayObject><any>tilemap).__renderable && (<internal.TileContainer><any>(<internal.Tilemap><any>tilemap).__group).__tiles.length > 0)
		{
			if ((<internal.DisplayObject><any>tilemap).__renderData.canvas == null)
			{
				(<internal.DisplayObject><any>tilemap).__renderData.canvas = document.createElement("canvas");
				(<internal.DisplayObject><any>tilemap).__renderData.context = (<internal.DisplayObject><any>tilemap).__renderData.canvas.getContext("2d");
				renderer.__initializeElement(tilemap, (<internal.DisplayObject><any>tilemap).__renderData.canvas);
			}

			(<internal.DisplayObject><any>tilemap).__renderData.canvas.width = (<internal.Tilemap><any>tilemap).__width;
			(<internal.DisplayObject><any>tilemap).__renderData.canvas.height = (<internal.Tilemap><any>tilemap).__height;

			renderer.__canvasRenderer.context = (<internal.DisplayObject><any>tilemap).__renderData.context;

			CanvasTilemap.render(tilemap, renderer.__canvasRenderer);

			renderer.__canvasRenderer.context = null;

			renderer.__updateClip(tilemap);
			renderer.__applyStyle(tilemap, true, false, true);
		}
		else
		{
			this.clear(tilemap, renderer);
		}
	}
}
