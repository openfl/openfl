package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ProgressEvent extends Event
{
	public static inline var PROGRESS:EventType<ProgressEvent> = "progress";
	public static inline var SOCKET_DATA:EventType<ProgressEvent> = "socketData";

	public var bytesLoaded:Float;
	public var bytesTotal:Float;

	// @:noCompletion private static var __pool:ObjectPool<ProgressEvent> = new ObjectPool<ProgressEvent>(function() return new ProgressEvent(null),
	// function(event) event.__init());

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
