package openfl._v2.utils; #if lime_legacy


import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;


class Timer extends EventDispatcher {
	
	
	public var currentCount:Int;
	public var delay (get, set):Float;
	public var repeatCount:Int;
	public var running:Bool;
	
	@:noCompletion private var __delay:Float;
	@:noCompletion private var __timer:haxe.Timer;
	
	
	public function new (delay:Float, repeatCount:Int = 0) {
		
		if (Math.isNaN (delay) || delay < 0) {
			
			throw new Error ("The delay specified is negative or not a finite number");
			
		}
		
		super ();
		
		__delay = delay;
		this.repeatCount = repeatCount;
		currentCount = 0;
		running = false;
		
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
			__timer = new haxe.Timer (__delay);
			__timer.run = timer_onTimer;
			
		}
		
	}
	
	
	public function stop ():Void {
		
		running = false;
		
		if (__timer != null) {
			
			__timer.stop ();
			__timer = null;
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_delay ():Float {
		
		return __delay;
		
	}
	
	
	private function set_delay (value:Float):Float {
		
		__delay = value;
		
		if (running) {
			
			stop ();
			start ();
			
		}
		
		return __delay;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function timer_onTimer ():Void {
		
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


#end