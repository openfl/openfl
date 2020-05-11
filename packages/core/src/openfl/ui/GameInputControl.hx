package openfl.ui;

#if !flash
import openfl.events.EventDispatcher;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class GameInputControl extends EventDispatcher
{
	/**
		Returns the GameInputDevice object that contains this control.
	**/
	public var device(get, never):GameInputDevice;

	/**
		Returns the id of this control.
	**/
	public var id(get, never):String;

	/**
		Returns the maximum value for this control.
	**/
	public var maxValue(get, never):Float;

	/**
		Returns the minimum value for this control.
	**/
	public var minValue(get, never):Float;

	/**
		Returns the value for this control.
	**/
	public var value(get, never):Float;

	@:noCompletion private function new(device:GameInputDevice, id:String, minValue:Float, maxValue:Float, value:Float = 0)
	{
		if (_ == null)
		{
			_ = new _GameInputControl(device, id, minValue, maxValue, value);
		}

		super();
	}

	// Get & Set Methods

	@:noCompletion private function get_device():GameInputDevice
	{
		return _.device;
	}

	@:noCompletion private function get_id():String
	{
		return _.id;
	}

	@:noCompletion private function get_maxValue():Float
	{
		return _.maxValue;
	}

	@:noCompletion private function get_minValue():Float
	{
		return _.minValue;
	}

	@:noCompletion private function get_value():Float
	{
		return _.value;
	}
}
#else
typedef GameInputControl = flash.ui.GameInputControl;
#end
