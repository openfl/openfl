package openfl.ui;

#if !flash
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
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
	public var enabled(get, set):Bool;

	/**
		Returns the ID of this device.
	**/
	public var id(get, never):String;

	/**
		Returns the name of this device.
	**/
	public var name(get, never):String;

	/**
		Returns the number of controls on this device.
	**/
	public var numControls(get, never):Int;

	/**
		Specifies the rate (in milliseconds) at which to retrieve control values.
	**/
	public var sampleInterval(get, set):Int;

	@:allow(openfl) @:noCompletion private var _:_GameInputDevice;

	@:noCompletion private function new(id:String, name:String)
	{
		_ = new _GameInputDevice(id, name);
	}

	/**
		Writes cached sample values to the ByteArray.
		@param	data
		@param	append
		@return
	**/
	public function getCachedSamples(data:ByteArray, append:Bool = false):Int
	{
		return _.getCachedSamples(data, append);
	}

	/**
		Retrieves a specific control from a device.
		@param	i
		@return
	**/
	public function getControlAt(i:Int):GameInputControl
	{
		return _.getControlAt(i);
	}

	/**
		Requests this device to start keeping a cache of sampled values.
		@param	numSamples
		@param	controls
	**/
	public function startCachingSamples(numSamples:Int, controls:Vector<String>):Void
	{
		_.startCachingSamples(numSamples, controls);
	}

	/**
		Stops sample caching.
	**/
	public function stopCachingSamples():Void
	{
		_.stopCachingSamples();
	}

	// Get & Set Methods

	@:noCompletion private function get_enabled():Bool
	{
		return _.enabled;
	}

	@:noCompletion private function set_enabled(value:Bool):Bool
	{
		return _.enabled = value;
	}

	@:noCompletion private function get_id():String
	{
		return _.id;
	}

	@:noCompletion private function get_name():String
	{
		return _.name;
	}

	@:noCompletion private function get_numControls():Int
	{
		return _.numControls;
	}

	@:noCompletion private function get_sampleInterval():Int
	{
		return _.sampleInterval;
	}

	@:noCompletion private function set_sampleInterval(value:Int):Int
	{
		return _.sampleInterval = value;
	}
}
#else
typedef GameInputDevice = flash.ui.GameInputDevice;
#end
