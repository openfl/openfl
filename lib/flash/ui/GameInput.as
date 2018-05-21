package flash.ui {
	
	
	import flash.events.EventDispatcher;
	
	
	/**
	 * @externs
	 */
	final public class GameInput extends EventDispatcher {
		
		
		public static function get isSupported ():Boolean { return false; }
		public static function get numDevices ():int { return 0; }
		
		
		public function GameInput () {}
		
		
		public static function getDeviceAt (index:int):GameInputDevice { return null; }
		
		
		
	}
	
	
}