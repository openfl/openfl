package openfl.events;

// import openfl.utils.ObjectPool;
import openfl.display.DisplayObjectRenderer;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

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
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.ColorTransform)
@:beta class RenderEvent extends Event
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
	public static inline var CLEAR_DOM:EventType<RenderEvent> = "clearDOM";

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
	public static inline var RENDER_CAIRO:EventType<RenderEvent> = "renderCairo";

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
	public static inline var RENDER_CANVAS:EventType<RenderEvent> = "renderCanvas";

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
	public static inline var RENDER_DOM:EventType<RenderEvent> = "renderDOM";

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
	public static inline var RENDER_OPENGL:EventType<RenderEvent> = "renderOpenGL";

	/**
		Whether the current render should allow smoothing.
	**/
	public var allowSmoothing:Bool;

	/**
		The concatenated color transform for the display object being rendered.
	**/
	public var objectColorTransform:ColorTransform;

	/**
		The concatenated matrix for the display object being rendered.
	**/
	public var objectMatrix:Matrix;

	/**
		The display object renderer being used for this render.
	**/
	public var renderer(default, null):DisplayObjectRenderer;

	// @:noCompletion private static var __pool:ObjectPool<RenderEvent> = new ObjectPool<RenderEvent>(function() return new RenderEvent(null),
	// function(event) event.__init());

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
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, objectMatrix:Matrix = null, objectColorTransform:ColorTransform = null,
			allowSmoothing:Bool = true):Void
	{
		super(type, bubbles, cancelable);

		this.objectMatrix = objectMatrix;
		this.objectColorTransform = objectColorTransform;
		this.allowSmoothing = allowSmoothing;
	}

	public override function clone():RenderEvent
	{
		var event = new RenderEvent(type, bubbles, cancelable, objectMatrix.clone(), #if flash null #else objectColorTransform.__clone() #end, allowSmoothing);
		#if !flash
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		#end
		return event;
	}

	#if !flash
	public override function toString():String
	{
		return __formatToString("RenderEvent", ["type", "bubbles", "cancelable"]);
	}
	#end

	@:noCompletion private override function __init():Void
	{
		super.__init();
		objectMatrix = null;
		objectColorTransform = null;
		allowSmoothing = false;
		renderer = null;
	}
}
