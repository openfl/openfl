package openfl.sensors; #if !flash #if !lime_legacy


import haxe.Timer;
import openfl.display.Stage;
import openfl.errors.ArgumentError;
import openfl.events.AccelerometerEvent;
import openfl.events.EventDispatcher;

#if js
import js.Browser;
#end


/**
 * The Accelerometer class dispatches events based on activity detected by the
 * device's motion sensor. This data represents the device's location or
 * movement along a 3-dimensional axis. When the device moves, the sensor
 * detects this movement and returns acceleration data. The Accelerometer
 * class provides methods to query whether or not accelerometer is supported,
 * and also to set the rate at which acceleration events are dispatched.
 *
 * <p><b>Note:</b> Use the <code>Accelerometer.isSupported</code> property to
 * test the runtime environment for the ability to use this feature. While the
 * Accelerometer class and its members are accessible to the Runtime Versions
 * listed for each API entry, the current environment for the runtime
 * determines the availability of this feature. For example, you can compile
 * code using the Accelerometer class properties for Flash Player 10.1, but
 * you need to use the <code>Accelerometer.isSupported</code> property to test
 * for the availability of the Accelerometer feature in the current deployment
 * environment for the Flash Player runtime. If
 * <code>Accelerometer.isSupported</code> is <code>true</code> at runtime,
 * then Accelerometer support currently exists.</p>
 *
 * <p><i>AIR profile support:</i> This feature is supported only on mobile
 * devices. It is not supported on desktop or AIR for TV devices. See <a
 * href="http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html">
 * AIR Profile Support</a> for more information regarding API support across
 * multiple profiles. </p>
 * 
 * @event status Dispatched when an accelerometer changes its status.
 *
 *               <p><b>Note:</b> On some devices, the accelerometer is always
 *               available. On such devices, an Accelerometer object never
 *               dispatches a <code>status</code> event.</p>
 * @event update The <code>update</code> event is dispatched in response to
 *               updates from the accelerometer sensor. The event is
 *               dispatched in the following circumstances:
 *
 *               <p>
 *               <ul>
 *                 <li>When a new listener function is attached through
 *               <code>addEventListener()</code>, this event is delivered once
 *               to all the registered listeners for providing the current
 *               value of the accelerometer.</li>
 *                 <li>Whenever accelerometer updates are obtained from the
 *               platform at device determined intervals.</li>
 *                 <li>Whenever the application misses a change in the
 *               accelerometer(for example, the runtime is resuming after
 *               being idle).</li>
 *               </ul>
 *               </p>
 */
class Accelerometer extends EventDispatcher {
	
	
	/**
	 * The <code>isSupported</code> property is set to <code>true</code> if the
	 * accelerometer sensor is available on the device, otherwise it is set to
	 * <code>false</code>.
	 */
	public static var isSupported (get, null):Bool;
	
	
	/**
	 * Specifies whether the user has denied access to the accelerometer
	 * (<code>true</code>) or allowed access(<code>false</code>). When this
	 * value changes, a <code>status</code> event is dispatched.
	 */
	public var muted (default, set_muted):Bool;
	
	private var _interval:Int;
	private var timer:Timer;
	
	private static var defaultInterval:Int = 34;
	
	
	/**
	 * Creates a new Accelerometer instance.
	 */
	public function new () {
		
		super ();
		
		_interval = 0;
		muted = false;
		setRequestedUpdateInterval (defaultInterval);
		
	}
	
	
	override public function addEventListener (type:String, listener:Dynamic -> Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		super.addEventListener (type, listener, useCapture, priority, useWeakReference);
		update ();
		
	}
	
	
	/**
	 * The <code>setRequestedUpdateInterval</code> method is used to set the
	 * desired time interval for updates. The time interval is measured in
	 * milliseconds. The update interval is only used as a hint to conserve the
	 * battery power. The actual time between acceleration updates may be greater
	 * or lesser than this value. Any change in the update interval affects all
	 * registered listeners. You can use the Accelerometer class without calling
	 * the <code>setRequestedUpdateInterval()</code> method. In this case, the
	 * application receives updates based on the device's default interval.
	 * 
	 * @param interval The requested update interval. If <code>interval</code> is
	 *                 set to 0, then the minimum supported update interval is
	 *                 used.
	 * @throws ArgumentError The specified <code>interval</code> is less than
	 *                       zero.
	 */
	public function setRequestedUpdateInterval (interval:Int):Void {
		
		_interval = interval;
		
		if (_interval < 0) {
			
			throw new ArgumentError ();
			
		} else if (_interval == 0) {
			
			_interval = defaultInterval;
			
		}
		
		if (timer != null) {
			
			timer.stop ();
			timer = null;
			
		}
		
		if (isSupported && !muted) {
			
			timer = new Timer (_interval);
			timer.run = update;
			
		}
		
	}
	
	
	private function update ():Void {
		
		var event = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		//var data = Stage.__acceleration;
		var data = { x: 0, y: 1, z: 0 };
		
		event.timestamp = Timer.stamp ();
		event.accelerationX = data.x;
		event.accelerationY = data.y;
		event.accelerationZ = data.z;
		
		dispatchEvent (event);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private static function get_isSupported ():Bool { 
		
		//var supported = Reflect.hasField (Browser.window, "on" + Lib.HTML_ACCELEROMETER_EVENT_TYPE);
		//return supported;
		return false;
		
	}
	
	
	@:noCompletion private function set_muted (inVal:Bool):Bool {
		
		this.muted = inVal;
		setRequestedUpdateInterval (_interval);
		return inVal;
		
	}
	
	
}


#else
typedef Accelerometer = openfl._v2.sensors.Accelerometer;
#end
#else
typedef Accelerometer = flash.sensors.Accelerometer;
#end