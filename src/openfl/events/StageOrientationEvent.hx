package openfl.events;

import openfl.display.StageOrientation;

#if !flash
/**
	A Stage object dispatches a StageOrientationEvent object when the
	orientation of the stage changes. This can occur when the device is rotated,
	when the user opens a slide-out keyboard, or when the `setAspectRatio()`
	method of the Stage is called.

	There are two types of StageOrientationEvent event: The
	`orientationChanging` (`StageOrientationEvent.ORIENTATION_CHANGING`), is
	dispatched before the screen changes to a new orientation. Calling the
	`preventDefault()` method of the event object dispatched for
	`orientationChanging` prevents the stage from changing orientation. The
	`orientationChange` (`StageOrientationEvent.ORIENTATION_CHANGE`), is
	dispatched after the screen changes to a new orientation.

	Note: If the `Stage.autoOrients` property is `false`, then the stage
	orientation does not change when a device is rotated. Thus,
	StageOrientationEvents are only dispatched for device rotation when
	`Stage.autoOrients` is `true`.

	@see `openfl.display.Stage.orientation`
	@see `openfl.display.Stage.deviceOrientation`
	@see `openfl.display.Stage.autoOrients`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class StageOrientationEvent extends Event
{
	/**
		The `ORIENTATION_CHANGE` constant defines the value of the `type`
		property of a `orientationChange` event object. This event has the
		following properties:

		| Property | Value |
		| --- | --- |
		| `afterOrientation` | The new orientation of the stage. |
		| `beforeOrientation` | The old orientation of the stage. |
		| `target` | The Stage object that dispatched the orientation change. |
		| `bubbles` | `true` |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `cancelable` | `false`;  it is too late to cancel the change. |

		@see `Stage.orientation`
		@see `Stage.deviceOrientation`
	**/
	public static inline var ORIENTATION_CHANGE:EventType<StageOrientationEvent> = "orientationChange";

	/**
		The `ORIENTATION_CHANGING` constant defines the value of the `type`
		property of a `orientationChanging` event object. This event has the
		following properties:

		| Property | Value |
		| --- | --- |
		| `afterOrientation` | The new orientation of the stage. |
		| `beforeOrientation` | The old orientation of the stage. |
		| `target` | The Stage object that dispatched the orientation change. |
		| `bubbles` | `true` |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `cancelable` | `true` |

		@see `Stage.orientation`
		@see `Stage.deviceOrientation`
	**/
	public static inline var ORIENTATION_CHANGING:EventType<StageOrientationEvent> = "orientationChanging";

	/**
		The orientation of the stage before the change.

		@see `Stage.orientation`
		@see `Stage.deviceOrientation`
		@see `StageOrientationEvent.afterOrientation`
	**/
	public var beforeOrientation:StageOrientation;

	/**
		The orientation of the stage after the change.

		@see `Stage.orientation`
		@see `Stage.deviceOrientation`
		@see `StageOrientationEvent.beforeOrientation`
	**/
	public var afterOrientation:StageOrientation;

	/**
		Creates a StageOrientationEvent object with specific information
		relevant to stage orientation events. Event objects are passed as
		parameters to event listeners. Generally you do not create this event
		using the constructor function. Instead, you add an event listener on
		the Stage object to detect these events as they occur.

		@param type              The type of the event. Event listeners can access
								 this information through the inherited
								 `type` property.
		@param bubbles           Determines whether the Event object bubbles. Event
								 listeners can access this information through the
								 inherited `bubbles` property.
		@param cancelable        Determines whether the Event object can be canceled.
								 Event listeners can access this information through
								 the inherited `cancelable` property.
		@param beforeOrientation Indicates the orientation before the change.
		@param afterOrientation  Indicates the orientation after the change.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, beforeOrientation:StageOrientation = UNKNOWN,
			afterOrientation:StageOrientation = UNKNOWN):Void
	{
		super(type, bubbles, cancelable);

		this.beforeOrientation = beforeOrientation;
		this.afterOrientation = afterOrientation;
	}

	public override function clone():StageOrientationEvent
	{
		var event = new StageOrientationEvent(type, bubbles, cancelable, beforeOrientation, afterOrientation);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("StageOrientationEvent", ["type", "bubbles", "cancelable", "beforeOrientation", "afterOrientation"]);
	}
}
#else
typedef StageOrientationEvent = flash.events.StageOrientationEvent;
#end
