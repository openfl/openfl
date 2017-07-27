package openfl.events; #if (display || !flash)


import openfl.display.InteractiveObject;


/**
 * An object dispatches a FocusEvent object when the user changes the focus
 * from one object in the display list to another. There are four types of
 * focus events:
 * 
 *  * `FocusEvent.FOCUS_IN`
 *  * `FocusEvent.FOCUS_OUT`
 *  * `FocusEvent.KEY_FOCUS_CHANGE`
 *  * `FocusEvent.MOUSE_FOCUS_CHANGE`
 * 
 * 
 */
extern class FocusEvent extends Event {
	
	
	/**
	 * Defines the value of the `type` property of a
	 * `focusIn` event object.
	 *
	 * This event has the following properties:
	 */
	public static inline var FOCUS_IN = "focusIn";
	
	/**
	 * Defines the value of the `type` property of a
	 * `focusOut` event object.
	 *
	 * This event has the following properties:
	 */
	public static inline var FOCUS_OUT = "focusOut";
	
	/**
	 * Defines the value of the `type` property of a
	 * `keyFocusChange` event object.
	 *
	 * This event has the following properties:
	 */
	public static inline var KEY_FOCUS_CHANGE = "keyFocusChange";
	
	/**
	 * Defines the value of the `type` property of a
	 * `mouseFocusChange` event object.
	 *
	 * This event has the following properties:
	 */
	public static inline var MOUSE_FOCUS_CHANGE = "mouseFocusChange";
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var isRelatedObjectInaccessible:Bool;
	#end
	
	/**
	 * The key code value of the key pressed to trigger a
	 * `keyFocusChange` event.
	 */
	public var keyCode:Int;
	
	/**
	 * A reference to the complementary InteractiveObject instance that is
	 * affected by the change in focus. For example, when a `focusOut`
	 * event occurs, the `relatedObject` represents the
	 * InteractiveObject instance that has gained focus.
	 *
	 * The value of this property can be `null` in two
	 * circumstances: if there no related object, or there is a related object,
	 * but it is in a security sandbox to which you don't have access. Use the
	 * `isRelatedObjectInaccessible()` property to determine which of
	 * these reasons applies.
	 */
	public var relatedObject:InteractiveObject;
	
	/**
	 * Indicates whether the Shift key modifier is activated, in which case the
	 * value is `true`. Otherwise, the value is `false`.
	 * This property is used only if the FocusEvent is of type
	 * `keyFocusChange`.
	 */
	public var shiftKey:Bool;
	
	
	/**
	 * Creates an Event object with specific information relevant to focus
	 * events. Event objects are passed as parameters to event listeners.
	 * 
	 * @param type          The type of the event. Possible values are:
	 *                      `FocusEvent.FOCUS_IN`,
	 *                      `FocusEvent.FOCUS_OUT`,
	 *                      `FocusEvent.KEY_FOCUS_CHANGE`, and
	 *                      `FocusEvent.MOUSE_FOCUS_CHANGE`.
	 * @param bubbles       Determines whether the Event object participates in
	 *                      the bubbling stage of the event flow.
	 * @param cancelable    Determines whether the Event object can be canceled.
	 * @param relatedObject Indicates the complementary InteractiveObject
	 *                      instance that is affected by the change in focus. For
	 *                      example, when a `focusIn` event occurs,
	 *                      `relatedObject` represents the
	 *                      InteractiveObject that has lost focus.
	 * @param shiftKey      Indicates whether the Shift key modifier is
	 *                      activated.
	 * @param keyCode       Indicates the code of the key pressed to trigger a
	 *                      `keyFocusChange` event.
	 */
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, relatedObject:InteractiveObject = null, shiftKey:Bool = false, keyCode:Int = 0);
	
	
}


#else
typedef FocusEvent = flash.events.FocusEvent;
#end