package flash.events;

#if flash
import openfl.events.EventType;
import openfl.utils.ByteArray;

extern class SampleDataEvent extends Event
{
	public static var SAMPLE_DATA(default, never):EventType<SampleDataEvent>;
	public var data:ByteArray;
	public var position:Float;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false);
	public override function clone():SampleDataEvent;
}
#else
typedef SampleDataEvent = openfl.events.SampleDataEvent;
#end
