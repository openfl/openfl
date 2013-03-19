package flash.events;
#if (flash || display)


/**
 * An object dispatches a SecurityErrorEvent object to report the occurrence
 * of a security error. Security errors reported through this class are
 * generally from asynchronous operations, such as loading data, in which
 * security violations may not manifest immediately. Your event listener can
 * access the object's <code>text</code> property to determine what operation
 * was attempted and any URLs that were involved. If there are no event
 * listeners, the debugger version of Flash Player or the AIR Debug Launcher
 * (ADL) application automatically displays an error message that contains the
 * contents of the <code>text</code> property. There is one type of security
 * error event: <code>SecurityErrorEvent.SECURITY_ERROR</code>.
 *
 * <p>Security error events are the final events dispatched for any target
 * object. This means that any other events, including generic error events,
 * are not dispatched for a target object that experiences a security
 * error.</p>
 * 
 */
extern class SecurityErrorEvent extends ErrorEvent {

	/**
	 * Creates an Event object that contains information about security error
	 * events. Event objects are passed as parameters to event listeners.
	 * 
	 * @param type       The type of the event. Event listeners can access this
	 *                   information through the inherited <code>type</code>
	 *                   property. There is only one type of error event:
	 *                   <code>SecurityErrorEvent.SECURITY_ERROR</code>.
	 * @param bubbles    Determines whether the Event object participates in the
	 *                   bubbling stage of the event flow. Event listeners can
	 *                   access this information through the inherited
	 *                   <code>bubbles</code> property.
	 * @param cancelable Determines whether the Event object can be canceled.
	 *                   Event listeners can access this information through the
	 *                   inherited <code>cancelable</code> property.
	 * @param text       Text to be displayed as an error message. Event
	 *                   listeners can access this information through the
	 *                   <code>text</code> property.
	 * @param id         A reference number to associate with the specific error.
	 */
	function new(type : String, bubbles : Bool = false, cancelable : Bool = false, ?text : String, id : Int = 0) : Void;

	/**
	 * The <code>SecurityErrorEvent.SECURITY_ERROR</code> constant defines the
	 * value of the <code>type</code> property of a <code>securityError</code>
	 * event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var SECURITY_ERROR : String;
}


#end
