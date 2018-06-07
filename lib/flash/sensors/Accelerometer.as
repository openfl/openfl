package flash.sensors {
	
	
	import flash.events.EventDispatcher;
	
	
	/**
	 * @externs
	 * The Accelerometer class dispatches events based on activity detected by the
	 * device's motion sensor. This data represents the device's location or
	 * movement along a 3-dimensional axis. When the device moves, the sensor
	 * detects this movement and returns acceleration data. The Accelerometer
	 * class provides methods to query whether or not accelerometer is supported,
	 * and also to set the rate at which acceleration events are dispatched.
	 *
	 * **Note:** Use the `Accelerometer.isSupported` property to
	 * test the runtime environment for the ability to use this feature. While the
	 * Accelerometer class and its members are accessible to the Runtime Versions
	 * listed for each API entry, the current environment for the runtime
	 * determines the availability of this feature. For example, you can compile
	 * code using the Accelerometer class properties for Flash Player 10.1, but
	 * you need to use the `Accelerometer.isSupported` property to test
	 * for the availability of the Accelerometer feature in the current deployment
	 * environment for the Flash Player runtime. If
	 * `Accelerometer.isSupported` is `true` at runtime,
	 * then Accelerometer support currently exists.
	 *
	 * _AIR profile support:_ This feature is supported only on mobile
	 * devices. It is not supported on desktop or AIR for TV devices. See
	 * [AIR Profile Support](http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	 * for more information regarding API support across
	 * multiple profiles. 
	 * 
	 * @event status Dispatched when an accelerometer changes its status.
	 *
	 *               **Note:** On some devices, the accelerometer is always
	 *               available. On such devices, an Accelerometer object never
	 *               dispatches a `status` event.
	 * @event update The `update` event is dispatched in response to
	 *               updates from the accelerometer sensor. The event is
	 *               dispatched in the following circumstances:
	 *
	 *               
	 *               
	 *                * When a new listener function is attached through
	 *               `addEventListener()`, this event is delivered once
	 *               to all the registered listeners for providing the current
	 *               value of the accelerometer.
	 *                * Whenever accelerometer updates are obtained from the
	 *               platform at device determined intervals.
	 *                * Whenever the application misses a change in the
	 *               accelerometer(for example, the runtime is resuming after
	 *               being idle).
	 *               
	 *               
	 */
	public class Accelerometer extends EventDispatcher {
		
		
		/**
		 * The `isSupported` property is set to `true` if the
		 * accelerometer sensor is available on the device, otherwise it is set to
		 * `false`.
		 */
		public static function get isSupported ():Boolean { return false; }
		
		protected static function get_isSupported ():Boolean { return false; }
		
		/**
		 * Specifies whether the user has denied access to the accelerometer
		 * (`true`) or allowed access(`false`). When this
		 * value changes, a `status` event is dispatched.
		 */
		public var muted:Boolean;
		
		protected function get_muted ():Boolean { return false; }
		protected function set_muted (value:Boolean):Boolean { return false; }
		
		
		/**
		 * Creates a new Accelerometer instance.
		 */
		public function Accelerometer () {}
		
		
		/**
		 * The `setRequestedUpdateInterval` method is used to set the
		 * desired time interval for updates. The time interval is measured in
		 * milliseconds. The update interval is only used as a hint to conserve the
		 * battery power. The actual time between acceleration updates may be greater
		 * or lesser than this value. Any change in the update interval affects all
		 * registered listeners. You can use the Accelerometer class without calling
		 * the `setRequestedUpdateInterval()` method. In this case, the
		 * application receives updates based on the device's default interval.
		 * 
		 * @param interval The requested update interval. If `interval` is
		 *                 set to 0, then the minimum supported update interval is
		 *                 used.
		 * @throws ArgumentError The specified `interval` is less than
		 *                       zero.
		 */
		public function setRequestedUpdateInterval (interval:int):void {}
		
		
	}
	
	
}