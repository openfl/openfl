package openfl.events; #if (display || !flash)


import openfl.ui.GameInputDevice;

@:jsRequire("openfl/events/GameInputEvent", "default")


/**
 * The GameInputEvent class represents an event that is dispatched when a game input device has either been added or removed from the application platform. A game input device also dispatches events when it is turned on or off.
 */
@:final extern class GameInputEvent extends Event {
	
	
	/**
	 * Indicates that a compatible device has been connected or turned on.
	 */
	public static inline var DEVICE_ADDED = "deviceAdded";
	
	/**
	 * Indicates that one of the enumerated devices has been disconnected or turned off.
	 */
	public static inline var DEVICE_REMOVED = "deviceRemoved";
	
	/**
	 * Dispatched when a game input device is connected but is not usable.
	 */
	public static inline var DEVICE_UNUSABLE = "deviceUnusable";
	
	
	/**
	 * Returns a reference to the device that was added or removed. When a device is added, use this property to get a reference to the new device, instead of enumerating all of the devices to find the new one.
	 */
	public var device (default, null):GameInputDevice;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, device:GameInputDevice = null);
	
	
}


#else
typedef GameInputEvent = flash.events.GameInputEvent;
#end