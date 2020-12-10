package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DataEvent extends TextEvent
{
	public static inline var DATA:EventType<DataEvent> = "data";
	public static inline var UPLOAD_COMPLETE_DATA:EventType<DataEvent> = "uploadCompleteData";

	public var data:String;

	// @:noCompletion private static var __pool:ObjectPool<DataEvent> = new ObjectPool<DataEvent>(function() return new DataEvent(null),
	// function(event) event.__init());

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
