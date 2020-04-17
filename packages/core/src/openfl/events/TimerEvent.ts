import ObjectPool from "../_internal/utils/ObjectPool";
import Event from "../events/Event";
import EventType from "../events/EventType";

/**
	A Timer object dispatches a TimerEvent objects whenever the Timer object
	reaches the interval specified by the `Timer.delay` property.
**/
export default class TimerEvent extends Event
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
	public static readonly TIMER: EventType<TimerEvent> = "timer";

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
	public static readonly TIMER_COMPLETE: EventType<TimerEvent> = "timerComplete";

	protected static __pool: ObjectPool<TimerEvent> = new ObjectPool<TimerEvent>(() => new TimerEvent(null),
		(event) => event.__init());

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
	public constructor(type: string, bubbles: boolean = false, cancelable: boolean = false)
	{
		super(type, bubbles, cancelable);
	}

	public clone(): TimerEvent
	{
		var event = new TimerEvent(this.__type, this.__bubbles, this.__cancelable);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("TimerEvent", "type", "bubbles", "cancelable");
	}

	/**
		Instructs Flash Player or the AIR runtime to render after processing of
		this event completes, if the display list has been modified.

	**/
	public updateAfterEvent(): void { }
}
