package openfl.events;

#if !flash
/**
	Almost exactly StageVideoEvent.
**/
class VideoTextureEvent extends Event
{
	/**
		The `VideoTextureEvent.RENDER_STATE` constant defines the value of the `type`
		property of a `renderState` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `colorSpace` | The available color spaces for displaying the video. |
		| `currentTarget` | The object that is actively processing the StageVideoEvent object with an event listener. |
		| `status` | Indicates whether the video is being rendered (decoded and displayed) by hardware or software, or not at all. |
		| `target` | The VideoTexture object that changed state. |
	**/
	public static inline var RENDER_STATE:EventType<VideoTextureEvent> = "renderState";

	/**
		The color space used by the video being displayed in the VideoTexture object.
	**/
	@:isVar public var colorSpace(default, null):String;

	/**
		The status of the VideoTexture object.
	**/
	@:isVar public var status(default, null):String;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:String = null, colorSpace:String = null)
	{
		super(type, bubbles, cancelable);
		this.status = status;
		this.colorSpace = colorSpace;
	}

	public override function clone():VideoTextureEvent
	{
		var event = new VideoTextureEvent(type, bubbles, status, colorSpace);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("VideoTextureEvent", ["type", "bubbles", "cancelable", "status", "colorSpace"]);
	}
}
#else
typedef VideoTextureEvent = flash.events.VideoTextureEvent;
#end
