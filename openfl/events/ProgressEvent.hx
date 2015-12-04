package openfl.events; #if (!display && !flash)


class ProgressEvent extends Event {
	
	
	public static var PROGRESS = "progress";
	public static var SOCKET_DATA = "socketData";
	
	public var bytesLoaded:Float;
	public var bytesTotal:Float;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0) {
		
		super (type, bubbles, cancelable);
		
		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new ProgressEvent (type, bubbles, cancelable, bytesLoaded, bytesTotal);
		event.target = target;
		event.currentTarget = currentTarget;
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("ProgressEvent",  [ "type", "bubbles", "cancelable", "bytesLoaded", "bytesTotal" ]);
		
	}
	
	
}


#else


/**
 * A ProgressEvent object is dispatched when a load operation has begun or a
 * socket has received data. These events are usually generated when SWF
 * files, images or data are loaded into an application. There are two types
 * of progress events: <code>ProgressEvent.PROGRESS</code> and
 * <code>ProgressEvent.SOCKET_DATA</code>. Additionally, in AIR ProgressEvent
 * objects are dispatched when a data is sent to or from a child process using
 * the NativeProcess class.
 * 
 */

#if flash
@:native("flash.events.ProgressEvent")
#end

extern class ProgressEvent extends Event {
	
	
	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>progress</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var PROGRESS:String;
	
	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>socketData</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var SOCKET_DATA:String;
	
	
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
	 *                    are:<code>ProgressEvent.PROGRESS</code>,
	 *                    <code>ProgressEvent.SOCKET_DATA</code>,
	 *                    <code>ProgressEvent.STANDARD_ERROR_DATA</code>,
	 *                    <code>ProgressEvent.STANDARD_INPUT_PROGRESS</code>, and
	 *                    <code>ProgressEvent.STANDARD_OUTPUT_DATA</code>.
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


#end