package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _ErrorEvent extends _TextEvent
{
	private static var __pool:ObjectPool<ErrorEvent> = new ObjectPool<ErrorEvent>(function() return new ErrorEvent(null), function(event)
	{
		(event._ : _Event).__init();
	});

	public var errorID(default, null):Int;

	private var errorEvent:ErrorEvent;

	public function new(errorEvent:ErrorEvent, type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0):Void
	{
		this.errorEvent = errorEvent;

		super(errorEvent, type, bubbles, cancelable, text);
		errorID = id;
	}

	public override function clone():ErrorEvent
	{
		var event = new ErrorEvent(type, bubbles, cancelable, text, errorID);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("ErrorEvent", ["type", "bubbles", "cancelable", "text", "errorID"]);
	}

	public override function __init():Void
	{
		super.__init();
		errorID = 0;
	}
}
