package openfl.utils;

import haxe.Timer as HaxeTimer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class Timer extends EventDispatcher
{
	public var currentCount:Int;
	public var delay(get, set):Float;
	public var repeatCount(get, set):Int;
	public var running:Bool;

	public var __delay:Float;
	public var __repeatCount:Int;
	public var haxeTimer:HaxeTimer;

	private var timer:Timer;

	public function new(timer:Timer, delay:Float, repeatCount:Int = 0):Void
	{
		this.timer = timer;

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

	public function reset():Void
	{
		if (running)
		{
			stop();
		}

		currentCount = 0;
	}

	public function start():Void
	{
		if (!running)
		{
			running = true;
			haxeTimer = new HaxeTimer(Std.int(__delay));
			haxeTimer.run = haxeTimer_onTimer;
		}
	}

	public function stop():Void
	{
		running = false;
		if (haxeTimer != null)
		{
			haxeTimer.stop();
			haxeTimer = null;
		}
	}

	// Getters & Setters

	private function get_delay():Float
	{
		return __delay;
	}

	private function set_delay(value:Float):Float
	{
		__delay = value;

		if (running)
		{
			stop();
			start();
		}

		return __delay;
	}

	private function get_repeatCount():Int
	{
		return __repeatCount;
	}

	private function set_repeatCount(v:Int):Int
	{
		if (running && v != 0 && v <= currentCount)
		{
			stop();
		}

		return __repeatCount = v;
	}

	// Event Handlers
	public function haxeTimer_onTimer():Void
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
