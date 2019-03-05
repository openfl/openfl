package flash.sensors;

#if flash
import openfl.events.EventDispatcher;

@:require(flash10_1)
extern class Accelerometer extends EventDispatcher
{
	public static var isSupported(default, never):Bool;
	public var muted(default, never):Bool;
	public function new();
	public function setRequestedUpdateInterval(interval:Int):Void;
}
#else
typedef Accelerometer = openfl.sensors.Accelerometer;
#end
