package flash.events;

#if flash
import openfl.events.EventType;
import openfl.ui.GameInputDevice;

@:final extern class GameInputEvent extends Event
{
	public static var DEVICE_ADDED(default, never):EventType<GameInputEvent>;
	public static var DEVICE_REMOVED(default, never):EventType<GameInputEvent>;
	public static var DEVICE_UNUSABLE(default, never):EventType<GameInputEvent>;
	public var device(default, never):GameInputDevice;
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, device:GameInputDevice = null);
	public override function clone():GameInputEvent;
}
#else
typedef GameInputEvent = openfl.events.GameInputEvent;
#end
