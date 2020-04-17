import * as internal from "../../../_internal/utils/InternalAccess";
import TextField from "../../../text/TextField";
import CanvasRenderer from "../canvas/CanvasRenderer";
import CanvasTextField from "../canvas/CanvasTextField";
import Context3DRenderer from "./Context3DRenderer";

export default class Context3DTextField
{
	public static render(textField: TextField, renderer: Context3DRenderer): void
	{
		CanvasTextField.render(textField, renderer.__softwareRenderer as CanvasRenderer, (<internal.DisplayObject><any>textField).__worldTransform);
		(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__hardwareDirty = false;
	}

	public static renderMask(textField: TextField, renderer: Context3DRenderer): void
	{
		CanvasTextField.render(textField, renderer.__softwareRenderer as CanvasRenderer, (<internal.DisplayObject><any>textField).__worldTransform);
		(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__hardwareDirty = false;
	}
}
