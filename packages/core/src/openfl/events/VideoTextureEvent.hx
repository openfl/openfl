package openfl.events;

#if !flash
import openfl._internal.utils.ObjectPool;

/**
	Almost exactly StageVideoEvent.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
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
	public var colorSpace(get, never):String;

	/**
		The status of the VideoTexture object.
	**/
	public var status(get, never):String;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:String = null, colorSpace:String = null)
	{
		if (_ == null)
		{
			_ = new _VideoTextureEvent(this, type, bubbles, cancelable, status, colorSpace);
		}

		super(type, bubbles, cancelable);
	}

	public override function clone():VideoTextureEvent
	{
		return _.clone();
	}

	// Get & Set Methods

	@:noCompletion private function get_colorSpace():String
	{
		return _.colorSpace;
	}

	@:noCompletion private function get_status():String
	{
		return _.status;
	}
}
#else
typedef VideoTextureEvent = flash.events.VideoTextureEvent;
#end
