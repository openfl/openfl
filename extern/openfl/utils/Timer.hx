package openfl.utils; #if (display || !flash)


import openfl.events.EventDispatcher;


/**
 * The Timer class is the interface to timers, which let you run code on a
 * specified time sequence. Use the <code>start()</code> method to start a
 * timer. Add an event listener for the <code>timer</code> event to set up
 * code to be run on the timer interval.
 *
 * <p>You can create Timer objects to run once or repeat at specified
 * intervals to execute code on a schedule. Depending on the SWF file's
 * framerate or the runtime environment(available memory and other factors),
 * the runtime may dispatch events at slightly offset intervals. For example,
 * if a SWF file is set to play at 10 frames per second(fps), which is 100
 * millisecond intervals, but your timer is set to fire an event at 80
 * milliseconds, the event will be dispatched close to the 100 millisecond
 * interval. Memory-intensive scripts may also offset the events.</p>
 * 
 * @event timer         Dispatched whenever a Timer object reaches an interval
 *                      specified according to the <code>Timer.delay</code>
 *                      property.
 * @event timerComplete Dispatched whenever it has completed the number of
 *                      requests set by <code>Timer.repeatCount</code>.
 */
extern class Timer extends EventDispatcher {
	
	
	/**
	 * The total number of times the timer has fired since it started at zero. If
	 * the timer has been reset, only the fires since the reset are counted.
	 */
	public var currentCount (default, null):Int;
	
	/**
	 * The delay, in milliseconds, between timer events. If you set the delay
	 * interval while the timer is running, the timer will restart at the same
	 * <code>repeatCount</code> iteration.
	 *
	 * <p><b>Note:</b> A <code>delay</code> lower than 20 milliseconds is not
	 * recommended. Timer frequency is limited to 60 frames per second, meaning a
	 * delay lower than 16.6 milliseconds causes runtime problems.</p>
	 * 
	 * @throws Error Throws an exception if the delay specified is negative or
	 *               not a finite number.
	 */
	public var delay (get, set):Float;
	
	/**
	 * The total number of times the timer is set to run. If the repeat count is
	 * set to 0, the timer continues forever or until the <code>stop()</code>
	 * method is invoked or the program stops. If the repeat count is nonzero,
	 * the timer runs the specified number of times. If <code>repeatCount</code>
	 * is set to a total that is the same or less then <code>currentCount</code>
	 * the timer stops and will not fire again.
	 */
	public var repeatCount (default, set):Int;
	
	/**
	 * The timer's current state; <code>true</code> if the timer is running,
	 * otherwise <code>false</code>.
	 */
	public var running (default, null):Bool;
	
	
	/**
	 * Constructs a new Timer object with the specified <code>delay</code> and
	 * <code>repeatCount</code> states.
	 *
	 * <p>The timer does not start automatically; you must call the
	 * <code>start()</code> method to start it.</p>
	 * 
	 * @param delay       The delay between timer events, in milliseconds. A
	 *                    <code>delay</code> lower than 20 milliseconds is not
	 *                    recommended. Timer frequency is limited to 60 frames
	 *                    per second, meaning a delay lower than 16.6
	 *                    milliseconds causes runtime problems.
	 * @param repeatCount Specifies the number of repetitions. If zero, the timer
	 *                    repeats infinitely. If nonzero, the timer runs the
	 *                    specified number of times and then stops.
	 * @throws Error if the delay specified is negative or not a finite number
	 */
	public function new (delay:Float, repeatCount:Int = 0);
	
	
	/**
	 * Stops the timer, if it is running, and sets the <code>currentCount</code>
	 * property back to 0, like the reset button of a stopwatch. Then, when
	 * <code>start()</code> is called, the timer instance runs for the specified
	 * number of repetitions, as set by the <code>repeatCount</code> value.
	 * 
	 */
	public function reset ():Void;
	
	
	/**
	 * Starts the timer, if it is not already running.
	 * 
	 */
	public function start ():Void;
	
	
	/**
	 * Stops the timer. When <code>start()</code> is called after
	 * <code>stop()</code>, the timer instance runs for the <i>remaining</i>
	 * number of repetitions, as set by the <code>repeatCount</code> property.
	 * 
	 */
	public function stop ():Void;
	
	
}


#else
typedef Timer = flash.utils.Timer;
#end