namespace openfl.display
{
	export class DOMElement extends DisplayObject
	{
		protected __active: boolean;
		protected __element: HTMLElement;

		public constructor(element: HTMLElement)
		{
			super();

			__element = element;
			__type = DOM_ELEMENT;
		}
	}
}

export default openfl.display.DOMElement;
