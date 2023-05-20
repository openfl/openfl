package flash.events;

#if flash
import openfl.events.EventType;

@:require(flash10_1)
extern class AccelerometerEvent extends Event
{
	public static var UPDATE(default, never):EventType<AccelerometerEvent>;

	#if (haxe_ver < 4.3)
	public var accelerationX:Float;
	public var accelerationY:Float;
	public var accelerationZ:Float;
	public var timestamp:Float;
	#else
	@:flash.property var accelerationX(get, set):Float;
	@:flash.property var accelerationY(get, set):Float;
	@:flash.property var accelerationZ(get, set):Float;
	@:flash.property var timestamp(get, set):Float;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, timestamp:Float = 0, accelerationX:Float = 0, accelerationY:Float = 0,
		accelerationZ:Float = 0):Void;
	public override function clone():AccelerometerEvent;

	#if (haxe_ver >= 4.3)
	private function get_accelerationX():Float;
	private function get_accelerationY():Float;
	private function get_accelerationZ():Float;
	private function get_timestamp():Float;
	private function set_accelerationX(value:Float):Float;
	private function set_accelerationY(value:Float):Float;
	private function set_accelerationZ(value:Float):Float;
	private function set_timestamp(value:Float):Float;
	#end
}
#else
typedef AccelerometerEvent = openfl.events.AccelerometerEvent;
#end
