package openfl.events;

#if (!flash && sys)
import openfl.geom.Rectangle;

/**
	A NativeWindow object dispatches a NativeWindowBoundsEvent object when the
	size or location of the window changes.

	@see `openfl.display.NativeWindow`
	@see `openfl.display.NativeWindow.x`
	@see `openfl.display.NativeWindow.y`
	@see `openfl.display.NativeWindow.width`
	@see `openfl.display.NativeWindow.height`
**/
class NativeWindowBoundsEvent extends Event
{
	/**
		Defines the value of the type property of a `moving` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `afterBounds` | The new bounds of the window. |
		| `beforeBounds` | The old bounds of the window. |
		| `target` | The NativeWindow object that has just changed state. |
		| `bubbles` | `false` |
		| `cancelable` | `true`; canceling this event object stops the move operation. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
	**/
	public static inline var MOVING:EventType<NativeWindowBoundsEvent> = "moving";

	/**
		Defines the value of the type property of a `move` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `afterBounds` | The new bounds of the window. |
		| `beforeBounds` | The old bounds of the window. |
		| `target` | The NativeWindow object that has just changed state. |
		| `bubbles` | `false` |
		| `cancelable` | `false`; There is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
	**/
	public static inline var MOVE:EventType<NativeWindowBoundsEvent> = "move";

	/**
		Defines the value of the type property of a `resizing` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `afterBounds` | The new bounds of the window. |
		| `beforeBounds` | The old bounds of the window. |
		| `target` | The NativeWindow object that has just changed state. |
		| `bubbles` | `false` |
		| `cancelable` | `true`; canceling this event object stops the resize operation. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
	**/
	public static inline var RESIZING:EventType<NativeWindowBoundsEvent> = "resizing";

	/**
		Defines the value of the type property of a `resize` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `afterBounds` | The new bounds of the window. |
		| `beforeBounds` | The old bounds of the window. |
		| `target` | The NativeWindow object that has just changed state. |
		| `bubbles` | `false` |
		| `cancelable` | `false`; There is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
	**/
	public static inline var RESIZE:EventType<NativeWindowBoundsEvent> = "resize";

	/**
		The bounds of the window before the change.

		If the event is `moving` or resizing, the bounds have not yet changed;
		`beforeBounds` reflects the current bounds. If the event is `move` or
		`resize`, `beforeBounds` indicates the original value.
	**/
	public var beforeBounds:Rectangle;

	/**
		The bounds of the window after the change.

		If the event is `moving` or `resizing`, the bounds have not yet changed;
		`afterBounds` indicates the new bounds if the event is not canceled. If
		the event is `move` or `resize`, `afterBounds` indicates the new bounds.
	**/
	public var afterBounds:Rectangle;

	/**
		Creates an Event object with specific information relevant to window
		bounds events. Event objects are passed as parameters to event
		listeners.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, beforeBounds:Rectangle = null, afterBounds:Rectangle = null)
	{
		super(type, bubbles, cancelable);
		this.beforeBounds = beforeBounds;
		this.afterBounds = afterBounds;
	}

	public override function clone():NativeWindowBoundsEvent
	{
		var event = new NativeWindowBoundsEvent(type, bubbles, cancelable, beforeBounds, afterBounds);

		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("NativeWindowBoundsEvent", ["type", "bubbles", "cancelable", "beforeBounds", "afterBounds"]);
	}
}
#else
#if air
typedef NativeWindowBoundsEvent = flash.events.NativeWindowBoundsEvent;
#end
#end
