package openfl.ui; #if (display || !flash)


import openfl.utils.ByteArray;

@:jsRequire("openfl/ui/GameInputDevice", "default")


@:final extern class GameInputDevice {
	
	
	public static var MAX_BUFFER_SIZE;
	
	/**
	 * Enables or disables this device.
	 */
	public var enabled:Bool;
	
	/**
	 * Returns the ID of this device.
	 */
	public var id (default, null):String;
	
	/**
	 * Returns the name of this device.
	 */
	public var name (default, null):String;
	
	/**
	 * Returns the number of controls on this device.
	 */
	public var numControls (default, never):Int;
	
	/**
	 * Specifies the rate (in milliseconds) at which to retrieve control values.
	 */
	public var sampleInterval:Int;
	
	
	/**
	 * Writes cached sample values to the ByteArray.
	 * @param	data
	 * @param	append
	 * @return
	 */
	public function getCachedSamples (data:ByteArray, append:Bool = false):Int;
	
	
	/**
	 * Retrieves a specific control from a device.
	 * @param	i
	 * @return
	 */
	public function getControlAt (i:Int):GameInputControl;
	
	
	/**
	 * Requests this device to start keeping a cache of sampled values.
	 * @param	numSamples
	 * @param	controls
	 */
	public function startCachingSamples (numSamples:Int, controls:Vector<String>):Void;
	
	
	/**
	 * Stops sample caching.
	 */
	public function stopCachingSamples ():Void;
	
	
}


#else
typedef GameInputDevice = flash.ui.GameInputDevice;
#end