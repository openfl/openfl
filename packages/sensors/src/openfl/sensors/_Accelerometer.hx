package openfl.sensors;

import haxe.Timer;
import lime.system.Sensor;
import lime.system.SensorType;
import openfl.errors.ArgumentError;
import openfl.events.AccelerometerEvent;
import openfl.events.EventDispatcher;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Accelerometer extends _EventDispatcher
{
	public static var isSupported(get, never):Bool;

	public static var currentX:Float = 0.0;
	public static var currentY:Float = 1.0;
	public static var currentZ:Float = 0.0;
	public static var defaultInterval:Int = 34;
	public static var initialized:Bool = false;
	public static var supported:Bool = false;

	public var muted(get, set):Bool;

	public var __interval:Int;
	public var __muted:Bool;
	public var __timer:Timer;

	private var accelerometer:Accelerometer;

	public function new(accelerometer:Accelerometer)
	{
		this.accelerometer = accelerometer;

		super(accelerometer);

		initialize();

		__interval = 0;
		__muted = false;

		setRequestedUpdateInterval(defaultInterval);
	}

	public override function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0,
			useWeakReference:Bool = false):Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		update();
	}

	public static function initialize():Void
	{
		#if (lime || openfl_html5)
		if (!initialized)
		{
			var sensors = Sensor.getSensors(SensorType.ACCELEROMETER);

			if (sensors.length > 0)
			{
				sensors[0].onUpdate.add(accelerometer_onUpdate);
				Accelerometer.supported = true;
			}

			initialized = true;
		}
		#end
	}

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

	public function update():Void
	{
		var event = new AccelerometerEvent(AccelerometerEvent.UPDATE);

		event.timestamp = Timer.stamp();
		event.accelerationX = currentX;
		event.accelerationY = currentY;
		event.accelerationZ = currentZ;

		dispatchEvent(event);
	}

	// Event Handlers

	public static function accelerometer_onUpdate(x:Float, y:Float, z:Float):Void
	{
		Accelerometer.currentX = x;
		Accelerometer.currentY = y;
		Accelerometer.currentZ = z;
	}

	// Get & Set Methods

	public static function get_isSupported():Bool
	{
		initialize();

		return supported;
	}

	private function get_muted():Bool
	{
		return __muted;
	}

	private function set_muted(value:Bool):Bool
	{
		__muted = value;
		setRequestedUpdateInterval(__interval);

		return value;
	}
}
