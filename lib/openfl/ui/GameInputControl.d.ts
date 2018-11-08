import GameInputDevice from "./GameInputDevice";
import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.ui {
	
	
	export class GameInputControl extends EventDispatcher {
		
		
		/**
		 * Returns the GameInputDevice object that contains this control.
		 */
		public readonly device:GameInputDevice;
		
		/**
		 * Returns the id of this control.
		 */
		public readonly id:string;
		
		/**
		 * Returns the maximum value for this control.
		 */
		public readonly maxValue:number;
		
		/**
		 * Returns the minimum value for this control.
		 */
		public readonly minValue:number;
		
		/**
		 * Returns the value for this control.
		 */
		public readonly value:number;
		
		
		protected new (device:GameInputDevice, id:string, minValue:number, maxValue:number, value?:number);
		
		
	}
	
	
}


export default openfl.ui.GameInputControl;