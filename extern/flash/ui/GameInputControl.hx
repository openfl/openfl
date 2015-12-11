package flash.ui; #if (!display && flash)


import openfl.events.EventDispatcher;


extern class GameInputControl extends EventDispatcher implements Dynamic {
	
	
	public var device (default, null):GameInputDevice;
	public var id (default, null):String;
	public var maxValue (default, null):Float;
	public var minValue (default, null):Float;
	public var value (default, null):Float;
	
	private function new (device:GameInputDevice, id:String, minValue:Float, maxValue:Float, value:Float = 0);
	
	
}


#else
typedef GameInputControl = openfl.ui.GameInputControl;
#end