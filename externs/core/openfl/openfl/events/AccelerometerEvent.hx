package openfl.events; #if (display || !flash)


/**
 * The Accelerometer class dispatches AccelerometerEvent objects when
 * acceleration updates are obtained from the Accelerometer sensor installed
 * on the device.
 * 
 */
extern class AccelerometerEvent extends Event {
	
	
	/**
	 * Defines the value of the `type` property of a
	 * `AccelerometerEvent` event object.
	 *
	 * This event has the following properties:
	 */
	public static inline var UPDATE = "update";
	
	
	/**
	 * Acceleration along the x-axis, measured in Gs.(1 G is roughly 9.8
	 * m/sec/sec.) The x-axis runs from the left to the right of the device when
	 * it is in the upright position. The acceleration is positive if the device
	 * moves towards the right.
	 */
	public var accelerationX:Float;
	
	/**
	 * Acceleration along the y-axis, measured in Gs.(1 G is roughly 9.8
	 * m/sec/sec.). The y-axis runs from the bottom to the top of the device when
	 * it is in the upright position. The acceleration is positive if the device
	 * moves up relative to this axis.
	 */
	public var accelerationY:Float;
	
	/**
	 * Acceleration along the z-axis, measured in Gs.(1 G is roughly 9.8
	 * m/sec/sec.). The z-axis runs perpendicular to the face of the device. The
	 * acceleration is positive if you move the device so that the face moves
	 * higher.
	 */
	public var accelerationZ:Float;
	
	/**
	 * The number of milliseconds at the time of the event since the runtime was
	 * initialized. For example, if the device captures accelerometer data 4
	 * seconds after the application initializes, then the `timestamp`
	 * property of the event is set to 4000.
	 */
	public var timestamp:Float;
	
	
	/**
	 * Creates an AccelerometerEvent object that contains information about
	 * acceleration along three dimensional axis. Event objects are passed as
	 * parameters to event listeners.
	 * 
	 * @param type          The type of the event. Event listeners can access
	 *                      this information through the inherited
	 *                      `type` property. There is only one type of
	 *                      update event: `AccelerometerEvent.UPDATE`.
	 * @param bubbles       Determines whether the Event object bubbles. Event
	 *                      listeners can access this information through the
	 *                      inherited `bubbles` property.
	 * @param cancelable    Determines whether the Event object can be canceled.
	 *                      Event listeners can access this information through
	 *                      the inherited `cancelable` property.
	 * @param timestamp     The timestamp of the Accelerometer update.
	 * @param accelerationX The acceleration value in Gs(9.8m/sec/sec) along the
	 *                      x-axis.
	 * @param accelerationY The acceleration value in Gs(9.8m/sec/sec) along the
	 *                      y-axis.
	 * @param accelerationZ The acceleration value in Gs(9.8m/sec/sec) along the
	 *                      z-axis.
	 */
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, timestamp:Float = 0, accelerationX:Float = 0, accelerationY:Float = 0, accelerationZ:Float = 0):Void;
	
	
}


#else
typedef AccelerometerEvent = flash.events.AccelerometerEvent;
#end