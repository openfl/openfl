package openfl.events;
import openfl.errors.SQLError;
import openfl.events.Event;

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
	
	override public function clone():Event 
	{
		return new SQLErrorEvent(type, error);
	}
}