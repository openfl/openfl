package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _IOErrorEvent extends _ErrorEvent
{
	private static var __pool:ObjectPool<IOErrorEvent> = new ObjectPool<IOErrorEvent>(function() return new IOErrorEvent(null),
		function(event) event.__init());

	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, text:String = "", id:Int = 0)
	{
		super(type, bubbles, cancelable, text, id);
	}

	public override function clone():IOErrorEvent
	{
		var event = new IOErrorEvent(type, bubbles, cancelable, text, errorID);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("IOErrorEvent", ["type", "bubbles", "cancelable", "text", "errorID"]);
	}
}
