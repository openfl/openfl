package openfl.utils; #if !flash


import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;


class Timer extends EventDispatcher {
	
	
	public var currentCount (default, null):Int;
	public var delay (default, set):Float;
	public var repeatCount (default, set):Int;
	public var running (default, null):Bool;

	private var timerId:Int;
	

	public function new (delay:Float, repeatCount:Int = 0):Void {
		
		super ();
		
		this.running = false;
		this.delay = delay;
		this.repeatCount = repeatCount;
		this.currentCount = 0;
		
	}
	
	
	public function reset ():Void {
		
		stop();
		currentCount = 0;
		
	}
	
	
	public function start ():Void {
		
		if (running) return;
		
		running = true;
		timerId = untyped window.setInterval (__onInterval, Std.int (delay));
		
	}
	
	
	public function stop ():Void {
		
		if (timerId != null) {
			
			untyped window.clearInterval (timerId);
			timerId = null;
			
		}
		
		running = false;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function __onInterval ():Void {
		
		currentCount ++;
		
		if (repeatCount > 0 && currentCount >= repeatCount) {
			
			stop ();
			dispatchEvent (new TimerEvent (TimerEvent.TIMER));
			dispatchEvent (new TimerEvent (TimerEvent.TIMER_COMPLETE));
			
		} else {
			
			dispatchEvent (new TimerEvent (TimerEvent.TIMER));
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_delay (v:Float):Float {
		
		if (v != delay) {
			
			var wasRunning = running;
			
			if (running) stop ();
			
			this.delay = v;
			
			if (wasRunning) start ();
			
		}
		
		return v;
		
	}
	
	
	private function set_repeatCount (v:Int):Int {
		
		if (running && v != 0 && v <= currentCount) {
			
			stop ();
			
		}
		
		repeatCount = v;
		return v;
		
	}
	
	
}


#else
typedef Timer = flash.utils.Timer;
#end