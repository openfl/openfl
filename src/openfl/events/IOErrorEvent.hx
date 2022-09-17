package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;

/**
	An IOErrorEvent object is dispatched when an error causes input or output
	operations to fail.

	You can check for error events that do not have any listeners by using
	the debugger version of Flash Player or the AIR Debug Launcher(ADL). The
	string defined by the `text` parameter of the IOErrorEvent
	constructor is displayed.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class IOErrorEvent extends ErrorEvent
{
	// @:noCompletion @:dox(hide) public static var DISK_ERROR:String;

	/**
		Defines the value of the `type` property of an `ioError` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `errorID` | A reference number associated with the specific error (AIR only). |
		| `target` | The network object experiencing the input/output error. |
		| `text` | Text to be displayed as an error message. |
	**/
	public static inline var IO_ERROR:EventType<IOErrorEvent> = "ioError";


	#if (haxe4 && sys)
	/**
		The `standardOutputIoError` event is dispatched when an error occurs
		while reading data from the `standardOutput` stream of a NativeProcess
		object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event. |
		| `errorID` | The reference number associated with the specific error. |
		| `target` | The object on which the error occurred. |
		| `text` | Text to be displayed as an error message. |
	**/
	public static inline var STANDARD_OUTPUT_IO_ERROR:EventType<IOErrorEvent> = "standardOutputIoError";

	/**
		The `standardErrorIoError` event is dispatched when an error occurs
		while reading data from the `standardError` stream of a NativeProcess
		object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event. |
		| `errorID` | The reference number associated with the specific error. |
		| `target` | The object on which the error occurred. |
		| `text` | Text to be displayed as an error message. |
	**/
	public static inline var STANDARD_ERROR_IO_ERROR:EventType<IOErrorEvent> = "standardErrorIoError";
	#end

	// @:noCompletion @:dox(hide) public static var NETWORK_ERROR:String;
	// @:noCompletion @:dox(hide) public static var VERIFY_ERROR:String;
	// @:noCompletion private static var __pool:ObjectPool<IOErrorEvent> = new ObjectPool<IOErrorEvent>(function() return new IOErrorEvent(null),
	// function(event) event.__init());

	/**
		Creates an Event object that contains specific information about
		`ioError` events. Event objects are passed as parameters to
		Event listeners.

		@param type       The type of the event. Event listeners can access this
						  information through the inherited `type`
						  property. There is only one type of input/output error
						  event: `IOErrorEvent.IO_ERROR`.
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
		@param id         A reference number to associate with the specific error
						 (supported in Adobe AIR only).
	**/
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
#else
typedef IOErrorEvent = flash.events.IOErrorEvent;
#end
