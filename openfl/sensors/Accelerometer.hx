package openfl.sensors;


import haxe.Timer;
import lime.system.Sensor;
import lime.system.SensorType;
import openfl.errors.ArgumentError;
import openfl.events.AccelerometerEvent;
import openfl.events.EventDispatcher;

#if (js && html5)
import js.Browser;
#end


class Accelerometer extends EventDispatcher {
	
	
	private static var currentX = 0.0;
	private static var currentY = 1.0;
	private static var currentZ = 0.0;
	private static var defaultInterval = 34;
	private static var initialized = false;
	private static var supported = false;
	
	public static var isSupported (get, never):Bool;
	public var muted (default, set):Bool;
	
	private var _interval:Int;
	private var timer:Timer;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (Accelerometer, "isSupported", { get: Accelerometer.isSupported });
		
	}
	#end
	
	
	public function new () {
		
		super ();
		
		initialize ();
		
		_interval = 0;
		muted = false;
		setRequestedUpdateInterval (defaultInterval);
		
	}
	
	
	override public function addEventListener (type:String, listener:Dynamic -> Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		super.addEventListener (type, listener, useCapture, priority, useWeakReference);
		update ();
		
	}
	
	
	private static function initialize ():Void {
		
		if (!initialized) {
			
			var sensors = Sensor.getSensors (SensorType.ACCELEROMETER);
			
			if (sensors.length > 0) {
				
				sensors[0].onUpdate.add (accelerometer_onUpdate);
				supported = true;
				
			}
			
			initialized = true;
			
		}
		
	}
	
	
	public function setRequestedUpdateInterval (interval:Int):Void {
		
		_interval = interval;
		
		if (_interval < 0) {
			
			throw new ArgumentError ();
			
		} else if (_interval == 0) {
			
			_interval = defaultInterval;
			
		}
		
		if (timer != null) {
			
			timer.stop ();
			timer = null;
			
		}
		
		if (supported && !muted) {
			
			timer = new Timer (_interval);
			timer.run = update;
			
		}
		
	}
	
	
	private function update ():Void {
		
		var event = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		
		event.timestamp = Timer.stamp ();
		event.accelerationX = currentX;
		event.accelerationY = currentY;
		event.accelerationZ = currentZ;
		
		dispatchEvent (event);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private static function accelerometer_onUpdate (x:Float, y:Float, z:Float):Void {
		
		currentX = x;
		currentY = y;
		currentZ = z;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_isSupported ():Bool { 
		
		initialize ();
		
		return supported;
		
	}
	
	
	private function set_muted (value:Bool):Bool {
		
		this.muted = value;
		setRequestedUpdateInterval (_interval);
		
		return value;
		
	}
	
	
}