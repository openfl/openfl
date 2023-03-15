package openfl.events;

#if (!flash && sys)
import openfl.geom.Rectangle;

/**
**/
class NativeWindowBoundsEvent extends Event
{
	/**
	**/
	public static inline var MOVING:EventType<NativeWindowBoundsEvent> = "moving";

	/**
	**/
	public static inline var MOVE:EventType<NativeWindowBoundsEvent> = "move";

	/**
	**/
	public static inline var RESIZING:EventType<NativeWindowBoundsEvent> = "resizing";

	/**
	**/
	public static inline var RESIZE:EventType<NativeWindowBoundsEvent> = "resize";

	/**
	**/
	public var beforeBounds:Rectangle;

	/**
	**/
	public var afterBounds:Rectangle;

	/**
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, beforeBounds:Rectangle = null, afterBounds:Rectangle = null)
	{
		super(type, bubbles, cancelable);
		this.beforeBounds = beforeBounds;
		this.afterBounds = afterBounds;
	}

	public override function clone():NativeWindowBoundsEvent
	{
		var event = new NativeWindowBoundsEvent(type, bubbles, cancelable, beforeBounds, afterBounds);

		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("NativeWindowBoundsEvent", ["type", "bubbles", "cancelable", "beforeBounds", "afterBounds"]);
	}
}
#else
#if air
typedef NativeWindowBoundsEvent = flash.events.NativeWindowBoundsEvent;
#end
#end
