import ObjectPool from "../_internal/utils/ObjectPool";
import Event from "../events/Event";
import EventType from "../events/EventType";

/**
	A Camera or Microphone object dispatches an ActivityEvent object whenever
	a camera or microphone reports that it has become active or inactive.
	There is only one type of activity event: `ActivityEvent.ACTIVITY`.

**/
export default class ActivityEvent extends Event
{
	/**
		The `ActivityEvent.ACTIVITY` constant defines the value of the `type`
		property of an `activity` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `activating` | `true` if the device is activating or `false` if it is deactivating. |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object beginning or ending a session, such as a Camera or Microphone object. |
	**/
	public static readonly ACTIVITY: EventType<ActivityEvent> = "activity";

	/**
		Indicates whether the device is activating (`true`) or deactivating
		(`false`).
	**/
	public activating: boolean;

	protected static __pool: ObjectPool<ActivityEvent> = new ObjectPool<ActivityEvent>(() => new ActivityEvent(null),
		(event) => event.__init());

	/**
		Creates an event object that contains information about activity
		events. Event objects are passed as parameters to Event listeners.

		@param type       The type of the event. Event listeners can access
						  this information through the inherited `type`
						  property. There is only one type of activity event:
						  `ActivityEvent.ACTIVITY`.
		@param bubbles    Determines whether the Event object participates in
						  the bubbling phase of the event flow. Event
						  listeners can access this information through the
						  inherited `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through
						  the inherited `cancelable` property.
		@param activating Indicates whether the device is activating (`true`)
						  or deactivating (`false`). Event listeners can
						  access this information through the `activating`
						  property.
	**/
	public constructor(type: string, bubbles: boolean = false, cancelable: boolean = false, activating: boolean = false)
	{
		super(type, bubbles, cancelable);

		this.activating = activating;
	}

	public clone(): ActivityEvent
	{
		var event = new ActivityEvent(this.__type, this.__bubbles, this.__cancelable, this.activating);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("ActivityEvent", "type", "bubbles", "cancelable", "activating");
	}

	protected __init(): void
	{
		super.__init();
		this.activating = false;
	}
}
