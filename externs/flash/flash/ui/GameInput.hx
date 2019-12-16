package flash.ui;

#if flash
import openfl.events.EventDispatcher;

@:require(flash11_8)
@:final extern class GameInput extends EventDispatcher
{
	public static var isSupported(default, never):Bool;
	public static var numDevices(default, never):Int;
	public function new();
	public static function getDeviceAt(index:Int):GameInputDevice;
}
#else
typedef GameInput = openfl.ui.GameInput;
#end
