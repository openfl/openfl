package openfl.events;

#if !flash
import haxe.io.Error;

// import openfl.utils.ObjectPool;

/**
	An object dispatches an AsyncErrorEvent when an exception is thrown from
	native asynchronous code, which could be from, for example,
	LocalConnection, NetConnection, SharedObject, or NetStream. There is only
	one type of asynchronous error event: `AsyncErrorEvent.ASYNC_ERROR`.

**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class AsyncErrorEvent extends ErrorEvent
{
	/**
		The `AsyncErrorEvent.ASYNC_ERROR` constant defines the value of the
		`type` property of an `asyncError` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object dispatching the event. |
		| `error` | The error that triggered the event. |
	**/
	public static inline var ASYNC_ERROR:EventType<AsyncErrorEvent> = "asyncError";

	/**
		The exception that was thrown.
	**/
	public var error:Error;

	// @:noCompletion private static var __pool:ObjectPool<AsyncErrorEvent> = new ObjectPool<AsyncErrorEvent>(function() return new AsyncErrorEvent(null),
	// function(event) event.__init());

	/**
		Creates an AsyncErrorEvent object that contains information about
		asyncError events. AsyncErrorEvent objects are passed as parameters to
		event listeners.

		@param type       The type of the event. Event listeners can access
						  this information through the inherited `type`
						  property. There is only one type of error event:
						  `ErrorEvent.ERROR`.
		@param bubbles    Determines whether the Event object bubbles. Event
						  listeners can access this information through the
						  inherited `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through
						  the inherited `cancelable` property.
		@param text       Text to be displayed as an error message. Event
						  listeners can access this information through the
						  `text` property.
		@param error      The exception that occurred. If error is non-null,
						  the event's `errorId` property is set from the
						  error's `errorId` property.
	**/
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
