package flash.utils; #if (!display && flash)


import openfl.events.EventDispatcher;


extern class Timer extends EventDispatcher {
	
	
	public var currentCount (default, null):Int;
	public var delay:Float;
	public var repeatCount:Int;
	public var running (default, null):Bool;
	
	public function new (delay:Float, repeatCount:Int = 0);
	public function reset ():Void;
	public function start ():Void;
	public function stop ():Void;
	
	
}


#else
typedef Timer = openfl.utils.Timer;
#end