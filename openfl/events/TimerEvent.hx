package openfl.events;


class TimerEvent extends Event {
	
	
	public static inline var TIMER = "timer";
	public static inline var TIMER_COMPLETE = "timerComplete";
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		
		super (type, bubbles, cancelable);
		
	}
	
	
	public override function clone ():Event {
		
		var event = new TimerEvent (type, bubbles, cancelable);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("TimerEvent",  [ "type", "bubbles", "cancelable" ]);
		
	}
	
	
	public function updateAfterEvent ():Void {
		
		
		
	}
	
	
}