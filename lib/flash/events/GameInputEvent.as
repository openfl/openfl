package flash.events {
	
	
	import flash.ui.GameInputDevice;
	
	
	/**
	 * @externs
	 * The GameInputEvent class represents an event that is dispatched when a game input device has either been added or removed from the application platform. A game input device also dispatches events when it is turned on or off.
	 */
	final public class GameInputEvent extends Event {
		
		
		/**
		 * Indicates that a compatible device has been connected or turned on.
		 */
		public static const DEVICE_ADDED:String = "deviceAdded";
		
		/**
		 * Indicates that one of the enumerated devices has been disconnected or turned off.
		 */
		public static const DEVICE_REMOVED:String = "deviceRemoved";
		
		/**
		 * Dispatched when a game input device is connected but is not usable.
		 */
		public static const DEVICE_UNUSABLE:String = "deviceUnusable";
		
		
		/**
		 * Returns a reference to the device that was added or removed. When a device is added, use this property to get a reference to the new device, instead of enumerating all of the devices to find the new one.
		 */
		public function get device ():GameInputDevice { return null; }
		
		
		public function GameInputEvent (type:String, bubbles:Boolean = true, cancelable:Boolean = false, device:GameInputDevice = null) { super (type); }
		
		
	}
	
	
}