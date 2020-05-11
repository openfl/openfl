package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.events._Event;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _TimerEvent extends _Event
{
	public static var __pool:ObjectPool<TimerEvent> = new ObjectPool<TimerEvent>(function() return new TimerEvent(null), function(event) event._.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false):Void
	{
		super(type, bubbles, cancelable);
	}

	public override function clone():TimerEvent
	{
		var event = new TimerEvent(type, bubbles, cancelable);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("TimerEvent", ["type", "bubbles", "cancelable"]);
	}

	public function updateAfterEvent():Void {}
}
