package flash.ui;

#if flash
import openfl.events.EventDispatcher;

@:require(flash11_8)
@:final extern class GameInput extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public static var isSupported(default, never):Bool;
	public static var numDevices(default, never):Int;
	#else
	@:flash.property static var isSupported(get, never):Bool;
	@:flash.property static var numDevices(get, never):Int;
	#end

	public function new();
	public static function getDeviceAt(index:Int):GameInputDevice;

	#if (haxe_ver >= 4.3)
	private static function get_isSupported():Bool;
	private static function get_numDevices():Int;
	#end
}
#else
typedef GameInput = openfl.ui.GameInput;
#end
