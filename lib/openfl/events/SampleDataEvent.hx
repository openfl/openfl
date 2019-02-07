package openfl.events;

#if (display || !flash)
import openfl.utils.ByteArray;

@:jsRequire("openfl/events/SampleDataEvent", "default")
extern class SampleDataEvent extends Event
{
	public static inline var SAMPLE_DATA = "sampleData";
	public var data:ByteArray;
	public var position:Float;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false);
}
#else
typedef SampleDataEvent = flash.events.SampleDataEvent;
#end
