package openfl.events;

#if (display || !flash)
import haxe.io.Error;

/**
	An object dispatches an AsyncErrorEvent when an exception is thrown from
	native asynchronous code, which could be from, for example,
	LocalConnection, NetConnection, SharedObject, or NetStream. There is only
	one type of asynchronous error event: `AsyncErrorEvent.ASYNC_ERROR`.

**/
@:jsRequire("openfl/events/AsyncErrorEvent", "default")
extern class AsyncErrorEvent extends ErrorEvent
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
	public static inline var ASYNC_ERROR = "asyncError";

	public var error:Error;
	
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
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", error:Error = null);
}
#else
typedef AsyncErrorEvent = flash.events.AsyncErrorEvent;
#end
