package openfl.events;

#if !flash
import openfl._internal.utils.ObjectPool;

/**
	A Camera or Microphone object dispatches an ActivityEvent object whenever
	a camera or microphone reports that it has become active or inactive.
	There is only one type of activity event: `ActivityEvent.ACTIVITY`.

**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ActivityEvent extends Event
{
	/**
		The `ActivityEvent.ACTIVITY` constant defines the value of the `type`
		property of an `activity` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `activating` | `true` if the device is activating or `false` if it is deactivating. |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object beginning or ending a session, such as a Camera or Microphone object. |
	**/
	public static inline var ACTIVITY:EventType<ActivityEvent> = "activity";

	/**
		Indicates whether the device is activating (`true`) or deactivating
		(`false`).
	**/
	public var activating(get, set):Bool;

	/**
		Creates an event object that contains information about activity
		events. Event objects are passed as parameters to Event listeners.

		@param type       The type of the event. Event listeners can access
						  this information through the inherited `type`
						  property. There is only one type of activity event:
						  `ActivityEvent.ACTIVITY`.
		@param bubbles    Determines whether the Event object participates in
						  the bubbling phase of the event flow. Event
						  listeners can access this information through the
						  inherited `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through
						  the inherited `cancelable` property.
		@param activating Indicates whether the device is activating (`true`)
						  or deactivating (`false`). Event listeners can
						  access this information through the `activating`
						  property.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false)
	{
		if (_ == null)
		{
			_ = new _ActivityEvent(this, type, bubbles, cancelable, activating);
		}

		super(type, bubbles, cancelable);
	}

	public override function clone():ActivityEvent
	{
		return (_ : _ActivityEvent).clone();
	}

	// Get & Set Methods

	@:noCompletion private function get_activating():Bool
	{
		return (_ : _ActivityEvent).activating;
	}

	@:noCompletion private function set_activating(value:Bool):Bool
	{
		return (_ : _ActivityEvent).activating = value;
	}
}
#else
typedef ActivityEvent = flash.events.ActivityEvent;
#end
