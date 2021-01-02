package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;
import openfl.display.InteractiveObject;

/**
	An object dispatches a FocusEvent object when the user changes the focus
	from one object in the display list to another. There are four types of
	focus events:

	* `FocusEvent.FOCUS_IN`
	* `FocusEvent.FOCUS_OUT`
	* `FocusEvent.KEY_FOCUS_CHANGE`
	* `FocusEvent.MOUSE_FOCUS_CHANGE`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FocusEvent extends Event
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
	public static inline var FOCUS_IN:EventType<FocusEvent> = "focusIn";

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
	public static inline var FOCUS_OUT:EventType<FocusEvent> = "focusOut";

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
	public static inline var KEY_FOCUS_CHANGE:EventType<FocusEvent> = "keyFocusChange";

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
	public static inline var MOUSE_FOCUS_CHANGE:EventType<FocusEvent> = "mouseFocusChange";

	#if false
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
	// @:noCompletion @:dox(hide) @:require(flash10) public var isRelatedObjectInaccessible:Bool;
	#end

	/**
		The key code value of the key pressed to trigger a
		`keyFocusChange` event.
	**/
	public var keyCode:Int;

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
	public var relatedObject:InteractiveObject;

	/**
		Indicates whether the Shift key modifier is activated, in which case the
		value is `true`. Otherwise, the value is `false`.
		This property is used only if the FocusEvent is of type
		`keyFocusChange`.
	**/
	public var shiftKey:Bool;

	// @:noCompletion private static var __pool:ObjectPool<FocusEvent> = new ObjectPool<FocusEvent>(function() return new FocusEvent(null),
	// function(event) event.__init());

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
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, relatedObject:InteractiveObject = null, shiftKey:Bool = false,
			keyCode:Int = 0)
	{
		super(type, bubbles, cancelable);

		this.keyCode = keyCode;
		this.shiftKey = shiftKey;
		this.relatedObject = relatedObject;
	}

	public override function clone():FocusEvent
	{
		var event = new FocusEvent(type, bubbles, cancelable, relatedObject, shiftKey, keyCode);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("FocusEvent", ["type", "bubbles", "cancelable", "relatedObject", "shiftKey", "keyCode"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		keyCode = 0;
		shiftKey = false;
		relatedObject = null;
	}
}
#else
typedef FocusEvent = flash.events.FocusEvent;
#end
