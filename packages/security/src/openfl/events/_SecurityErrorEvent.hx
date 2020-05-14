package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _SecurityErrorEvent extends _ErrorEvent
{
	public static var __pool:ObjectPool<SecurityErrorEvent> = new ObjectPool<SecurityErrorEvent>(function() return new SecurityErrorEvent(null),
		function(event)(event._:_Event).__init());

	private var securityErrorEvent:SecurityErrorEvent;

	public function new(securityErrorEvent:SecurityErrorEvent, type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0)
	{
		this.securityErrorEvent = securityErrorEvent;

		super(securityErrorEvent, type, bubbles, cancelable, text, id);
	}

	public override function clone():SecurityErrorEvent
	{
		var event = new SecurityErrorEvent(type, bubbles, cancelable, text, errorID);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("SecurityErrorEvent", ["type", "bubbles", "cancelable", "text", "errorID"]);
	}
}
