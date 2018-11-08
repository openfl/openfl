package openfl.events; #if (display || !flash)


@:jsRequire("openfl/events/ActivityEvent", "default")

extern class ActivityEvent extends Event {
	
	
	public static inline var ACTIVITY = "activity";
	
	public var activating:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false);
	
	
}


#else
typedef ActivityEvent = flash.events.ActivityEvent;
#end