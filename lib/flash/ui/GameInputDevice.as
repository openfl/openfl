package flash.ui {
	
	
	import flash.utils.ByteArray;
	// import flash.Vector;
	
	
	/**
	 * @externs
	 */
	final public class GameInputDevice {
		
		
		public static var MAX_BUFFER_SIZE:int;
		
		/**
		 * Enables or disables this device.
		 */
		public var enabled:Boolean;
		
		/**
		 * Returns the ID of this device.
		 */
		public function get id ():String { return null; }
		
		/**
		 * Returns the name of this device.
		 */
		public function get name ():String { return null; }
		
		/**
		 * Returns the number of controls on this device.
		 */
		public function get numControls ():int { return 0; }
		
		protected function get_numControls ():int { return 0; }
		
		/**
		 * Specifies the rate (in milliseconds) at which to retrieve control values.
		 */
		public var sampleInterval:int;
		
		
		/**
		 * Writes cached sample values to the ByteArray.
		 * @param	data
		 * @param	append
		 * @return
		 */
		public function getCachedSamples (data:ByteArray, append:Boolean = false):int { return 0; }
		
		
		/**
		 * Retrieves a specific control from a device.
		 * @param	i
		 * @return
		 */
		public function getControlAt (i:int):GameInputControl { return null; }
		
		
		/**
		 * Requests this device to start keeping a cache of sampled values.
		 * @param	numSamples
		 * @param	controls
		 */
		public function startCachingSamples (numSamples:int, controls:Vector.<String>):void {}
		
		
		/**
		 * Stops sample caching.
		 */
		public function stopCachingSamples ():void {}
		
		
	}
	
	
}