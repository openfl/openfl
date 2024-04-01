package flash.events;

#if flash
import openfl.events.EventType;

extern class ActivityEvent extends Event
{
	public static var ACTIVITY(default, never):EventType<ActivityEvent>;

	#if (haxe_ver < 4.3)
	public var activating:Bool;
	#else
	@:flash.property var activating(get, set):Bool;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false);
	public override function clone():ActivityEvent;

	#if (haxe_ver >= 4.3)
	private function get_activating():Bool;
	private function set_activating(value:Bool):Bool;
	#end
}
#else
typedef ActivityEvent = openfl.events.ActivityEvent;
#end
