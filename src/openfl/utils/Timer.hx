package openfl.utils;

#if !flash
import haxe.Timer as HaxeTimer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;
#if (js && html5)
import js.Browser;
#end

/**
	The Timer class is the interface to timers, which let you run code on a
	specified time sequence. Use the `start()` method to start a
	timer. Add an event listener for the `timer` event to set up
	code to be run on the timer interval.

	You can create Timer objects to run once or repeat at specified
	intervals to execute code on a schedule. Depending on the SWF file's
	framerate or the runtime environment(available memory and other factors),
	the runtime may dispatch events at slightly offset intervals. For example,
	if a SWF file is set to play at 10 frames per second(fps), which is 100
	millisecond intervals, but your timer is set to fire an event at 80
	milliseconds, the event will be dispatched close to the 100 millisecond
	interval. Memory-intensive scripts may also offset the events.

	@event timer         Dispatched whenever a Timer object reaches an interval
						 specified according to the `Timer.delay`
						 property.
	@event timerComplete Dispatched whenever it has completed the number of
						 requests set by `Timer.repeatCount`.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Timer extends EventDispatcher
{
	/**
		The total number of times the timer has fired since it started at zero. If
		the timer has been reset, only the fires since the reset are counted.
	**/
	public var currentCount(default, null):Int;

	/**
		The delay, in milliseconds, between timer events. If you set the delay
		interval while the timer is running, the timer will restart at the same
		`repeatCount` iteration.

		**Note:** A `delay` lower than 20 milliseconds is not
		recommended. Timer frequency is limited to 60 frames per second, meaning a
		delay lower than 16.6 milliseconds causes runtime problems.

		@throws Error Throws an exception if the delay specified is negative or
					  not a finite number.
	**/
	public var delay(get, set):Float;

	/**
		The total number of times the timer is set to run. If the repeat count is
		set to 0, the timer continues forever or until the `stop()`
		method is invoked or the program stops. If the repeat count is nonzero,
		the timer runs the specified number of times. If `repeatCount`
		is set to a total that is the same or less then `currentCount`
		the timer stops and will not fire again.
	**/
	public var repeatCount(get, set):Int;

	/**
		The timer's current state; `true` if the timer is running,
		otherwise `false`.
	**/
	public var running(default, null):Bool;

	@:noCompletion private var __delay:Float;
	@:noCompletion private var __repeatCount:Int;
	@:noCompletion private var __timer:HaxeTimer;
	@:noCompletion private var __timerID:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		var p = untyped Timer.prototype;
		untyped global.Object.defineProperties(p, {
			"delay": {get: p.get_delay, set: p.set_delay},
			"repeatCount": {get: p.get_repeatCount, set: p.set_repeatCount}
		});
	}
	#end

	/**
		Constructs a new Timer object with the specified `delay` and
		`repeatCount` states.

		The timer does not start automatically; you must call the
		`start()` method to start it.

		@param delay       The delay between timer events, in milliseconds. A
						   `delay` lower than 20 milliseconds is not
						   recommended. Timer frequency is limited to 60 frames
						   per second, meaning a delay lower than 16.6
						   milliseconds causes runtime problems.
		@param repeatCount Specifies the number of repetitions. If zero, the timer
						   repeats infinitely. If nonzero, the timer runs the
						   specified number of times and then stops.
		@throws Error if the delay specified is negative or not a finite number
	**/
	public function new(delay:Float, repeatCount:Int = 0):Void
	{
		if (Math.isNaN(delay) || delay < 0)
		{
			throw new Error("The delay specified is negative or not a finite number");
		}

		super();

		__delay = delay;
		__repeatCount = repeatCount;

		running = false;
		currentCount = 0;
	}

	/**
		Stops the timer, if it is running, and sets the `currentCount`
		property back to 0, like the reset button of a stopwatch. Then, when
		`start()` is called, the timer instance runs for the specified
		number of repetitions, as set by the `repeatCount` value.

	**/
	public function reset():Void
	{
		if (running)
		{
			stop();
		}

		currentCount = 0;
	}

	/**
		Starts the timer, if it is not already running.

	**/
	public function start():Void
	{
		if (!running)
		{
			running = true;

			#if (js && html5)
			__timerID = Browser.window.setInterval(timer_onTimer, Std.int(__delay));
			#else
			__timer = new HaxeTimer(Std.int(__delay));
			__timer.run = timer_onTimer;
			#end
		}
	}

	/**
		Stops the timer. When `start()` is called after
		`stop()`, the timer instance runs for the _remaining_
		number of repetitions, as set by the `repeatCount` property.

	**/
	public function stop():Void
	{
		running = false;

		#if (js && html5)
		if (__timerID != null)
		{
			Browser.window.clearInterval(__timerID);
			__timerID = null;
		}
		#else
		if (__timer != null)
		{
			__timer.stop();
			__timer = null;
		}
		#end
	}

	// Getters & Setters
	@:noCompletion private function get_delay():Float
	{
		return __delay;
	}

	@:noCompletion private function set_delay(value:Float):Float
	{
		__delay = value;

		if (running)
		{
			stop();
			start();
		}

		return __delay;
	}

	@:noCompletion private function get_repeatCount():Int
	{
		return __repeatCount;
	}

	@:noCompletion private function set_repeatCount(v:Int):Int
	{
		if (running && v != 0 && v <= currentCount)
		{
			stop();
		}

		return __repeatCount = v;
	}

	// Event Handlers
	@:noCompletion private function timer_onTimer():Void
	{
		currentCount++;

		if (__repeatCount > 0 && currentCount >= __repeatCount)
		{
			stop();
			dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
		}
		else
		{
			dispatchEvent(new TimerEvent(TimerEvent.TIMER));
		}
	}
}
#else
typedef Timer = flash.utils.Timer;
#end
