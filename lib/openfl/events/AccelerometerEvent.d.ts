import Event from "./Event";


declare namespace openfl.events {
	
	
	/**
	 * The Accelerometer class dispatches AccelerometerEvent objects when
	 * acceleration updates are obtained from the Accelerometer sensor installed
	 * on the device.
	 * 
	 */
	export class AccelerometerEvent extends Event {
		
		
		/**
		 * Defines the value of the `type` property of a
		 * `AccelerometerEvent` event object.
		 *
		 * This event has the following properties:
		 */
		public static UPDATE:string;
		
		
		/**
		 * Acceleration along the x-axis, measured in Gs.(1 G is roughly 9.8
		 * m/sec/sec.) The x-axis runs from the left to the right of the device when
		 * it is in the upright position. The acceleration is positive if the device
		 * moves towards the right.
		 */
		public accelerationX:number;
		
		/**
		 * Acceleration along the y-axis, measured in Gs.(1 G is roughly 9.8
		 * m/sec/sec.). The y-axis runs from the bottom to the top of the device when
		 * it is in the upright position. The acceleration is positive if the device
		 * moves up relative to this axis.
		 */
		public accelerationY:number;
		
		/**
		 * Acceleration along the z-axis, measured in Gs.(1 G is roughly 9.8
		 * m/sec/sec.). The z-axis runs perpendicular to the face of the device. The
		 * acceleration is positive if you move the device so that the face moves
		 * higher.
		 */
		public accelerationZ:number;
		
		/**
		 * The number of milliseconds at the time of the event since the runtime was
		 * initialized. For example, if the device captures accelerometer data 4
		 * seconds after the application initializes, then the `timestamp`
		 * property of the event is set to 4000.
		 */
		public timestamp:number;
		
		
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
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean, timestamp?:number, accelerationX?:number, accelerationY?:number, accelerationZ?:number);
		
		
	}
	
	
}


export default openfl.events.AccelerometerEvent;