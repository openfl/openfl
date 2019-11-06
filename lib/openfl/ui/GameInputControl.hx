package openfl.ui;

#if (display || !flash)
import openfl.events.EventDispatcher;

#if !openfl_global
@:jsRequire("openfl/ui/GameInputControl", "default")
#end
extern class GameInputControl extends EventDispatcher
{
	/**
	 * Returns the GameInputDevice object that contains this control.
	 */
	public var device(default, null):GameInputDevice;

	/**
	 * Returns the id of this control.
	 */
	public var id(default, null):String;

	/**
	 * Returns the maximum value for this control.
	 */
	public var maxValue(default, null):Float;

	/**
	 * Returns the minimum value for this control.
	 */
	public var minValue(default, null):Float;

	/**
	 * Returns the value for this control.
	 */
	public var value(default, null):Float;

	private function new(device:GameInputDevice, id:String, minValue:Float, maxValue:Float, value:Float = 0);
}
#else
typedef GameInputControl = flash.ui.GameInputControl;
#end
