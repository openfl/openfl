package flash.events; #if (!display && flash)


extern class TimerEvent extends Event {
	
	
	public static var TIMER (default, never):String;
	public static var TIMER_COMPLETE (default, never):String;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void;
	public function updateAfterEvent ():Void;
	
	
}


#else
typedef TimerEvent = openfl.events.TimerEvent;
#end