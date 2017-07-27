package openfl.events; #if (display || !flash)


/**
 * A ProgressEvent object is dispatched when a load operation has begun or a
 * socket has received data. These events are usually generated when SWF
 * files, images or data are loaded into an application. There are two types
 * of progress events: `ProgressEvent.PROGRESS` and
 * `ProgressEvent.SOCKET_DATA`. Additionally, in AIR ProgressEvent
 * objects are dispatched when a data is sent to or from a child process using
 * the NativeProcess class.
 * 
 */
extern class ProgressEvent extends Event {
	
	
	/**
	 * Defines the value of the `type` property of a
	 * `progress` event object.
	 *
	 * This event has the following properties:
	 */
	public static inline var PROGRESS = "progress";
	
	/**
	 * Defines the value of the `type` property of a
	 * `socketData` event object.
	 *
	 * This event has the following properties:
	 */
	public static inline var SOCKET_DATA = "socketData";
	
	
	/**
	 * The number of items or bytes loaded when the listener processes the event.
	 */
	public var bytesLoaded:Float;
	
	/**
	 * The total number of items or bytes that will be loaded if the loading
	 * process succeeds. If the progress event is dispatched/attached to a Socket
	 * object, the bytesTotal will always be 0 unless a value is specified in the
	 * bytesTotal parameter of the constructor. The actual number of bytes sent
	 * back or forth is not set and is up to the application developer.
	 */
	public var bytesTotal:Float;
	
	
	/**
	 * Creates an Event object that contains information about progress events.
	 * Event objects are passed as parameters to event listeners.
	 * 
	 * @param type        The type of the event. Possible values
	 *                    are:`ProgressEvent.PROGRESS`,
	 *                    `ProgressEvent.SOCKET_DATA`,
	 *                    `ProgressEvent.STANDARD_ERROR_DATA`,
	 *                    `ProgressEvent.STANDARD_INPUT_PROGRESS`, and
	 *                    `ProgressEvent.STANDARD_OUTPUT_DATA`.
	 * @param bubbles     Determines whether the Event object participates in the
	 *                    bubbling stage of the event flow.
	 * @param cancelable  Determines whether the Event object can be canceled.
	 * @param bytesLoaded The number of items or bytes loaded at the time the
	 *                    listener processes the event.
	 * @param bytesTotal  The total number of items or bytes that will be loaded
	 *                    if the loading process succeeds.
	 */
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0);
	
	
}


#else
typedef ProgressEvent = flash.events.ProgressEvent;
#end