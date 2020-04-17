import * as internal from "../_internal/utils/InternalAccess";
import ObjectPool from "../_internal/utils/ObjectPool";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import Event from "../events/Event";
import EventType from "../events/EventType";
import ColorTransform from "../geom/ColorTransform";
import Matrix from "../geom/Matrix";

/**
	**BETA**

	RenderEvent is dispatched (optionally) once a listener is added to a
	DisplayObject. When the internal Stage renderer is ready to draw the specified
	object, a RenderEvent will be dispatched.

	Caching a RenderEvent to access at a later time will not work properly. Also,
	since the RenderEvent is more of an internal API, there may be additional
	concerns to order to ensure that all objects and features work as-intended.

	The type of RenderEvent dispatched will match the type of rendering being used.
	This renderer type will match the default Stage render, but also can depend on
	whether an off-screen render (such as DisplayObject `cacheAsBitmap` or BitmapData
	`draw`) is being used.
**/
export default class RenderEvent extends Event
{
	/**
		The `RenderEvent.CLEAR_DOM` constant defines the value of the `type` property
		of an `renderEvent` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true` |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `renderer` | A reference to the active display object renderer. |
		| `target` | The display object that is going to be rendered. |
	**/
	public static readonly CLEAR_DOM: EventType<RenderEvent> = "clearDOM";

	/**
		The `RenderEvent.RENDER_CAIRO` constant defines the value of the `type` property
		of an `renderEvent` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true` |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `renderer` | A reference to the active display object renderer. |
		| `target` | The display object that is going to be rendered. |
	**/
	public static readonly RENDER_CAIRO: EventType<RenderEvent> = "renderCairo";

	/**
		The `RenderEvent.RENDER_CANVAS` constant defines the value of the `type` property
		of an `renderEvent` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true` |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `renderer` | A reference to the active display object renderer. |
		| `target` | The display object that is going to be rendered. |
	**/
	public static readonly RENDER_CANVAS: EventType<RenderEvent> = "renderCanvas";

	/**
		The `RenderEvent.RENDER_DOM` constant defines the value of the `type` property
		of an `renderEvent` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true` |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `renderer` | A reference to the active display object renderer. |
		| `target` | The display object that is going to be rendered. |
	**/
	public static readonly RENDER_DOM: EventType<RenderEvent> = "renderDOM";

	/**
		The `RenderEvent.RENDER_OPENGL` constant defines the value of the `type` property
		of an `renderEvent` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true` |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `renderer` | A reference to the active display object renderer. |
		| `target` | The display object that is going to be rendered. |
	**/
	public static readonly RENDER_OPENGL: EventType<RenderEvent> = "renderOpenGL";

	/**
		Whether the current render should allow smoothing.
	**/
	public allowSmoothing: boolean;

	/**
		The concatenated color transform for the display object being rendered.
	**/
	public objectColorTransform: ColorTransform;

	/**
		The concatenated matrix for the display object being rendered.
	**/
	public objectMatrix: Matrix;

	protected static __pool: ObjectPool<RenderEvent> = new ObjectPool<RenderEvent>(() => new RenderEvent(null),
		(event) => event.__init());

	protected __renderer: DisplayObjectRenderer;

	/**
		Creates an Event object that contains information about render events.
		Event objects are passed as parameters to event listeners.

		@param type        The type of the event. Possible values
						   are: `RenderEvent.CLEAR_DOM`,
						   `RenderEvent.RENDER_CAIRO`,
						   `RenderEvent.RENDER_CANVAS`,
						   `RenderEvent.RENDER_DOM`, and
						   `RenderEvent.RENDER_OPENGL`.
		@param bubbles     Determines whether the Event object participates in the
						   bubbling stage of the event flow.
		@param cancelable  Determines whether the Event object can be canceled.
		@param objectMatrix Sets the concatenated matrix for the display object being rendered.
		@param objectTransform  Sets the concatenated color transform for the display object being
		rendered.
		@param	allowSmoothing	Determines whether the current render should allow smoothing.
	**/
	public constructor(type: string, bubbles: boolean = false, cancelable: boolean = false, objectMatrix: Matrix = null, objectColorTransform: ColorTransform = null,
		allowSmoothing: boolean = true)
	{
		super(type, bubbles, cancelable);

		this.objectMatrix = objectMatrix;
		this.objectColorTransform = objectColorTransform;
		this.allowSmoothing = allowSmoothing;
	}

	public clone(): RenderEvent
	{
		var event = new RenderEvent(this.__type, this.__bubbles, this.__cancelable, this.objectMatrix.clone(), (<internal.ColorTransform><any>this.objectColorTransform).__clone(), this.allowSmoothing);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("RenderEvent", "type", "bubbles", "cancelable");
	}

	protected __init(): void
	{
		super.__init();
		this.objectMatrix = null;
		this.objectColorTransform = null;
		this.allowSmoothing = false;
		this.__renderer = null;
	}

	// Get & Set Methods

	/**
		The display object renderer being used for this render.
	**/
	public get renderer(): DisplayObjectRenderer
	{
		return this.__renderer;
	}
}
