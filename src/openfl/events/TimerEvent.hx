package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;

/**
	A Timer object dispatches a TimerEvent objects whenever the Timer object
	reaches the interval specified by the `Timer.delay` property.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class TimerEvent extends Event
{
	/**
		Defines the value of the `type` property of a `timer` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Timer object that has reached its interval. |
	**/
	public static inline var TIMER:EventType<TimerEvent> = "timer";

	/**
		Defines the value of the `type` property of a `timerComplete` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Timer object that has completed its requests. |
	**/
	public static inline var TIMER_COMPLETE:EventType<TimerEvent> = "timerComplete";

	// @:noCompletion private static var __pool:ObjectPool<TimerEvent> = new ObjectPool<TimerEvent>(function() return new TimerEvent(null),
	// 	function(event) event.__init());

	/**
		Creates an Event object with specific information relevant to
		`timer` events. Event objects are passed as parameters to event
		listeners.

		@param type       The type of the event. Event listeners can access this
						  information through the inherited `type`
						  property.
		@param bubbles    Determines whether the Event object bubbles. Event
						  listeners can access this information through the
						  inherited `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through the
						  inherited `cancelable` property.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false):Void
	{
		super(type, bubbles, cancelable);
	}

	public override function clone():TimerEvent
	{
		var event = new TimerEvent(type, bubbles, cancelable);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("TimerEvent", ["type", "bubbles", "cancelable"]);
	}

	/**
		Instructs Flash Player or the AIR runtime to render after processing of
		this event completes, if the display list has been modified.

	**/
	public function updateAfterEvent():Void {}
}
#else
typedef TimerEvent = flash.events.TimerEvent;
#end
