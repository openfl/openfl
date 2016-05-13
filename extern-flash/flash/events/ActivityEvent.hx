package flash.events; #if (!display && flash)


extern class ActivityEvent extends Event {
	
	
	public static var ACTIVITY (default, never):String;
	
	public var activating:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false);
	
	
}


#else
typedef ActivityEvent = openfl.events.ActivityEvent;
#end