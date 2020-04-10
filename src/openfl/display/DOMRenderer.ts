import Bitmap from "../display/Bitmap";
import DisplayObject from "../display/DisplayObject";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";

/**
	**BETA**

	The DOMRenderer API exposes support for HTML5 DOM render instructions within the
	`RenderEvent.RENDER_DOM` event
**/
export default class DOMRenderer extends DisplayObjectRenderer
{
	/**
		The current HTML5 DOM element
	**/
	public element: HTMLElement;

	protected __pixelRatio: number = 1;

	protected constructor(element: HTMLElement)
	{
		super();

		this.element = element;
	}

	/**
		Applies CSS styles to the specified DOM element, using a DisplayObject as the
		virtual parent. This helps set the z-order, position and other components for
		the DOM object
	**/
	public applyStyle(parent: DisplayObject, childElement: HTMLElement): void { }

	/**
	Removes previously set CSS styles from a DOM element, used when the element
	should no longer be a part of the display hierarchy
	**/
	public clearStyle(childElement: HTMLElement): void { }

	protected __clearBitmap(bitmap: Bitmap): void { }

	// Get & Set Methods

	/**
		The active pixel ratio used during rendering
	**/
	public get pixelRatio(): number
	{
		return this.__pixelRatio;
	}
}
