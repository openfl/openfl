import Event from "./Event";
import GameInputDevice from "./../ui/GameInputDevice";


declare namespace openfl.events {
	
	
	/**
	 * The GameInputEvent class represents an event that is dispatched when a game input device has either been added or removed from the application platform. A game input device also dispatches events when it is turned on or off.
	 */
	/*@:final*/ export class GameInputEvent extends Event {
		
		
		/**
		 * Indicates that a compatible device has been connected or turned on.
		 */
		public static DEVICE_ADDED:string;
		
		/**
		 * Indicates that one of the enumerated devices has been disconnected or turned off.
		 */
		public static DEVICE_REMOVED:string;
		
		/**
		 * Dispatched when a game input device is connected but is not usable.
		 */
		public static DEVICE_UNUSABLE:string;
		
		
		/**
		 * Returns a reference to the device that was added or removed. When a device is added, use this property to get a reference to the new device, instead of enumerating all of the devices to find the new one.
		 */
		public readonly device:GameInputDevice;
		
		
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean, device?:GameInputDevice);
		
		
	}
	
	
}


export default openfl.events.GameInputEvent;