package openfl.ui; #if !flash


import lime.ui.Gamepad;
import openfl.utils.ByteArray;

@:access(openfl.ui.GameInputControl)


@:final class GameInputDevice {
	
	
	public static var MAX_BUFFER_SIZE = 32000;
	
	public var enabled:Bool;
	public var id (default, null):String;
	public var name (default, null):String;
	public var numControls (get, never):Int;
	public var sampleInterval:Int;
	
	private var __axis = new Map<Int, GameInputControl> ();
	private var __button = new Map<Int, GameInputControl> ();
	private var __controls = new Array<GameInputControl> ();
	private var __gamepad:Gamepad;
	
	
	private function new (id:String, name:String) {
		
		this.id = id;
		this.name = name;
		
		var control;
		
		for (i in 0...6) {
			
			control = new GameInputControl (this, "AXIS_" + i, -1, 1);
			__axis.set (i, control);
			__controls.push (control);
			
		}
		
		for (i in 0...15) {
			
			control = new GameInputControl (this, "BUTTON_" + i, 0, 1);
			__button.set (i, control);
			__controls.push (control);
			
		}
		
	}
	
	
	public function getCachedSamples (data:ByteArray, append:Bool = false):Int {
		
		return 0;
		
	}
	
	
	public function getControlAt (i:Int):GameInputControl {
		
		if (i >= 0 && i < __controls.length) {
			
			return __controls[i];
			
		}
		
		return null;
		
	}
	
	
	public function startCachingSamples (numSamples:Int, controls:Vector<String>):Void {
		
		
		
	}
	
	
	public function stopCachingSamples ():Void {
		
		
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_numControls ():Int {
		
		return __controls.length;
		
	}
	
	
}


#else


import openfl.utils.ByteArray;

#if flash
@:native("flash.ui.GameInputDevice")
@:require(flash11_8)
#end


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
	#if (flash && !display)
	public var numControls (default, null):Int;
	#else
	public var numControls (get, never):Int;
	#end
	
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


#end