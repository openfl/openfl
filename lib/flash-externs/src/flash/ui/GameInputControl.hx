package flash.ui;

#if flash
import openfl.events.EventDispatcher;

extern class GameInputControl extends EventDispatcher implements Dynamic
{
	#if (haxe_ver < 4.3)
	public var device(default, never):GameInputDevice;
	public var id(default, never):String;
	public var maxValue(default, never):Float;
	public var minValue(default, never):Float;
	public var value(default, never):Float;
	#else
	@:flash.property var device(get, never):GameInputDevice;
	@:flash.property var id(get, never):String;
	@:flash.property var maxValue(get, never):Float;
	@:flash.property var minValue(get, never):Float;
	@:flash.property var value(get, never):Float;
	#end

	private function new(device:GameInputDevice, id:String, minValue:Float, maxValue:Float, value:Float = 0);

	#if (haxe_ver >= 4.3)
	private function get_device():GameInputDevice;
	private function get_id():String;
	private function get_maxValue():Float;
	private function get_minValue():Float;
	private function get_value():Float;
	#end
}
#else
typedef GameInputControl = openfl.ui.GameInputControl;
#end
