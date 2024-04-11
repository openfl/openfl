package openfl.events;

#if (!flash && sys)
/**
	A Geolocation object dispatches GeolocationEvent objects when it receives
	updates from the location sensor installed on the device.

	@see `openfl.sensors.Geolocation`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class GeolocationEvent extends Event
{
	/**
		Defines the value of the `type` property of a `update` event object.
	**/
	public static inline var UPDATE:EventType<DeviceRotationEvent> = "update";

	/**
		The latitude in degrees. The latitude values have the following range:
		(-90 <= `latitude` <= 90). Negative latitude is south and positive
		latitude is north.
	**/
	public var latitude:Float;

	/**
		The longitude in degrees. The longitude values have the following range:
		(-180 <= `longitude` < 180). Negative longitude is west and positivelongitude is east.
	**/
	public var longitude:Float;

	/**
		The altitude in meters.

		If altitude is not supported by the device, then this property is set to
		`Math.NaN`.
	**/
	public var altitude:Float;

	/**
		The horizontal accuracy in meters.
	**/
	public var horizontalAccuracy:Float;

	/**
		The vertical accuracy in meters.
	**/
	public var verticalAccuracy:Float;

	/**
		The speed in meters/second.
	**/
	public var speed:Float;

	/**
		The direction of movement (with respect to true north) in integer
		degrees. This is not the same as "bearing", which returns the direction
		of movement with respect to another point.

		**Note:** On Android devices, heading is not supported. The value of the
		`heading` property is always `Math.NaN` (Not a Number).
	**/
	public var heading:Float;

	/**
		The number of milliseconds at the time of the event since the runtime
		was initialized. For example, if the device captures geolocation data 4
		seconds after the application initializes, then the timestamp property
		of the event is set to 4000.
	**/
	public var timestamp:Float;

	/**
		Creates a GeolocationEvent object that contains information about the
		location of the device. Event objects are passed as parameters to event
		listeners.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, latitude:Float = 0, longitude:Float = 0, altitude:Float = 0,
			hAccuracy:Float = 0, vAccuracy:Float = 0, speed:Float = 0, heading:Float = 0, timestamp:Float = 0)
	{
		super(type, bubbles, cancelable);
		this.latitude = latitude;
		this.longitude = longitude;
		this.altitude = altitude;
		this.horizontalAccuracy = hAccuracy;
		this.verticalAccuracy = vAccuracy;
		this.speed = speed;
		this.heading = heading;
		this.timestamp = timestamp;
	}

	public override function clone():GeolocationEvent
	{
		return new GeolocationEvent(type, bubbles, cancelable, latitude, longitude, altitude, horizontalAccuracy, verticalAccuracy, speed, heading, timestamp);
	}
}
#else
#if air
typedef GeolocationEvent = flash.events.GeolocationEvent;
#end
#end
