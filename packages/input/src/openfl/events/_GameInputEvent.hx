package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.ui.GameInputDevice;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _GameInputEvent extends _Event
{
	public var device:GameInputDevice;

	public static var __pool:ObjectPool<GameInputEvent> = new ObjectPool<GameInputEvent>(function() return new GameInputEvent(null),
		function(event) event._.__init());

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

	public override function __init():Void
	{
		super._.__init();
		device = null;
	}
}
