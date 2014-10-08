package openfl.utils; #if !flash #if (display || openfl_next || js)


import haxe.Timer in HaxeTimer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;

#if js
import js.Browser;
#end


class Timer extends EventDispatcher {
	
	
	public var currentCount (default, null):Int;
	public var delay (get, set):Float;
	public var repeatCount (default, set):Int;
	public var running (default, null):Bool;
	
	@:noCompletion private var __delay:Float;
	@:noCompletion private var __timer:HaxeTimer;
	@:noCompletion private var __timerID:Int;
	
	
	public function new (delay:Float, repeatCount:Int = 0):Void {
		
		if (Math.isNaN (delay) || delay < 0) {
			
			throw new Error ("The delay specified is negative or not a finite number");
			
		}
		
		super ();
		
		__delay = delay;
		this.repeatCount = repeatCount;
		
		running = false;
		currentCount = 0;
		
	}
	
	
	public function reset ():Void {
		
		if (running) {
			
			stop ();
			
		}
		
		currentCount = 0;
		
	}
	
	
	public function start ():Void {
		
		if (!running) {
			
			running = true;
			
			#if js
			__timerID = Browser.window.setInterval (timer_onTimer, Std.int (__delay));
			#else
			__timer = new HaxeTimer (__delay);
			__timer.run = timer_onTimer;
			#end
			
		}
		
	}
	
	
	public function stop ():Void {
		
		running = false;
		
		#if js
		if (__timerID != null) {
			
			Browser.window.clearInterval (__timerID);
			__timerID = null;
			
		}
		#else
		if (__timer != null) {
			
			__timer.stop ();
			__timer = null;
			
		}
		#end
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_delay ():Float {
		
		return __delay;
		
	}
	
	
	@:noCompletion private function set_delay (value:Float):Float {
		
		__delay = value;
		
		if (running) {
			
			stop ();
			start ();
			
		}
		
		return __delay;
		
	}
	
	
	@:noCompletion private function set_repeatCount (v:Int):Int {
		
		if (running && v != 0 && v <= currentCount) {
			
			stop ();
			
		}
		
		repeatCount = v;
		return v;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function timer_onTimer ():Void {
		
		currentCount ++;
		
		if (repeatCount > 0 && currentCount >= repeatCount) {
			
			stop ();
			dispatchEvent (new TimerEvent (TimerEvent.TIMER));
			dispatchEvent (new TimerEvent (TimerEvent.TIMER_COMPLETE));
			
		} else {
			
			dispatchEvent (new TimerEvent (TimerEvent.TIMER));
			
		}
		
	}
	
	
}


#else
typedef Timer = openfl._v2.utils.Timer;
#end
#else
typedef Timer = flash.utils.Timer;
#end