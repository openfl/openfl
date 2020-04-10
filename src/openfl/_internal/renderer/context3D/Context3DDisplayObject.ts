import * as internal from "../../../_internal/utils/InternalAccess";
import Context3DClearMask from "../../../display3D/Context3DClearMask";
import DisplayObject from "../../../display/DisplayObject";
import Rectangle from "../../../geom/Rectangle";
import ARGB from "../../graphics/ARGB";
// import openfl._internal.backend.lime_standalone.ARGB;
import Context3DRenderer from "./Context3DRenderer";
import Context3DShape from "./Context3DShape";

export default class Context3DDisplayObject
{
	public static render(displayObject: DisplayObject, renderer: Context3DRenderer): void
	{
		if (displayObject.opaqueBackground == null && (<internal.DisplayObject><any>displayObject).__graphics == null) return;
		if (!(<internal.DisplayObject><any>displayObject).__renderable || (<internal.DisplayObject><any>displayObject).__worldAlpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !(<internal.DisplayObject><any>displayObject).__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			// #if!disable_batcher
			renderer.batcher.flush();
			// #end

			renderer.__setBlendMode((<internal.DisplayObject><any>displayObject).__worldBlendMode);
			renderer.__pushMaskObject(displayObject);

			var context = renderer.context3D;

			var rect = (<internal.Rectangle><any>Rectangle).__pool.get();
			rect.setTo(0, 0, displayObject.width, displayObject.height);
			renderer.__pushMaskRect(rect, (<internal.DisplayObject><any>displayObject).__renderTransform);

			var color = new ARGB(displayObject.opaqueBackground);
			context.clear(color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1, 0, 0, Context3DClearMask.COLOR);

			renderer.__popMaskRect();
			renderer.__popMaskObject(displayObject);

			(<internal.Rectangle><any>Rectangle).__pool.release(rect);
		}

		if ((<internal.DisplayObject><any>displayObject).__graphics != null)
		{
			Context3DShape.render(displayObject, renderer);
		}
	}

	public static renderMask(displayObject: DisplayObject, renderer: Context3DRenderer): void
	{
		if (displayObject.opaqueBackground == null && (<internal.DisplayObject><any>displayObject).__graphics == null) return;

		if (displayObject.opaqueBackground != null
			&& !(<internal.DisplayObject><any>displayObject).__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			// TODO

			// rect = (<internal.Rectangle><any>Rectangle).__pool.get ();
			// rect.setTo (0, 0, displayObject.width, displayObject.height);
			// renderer.__pushMaskRect (rect, (<internal.DisplayObject><any>displayObject).__renderTransform);

			// color:ARGB = (displayObject.opaqueBackground:ARGB);
			// gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1);
			// gl.clear (gl.COLOR_BUFFER_BIT);

			// renderer.__popMaskRect ();
			// renderer.__popMaskObject (displayObject);

			// (<internal.Rectangle><any>Rectangle).__pool.release (rect);
		}

		if ((<internal.DisplayObject><any>displayObject).__graphics != null)
		{
			Context3DShape.renderMask(displayObject, renderer);
		}
	}
}
