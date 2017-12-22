import GameInputDevice from "./GameInputDevice";
import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.ui {
	
	
	/*@:final*/ export class GameInput extends EventDispatcher {
		
		
		public static readonly isSupported:boolean;
		public static readonly numDevices:number;
		
		
		public constructor ();
		
		
		public static getDeviceAt (index:number):GameInputDevice;
		
		
	}
	
	
}


export default openfl.ui.GameInput;