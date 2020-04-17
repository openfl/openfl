import ObjectPool from "../_internal/utils/ObjectPool";
import InteractiveObject from "../display/InteractiveObject";
import Event from "../events/Event";
import EventType from "../events/EventType";

/**
	An object dispatches a FocusEvent object when the user changes the focus
	from one object in the display list to another. There are four types of
	focus events:

	* `FocusEvent.FOCUS_IN`
	* `FocusEvent.FOCUS_OUT`
	* `FocusEvent.KEY_FOCUS_CHANGE`
	* `FocusEvent.MOUSE_FOCUS_CHANGE`
**/
export default class FocusEvent extends Event
{
	/**
		Defines the value of the `type` property of a `focusIn` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `keyCode` | 0; applies only to `keyFocusChange` events. |
		| `relatedObject` | The complementary InteractiveObject instance that is affected by the change in focus. |
		| `shiftKey` | `false`; applies only to `keyFocusChange` events. |
		| `target` | The InteractiveObject instance that has just received focus. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `direction` | The direction from which focus was assigned. This property reports the value of the `direction` parameter of the `assignFocus()` method of the stage. If the focus changed through some other means, the value will always be `FocusDirection.NONE`. Applies only to `focusIn` events. For all other focus events the value will be `FocusDirection.NONE`. |
	**/
	public static readonly FOCUS_IN: EventType<FocusEvent> = "focusIn";

	/**
		Defines the value of the `type` property of a `focusOut` event object.

		This event has the following properties:

		|Property | Value || --- | --- || `bubbles` | `true` || `cancelable` | `false`;
		there is no default behavior to
		cancel. || `currentTarget` | The
		object that is actively processing the Event object with an event
		listener. || `keyCode` | 0; applies
		only to `keyFocusChange`
		events. || `relatedObject` | The
		complementary InteractiveObject instance that is affected by the
		change in
		focus. || `shiftKey` | `false`;
		applies only to `keyFocusChange`
		events. || `target` | The
		InteractiveObject instance that has just lost focus. The `target` is
		not always the object in the display list that registered the event
		listener. Use the `currentTarget` property to access the object in the
		display list that is currently processing the event.
		 |
	**/
	public static readonly FOCUS_OUT: EventType<FocusEvent> = "focusOut";

	/**
		Defines the value of the `type` property of a `keyFocusChange` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true`; call the `preventDefault()` method to cancel default behavior. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `keyCode` | The key code value of the key pressed to trigger a `keyFocusChange` event. |
		| `relatedObject` | The complementary InteractiveObject instance that is affected by the change in focus. |
		| `shiftKey` | `true` if the Shift key modifier is activated; `false` otherwise. |
		| `target` | The InteractiveObject instance that currently has focus. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static readonly KEY_FOCUS_CHANGE: EventType<FocusEvent> = "keyFocusChange";

	/**
		Defines the value of the `type` property of a `mouseFocusChange` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true`; call the `preventDefault()` method to cancel default behavior. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `keyCode` | 0; applies only to `keyFocusChange` events. |
		| `relatedObject` | The complementary InteractiveObject instance that is affected by the change in focus. |
		| `shiftKey` | `false`; applies only to `keyFocusChange` events. |
		| `target` | The InteractiveObject instance that currently has focus. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static readonly MOUSE_FOCUS_CHANGE: EventType<FocusEvent> = "mouseFocusChange";

	/**
		If `true`, the `relatedObject` property is set to `null` for reasons
		related to security sandboxes. If the nominal value of `relatedObject`
		is a reference to a DisplayObject in another sandbox, `relatedObject`
		is set to `null` unless there is permission in both directions across
		this sandbox boundary. Permission is established by calling
		`Security.allowDomain()` from a SWF file, or by providing a policy
		file from the server of an image file, and setting the
		`LoaderContext.checkPolicyFile` property when loading the image.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10) public isRelatedObjectInaccessible:Bool;

	/**
		The key code value of the key pressed to trigger a
		`keyFocusChange` event.
	**/
	public keyCode: number;

	/**
		A reference to the complementary InteractiveObject instance that is
		affected by the change in focus. For example, when a `focusOut`
		event occurs, the `relatedObject` represents the
		InteractiveObject instance that has gained focus.

		The value of this property can be `null` in two
		circumstances: if there no related object, or there is a related object,
		but it is in a security sandbox to which you don't have access. Use the
		`isRelatedObjectInaccessible()` property to determine which of
		these reasons applies.
	**/
	public relatedObject: InteractiveObject;

	/**
		Indicates whether the Shift key modifier is activated, in which case the
		value is `true`. Otherwise, the value is `false`.
		This property is used only if the FocusEvent is of type
		`keyFocusChange`.
	**/
	public shiftKey: boolean;

	protected static __pool: ObjectPool<FocusEvent> = new ObjectPool<FocusEvent>(() => new FocusEvent(null),
		(event) => event.__init());

	/**
		Creates an Event object with specific information relevant to focus
		events. Event objects are passed as parameters to event listeners.

		@param type          The type of the event. Possible values are:
							 `FocusEvent.FOCUS_IN`,
							 `FocusEvent.FOCUS_OUT`,
							 `FocusEvent.KEY_FOCUS_CHANGE`, and
							 `FocusEvent.MOUSE_FOCUS_CHANGE`.
		@param bubbles       Determines whether the Event object participates in
							 the bubbling stage of the event flow.
		@param cancelable    Determines whether the Event object can be canceled.
		@param relatedObject Indicates the complementary InteractiveObject
							 instance that is affected by the change in focus. For
							 example, when a `focusIn` event occurs,
							 `relatedObject` represents the
							 InteractiveObject that has lost focus.
		@param shiftKey      Indicates whether the Shift key modifier is
							 activated.
		@param keyCode       Indicates the code of the key pressed to trigger a
							 `keyFocusChange` event.
	**/
	public constructor(type: string, bubbles: boolean = false, cancelable: boolean = false, relatedObject: InteractiveObject = null, shiftKey: boolean = false,
		keyCode: number = 0)
	{
		super(type, bubbles, cancelable);

		this.keyCode = keyCode;
		this.shiftKey = shiftKey;
		this.relatedObject = relatedObject;
	}

	public clone(): FocusEvent
	{
		var event = new FocusEvent(this.__type, this.__bubbles, this.__cancelable, this.relatedObject, this.shiftKey, this.keyCode);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("FocusEvent", "type", "bubbles", "cancelable", "relatedObject", "shiftKey", "keyCode");
	}

	protected __init(): void
	{
		super.__init();
		this.keyCode = 0;
		this.shiftKey = false;
		this.relatedObject = null;
	}
}
