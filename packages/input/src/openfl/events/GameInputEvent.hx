package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
import openfl.ui.GameInputDevice;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GameInputEvent extends Event
{
	public static inline var DEVICE_ADDED:EventType<GameInputEvent> = "deviceAdded";
	public static inline var DEVICE_REMOVED:EventType<GameInputEvent> = "deviceRemoved";
	public static inline var DEVICE_UNUSABLE:EventType<GameInputEvent> = "deviceUnusable";

	public var device(default, null):GameInputDevice;

	// @:noCompletion private static var __pool:ObjectPool<GameInputEvent> = new ObjectPool<GameInputEvent>(function() return new GameInputEvent(null),
	// function(event) event.__init());

	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, device:GameInputDevice = null)
	{
		super(type, bubbles, cancelable);

		this.device = device;
	}

	public override function clone():GameInputEvent
	{
		var event = new GameInputEvent(type, bubbles, cancelable, device);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("GameInputEvent", ["type", "bubbles", "cancelable", "device"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		device = null;
	}
}
#else
typedef GameInputEvent = flash.events.GameInputEvent;
#end
