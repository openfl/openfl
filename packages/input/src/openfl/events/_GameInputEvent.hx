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
	public static var __pool:ObjectPool<GameInputEvent> = new ObjectPool<GameInputEvent>(function() return new GameInputEvent(null),
		function(event)(event._:_Event).__init());

	public var device:GameInputDevice;

	private var gameInputEvent:GameInputEvent;

	public function new(gameInputEvent:GameInputEvent, type:String, bubbles:Bool = true, cancelable:Bool = false, device:GameInputDevice = null)
	{
		this.gameInputEvent = gameInputEvent;

		super(gameInputEvent, type, bubbles, cancelable);

		this.device = device;
	}

	public override function clone():GameInputEvent
	{
		var event = new GameInputEvent(type, bubbles, cancelable, device);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("GameInputEvent", ["type", "bubbles", "cancelable", "device"]);
	}

	public override function __init():Void
	{
		super.__init();
		device = null;
	}
}
