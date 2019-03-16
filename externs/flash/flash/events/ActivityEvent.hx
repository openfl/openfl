package flash.events;

#if flash
import openfl.events.EventType;

extern class ActivityEvent extends Event
{
	public static var ACTIVITY(default, never):EventType<ActivityEvent>;
	public var activating:Bool;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false);
	public override function clone():ActivityEvent;
}
#else
typedef ActivityEvent = openfl.events.ActivityEvent;
#end
