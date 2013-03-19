package flash.events;
#if (flash || display)


/**
 * An object dispatches a FocusEvent object when the user changes the focus
 * from one object in the display list to another. There are four types of
 * focus events:
 * <ul>
 *   <li><code>FocusEvent.FOCUS_IN</code></li>
 *   <li><code>FocusEvent.FOCUS_OUT</code></li>
 *   <li><code>FocusEvent.KEY_FOCUS_CHANGE</code></li>
 *   <li><code>FocusEvent.MOUSE_FOCUS_CHANGE</code></li>
 * </ul>
 * 
 */
extern class FocusEvent extends Event {

	/**
	 * If <code>true</code>, the <code>relatedObject</code> property is set to
	 * <code>null</code> for reasons related to security sandboxes. If the
	 * nominal value of <code>relatedObject</code> is a reference to a
	 * DisplayObject in another sandbox, <code>relatedObject</code> is set to
	 * <code>null</code> unless there is permission in both directions across
	 * this sandbox boundary. Permission is established by calling
	 * <code>Security.allowDomain()</code> from a SWF file, or by providing a
	 * policy file from the server of an image file, and setting the
	 * <code>LoaderContext.checkPolicyFile</code> property when loading the
	 * image.
	 */
	@:require(flash10) var isRelatedObjectInaccessible : Bool;

	/**
	 * The key code value of the key pressed to trigger a
	 * <code>keyFocusChange</code> event.
	 */
	var keyCode : Int;

	/**
	 * A reference to the complementary InteractiveObject instance that is
	 * affected by the change in focus. For example, when a <code>focusOut</code>
	 * event occurs, the <code>relatedObject</code> represents the
	 * InteractiveObject instance that has gained focus.
	 *
	 * <p>The value of this property can be <code>null</code> in two
	 * circumstances: if there no related object, or there is a related object,
	 * but it is in a security sandbox to which you don't have access. Use the
	 * <code>isRelatedObjectInaccessible()</code> property to determine which of
	 * these reasons applies.</p>
	 */
	var relatedObject : flash.display.InteractiveObject;

	/**
	 * Indicates whether the Shift key modifier is activated, in which case the
	 * value is <code>true</code>. Otherwise, the value is <code>false</code>.
	 * This property is used only if the FocusEvent is of type
	 * <code>keyFocusChange</code>.
	 */
	var shiftKey : Bool;

	/**
	 * Creates an Event object with specific information relevant to focus
	 * events. Event objects are passed as parameters to event listeners.
	 * 
	 * @param type          The type of the event. Possible values are:
	 *                      <code>FocusEvent.FOCUS_IN</code>,
	 *                      <code>FocusEvent.FOCUS_OUT</code>,
	 *                      <code>FocusEvent.KEY_FOCUS_CHANGE</code>, and
	 *                      <code>FocusEvent.MOUSE_FOCUS_CHANGE</code>.
	 * @param bubbles       Determines whether the Event object participates in
	 *                      the bubbling stage of the event flow.
	 * @param cancelable    Determines whether the Event object can be canceled.
	 * @param relatedObject Indicates the complementary InteractiveObject
	 *                      instance that is affected by the change in focus. For
	 *                      example, when a <code>focusIn</code> event occurs,
	 *                      <code>relatedObject</code> represents the
	 *                      InteractiveObject that has lost focus.
	 * @param shiftKey      Indicates whether the Shift key modifier is
	 *                      activated.
	 * @param keyCode       Indicates the code of the key pressed to trigger a
	 *                      <code>keyFocusChange</code> event.
	 */
	function new(type : String, bubbles : Bool = true, cancelable : Bool = false, ?relatedObject : flash.display.InteractiveObject, shiftKey : Bool = false, keyCode : Int = 0) : Void;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>focusIn</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var FOCUS_IN : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>focusOut</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var FOCUS_OUT : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>keyFocusChange</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var KEY_FOCUS_CHANGE : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>mouseFocusChange</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var MOUSE_FOCUS_CHANGE : String;
}


#end
