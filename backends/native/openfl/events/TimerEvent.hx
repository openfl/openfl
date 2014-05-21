package openfl.events;


class TimerEvent extends Event {
	
	
	public static var TIMER:String = "timer";
	public static var TIMER_COMPLETE:String = "timerComplete";
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false) {
		
		super (type, bubbles, cancelable);
		
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