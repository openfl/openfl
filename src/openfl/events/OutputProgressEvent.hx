package openfl.events;

#if (!flash && sys && (!flash_doc_gen || air_doc_gen))
import openfl.events.Event;

/**
	A FileStream object dispatches OutputProgressEvent objects as pendin
	asynchronous file write operations are performed. There is one type of
	output progress event: `OutputProgressEvent.OUTPUT_PROGRESS`.
**/
class OutputProgressEvent extends Event
{
	/**
		Defines the value of the `type` property of an `outputProgress` event
		object.
	**/
	public static inline var OUTPUT_PROGRESS:EventType<OutputProgressEvent> = "outputProgress";

	/**
		The number of bytes not yet written when the listener processes the
		event.
	**/
	public var bytesPending:Float;

	/**
		The total number of bytes written so far, plus the number of pending
		bytes to be written.
	**/
	public var bytesTotal:Float;

	/**
		Creates an Event object that contains information about output progress
		events. Event objects are passed as parameters to event listeners.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, bytesPending:Float = 0, bytesTotal:Float = 0)
	{
		super(type, bubbles, cancelable);
		this.bytesPending = bytesPending;
		this.bytesTotal = bytesTotal;
	}

	override public function clone():Event
	{
		return new OutputProgressEvent(type, bubbles, cancelable, bytesPending, bytesTotal);
	}

	public override function toString():String
	{
		return __formatToString("OutputProgressEvent", ["type", "bubbles", "cancelable", "bytesPending", "bytesTotal"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		bytesPending = Math.NaN;
		bytesTotal = Math.NaN;
	}
}
#else
#if air
typedef OutputProgressEvent = flash.events.OutputProgressEvent;
#end
#end
