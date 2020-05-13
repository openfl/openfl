package openfl.events;

import openfl._internal.utils.ObjectPool;
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
	public var allowSmoothing(get, set):Bool;

	/**
		The concatenated color transform for the display object being rendered.
	**/
	public var objectColorTransform(get, set):ColorTransform;

	/**
		The concatenated matrix for the display object being rendered.
	**/
	public var objectMatrix(get, set):Matrix;

	/**
		The display object renderer being used for this render.
	**/
	public var renderer(get, never):DisplayObjectRenderer;

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
		if (_ == null)
		{
			_ = new _RenderEvent(type, bubbles, cancelable, objectMatrix, objectColorTransform, allowSmoothing);
		}

		super(type, bubbles, cancelable);
	}

	public override function clone():RenderEvent
	{
		return (_ : _RenderEvent).clone();
	}

	#if !flash
	public override function toString():String
	{
		return (_ : _RenderEvent).toString();
	}
	#end

	// Get & Set Methods

	@:noCompletion private function get_allowSmoothing():Bool
	{
		return (_ : _RenderEvent).allowSmoothing;
	}

	@:noCompletion private function set_allowSmoothing(value:Bool):Bool
	{
		return (_ : _RenderEvent).allowSmoothing = value;
	}

	@:noCompletion private function get_objectColorTransform():ColorTransform
	{
		return (_ : _RenderEvent).objectColorTransform;
	}

	@:noCompletion private function set_objectColorTransform(value:ColorTransform):ColorTransform
	{
		return (_ : _RenderEvent).objectColorTransform = value;
	}

	@:noCompletion private function get_objectMatrix():Matrix
	{
		return (_ : _RenderEvent).objectMatrix;
	}

	@:noCompletion private function set_objectMatrix(value:Matrix):Matrix
	{
		return (_ : _RenderEvent).objectMatrix = value;
	}

	@:noCompletion private function get_renderer():DisplayObjectRenderer
	{
		return (_ : _RenderEvent).renderer;
	}
}
