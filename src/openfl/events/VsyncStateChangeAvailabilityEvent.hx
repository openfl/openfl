package openfl.events;

#if !flash
/**
	The stage dispatches a VsyncStateChangeAvailabilityEvent when changing
	`Stage.vsyncEnabled` becomes available or unavailable, as in AIR.

	OpenFL never dispatches it (see `Stage.vsyncEnabled`). The class lets code
	written for AIR compile.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class VsyncStateChangeAvailabilityEvent extends Event
{
	/**
		The `VsyncStateChangeAvailabilityEvent.VSYNC_STATE_CHANGE_AVAILABILITY`
		constant defines the value of the `type` property of a
		`vSyncStateChangeAvailability` event object.
	**/
	public static inline var VSYNC_STATE_CHANGE_AVAILABILITY:EventType<VsyncStateChangeAvailabilityEvent> = "vSyncStateChangeAvailability";

	/**
		Whether `Stage.vsyncEnabled` can be changed.
	**/
	public var available(default, null):Bool;

	/**
		Creates an event object with information about the availability of
		changing `Stage.vsyncEnabled`.

		@param type       The type of the event.
		@param bubbles    Determines whether the Event object participates in
						  the bubbling phase of the event flow.
		@param cancelable Determines whether the Event object can be canceled.
		@param available  Whether `Stage.vsyncEnabled` can be changed.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, available:Bool = false)
	{
		super(type, bubbles, cancelable);
		this.available = available;
	}

	public override function clone():VsyncStateChangeAvailabilityEvent
	{
		var event = new VsyncStateChangeAvailabilityEvent(type, bubbles, cancelable, available);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("VsyncStateChangeAvailabilityEvent", ["type", "bubbles", "cancelable", "available"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		available = false;
	}
}
#else
typedef VsyncStateChangeAvailabilityEvent = flash.events.VsyncStateChangeAvailabilityEvent;
#end
