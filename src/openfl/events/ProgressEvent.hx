package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;

/**
	A ProgressEvent object is dispatched when a load operation has begun or a
	socket has received data. These events are usually generated when SWF
	files, images or data are loaded into an application. There are two types
	of progress events: `ProgressEvent.PROGRESS` and
	`ProgressEvent.SOCKET_DATA`. Additionally, in AIR ProgressEvent
	objects are dispatched when a data is sent to or from a child process using
	the NativeProcess class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ProgressEvent extends Event
{
	/**
		Defines the value of the `type` property of a `progress` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `bytesLoaded` | The number of items or bytes loaded at the time the listener processes the event. |
		| `bytesTotal` | The total number of items or bytes that ultimately will be loaded if the loading process succeeds. |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object reporting progress.  |
	**/
	public static inline var PROGRESS:EventType<ProgressEvent> = "progress";

	/**
		Defines the value of the `type` property of a `socketData` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event. |
		| `bytesLoaded` | The number of items or bytes loaded at the time the listener processes the event. |
		| `bytesTotal` | 0; this property is not used by `socketData` event objects. |
		| `target` | The socket reporting progress. |
	**/
	public static inline var SOCKET_DATA:EventType<ProgressEvent> = "socketData";

	/**
		The number of items or bytes loaded when the listener processes the event.
	**/
	public var bytesLoaded:Float;

	/**
		The total number of items or bytes that will be loaded if the loading
		process succeeds. If the progress event is dispatched/attached to a Socket
		object, the bytesTotal will always be 0 unless a value is specified in the
		bytesTotal parameter of the constructor. The actual number of bytes sent
		back or forth is not set and is up to the application developer.
	**/
	public var bytesTotal:Float;

	// @:noCompletion private static var __pool:ObjectPool<ProgressEvent> = new ObjectPool<ProgressEvent>(function() return new ProgressEvent(null),
	// function(event) event.__init());

	/**
		Creates an Event object that contains information about progress events.
		Event objects are passed as parameters to event listeners.

		@param type        The type of the event. Possible values
						   are:`ProgressEvent.PROGRESS`,
						   `ProgressEvent.SOCKET_DATA`,
						   `ProgressEvent.STANDARD_ERROR_DATA`,
						   `ProgressEvent.STANDARD_INPUT_PROGRESS`, and
						   `ProgressEvent.STANDARD_OUTPUT_DATA`.
		@param bubbles     Determines whether the Event object participates in the
						   bubbling stage of the event flow.
		@param cancelable  Determines whether the Event object can be canceled.
		@param bytesLoaded The number of items or bytes loaded at the time the
						   listener processes the event.
		@param bytesTotal  The total number of items or bytes that will be loaded
						   if the loading process succeeds.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0)
	{
		super(type, bubbles, cancelable);

		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;
	}

	public override function clone():ProgressEvent
	{
		var event = new ProgressEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("ProgressEvent", ["type", "bubbles", "cancelable", "bytesLoaded", "bytesTotal"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		bytesLoaded = 0;
		bytesTotal = 0;
	}
}
#else
typedef ProgressEvent = flash.events.ProgressEvent;
#end
