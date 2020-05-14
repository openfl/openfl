package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _ActivityEvent extends _Event
{
	public static var __pool:ObjectPool<ActivityEvent> = new ObjectPool<ActivityEvent>(function() return new ActivityEvent(null), function(event)
	{
		(event._ : _Event).__init();
	});

	public var activating:Bool;

	private var activityEvent:ActivityEvent;

	public function new(activityEvent:ActivityEvent, type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false)
	{
		this.activityEvent = activityEvent;

		super(activityEvent, type, bubbles, cancelable);

		this.activating = activating;
	}

	public override function clone():ActivityEvent
	{
		var event = new ActivityEvent(type, bubbles, cancelable, activating);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("ActivityEvent", ["type", "bubbles", "cancelable", "activating"]);
	}

	public override function __init():Void
	{
		super.__init();
		activating = false;
	}
}
