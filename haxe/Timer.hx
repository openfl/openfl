package haxe;
#if (macro || (!neko && !cpp))


// Original haxe.Timer class

/*
 * Copyright (C)2005-2013 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

/**
	The Timer class allows you to create asynchronous timers on platforms that
	support events.

	The intended usage is to create an instance of the Timer class with a given
	interval, set its run() method to a custom function to be invoked and
	eventually call stop() to stop the Timer.

	Note that a running Timer may or may not prevent the program to exit
	automatically when main() returns.

	It is also possible to extend this class and override its run() method in
	the child class.
**/
class Timer {
	#if (flash || js || java)

	#if (flash || js)
		private var id : Null<Int>;
	#elseif java
		private var timer : java.util.Timer;
		private var task : java.util.TimerTask;
	#end

	/**
		Creates a new timer that will run every `time_ms` milliseconds.

		After creating the Timer instance, it calls `this].run` repeatedly,
		with delays of `time_ms` milliseconds, until `this.stop` is called.

		The first invocation occurs after `time_ms` milliseconds, not
		immediately.

		The accuracy of this may be platform-dependent.
	**/
	public function new( time_ms : Int ){
		#if flash9
			var me = this;
			id = untyped __global__["flash.utils.setInterval"](function() { me.run(); },time_ms);
		#elseif flash
			var me = this;
			id = untyped _global["setInterval"](function() { me.run(); },time_ms);
		#elseif js
			var me = this;
			id = untyped setInterval(function() me.run(),time_ms);
		#elseif java
			timer = new java.util.Timer();
			timer.scheduleAtFixedRate(task = new TimerTask(this), haxe.Int64.ofInt(time_ms), haxe.Int64.ofInt(time_ms));
		#end
	}

	/**
		Stops `this` Timer.

		After calling this method, no additional invocations of `this.run`
		will occur.

		It is not possible to restart `this` Timer once stopped.
	**/
	public function stop() {
		#if (flash || js)
			if( id == null )
				return;
			#if flash9
				untyped __global__["flash.utils.clearInterval"](id);
			#elseif flash
				untyped _global["clearInterval"](id);
			#elseif js
				untyped clearInterval(id);
			#end
			id = null;
		#elseif java
			timer.cancel();
			timer = null;
			task = null;
		#end
	}

	/**
		This method is invoked repeatedly on `this` Timer.

		It can be overridden in a subclass, or rebound directly to a custom
		function:
			var timer = new haxe.Timer(1000); // 1000ms delay
			timer.run = function() { ... }

		Once bound, it can still be rebound to different functions until `this`
		Timer is stopped through a call to `this.stop`.
	**/
	public dynamic function run() {

	}

	/**
		Invokes `f` after `time_ms` milliseconds.

		This is a convenience function for creating a new Timer instance with
		`time_ms` as argument, binding its run() method to `f` and then stopping
		`this` Timer upon the first invocation.

		If `f` is null, the result is unspecified.
	**/
	public static function delay( f : Void -> Void, time_ms : Int ) {
		var t = new haxe.Timer(time_ms);
		t.run = function() {
			t.stop();
			f();
		};
		return t;
	}

	#end

	/**
		Measures the time it takes to execute `f`, in seconds with fractions.

		This is a convenience function for calculating the difference between
		Timer.stamp() before and after the invocation of `f`.

		The difference is passed as argument to Log.trace(), with "s" appended
		to denote the unit. The optional `pos` argument is passed through.

		If `f` is null, the result is unspecified.
	**/
	public static function measure<T>( f : Void -> T, ?pos : PosInfos ) : T {
		var t0 = stamp();
		var r = f();
		Log.trace((stamp() - t0) + "s", pos);
		return r;
	}

	/**
		Returns a timestamp, in seconds with fractions.

		The value itself might differ depending on platforms, only differences
		between two values make sense.
	**/
	public static function stamp() : Float {
		#if flash
			return flash.Lib.getTimer() / 1000;
		#elseif (neko || php)
			return Sys.time();
		#elseif js
			return Date.now().getTime() / 1000;
		#elseif cpp
			return untyped __global__.__time_stamp();
		#elseif sys
			return Sys.time();
		#else
			return 0;
		#end
	}

}

#if java
@:nativeGen
private class TimerTask extends java.util.TimerTask {
	var timer:Timer;
	public function new(timer:Timer):Void {
		super();
		this.timer = timer;
	}

	@:overload public function run():Void {
		timer.run();
	}
}
#end


#else


#if (lime && !lime_legacy)
import lime.system.System;
#end


class Timer {
	
	
	private static var sRunningTimers:Array <Timer> = [];
	
	private var mTime:Float;
	private var mFireAt:Float;
	private var mRunning:Bool;
	
	
	public function new (time:Float) {
		
		mTime = time;
		sRunningTimers.push (this);
		mFireAt = getMS () + mTime;
		mRunning = true;
		
	}
	
	
	public static function delay (f:Void -> Void, time:Int) {
		
		var t = new Timer (time);
		
		t.run = function () {
			
			t.stop ();
			f ();
			
		};
		
		return t;
		
	}
	
	
	private static function getMS ():Float {
		
		return stamp () * 1000.0;
		
	}
	
	
	public static function measure<T> (f:Void -> T, ?pos:PosInfos):T {
		
		var t0 = stamp ();
		var r = f ();
		Log.trace ((stamp () - t0) + "s", pos);
		return r;
		
	}
	
	
	dynamic public function run () {
		
		
		
	}
	
	
	public static function stamp ():Float {
		
		#if lime_legacy
		return lime_time_stamp ();
		#else
		return System.getTimer () / 1000;
		#end
		
	}
	
	
	public function stop ():Void {
		
		if (mRunning) {
			
			mRunning = false;
			
			for (i in 0...sRunningTimers.length) {
				
				if (sRunningTimers[i] == this) {
					
					sRunningTimers[i] = null;
					break;
					
				}
				
			}
			
		}
		
	}
	
	
	#if lime_legacy
	@:noCompletion private function __check (inTime:Float) {
		
		if (inTime >= mFireAt) {
			
			mFireAt += mTime;
			run ();
			
		}
		
	}
	
	
	@:noCompletion public static function __checkTimers () {
		
		var now = getMS ();
		var foundNull = false;
		var timer;
		
		for (i in 0...sRunningTimers.length) {
			
			timer = sRunningTimers[i];
			
			if (timer != null) {
				
				timer.__check (now);
				
			}
			
			foundNull = (foundNull || sRunningTimers[i] == null);
			
		}
		
		if (foundNull) {
			
			sRunningTimers = sRunningTimers.filter (function (val) { return val != null; });
			
		}
		
	}
	
	
	@:noCompletion public static function __nextWake (limit:Float):Float {
		
		var now = lime_time_stamp () * 1000.0;
		var sleep;
		
		for (timer in sRunningTimers) {
			
			if (timer == null)
				continue;
			
			sleep = timer.mFireAt - now;
			
			if (sleep < limit) {
				
				limit = sleep;
				
				if (limit < 0) {
					
					return 0;
					
				}
				
			}
			
		}
		
		return limit * 0.001;
		
	}
	#end
	
	
	
	
	// Native Methods
	
	
	
	
	#if lime_legacy
	static var lime_time_stamp = flash.Lib.load ("lime", "lime_time_stamp", 0);
	#end
	
	
}


#end