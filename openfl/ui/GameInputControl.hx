package openfl.ui; #if (!display && !flash)


import openfl.events.EventDispatcher;


class GameInputControl extends EventDispatcher {
	
	
	public var device (default, null):GameInputDevice;
	public var id (default, null):String;
	public var maxValue (default, null):Float;
	public var minValue (default, null):Float;
	public var value (default, null):Float;
	
	
	private function new (device:GameInputDevice, id:String, minValue:Float, maxValue:Float, value:Float = 0) {
		
		super ();
		
		this.device = device;
		this.id = id;
		this.minValue = minValue;
		this.maxValue = maxValue;
		this.value = value;
		
	}
	
	
}


#else


import openfl.events.EventDispatcher;

#if flash
@:native("flash.ui.GameInputControl")
#end


extern class GameInputControl extends EventDispatcher implements Dynamic {
	
	
	/**
	 * Returns the GameInputDevice object that contains this control.
	 */
	public var device (default, null):GameInputDevice;
	
	/**
	 * Returns the id of this control.
	 */
	public var id (default, null):String;
	
	/**
	 * Returns the maximum value for this control.
	 */
	public var maxValue (default, null):Float;
	
	/**
	 * Returns the minimum value for this control.
	 */
	public var minValue (default, null):Float;
	
	/**
	 * Returns the value for this control.
	 */
	public var value (default, null):Float;
	
	
	private function new (device:GameInputDevice, id:String, minValue:Float, maxValue:Float, value:Float = 0);
	
	
}


#end