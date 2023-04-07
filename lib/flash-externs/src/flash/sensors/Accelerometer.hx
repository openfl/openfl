package flash.sensors;

#if flash
import openfl.events.EventDispatcher;

@:require(flash10_1)
extern class Accelerometer extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public static var isSupported(default, never):Bool;
	public var muted(default, never):Bool;
	#else
	@:flash.property static var isSupported(get, never):Bool;
	@:flash.property var muted(get, never):Bool;
	#end

	public function new();
	public function setRequestedUpdateInterval(interval:Int):Void;

	#if (haxe_ver >= 4.3)
	private function get_muted():Bool;
	private static function get_isSupported():Bool;
	#end
}
#else
typedef Accelerometer = openfl.sensors.Accelerometer;
#end
