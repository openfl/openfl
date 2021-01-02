package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;

/**
	An object dispatches a SecurityErrorEvent object to report the occurrence
	of a security error. Security errors reported through this class are
	generally from asynchronous operations, such as loading data, in which
	security violations may not manifest immediately. Your event listener can
	access the object's `text` property to determine what operation
	was attempted and any URLs that were involved. If there are no event
	listeners, the debugger version of Flash Player or the AIR Debug Launcher
	(ADL) application automatically displays an error message that contains the
	contents of the `text` property. There is one type of security
	error event: `SecurityErrorEvent.SECURITY_ERROR`.

	Security error events are the final events dispatched for any target
	object. This means that any other events, including generic error events,
	are not dispatched for a target object that experiences a security
	error.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class SecurityErrorEvent extends ErrorEvent
{
	/**
		The `SecurityErrorEvent.SECURITY_ERROR` constant defines the value of
		the `type` property of a `securityError` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The network object reporting the security error. |
		| `text` | Text to be displayed as an error message. |
	**/
	public static inline var SECURITY_ERROR:EventType<SecurityErrorEvent> = "securityError";

	// @:noCompletion private static var __pool:ObjectPool<SecurityErrorEvent> = new ObjectPool<SecurityErrorEvent>(function() return
	// 	new SecurityErrorEvent(null), function(event) event.__init());

	/**
		Creates an Event object that contains information about security error
		events. Event objects are passed as parameters to event listeners.

		@param type       The type of the event. Event listeners can access this
						  information through the inherited `type`
						  property. There is only one type of error event:
						  `SecurityErrorEvent.SECURITY_ERROR`.
		@param bubbles    Determines whether the Event object participates in the
						  bubbling stage of the event flow. Event listeners can
						  access this information through the inherited
						  `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through the
						  inherited `cancelable` property.
		@param text       Text to be displayed as an error message. Event
						  listeners can access this information through the
						  `text` property.
		@param id         A reference number to associate with the specific error.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0)
	{
		super(type, bubbles, cancelable, text, id);
	}

	public override function clone():SecurityErrorEvent
	{
		var event = new SecurityErrorEvent(type, bubbles, cancelable, text, errorID);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("SecurityErrorEvent", ["type", "bubbles", "cancelable", "text", "errorID"]);
	}
}
#else
typedef SecurityErrorEvent = flash.events.SecurityErrorEvent;
#end
