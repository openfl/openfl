package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _ErrorEvent extends _TextEvent
{
	public var errorID(default, null):Int;

	private static var __pool:ObjectPool<ErrorEvent> = new ObjectPool<ErrorEvent>(function() return new ErrorEvent(null), function(event) event.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0):Void
	{
		super(type, bubbles, cancelable, text);
		errorID = id;
	}

	public override function clone():ErrorEvent
	{
		var event = new ErrorEvent(type, bubbles, cancelable, text, errorID);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("ErrorEvent", ["type", "bubbles", "cancelable", "text", "errorID"]);
	}

	private override function __init():Void
	{
		super.__init();
		errorID = 0;
	}
}
