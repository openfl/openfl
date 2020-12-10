package openfl.sensors;

#if !flash
import haxe.Timer;
import openfl.errors.ArgumentError;
import openfl.events.AccelerometerEvent;
import openfl.events.EventDispatcher;
#if lime
import lime.system.Sensor;
import lime.system.SensorType;
#end

/**
	The Accelerometer class dispatches events based on activity detected by the
	device's motion sensor. This data represents the device's location or
	movement along a 3-dimensional axis. When the device moves, the sensor
	detects this movement and returns acceleration data. The Accelerometer
	class provides methods to query whether or not accelerometer is supported,
	and also to set the rate at which acceleration events are dispatched.

	**Note:** Use the `Accelerometer.isSupported` property to
	test the runtime environment for the ability to use this feature. While the
	Accelerometer class and its members are accessible to the Runtime Versions
	listed for each API entry, the current environment for the runtime
	determines the availability of this feature. For example, you can compile
	code using the Accelerometer class properties for Flash Player 10.1, but
	you need to use the `Accelerometer.isSupported` property to test
	for the availability of the Accelerometer feature in the current deployment
	environment for the Flash Player runtime. If
	`Accelerometer.isSupported` is `true` at runtime,
	then Accelerometer support currently exists.

	_AIR profile support:_ This feature is supported only on mobile
	devices. It is not supported on desktop or AIR for TV devices. See
	[AIR Profile Support](http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across
	multiple profiles.

	@event status Dispatched when an accelerometer changes its status.

				  **Note:** On some devices, the accelerometer is always
				  available. On such devices, an Accelerometer object never
				  dispatches a `status` event.
	@event update The `update` event is dispatched in response to
				  updates from the accelerometer sensor. The event is
				  dispatched in the following circumstances:



				   * When a new listener function is attached through
				  `addEventListener()`, this event is delivered once
				  to all the registered listeners for providing the current
				  value of the accelerometer.
				   * Whenever accelerometer updates are obtained from the
				  platform at device determined intervals.
				   * Whenever the application misses a change in the
				  accelerometer(for example, the runtime is resuming after
				  being idle).
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Accelerometer extends EventDispatcher
{
	/**
		The `isSupported` property is set to `true` if the
		accelerometer sensor is available on the device, otherwise it is set to
		`false`.
	**/
	public static var isSupported(get, never):Bool;

	@:noCompletion private static var currentX:Float = 0.0;
	@:noCompletion private static var currentY:Float = 1.0;
	@:noCompletion private static var currentZ:Float = 0.0;
	@:noCompletion private static var defaultInterval:Int = 34;
	@:noCompletion private static var initialized:Bool = false;
	@:noCompletion private static var supported:Bool = false;

	/**
		Specifies whether the user has denied access to the accelerometer
		(`true`) or allowed access(`false`). When this
		value changes, a `status` event is dispatched.
	**/
	public var muted(get, set):Bool;

	@:noCompletion private var __interval:Int;
	@:noCompletion private var __muted:Bool;
	@:noCompletion private var __timer:Timer;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(Accelerometer.prototype, "muted", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_muted (); }"),
			set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_muted (v); }")
		});
		untyped Object.defineProperty(Accelerometer, "isSupported", {
			get: function()
			{
				return Accelerometer.get_isSupported();
			}
		});
	}
	#end

	/**
		Creates a new Accelerometer instance.
	**/
	public function new()
	{
		super();

		initialize();

		__interval = 0;
		__muted = false;

		setRequestedUpdateInterval(defaultInterval);
	}

	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0,
			useWeakReference:Bool = false):Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		update();
	}

	@:noCompletion private static function initialize():Void
	{
		if (!initialized)
		{
			#if lime
			var sensors = Sensor.getSensors(SensorType.ACCELEROMETER);

			if (sensors.length > 0)
			{
				sensors[0].onUpdate.add(accelerometer_onUpdate);
				supported = true;
			}
			#end

			initialized = true;
		}
	}

	/**
		The `setRequestedUpdateInterval` method is used to set the
		desired time interval for updates. The time interval is measured in
		milliseconds. The update interval is only used as a hint to conserve the
		battery power. The actual time between acceleration updates may be greater
		or lesser than this value. Any change in the update interval affects all
		registered listeners. You can use the Accelerometer class without calling
		the `setRequestedUpdateInterval()` method. In this case, the
		application receives updates based on the device's default interval.

		@param interval The requested update interval. If `interval` is
						set to 0, then the minimum supported update interval is
						used.
		@throws ArgumentError The specified `interval` is less than
							  zero.
	**/
	public function setRequestedUpdateInterval(interval:Int):Void
	{
		__interval = interval;

		if (__interval < 0)
		{
			throw new ArgumentError();
		}
		else if (__interval == 0)
		{
			__interval = defaultInterval;
		}

		if (__timer != null)
		{
			__timer.stop();
			__timer = null;
		}

		if (supported && !muted)
		{
			__timer = new Timer(__interval);
			__timer.run = update;
		}
	}

	@:noCompletion private function update():Void
	{
		var event = new AccelerometerEvent(AccelerometerEvent.UPDATE);

		event.timestamp = Timer.stamp();
		event.accelerationX = currentX;
		event.accelerationY = currentY;
		event.accelerationZ = currentZ;

		dispatchEvent(event);
	}

	// Event Handlers
	@:noCompletion private static function accelerometer_onUpdate(x:Float, y:Float, z:Float):Void
	{
		currentX = x;
		currentY = y;
		currentZ = z;
	}

	// Getters & Setters
	@:noCompletion private static function get_isSupported():Bool
	{
		initialize();

		return supported;
	}

	@:noCompletion private function get_muted():Bool
	{
		return __muted;
	}

	@:noCompletion private function set_muted(value:Bool):Bool
	{
		__muted = value;
		setRequestedUpdateInterval(__interval);

		return value;
	}
}
#else
typedef Accelerometer = flash.sensors.Accelerometer;
#end
