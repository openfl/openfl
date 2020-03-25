import Matrix from "openfl/geom/Matrix";
// import openfl._internal.backend.lime_standalone.Canvas2DRenderContext;

namespace openfl.display
{
	/**
		**BETA**

		The CanvasRenderer API exposes support for HTML5 canvas render instructions within the
		`RenderEvent.RENDER_CANVAS` event
	**/
	export class CanvasRenderer extends DisplayObjectRenderer
	{
		/**
			The current HTML5 canvas render context
		**/
		public context: Canvas2DRenderContext;

		/**
			The active pixel ratio used during rendering
		**/
		public pixelRatio(default , null): number = 1;

		protected constructor(context: Canvas2DRenderContext)
		{
			super();

			this.context = context;
		}

		/**
			Set whether smoothing should be enabled on a canvas context
		**/
		public applySmoothing(context: Canvas2DRenderContext, value: boolean): void { }

		/**
			Set the matrix value for the current render context, or (optionally) another canvas
			context
		**/
		public setTransform(transform: Matrix, context: Canvas2DRenderContext = null): void { }
	}
}

export default openfl.display.CanvasRenderer;
