package flash.utils;

#if flash
import openfl.events.EventDispatcher;

extern class Timer extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var currentCount(default, never):Int;
	public var delay:Float;
	public var repeatCount:Int;
	public var running(default, never):Bool;
	#else
	@:flash.property var currentCount(get, never):Int;
	@:flash.property var delay(get, set):Float;
	@:flash.property var repeatCount(get, set):Int;
	@:flash.property var running(get, never):Bool;
	#end

	public function new(delay:Float, repeatCount:Int = 0);
	public function reset():Void;
	public function start():Void;
	public function stop():Void;

	#if (haxe_ver >= 4.3)
	private function get_currentCount():Int;
	private function get_delay():Float;
	private function get_repeatCount():Int;
	private function get_running():Bool;
	private function set_delay(value:Float):Float;
	private function set_repeatCount(value:Int):Int;
	#end
}
#else
typedef Timer = openfl.utils.Timer;
#end
