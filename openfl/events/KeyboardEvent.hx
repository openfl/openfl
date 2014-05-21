/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.events;
#if display


/**
 * A KeyboardEvent object id dispatched in response to user input through a
 * keyboard. There are two types of keyboard events:
 * <code>KeyboardEvent.KEY_DOWN</code> and <code>KeyboardEvent.KEY_UP</code>
 *
 * <p>Because mappings between keys and specific characters vary by device and
 * operating system, use the TextEvent event type for processing character
 * input.</p>
 *
 * <p>To listen globally for key events, listen on the Stage for the capture
 * and target or bubble phase.</p>
 * 
 */
extern class KeyboardEvent extends Event {

	/**
	 * Indicates whether the Alt key is active(<code>true</code>) or inactive
	 * (<code>false</code>) on Windows; indicates whether the Option key is
	 * active on Mac OS.
	 */
	var altKey : Bool;

	/**
	 * Contains the character code value of the key pressed or released. The
	 * character code values are English keyboard values. For example, if you
	 * press Shift+3, <code>charCode</code> is # on a Japanese keyboard, just as
	 * it is on an English keyboard.
	 *
	 * <p><b>Note: </b>When an input method editor(IME) is running,
	 * <code>charCode</code> does not report accurate character codes.</p>
	 */
	var charCode : UInt;

	/**
	 * On Windows and Linux, indicates whether the Ctrl key is active
	 * (<code>true</code>) or inactive(<code>false</code>); On Mac OS, indicates
	 * whether either the Ctrl key or the Command key is active.
	 */
	var ctrlKey : Bool;

	/**
	 * The key code value of the key pressed or released.
	 *
	 * <p><b>Note: </b>When an input method editor(IME) is running,
	 * <code>keyCode</code> does not report accurate key codes.</p>
	 */
	var keyCode : UInt;

	/**
	 * Indicates whether the Shift key modifier is active(<code>true</code>) or
	 * inactive(<code>false</code>).
	 */
	var shiftKey : Bool;
	
	/**
	 * Creates an Event object that contains specific information about keyboard
	 * events. Event objects are passed as parameters to event listeners.
	 * 
	 * @param type          The type of the event. Possible values are:
	 *                      <code>KeyboardEvent.KEY_DOWN</code> and
	 *                      <code>KeyboardEvent.KEY_UP</code>
	 * @param bubbles       Determines whether the Event object participates in
	 *                      the bubbling stage of the event flow.
	 * @param cancelable    Determines whether the Event object can be canceled.
	 * @param charCodeValue The character code value of the key pressed or
	 *                      released. The character code values returned are
	 *                      English keyboard values. For example, if you press
	 *                      Shift+3, the <code>Keyboard.charCode()</code>
	 *                      property returns # on a Japanese keyboard, just as it
	 *                      does on an English keyboard.
	 * @param keyCodeValue  The key code value of the key pressed or released.
	 */
	function new(type : String, bubbles : Bool = true, cancelable : Bool = false, charCodeValue : Int = 0, keyCodeValue : Int = 0) : Void;

	/**
	 * Indicates that the display should be rendered after processing of this
	 * event completes, if the display list has been modified
	 * 
	 */
	function updateAfterEvent() : Void;

	/**
	 * The <code>KeyboardEvent.KEY_DOWN</code> constant defines the value of the
	 * <code>type</code> property of a <code>keyDown</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var KEY_DOWN : String;

	/**
	 * The <code>KeyboardEvent.KEY_UP</code> constant defines the value of the
	 * <code>type</code> property of a <code>keyUp</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var KEY_UP : String;
}


#end
