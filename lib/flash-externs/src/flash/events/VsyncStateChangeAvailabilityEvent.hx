package flash.events;

#if flash
import openfl.events.EventType;

extern class VsyncStateChangeAvailabilityEvent extends Event
{
	public static var VSYNC_STATE_CHANGE_AVAILABILITY(default, never):EventType<VsyncStateChangeAvailabilityEvent>;

	#if (haxe_ver < 4.3)
	public var available(default, never):Bool;
	#else
	@:flash.property var available(get, never):Bool;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, available:Bool = false);
	public override function clone():VsyncStateChangeAvailabilityEvent;

	#if (haxe_ver >= 4.3)
	private function get_available():Bool;
	#end
}
#else
typedef VsyncStateChangeAvailabilityEvent = openfl.events.VsyncStateChangeAvailabilityEvent;
#end
