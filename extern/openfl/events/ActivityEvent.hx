package openfl.events; #if (display || !flash)


extern class ActivityEvent extends Event {
	
	
	public static var ACTIVITY:String;
	
	public var activating:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false);
	
	
}


#else
typedef ActivityEvent = flash.events.ActivityEvent;
#end