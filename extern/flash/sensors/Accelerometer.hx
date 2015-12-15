package flash.sensors; #if (!display && flash)


import openfl.events.EventDispatcher;

@:require(flash10_1)


extern class Accelerometer extends EventDispatcher {
	
	
	public static var isSupported (default, null):Bool;
	public var muted (default, null):Bool;
	
	public function new ();
	public function setRequestedUpdateInterval (interval:Int):Void;
	
	
}


#else
typedef Accelerometer = openfl.sensors.Accelerometer;
#end