import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import Matrix from "../geom/Matrix";

/**
	**BETA**

	The CanvasRenderer API exposes support for HTML5 canvas render instructions within the
	`RenderEvent.RENDER_CANVAS` event
**/
export default class CanvasRenderer extends DisplayObjectRenderer
{
	/**
		The current HTML5 canvas render context
	**/
	public context: CanvasRenderingContext2D;

	protected __pixelRatio: number = 1;

	protected constructor(context: CanvasRenderingContext2D)
	{
		super();

		this.context = context;
	}

	/**
		Set whether smoothing should be enabled on a canvas context
	**/
	public applySmoothing(context: CanvasRenderingContext2D, value: boolean): void { }

	/**
		Set the matrix value for the current render context, or (optionally) another canvas
		context
	**/
	public setTransform(transform: Matrix, context: CanvasRenderingContext2D = null): void { }

	// Get & Set Methods

	/**
		The active pixel ratio used during rendering
	**/
	public get pixelRatio(): number
	{
		return this.__pixelRatio;
	}
}
