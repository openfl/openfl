package openfl.events;

#if !flash
import haxe.io.Error;

// import openfl._internal.utils.ObjectPool;
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class AsyncErrorEvent extends ErrorEvent
{
	public static inline var ASYNC_ERROR:EventType<AsyncErrorEvent> = "asyncError";

	/**
		The exception that was thrown.
	**/
	public var error:Error;

	// @:noCompletion private static var __pool:ObjectPool<AsyncErrorEvent> = new ObjectPool<AsyncErrorEvent>(function() return new AsyncErrorEvent(null),
	// function(event) event.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", error:Error = null):Void
	{
		super(type, bubbles, cancelable);

		this.text = text;
		this.error = error;
	}

	public override function clone():AsyncErrorEvent
	{
		var event = new AsyncErrorEvent(type, bubbles, cancelable, text, error);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("AsyncErrorEvent", ["type", "bubbles", "cancelable", "text", "error"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		text = "";
		error = null;
	}
}
#else
typedef AsyncErrorEvent = flash.events.AsyncErrorEvent;
#end
