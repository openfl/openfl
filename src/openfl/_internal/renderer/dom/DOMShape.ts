import * as internal from "../../../_internal/utils/InternalAccess";
import DisplayObject from "../../../display/DisplayObject";
import CanvasGraphics from "../canvas/CanvasGraphics";
import DOMRenderer from "./DOMRenderer";

export default class DOMShape
{
	public static clear(shape: DisplayObject, renderer: DOMRenderer): void
	{
		if ((<internal.DisplayObject><any>shape).__renderData.canvas != null)
		{
			renderer.element.removeChild((<internal.DisplayObject><any>shape).__renderData.canvas);
			(<internal.DisplayObject><any>shape).__renderData.canvas = null;
			(<internal.DisplayObject><any>shape).__renderData.style = null;
		}
	}

	public static render(shape: DisplayObject, renderer: DOMRenderer): void
	{
		var graphics = (<internal.DisplayObject><any>shape).__graphics;

		if (shape.stage != null && (<internal.DisplayObject><any>shape).__worldVisible && (<internal.DisplayObject><any>shape).__renderable && graphics != null)
		{
			CanvasGraphics.render(graphics, renderer.__canvasRenderer);

			if ((<internal.Graphics><any>graphics).__softwareDirty || (<internal.DisplayObject><any>shape).__worldAlphaChanged || ((<internal.DisplayObject><any>shape).__renderData.canvas != (<internal.Graphics><any>graphics).__renderData.canvas))
			{
				if ((<internal.Graphics><any>graphics).__renderData.canvas != null)
				{
					if ((<internal.DisplayObject><any>shape).__renderData.canvas != (<internal.Graphics><any>graphics).__renderData.canvas)
					{
						if ((<internal.DisplayObject><any>shape).__renderData.canvas != null)
						{
							renderer.element.removeChild((<internal.DisplayObject><any>shape).__renderData.canvas);
						}

						(<internal.DisplayObject><any>shape).__renderData.canvas = (<internal.Graphics><any>graphics).__renderData.canvas;
						(<internal.DisplayObject><any>shape).__renderData.context = (<internal.Graphics><any>graphics).__renderData.context;

						renderer.__initializeElement(shape, (<internal.DisplayObject><any>shape).__renderData.canvas);
					}
				}
				else
				{
					this.clear(shape, renderer);
				}
			}

			if ((<internal.DisplayObject><any>shape).__renderData.canvas != null)
			{
				renderer.__pushMaskObject(shape);

				var cacheTransform = (<internal.DisplayObject><any>shape).__renderTransform;
				(<internal.DisplayObject><any>shape).__renderTransform = (<internal.Graphics><any>graphics).__worldTransform;

				if ((<internal.Graphics><any>graphics).__transformDirty)
				{
					(<internal.Graphics><any>graphics).__transformDirty = false;
					(<internal.DisplayObject><any>shape).__renderTransformChanged = true;
				}

				renderer.__updateClip(shape);
				renderer.__applyStyle(shape, true, true, true);

				(<internal.DisplayObject><any>shape).__renderTransform = cacheTransform;

				renderer.__popMaskObject(shape);
			}
		}
		else
		{
			this.clear(shape, renderer);
		}
	}
}
