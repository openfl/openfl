package openfl.events;

#if (!flash && sys)
/**
	The DeviceRotation class dispatches DeviceRotationEvent and returns roll,
	yaw, pitch and quaternion data when DeviceRotation updates are obtained from
	the combined readings from Accelerometer and Gyroscope sensors' readings
	installed on the device.

	@see `openfl.sensors.DeviceRotation`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DeviceRotationEvent extends Event
{
	/**
		Defines the value of the `type` property of a `update` event object.
	**/
	public static inline var UPDATE:EventType<DeviceRotationEvent> = "update";

	/**
		The number of milliseconds at the time of the event since the runtime
		was initialized. For example, if the device captures DeviceRotation data
		4 seconds after the application initializes, then the timestamp property
		of the event is set to 4000.
	**/
	public var timestamp:Float;

	/**
		The roll along the y-axis, measured in degrees.
	**/
	public var roll:Float;

	/**
		The pitch along the x-axis, measured in degrees.
	**/
	public var pitch:Float;

	/**
		The yaw along the z-axis, measured in degrees.
	**/
	public var yaw:Float;

	/**
		Quaternion data for the device rotation in the [w, x, y, z] format.
	**/
	public var quaternion:Array<Float>;

	/**
		Creates an DeviceRotationEvent object that contains information about
		roll, yaw, pitch along the three dimensional axis. Event objects are
		passed as parameters to event listeners.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, timestamp:Float = 0, roll:Float = 0, pitch:Float = 0, yaw:Float = 0,
			quaternion:Array<Float> = null)
	{
		super(type, bubbles, cancelable);
		this.timestamp = timestamp;
		this.roll = roll;
		this.pitch = pitch;
		this.yaw = yaw;
		this.quaternion = quaternion;
	}

	public override function clone():DeviceRotationEvent
	{
		return new DeviceRotationEvent(type, bubbles, cancelable, timestamp, roll, pitch, yaw, quaternion);
	}
}
#else
#if air
typedef DeviceRotationEvent = flash.events.DeviceRotationEvent;
#end
#end
