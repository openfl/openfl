package openfl.ui {
	
	
	import openfl.events.EventDispatcher;
	
	
	/**
	 * @externs
	 */
	public class GameInputControl extends EventDispatcher {
		
		
		/**
		 * Returns the GameInputDevice object that contains this control.
		 */
		public function get device ():GameInputDevice { return null; }
		
		/**
		 * Returns the id of this control.
		 */
		public function get id ():String { return null; }
		
		/**
		 * Returns the maximum value for this control.
		 */
		public function get maxValue ():Number { return 0; }
		
		/**
		 * Returns the minimum value for this control.
		 */
		public function get minValue ():Number { return 0; }
		
		/**
		 * Returns the value for this control.
		 */
		public function get value ():Number { return 0; }
		
		
		// private function GameInputControl (device:GameInputDevice, id:String, minValue:Number, maxValue:Number, value:Number = 0) {}
		
		
	}
	
	
}