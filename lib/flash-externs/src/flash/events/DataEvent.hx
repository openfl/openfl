package flash.events;

#if flash
import openfl.events.EventType;

extern class DataEvent extends TextEvent
{
	public static var DATA(default, never):EventType<DataEvent>;
	public static var UPLOAD_COMPLETE_DATA(default, never):EventType<DataEvent>;
	public var data:String;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "");
	public override function clone():DataEvent;
}
#else
typedef DataEvent = openfl.events.DataEvent;
#end
