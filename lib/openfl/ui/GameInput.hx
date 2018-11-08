package openfl.ui; #if (display || !flash)


import openfl.events.EventDispatcher;

@:jsRequire("openfl/ui/GameInput", "default")


@:final extern class GameInput extends EventDispatcher {
	
	
	public static var isSupported (default, null):Bool;
	public static var numDevices (default, null):Int;
	
	
	public function new ();
	
	
	public static function getDeviceAt (index:Int):GameInputDevice;
	
	
	
}


#else
typedef GameInput = flash.ui.GameInput;
#end