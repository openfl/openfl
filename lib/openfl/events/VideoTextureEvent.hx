package openfl.events;

#if (display || !flash)
@:jsRequire("openfl/events/VideoTextureEvent", "default")
extern class VideoTextureEvent extends Event
{
	public static inline var RENDER_STATE = "renderState";
	public var colorSpace(default, null):String;
	public var status(default, null):String;
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = true, status:String = null, colorSpace:String = null);
}
#else
typedef VideoTextureEvent = flash.events.VideoTextureEvent;
#end
