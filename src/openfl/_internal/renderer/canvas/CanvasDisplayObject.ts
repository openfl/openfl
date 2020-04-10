import DisplayObject from "../../../display/DisplayObject";
import ARGB from "../../graphics/ARGB";
import * as internal from "../../utils/InternalAccess";
import CanvasRenderer from "./CanvasRenderer";
import CanvasShape from "./CanvasShape";
// import openfl._internal.backend.lime_standalone.ARGB;

export default class CanvasDisplayObject
{
	public static render(displayObject: DisplayObject, renderer: CanvasRenderer): void
	{
		if (displayObject.opaqueBackground == null && (<internal.DisplayObject><any>displayObject).__graphics == null) return;
		if (!(<internal.DisplayObject><any>displayObject).__renderable) return;

		var alpha = (<any>renderer).__getAlpha((<internal.DisplayObject><any>displayObject).__worldAlpha);
		if (alpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !(<internal.DisplayObject><any>displayObject).__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			(<any>renderer).__setBlendMode((<internal.DisplayObject><any>displayObject).__worldBlendMode);
			(<any>renderer).__pushMaskObject(displayObject);

			var context = renderer.context;

			renderer.setTransform((<internal.DisplayObject><any>displayObject).__renderTransform, context);

			var color = new ARGB(displayObject.opaqueBackground);
			context.fillStyle = 'rgb(${color.r},${color.g},${color.b})';
			context.fillRect(0, 0, displayObject.width, displayObject.height);

			(<any>renderer).__popMaskObject(displayObject);
		}

		if ((<internal.DisplayObject><any>displayObject).__graphics != null)
		{
			CanvasShape.render(displayObject, renderer);
		}
	}
}
