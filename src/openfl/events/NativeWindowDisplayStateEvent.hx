package openfl.events;

#if (!flash && sys)
import openfl.display.NativeWindowDisplayState;

/**
**/
class NativeWindowDisplayStateEvent extends Event
{
	/**
	**/
	public static inline var DISPLAY_STATE_CHANGING:EventType<NativeWindowDisplayStateEvent> = "displayStateChanging";

	/**
	**/
	public static inline var DISPLAY_STATE_CHANGE:EventType<NativeWindowDisplayStateEvent> = "displayStateChange";

	/**
	**/
	public var beforeDisplayState:NativeWindowDisplayState;

	/**
	**/
	public var afterDisplayState:NativeWindowDisplayState;

	/**
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
