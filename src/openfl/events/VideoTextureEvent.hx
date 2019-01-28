package openfl.events;

#if !flash
class VideoTextureEvent extends Event
{
	public static var RENDER_STATE:String = "renderState";

	@:isVar public var colorSpace(default, null):String;
	@:isVar public var status(default, null):String;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:String = null, colorSpace:String = null)
	{
		super(type, bubbles, cancelable);
		this.status = status;
		this.colorSpace = colorSpace;
	}
}
#else
typedef VideoTextureEvent = flash.events.VideoTextureEvent;
#end
