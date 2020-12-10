package flash.events;

#if flash
import openfl.events.EventType;

extern class TimerEvent extends Event
{
	public static var TIMER(default, never):EventType<TimerEvent>;
	public static var TIMER_COMPLETE(default, never):EventType<TimerEvent>;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false):Void;
	public override function clone():TimerEvent;
	public function updateAfterEvent():Void;
}
#else
typedef TimerEvent = openfl.events.TimerEvent;
#end
