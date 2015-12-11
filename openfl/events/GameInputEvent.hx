package openfl.events;


import openfl.ui.GameInputDevice;


@:final class GameInputEvent extends Event {
	
	
	public static var DEVICE_ADDED = "deviceAdded";
	public static var DEVICE_REMOVED = "deviceRemoved";
	public static var DEVICE_UNUSABLE = "deviceUnusable";
	
	public var device (default, null):GameInputDevice;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, device:GameInputDevice = null) {
		
		super (type, bubbles, cancelable);
		
		this.device = device;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new GameInputEvent (type, bubbles, cancelable, device);
		event.target = target;
		event.currentTarget = currentTarget;
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("GameInputEvent",  [ "type", "bubbles", "cancelable", "device" ]);
		
	}
	
	
}