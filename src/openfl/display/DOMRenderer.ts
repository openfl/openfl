// import openfl._internal.backend.lime_standalone.DOMRenderContext;

namespace openfl.display
{
	/**
		**BETA**

		The DOMRenderer API exposes support for HTML5 DOM render instructions within the
		`RenderEvent.RENDER_DOM` event
	**/
	export class DOMRenderer extends DisplayObjectRenderer
	{
		/**
			The current HTML5 DOM element
		**/
		public element: DOMRenderContext;

		/**
			The active pixel ratio used during rendering
		**/
		public pixelRatio(default , null): number = 1;

		protected constructor(element: DOMRenderContext)
		{
			super();

			this.element = element;
		}

		/**
			Applies CSS styles to the specified DOM element, using a DisplayObject as the
			virtual parent. This helps set the z-order, position and other components for
			the DOM object
		**/
		public applyStyle(parent: DisplayObject, childElement: #if(openfl_html5 && !display) Element #else Dynamic #end): void {}

/**
	Removes previously set CSS styles from a DOM element, used when the element
	should no longer be a part of the display hierarchy
**/
public clearStyle(childElement: #if(openfl_html5 && !display) Element #else Dynamic #end): void {}

private __clearBitmap(bitmap: Bitmap): void {}
}
}

export default openfl.display.DOMRenderer;
