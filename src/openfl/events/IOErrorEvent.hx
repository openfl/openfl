package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class IOErrorEvent extends ErrorEvent
{
	// @:noCompletion @:dox(hide) public static var DISK_ERROR:String;
	public static inline var IO_ERROR:EventType<IOErrorEvent> = "ioError";

	// @:noCompletion @:dox(hide) public static var NETWORK_ERROR:String;
	// @:noCompletion @:dox(hide) public static var VERIFY_ERROR:String;
	// @:noCompletion private static var __pool:ObjectPool<IOErrorEvent> = new ObjectPool<IOErrorEvent>(function() return new IOErrorEvent(null),
	// function(event) event.__init());

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
