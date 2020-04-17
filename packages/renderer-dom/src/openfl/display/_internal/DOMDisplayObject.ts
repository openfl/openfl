import * as internal from "../../../_internal/utils/InternalAccess"
import DisplayObject from "../../../display/DisplayObject";
import DOMBitmap from "./DOMBitmap";
import DOMRenderer from "./DOMRenderer";
import DOMShape from "./DOMShape";

export default class DOMDisplayObject
{
	public static clear(displayObject: DisplayObject, renderer: DOMRenderer): void
	{
		if ((<internal.DisplayObject><any>displayObject).__renderData.cacheBitmap != null)
		{
			DOMBitmap.clear((<internal.DisplayObject><any>displayObject).__renderData.cacheBitmap, renderer);
		}
		DOMShape.clear(displayObject, renderer);
	}

	public static render(displayObject: DisplayObject, renderer: DOMRenderer): void
	{
		// if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		// if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !(<internal.DisplayObject><any>displayObject).__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			// renderer.__pushMaskObject (displayObject);

			// TODO: opaqueBackground using DIV element

			// renderer.__popMaskObject (displayObject);
		}

		DOMShape.render(displayObject, renderer);
	}
}
