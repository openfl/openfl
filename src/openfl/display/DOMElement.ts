import DisplayObjectType from "../_internal/renderer/DisplayObjectType";
import DisplayObject from "../display/DisplayObject";

export default class DOMElement extends DisplayObject
{
	protected __active: boolean;
	protected __element: HTMLElement;

	public constructor(element: HTMLElement)
	{
		super();

		this.__element = element;
		this.__type = DisplayObjectType.DOM_ELEMENT;
	}
}
