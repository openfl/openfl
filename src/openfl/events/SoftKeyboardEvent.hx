package openfl.events;

import openfl.display.InteractiveObject;

#if !flash
/**
	A SoftKeyboardEvent object is dispatched when a software-driven keyboard is
	activated or de-activated on a device or operating system. A
	SoftKeyboardEvent object is dispatched by a TextField or InteractiveObject
	that has the `needsSoftKeyboard` property set to `true`.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class SoftKeyboardEvent extends Event
{
	/**
		The `SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE` constant defines the
		value of the `type` property of a SoftKeyboardEvent event object when a
		soft keyboard is displayed. For this event, `cancelable = false`.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `relatedObject` | A reference to a display list object that is related to the event. |
		| `triggerType` | `Indicates whether the keyboard event was triggered by an application or user. |
	**/
	public static inline var SOFT_KEYBOARD_ACTIVATE:EventType<SoftKeyboardEvent> = "softKeyboardActivate";

	/**
		The `SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING` constant defines the
		value of the `type` property of a SoftKeyboardEvent object immediately
		before a soft keyboard is displayed. For this event,
		`cancelable = true`.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true` unless the event is dispatched by a StageText object. For StageText objects, the event is not cancellable. |
		| `relatedObject` | A reference to a display list object that is related to the event. |
		| `triggerType` | `Indicates whether the keyboard event was triggered by an application or user. |
	**/
	public static inline var SOFT_KEYBOARD_ACTIVATING:EventType<KeyboardEvent> = "softKeyboardActivating";

	/**
		The `SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE` constant defines the
		value of the `type` property of a SoftKeyboardEvent object when a soft
		keyboard is lowered or hidden. For this event, `cancelable = false`.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `relatedObject` | A reference to a display list object that is related to the event. |
		| `triggerType` | `Indicates whether the keyboard event was triggered by an application or user. |
	**/
	public static inline var SOFT_KEYBOARD_DEACTIVATE:EventType<KeyboardEvent> = "softKeyboardDectivate";

	/**
		A reference to a display list object that is related to the event.
	**/
	public var relatedObject:InteractiveObject;

	/**
		Indicates whether the change in keyboard status has been triggered by an
		application (such as programmatic use of `requestSoftKeyboard()`) or by
		the user (such as selecting a text field).
	**/
	public var triggerType(default, null):SoftKeyboardTrigger;

	/**
		Creates an event object that contains information about soft keyboard
		activation and de-activation events. Event objects are passed as
		parameters to event listeners.

		@param type               The type of the event as a constant value
								  (such as `SOFT_KEYBOARD_ACTIVATE`). Event
								  listeners can access this information through
								  the inherited `type` property.
		@param bubbles            Determines whether the Event object participates
								  in the bubbling stage of the event flow.
		@param cancelable         Determines whether the Event object can be
								  canceled.
		@param relatedObjectVal   A reference to a display list object that is
								  related to the event.
		@param triggerTypeVal     Indicates whether the keyboard event was
								  triggered by an application or user.
	**/
	public function new(type:String, bubbles:Bool, cancelable:Bool, relatedObjectVal:InteractiveObject, triggerTypeVal:SoftKeyboardTrigger)
	{
		super(type, bubbles, cancelable);

		relatedObject = relatedObjectVal;
		triggerType = triggerTypeVal;
	}

	public override function clone():SoftKeyboardEvent
	{
		var event = new SoftKeyboardEvent(type, bubbles, cancelable, relatedObject, triggerType);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("SoftKeyboardEvent", ["type", "bubbles", "cancelable", "relatedObject", "triggerType"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		relatedObject = null;
		triggerType = null;
	}
}
#else
typedef SoftKeyboardEvent = flash.events.SoftKeyboardEvent;
#end
