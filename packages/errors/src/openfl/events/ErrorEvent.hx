package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
import openfl.events.TextEvent;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ErrorEvent extends TextEvent
{
	public static inline var ERROR:EventType<ErrorEvent> = "error";

	public var errorID(default, null):Int;

	// @:noCompletion private static var __pool:ObjectPool<ErrorEvent> = new ObjectPool<ErrorEvent>(function() return new ErrorEvent(null),
	// function(event) event.__init());

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

	@:noCompletion private override function __init():Void
	{
		super.__init();
		errorID = 0;
	}
}
#else
typedef ErrorEvent = flash.events.ErrorEvent;
#end
