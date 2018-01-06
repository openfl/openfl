package openfl.ui;


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