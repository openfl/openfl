package openfl.events;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/events/DataEvent", "default")
#end
extern class DataEvent extends TextEvent
{
	public static inline var DATA = "data";
	public static inline var UPLOAD_COMPLETE_DATA = "uploadCompleteData";
	public var data:String;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "");
}
#else
typedef DataEvent = flash.events.DataEvent;
#end
