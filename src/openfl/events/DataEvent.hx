package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;

/**
	An object dispatches a DataEvent object when raw data has completed
	loading. There are two types of data event:
	* `DataEvent.DATA`: dispatched for data sent or received.
	* `DataEvent.UPLOAD_COMPLETE_DATA`: dispatched when data is sent and the
	server has responded.

**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DataEvent extends TextEvent
{
	/**
		Defines the value of the `type` property of a `data` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `data` | The raw data loaded into Flash Player or Adobe AIR. |
		| `target` | The XMLSocket object receiving data. |
	**/
	public static inline var DATA:EventType<DataEvent> = "data";

	/**
		Defines the value of the `type` property of an `uploadCompleteData`
		event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `data` | The raw data returned from the server after a successful file upload. |
		| `target` | The FileReference object receiving data after a successful upload. |
	**/
	public static inline var UPLOAD_COMPLETE_DATA:EventType<DataEvent> = "uploadCompleteData";

	/**
		The raw data loaded into Flash Player or Adobe AIR.
	**/
	public var data:String;

	// @:noCompletion private static var __pool:ObjectPool<DataEvent> = new ObjectPool<DataEvent>(function() return new DataEvent(null),
	// function(event) event.__init());

	/**
		Creates an event object that contains information about data events.
		Event objects are passed as parameters to event listeners.

		@param type       The type of the event. Event listeners can access
						  this information through the inherited `type`
						  property. There is only one type of data event:
						  `DataEvent.DATA`.
		@param bubbles    Determines whether the Event object participates in
						  the bubbling phase of the event flow. Event
						  listeners can access this information through the
						  inherited `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through
						  the inherited `cancelable` property.
		@param data       The raw data loaded into Flash Player or Adobe AIR.
						  Event listeners can access this information through
						  the `data` property.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "")
	{
		super(type, bubbles, cancelable);

		this.data = data;
	}

	public override function clone():DataEvent
	{
		var event = new DataEvent(type, bubbles, cancelable, data);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("DataEvent", ["type", "bubbles", "cancelable", "data"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		data = "";
	}
}
#else
typedef DataEvent = flash.events.DataEvent;
#end
