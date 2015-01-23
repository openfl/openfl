package openfl.events; #if !flash


/**
 * A Timer object dispatches a TimerEvent objects whenever the Timer object
 * reaches the interval specified by the <code>Timer.delay</code> property.
 * 
 */
class TimerEvent extends Event {
	
	
	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>timer</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var TIMER:String = "timer";
	
	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>timerComplete</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var TIMER_COMPLETE:String = "timerComplete";
	
	
	/**
	 * Creates an Event object with specific information relevant to
	 * <code>timer</code> events. Event objects are passed as parameters to event
	 * listeners.
	 * 
	 * @param type       The type of the event. Event listeners can access this
	 *                   information through the inherited <code>type</code>
	 *                   property.
	 * @param bubbles    Determines whether the Event object bubbles. Event
	 *                   listeners can access this information through the
	 *                   inherited <code>bubbles</code> property.
	 * @param cancelable Determines whether the Event object can be canceled.
	 *                   Event listeners can access this information through the
	 *                   inherited <code>cancelable</code> property.
	 */
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		
		super(type, bubbles, cancelable);
		
	}
	
	
	public override function clone ():Event {
		
		return new TimerEvent (type, bubbles, cancelable);
		
	}
	
	
	public override function toString ():String {
		
		return "[TimerEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + "]";
		
	}
	
	
	/**
	 * Instructs Flash Player or the AIR runtime to render after processing of
	 * this event completes, if the display list has been modified.
	 * 
	 */
	public function updateAfterEvent ():Void {
		
		
		
	}
	
	
}


#else
typedef TimerEvent = flash.events.TimerEvent;
#end