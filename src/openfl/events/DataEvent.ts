import ObjectPool from "../_internal/utils/ObjectPool";
import EventType from "../events/EventType";
import TextEvent from "../events/TextEvent";

/**
	An object dispatches a DataEvent object when raw data has completed
	loading. There are two types of data event:
	* `DataEvent.DATA`: dispatched for data sent or received.
	* `DataEvent.UPLOAD_COMPLETE_DATA`: dispatched when data is sent and the
	server has responded.

**/
export default class DataEvent extends TextEvent
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
	public static readonly DATA: EventType<DataEvent> = "data";

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
	public static readonly UPLOAD_COMPLETE_DATA: EventType<DataEvent> = "uploadCompleteData";

	/**
		The raw data loaded into Flash Player or Adobe AIR.
	**/
	public data: string;

	protected static __pool: ObjectPool<DataEvent> = new ObjectPool<DataEvent>(() => new DataEvent(null),
		(event) => event.__init());

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
	public constructor(type: string, bubbles: boolean = false, cancelable: boolean = false, data: string = "")
	{
		super(type, bubbles, cancelable);

		this.data = data;
	}

	public clone(): DataEvent
	{
		var event = new DataEvent(this.__type, this.__bubbles, this.__cancelable, this.data);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("DataEvent", "type", "bubbles", "cancelable", "data");
	}

	protected __init(): void
	{
		super.__init();
		this.data = "";
	}
}
