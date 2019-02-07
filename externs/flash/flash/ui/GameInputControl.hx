package flash.ui;

#if flash
import openfl.events.EventDispatcher;

extern class GameInputControl extends EventDispatcher implements Dynamic
{
	public var device(default, never):GameInputDevice;
	public var id(default, never):String;
	public var maxValue(default, never):Float;
	public var minValue(default, never):Float;
	public var value(default, never):Float;
	private function new(device:GameInputDevice, id:String, minValue:Float, maxValue:Float, value:Float = 0);
}
#else
typedef GameInputControl = openfl.ui.GameInputControl;
#end
