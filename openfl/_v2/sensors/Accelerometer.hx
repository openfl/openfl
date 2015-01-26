package openfl._v2.sensors; #if lime_legacy


import haxe.Timer;
import openfl.errors.ArgumentError;
import openfl.events.AccelerometerEvent;
import openfl.events.EventDispatcher;
import openfl.Lib;


class Accelerometer extends EventDispatcher {
	
	
	public static var isSupported (get, null):Bool;
	
	public var muted (default, null):Bool;
	
	@:noCompletion private static var __defaultInterval:Int = 34;
	@:noCompletion private var __timer:Timer;
	
	
	public function new () {
		
		super ();
		
		muted = false;
		setRequestedUpdateInterval (__defaultInterval);
		
	}
	
	
	override public function addEventListener (type:String, listener:Function, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		super.addEventListener (type, listener, useCapture, priority, useWeakReference);
		__update ();
		
	}
	
	
	public function setRequestedUpdateInterval (interval:Float):Void {
		
		if (interval < 0) {
			
			throw new ArgumentError ();
			
		} else if (interval == 0) {
			
			interval = __defaultInterval;
			
		}
		
		if (__timer != null) {
			
			__timer.stop ();
			
		}
		
		if (isSupported) {
			
			__timer = new Timer (interval);
			__timer.run = __update;
			
		}
		
	}
	
	
	@:noCompletion private function __update ():Void {
		
		var event = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var data = lime_input_get_acceleration ();
		
		event.timestamp = Timer.stamp ();
		event.accelerationX = data.x;
		event.accelerationY = data.y;
		event.accelerationZ = data.z;
		
		dispatchEvent (event);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_isSupported ():Bool { return lime_input_get_acceleration () != null; }
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_input_get_acceleration = Lib.load ("lime", "lime_input_get_acceleration", 0);
	
	
}


typedef Function = Dynamic -> Void;


#end