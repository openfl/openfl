package openfl.events;

#if (!flash && sys)
import openfl.display.NativeWindowDisplayState;

/**
	A NativeWindow object dispatches events of the NativeWindowDisplayStateEvent
	class when the window display state changes.

	@see `openfl.display.NativeWindow`
	@see `openfl.display.NativeWindow.displayState`
**/
class NativeWindowDisplayStateEvent extends Event
{
	/**
		Defines the value of the `type` property of a `displayStateChanging` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `afterDisplayState` | The display state of the window before the pending change. |
		| `beforeDisplayState` | The display state of the window after the pending change. |
		| `target` | The NativeWindow object that has just changed state. |
		| `bubbles` | `false` |
		| `cancelable` | `true`; canceling the event will prevent the change. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
	**/
	public static inline var DISPLAY_STATE_CHANGING:EventType<NativeWindowDisplayStateEvent> = "displayStateChanging";

	/**
		Defines the value of the `type` property of a `displayStateChange` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `afterDisplayState` | The old display state of the window. |
		| `beforeDisplayState` | The new display state of the window. |
		| `target` | The NativeWindow object that has just changed state. |
		| `bubbles` | `false` |
		| `cancelable` | `false`; There is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
	**/
	public static inline var DISPLAY_STATE_CHANGE:EventType<NativeWindowDisplayStateEvent> = "displayStateChange";

	/**
		The display state of the NativeWindow before the change.

		If the event is `displayStateChanging`, the display state has not yet
		changed; `beforeDisplayState` reflects the Window's current display
		state. If the event is `displayStateChanged`, `beforeDisplayState`
		indicates the previous value.
	**/
	public var beforeDisplayState:NativeWindowDisplayState;

	/**
		The display state of the NativeWindow after the change.

		If the event is `displayStateChanging`, the display state has not yet\
		changed; `afterDisplayState` indicates the new display state if the
		event is not canceled. If the event is `displayStateChanged`,
		`afterDisplayState` indicates the current value.
	**/
	public var afterDisplayState:NativeWindowDisplayState;

	/**
		Creates an Event object with specific information relevant to window
		display state events. Event objects are passed as parameters to event
		listeners.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, beforeDisplayState:NativeWindowDisplayState = null,
			afterDisplayState:NativeWindowDisplayState = null)
	{
		super(type, bubbles, cancelable);
		this.beforeDisplayState = beforeDisplayState;
		this.afterDisplayState = afterDisplayState;
	}

	public override function clone():NativeWindowDisplayStateEvent
	{
		var event = new NativeWindowDisplayStateEvent(type, bubbles, cancelable, beforeDisplayState, afterDisplayState);

		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("NativeWindowDisplayStateEvent", ["type", "bubbles", "cancelable", "beforeDisplayState", "afterDisplayState"]);
	}
}
#else
#if air
typedef NativeWindowDisplayStateEvent = flash.events.NativeWindowDisplayStateEvent;
#end
#end
