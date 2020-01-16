package openfl.events;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/events/ActivityEvent", "default")
#end
extern class ActivityEvent extends Event
{
	public static inline var ACTIVITY = "activity";
	public var activating:Bool;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false);
}
#else
typedef ActivityEvent = flash.events.ActivityEvent;
#end
