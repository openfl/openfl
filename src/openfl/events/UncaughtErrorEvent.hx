package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class UncaughtErrorEvent extends ErrorEvent
{
	public static inline var UNCAUGHT_ERROR:EventType<UncaughtErrorEvent> = "uncaughtError";

	public var error(default, null):Dynamic;

	// @:noCompletion private static var __pool:ObjectPool<UncaughtErrorEvent> = new ObjectPool<UncaughtErrorEvent>(function() return
	// 	new UncaughtErrorEvent(null), function(event) event.__init());

	public function new(type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null)
	{
		super(type, bubbles, cancelable);

		this.error = error;
	}

	public override function clone():UncaughtErrorEvent
	{
		var event = new UncaughtErrorEvent(type, bubbles, cancelable, error);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("UncaughtErrorEvent", ["type", "bubbles", "cancelable", "error"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		error = null;
	}
}
#else
typedef UncaughtErrorEvent = flash.events.UncaughtErrorEvent;
#end
