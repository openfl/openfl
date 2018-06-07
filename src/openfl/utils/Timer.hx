package openfl.utils;


import haxe.Timer in HaxeTimer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;

#if (js && html5)
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Timer extends EventDispatcher {
	
	
	public var currentCount (default, null):Int;
	public var delay (get, set):Float;
	public var repeatCount (get, set):Int;
	public var running (default, null):Bool;
	
	private var __delay:Float;
	private var __repeatCount:Int;
	private var __timer:HaxeTimer;
	private var __timerID:Int;
	
	
	#if openfljs
	private static function __init__ () {
		
		var p = untyped Timer.prototype;
		untyped global.Object.defineProperties (p, {
			"delay": { get: p.get_delay, set: p.set_delay },
			"repeatCount": { get: p.get_repeatCount, set: p.set_repeatCount }
		});
		
	}
	#end
	
	
	public function new (delay:Float, repeatCount:Int = 0):Void {
		
		if (Math.isNaN (delay) || delay < 0) {
			
			throw new Error ("The delay specified is negative or not a finite number");
			
		}
		
		super ();
		
		__delay = delay;
		__repeatCount = repeatCount;
		
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
			
			#if (js && html5)
			__timerID = Browser.window.setInterval (timer_onTimer, Std.int (__delay));
			#else
			__timer = new HaxeTimer (Std.int (__delay));
			__timer.run = timer_onTimer;
			#end
			
		}
		
	}
	
	
	public function stop ():Void {
		
		running = false;
		
		#if (js && html5)
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
	
	
	private function get_repeatCount ():Int {
		
		return __repeatCount;
		
	}
	
	
	private function set_repeatCount (v:Int):Int {
		
		if (running && v != 0 && v <= currentCount) {
			
			stop ();
			
		}
		
		return __repeatCount = v;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function timer_onTimer ():Void {
		
		currentCount++;
		
		if (__repeatCount > 0 && currentCount >= __repeatCount) {
			
			stop ();
			dispatchEvent (new TimerEvent (TimerEvent.TIMER));
			dispatchEvent (new TimerEvent (TimerEvent.TIMER_COMPLETE));
			
		} else {
			
			dispatchEvent (new TimerEvent (TimerEvent.TIMER));
			
		}
		
	}
	
	
}