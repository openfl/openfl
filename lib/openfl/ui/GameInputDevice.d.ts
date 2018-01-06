import GameInputControl from "./GameInputControl";
import ByteArray from "./../utils/ByteArray";

type Vector<T> = any;


declare namespace openfl.ui {
	
	
	/*@:final*/ export class GameInputDevice {
		
		
		public static MAX_BUFFER_SIZE:number;
		
		/**
		 * Enables or disables this device.
		 */
		public enabled:boolean;
		
		/**
		 * Returns the ID of this device.
		 */
		public readonly id:string;
		
		/**
		 * Returns the name of this device.
		 */
		public readonly name:string;
		
		/**
		 * Returns the number of controls on this device.
		 */
		public readonly numControls:number;
		
		/**
		 * Specifies the rate (in milliseconds) at which to retrieve control values.
		 */
		public sampleInterval:number;
		
		
		/**
		 * Writes cached sample values to the ByteArray.
		 * @param	data
		 * @param	append
		 * @return
		 */
		public getCachedSamples (data:ByteArray, append?:boolean):number;
		
		
		/**
		 * Retrieves a specific control from a device.
		 * @param	i
		 * @return
		 */
		public getControlAt (i:number):GameInputControl;
		
		
		/**
		 * Requests this device to start keeping a cache of sampled values.
		 * @param	numSamples
		 * @param	controls
		 */
		public startCachingSamples (numSamples:number, controls:Vector<String>):void;
		
		
		/**
		 * Stops sample caching.
		 */
		public stopCachingSamples ():void;
		
		
	}
	
	
}


export default openfl.ui.GameInputDevice;