package openfl.events;

#if (!flash && sys)
import openfl.events.Event;

class OutputProgressEvent extends Event
{
	public static inline var OUTPUT_PROGRESS:EventType<OutputProgressEvent> = "outputProgress";

	public var bytesPending:Float;
	public var bytesTotal:Float;

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
