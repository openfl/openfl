package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ActivityEvent extends Event
{
	public static inline var ACTIVITY:EventType<ActivityEvent> = "activity";

	public var activating:Bool;

	// @:noCompletion private static var __pool:ObjectPool<ActivityEvent> = new ObjectPool<ActivityEvent>(function() return new ActivityEvent(null),
	// function(event) event.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.activating = activating;
	}

	public override function clone():ActivityEvent
	{
		var event = new ActivityEvent(type, bubbles, cancelable, activating);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("ActivityEvent", ["type", "bubbles", "cancelable", "activating"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		activating = false;
	}
}
#else
typedef ActivityEvent = flash.events.ActivityEvent;
#end
