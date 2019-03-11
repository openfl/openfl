package flash.events;

#if flash
import openfl.events.EventType;

@:require(flash10_1)
extern class AccelerometerEvent extends Event
{
	public static var UPDATE(default, never):EventType<AccelerometerEvent>;
	public var accelerationX:Float;
	public var accelerationY:Float;
	public var accelerationZ:Float;
	public var timestamp:Float;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, timestamp:Float = 0, accelerationX:Float = 0, accelerationY:Float = 0,
		accelerationZ:Float = 0):Void;
	public override function clone():AccelerometerEvent;
}
#else
typedef AccelerometerEvent = openfl.events.AccelerometerEvent;
#end
