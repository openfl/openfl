package openfl.ui;

#if !flash
import openfl.utils.ByteArray;
#if lime
import lime.ui.Gamepad;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.ui.GameInputControl)
@:final class GameInputDevice
{
	/**
		Specifies the maximum size for the buffer used to cache sampled control values.
		If `startCachingSamples` returns samples that require more memory than you specify,
		it throws a memory error.
	**/
	public static inline var MAX_BUFFER_SIZE:Int = 32000;

	/**
		Enables or disables this device.
	**/
	public var enabled:Bool;

	/**
		Returns the ID of this device.
	**/
	public var id(default, null):String;

	/**
		Returns the name of this device.
	**/
	public var name(default, null):String;

	/**
		Returns the number of controls on this device.
	**/
	public var numControls(get, never):Int;

	/**
		Specifies the rate (in milliseconds) at which to retrieve control values.
	**/
	public var sampleInterval:Int;

	@:noCompletion private var __axis:Map<Int, GameInputControl> = new Map();
	@:noCompletion private var __button:Map<Int, GameInputControl> = new Map();
	@:noCompletion private var __controls:Array<GameInputControl> = new Array();
	#if lime
	@:noCompletion private var __gamepad:Gamepad;
	#end

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(GameInputDevice.prototype, {
			"numControls": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_numControls (); }")},
		});
	}
	#end

	@:noCompletion private function new(id:String, name:String)
	{
		this.id = id;
		this.name = name;

		var control;

		for (i in 0...6)
		{
			control = new GameInputControl(this, "AXIS_" + i, -1, 1);
			__axis.set(i, control);
			__controls.push(control);
		}

		for (i in 0...15)
		{
			control = new GameInputControl(this, "BUTTON_" + i, 0, 1);
			__button.set(i, control);
			__controls.push(control);
		}
	}

	/**
		Writes cached sample values to the ByteArray.
		@param	data
		@param	append
		@return
	**/
	public function getCachedSamples(data:ByteArray, append:Bool = false):Int
	{
		return 0;
	}

	/**
		Retrieves a specific control from a device.
		@param	i
		@return
	**/
	public function getControlAt(i:Int):GameInputControl
	{
		if (i >= 0 && i < __controls.length)
		{
			return __controls[i];
		}

		return null;
	}

	/**
		Requests this device to start keeping a cache of sampled values.
		@param	numSamples
		@param	controls
	**/
	public function startCachingSamples(numSamples:Int, controls:Vector<String>):Void {}

	/**
		Stops sample caching.
	**/
	public function stopCachingSamples():Void {}

	// Get & Set Methods
	@:noCompletion private function get_numControls():Int
	{
		return __controls.length;
	}
}
#else
typedef GameInputDevice = flash.ui.GameInputDevice;
#end
