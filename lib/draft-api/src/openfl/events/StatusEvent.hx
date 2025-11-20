package openfl.events;

class StatusEvent extends Event
{
	public static inline var STATUS:EventType<StatusEvent> = "status";

	public var code:String;
	public var level:String;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, code:String = "", level:String = "")
	{
		super(type, bubbles, cancelable);
		this.code = code;
		this.level = level;
	}

	public override function clone():StatusEvent
	{
		var event:StatusEvent = new StatusEvent(type, bubbles, cancelable, code, level);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;

		return event;
	}

	public override function toString():String
	{
		return __formatToString("StatusEvent", ["type", "bubbles", "cancelable", "code", "level"]);
	}
}
