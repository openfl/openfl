package flash.events;
#if (flash || display)


/**
 * An object dispatches an ErrorEvent object when an error causes an
 * asynchronous operation to fail.
 *
 * <p>The ErrorEvent class defines only one type of <code>error</code> event:
 * <code>ErrorEvent.ERROR</code>. The ErrorEvent class also serves as the base
 * class for several other error event classes, including the AsyncErrorEvent,
 * IOErrorEvent, SecurityErrorEvent, SQLErrorEvent, and UncaughtErrorEvent
 * classes.</p>
 *
 * <p>You can check for <code>error</code> events that do not have any
 * listeners by registering a listener for the <code>uncaughtError</code>
 * (UncaughtErrorEvent.UNCAUGHT_ERROR) event.</p>
 *
 * <p>An uncaught error also causes an error dialog box displaying the error
 * event to appear when content is running in the debugger version of Flash
 * Player or the AIR Debug Launcher(ADL) application.</p>
 * 
 */
extern class ErrorEvent extends TextEvent {

	/**
	 * Contains the reference number associated with the specific error. For a
	 * custom ErrorEvent object, this number is the value from the
	 * <code>id</code> parameter supplied in the constructor.
	 */
	@:require(flash10_1) var errorID(default,null) : Int;

	/**
	 * Creates an Event object that contains information about error events.
	 * Event objects are passed as parameters to event listeners.
	 * 
	 * @param type       The type of the event. Event listeners can access this
	 *                   information through the inherited <code>type</code>
	 *                   property. There is only one type of error event:
	 *                   <code>ErrorEvent.ERROR</code>.
	 * @param bubbles    Determines whether the Event object bubbles. Event
	 *                   listeners can access this information through the
	 *                   inherited <code>bubbles</code> property.
	 * @param cancelable Determines whether the Event object can be canceled.
	 *                   Event listeners can access this information through the
	 *                   inherited <code>cancelable</code> property.
	 * @param text       Text to be displayed as an error message. Event
	 *                   listeners can access this information through the
	 *                   <code>text</code> property.
	 * @param id         A reference number to associate with the specific error
	 *                  (supported in Adobe AIR only).
	 */
	function new(type : String, bubbles : Bool = false, cancelable : Bool = false, ?text : String, id : Int = 0) : Void;

	/**
	 * Defines the value of the <code>type</code> property of an
	 * <code>error</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var ERROR : String;
}


#end
