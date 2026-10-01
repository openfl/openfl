package openfl.events;

import openfl.errors.SQLError;

/**
 * ...
 * @author Christopher Speciale
 */
class SQLErrorEvent extends ErrorEvent
{
	public static inline var ERROR:EventType<SQLErrorEvent> = "error";

	public var error(default, null):SQLError;

	public function new(type:String, error:SQLError)
	{
		super(type);
		this.error = error;
	}

	public override function clone():SQLErrorEvent
	{
		var event = new SQLErrorEvent(type, error);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}
}
