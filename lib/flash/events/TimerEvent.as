package flash.events {
	
	
	/**
	 * @externs
	 * A Timer object dispatches a TimerEvent objects whenever the Timer object
	 * reaches the interval specified by the `Timer.delay` property.
	 * 
	 */
	public class TimerEvent extends Event {
		
		
		/**
		 * Defines the value of the `type` property of a
		 * `timer` event object.
		 *
		 * This event has the following properties:
		 */
		public static const TIMER:String = "timer";
		
		/**
		 * Defines the value of the `type` property of a
		 * `timerComplete` event object.
		 *
		 * This event has the following properties:
		 */
		public static const TIMER_COMPLETE:String = "timerComplete";
		
		
		/**
		 * Creates an Event object with specific information relevant to
		 * `timer` events. Event objects are passed as parameters to event
		 * listeners.
		 * 
		 * @param type       The type of the event. Event listeners can access this
		 *                   information through the inherited `type`
		 *                   property.
		 * @param bubbles    Determines whether the Event object bubbles. Event
		 *                   listeners can access this information through the
		 *                   inherited `bubbles` property.
		 * @param cancelable Determines whether the Event object can be canceled.
		 *                   Event listeners can access this information through the
		 *                   inherited `cancelable` property.
		 */
		public function TimerEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false) { super (type); }
		
		
		/**
		 * Instructs Flash Player or the AIR runtime to render after processing of
		 * this event completes, if the display list has been modified.
		 * 
		 */
		public function updateAfterEvent ():void {}
		
		
	}
	
	
}