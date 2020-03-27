import ObjectPool from "../_internal/utils/ObjectPool";
import Event from "../events/Event";
import EventType from "../events/EventType";

/**
	The Accelerometer class dispatches AccelerometerEvent objects when
	acceleration updates are obtained from the Accelerometer sensor installed
	on the device.
**/
export default class AccelerometerEvent extends Event
{
	/**
		Defines the value of the `type` property of a `AccelerometerEvent`
		event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `timestamp` | The timestamp of the Accelerometer update. |
		| `accelerationX` | The acceleration value in Gs (9.8m/sec/sec) along the x-axis. |
		| `accelerationY` | The acceleration value in Gs (9.8m/sec/sec) along the y-axis. |
		| `accelerationZ` | The acceleration value in Gs (9.8m/sec/sec) along the z-axis. |
	**/
	public static readonly UPDATE: EventType<AccelerometerEvent> = "update";

	/**
		Acceleration along the x-axis, measured in Gs.(1 G is roughly 9.8
		m/sec/sec.) The x-axis runs from the left to the right of the device when
		it is in the upright position. The acceleration is positive if the device
		moves towards the right.
	**/
	public accelerationX: number;

	/**
		Acceleration along the y-axis, measured in Gs.(1 G is roughly 9.8
		m/sec/sec.). The y-axis runs from the bottom to the top of the device when
		it is in the upright position. The acceleration is positive if the device
		moves up relative to this axis.
	**/
	public accelerationY: number;

	/**
		Acceleration along the z-axis, measured in Gs.(1 G is roughly 9.8
		m/sec/sec.). The z-axis runs perpendicular to the face of the device. The
		acceleration is positive if you move the device so that the face moves
		higher.
	**/
	public accelerationZ: number;

	/**
		The number of milliseconds at the time of the event since the runtime was
		initialized. For example, if the device captures accelerometer data 4
		seconds after the application initializes, then the `timestamp`
		property of the event is set to 4000.
	**/
	public timestamp: number;

	protected static __pool: ObjectPool<AccelerometerEvent> = new ObjectPool<AccelerometerEvent>(() => new AccelerometerEvent(null), (event) => event.__init());

	/**
		Creates an AccelerometerEvent object that contains information about
		acceleration along three dimensional axis. Event objects are passed as
		parameters to event listeners.

		@param type          The type of the event. Event listeners can access
							 this information through the inherited
							 `type` property. There is only one type of
							 update event: `AccelerometerEvent.UPDATE`.
		@param bubbles       Determines whether the Event object bubbles. Event
							 listeners can access this information through the
							 inherited `bubbles` property.
		@param cancelable    Determines whether the Event object can be canceled.
							 Event listeners can access this information through
							 the inherited `cancelable` property.
		@param timestamp     The timestamp of the Accelerometer update.
		@param accelerationX The acceleration value in Gs(9.8m/sec/sec) along the
							 x-axis.
		@param accelerationY The acceleration value in Gs(9.8m/sec/sec) along the
							 y-axis.
		@param accelerationZ The acceleration value in Gs(9.8m/sec/sec) along the
							 z-axis.
	**/
	public constructor(type: string, bubbles: boolean = false, cancelable: boolean = false, timestamp: number = 0, accelerationX: number = 0, accelerationY: number = 0,
		accelerationZ: number = 0)
	{
		super(type, bubbles, cancelable);

		this.timestamp = timestamp;
		this.accelerationX = accelerationX;
		this.accelerationY = accelerationY;
		this.accelerationZ = accelerationZ;
	}

	public clone(): AccelerometerEvent
	{
		var event = new AccelerometerEvent(this.__type, this.__bubbles, this.__cancelable, this.timestamp, this.accelerationX, this.accelerationY, this.accelerationZ);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("AccelerometerEvent",
			"type",
			"bubbles",
			"cancelable",
			"timestamp",
			"accelerationX",
			"accelerationY",
			"accelerationZ"
		);
	}

	protected __init(): void
	{
		super.__init();
		this.timestamp = 0;
		this.accelerationX = 0;
		this.accelerationY = 0;
		this.accelerationZ = 0;
	}
}
