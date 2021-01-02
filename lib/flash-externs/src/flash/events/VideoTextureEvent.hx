package flash.events;

#if flash
import openfl.events.EventType;

extern class VideoTextureEvent extends Event
{
	public static var RENDER_STATE(default, never):EventType<VideoTextureEvent>;
	public var colorSpace(default, null):String;
	public var status(default, null):String;
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = true, status:String = null, colorSpace:String = null);
	public override function clone():VideoTextureEvent;
}
#else
typedef VideoTextureEvent = openfl.events.VideoTextureEvent;
#end
