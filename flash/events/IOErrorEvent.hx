package flash.events;
#if (flash || display)


/**
 * An IOErrorEvent object is dispatched when an error causes input or output
 * operations to fail.
 *
 * <p>You can check for error events that do not have any listeners by using
 * the debugger version of Flash Player or the AIR Debug Launcher(ADL). The
 * string defined by the <code>text</code> parameter of the IOErrorEvent
 * constructor is displayed.</p>
 * 
 */
extern class IOErrorEvent extends ErrorEvent {

	/**
	 * Creates an Event object that contains specific information about
	 * <code>ioError</code> events. Event objects are passed as parameters to
	 * Event listeners.
	 * 
	 * @param type       The type of the event. Event listeners can access this
	 *                   information through the inherited <code>type</code>
	 *                   property. There is only one type of input/output error
	 *                   event: <code>IOErrorEvent.IO_ERROR</code>.
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
	 * @param id         A reference number to associate with the specific error
	 *                  (supported in Adobe AIR only).
	 */
	function new(type : String, bubbles : Bool = false, cancelable : Bool = false, ?text : String, id : Int = 0) : Void;
	static var DISK_ERROR : String;

	/**
	 * Defines the value of the <code>type</code> property of an
	 * <code>ioError</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	static var IO_ERROR : String;
	static var NETWORK_ERROR : String;
	static var VERIFY_ERROR : String;
}


#end
