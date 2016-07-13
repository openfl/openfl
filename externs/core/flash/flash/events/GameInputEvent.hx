package flash.events; #if (!display && flash)


import openfl.ui.GameInputDevice;


@:final extern class GameInputEvent extends Event {
	
	
	public static var DEVICE_ADDED (default, never):String;
	public static var DEVICE_REMOVED (default, never):String;
	public static var DEVICE_UNUSABLE (default, never):String;
	
	public var device (default, null):GameInputDevice;
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, device:GameInputDevice = null);
	
	
}


#else
typedef GameInputEvent = openfl.events.GameInputEvent;
#end