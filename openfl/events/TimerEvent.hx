package openfl.events;


import openfl.events.Event;


class TimerEvent extends Event {
	
	
	public static inline var TIMER:String = "timer";
	public static inline var TIMER_COMPLETE:String = "timerComplete";
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		
		super(type, bubbles, cancelable);
		
	}
	
	
	public function updateAfterEvent ():Void {
		
		
		
	}
	
	
}