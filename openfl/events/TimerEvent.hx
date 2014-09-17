package openfl.events; #if !flash


class TimerEvent extends Event {
	
	
	public static var TIMER:String = "timer";
	public static var TIMER_COMPLETE:String = "timerComplete";
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		
		super(type, bubbles, cancelable);
		
	}
	
	
	public override function clone ():Event {
		
		return new TimerEvent (type, bubbles, cancelable);
		
	}
	
	
	public override function toString ():String {
		
		return "[TimerEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + "]";
		
	}
	
	
	public function updateAfterEvent ():Void {
		
		
		
	}
	
	
}


#else
typedef TimerEvent = flash.events.TimerEvent;
#end