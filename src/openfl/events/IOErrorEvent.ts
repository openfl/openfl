import ObjectPool from "../_internal/utils/ObjectPool";
import ErrorEvent from "../events/ErrorEvent";
import EventType from "../events/EventType";

/**
	An IOErrorEvent object is dispatched when an error causes input or output
	operations to fail.

	You can check for error events that do not have any listeners by using
	the debugger version of Flash Player or the AIR Debug Launcher(ADL). The
	string defined by the `text` parameter of the IOErrorEvent
	constructor is displayed.
**/
export default class IOErrorEvent extends ErrorEvent
{
	// /** @hidden */ @:dox(hide) public static DISK_ERROR:String;

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
	public static readonly IO_ERROR: EventType<IOErrorEvent> = "ioError";

	// /** @hidden */ @:dox(hide) public static NETWORK_ERROR:String;
	// /** @hidden */ @:dox(hide) public static VERIFY_ERROR:String;
	protected static __pool: ObjectPool<IOErrorEvent> = new ObjectPool<IOErrorEvent>(() => new IOErrorEvent(null),
		(event) => event.__init());

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
	public constructor(type: string, bubbles: boolean = true, cancelable: boolean = false, text: string = "", id: number = 0)
	{
		super(type, bubbles, cancelable, text, id);
	}

	public clone(): IOErrorEvent
	{
		var event = new IOErrorEvent(this.__type, this.__bubbles, this.__cancelable, this.text, this.__errorID);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("IOErrorEvent", "type", "bubbles", "cancelable", "text", "errorID");
	}
}
