import TextEvent from "./TextEvent";


declare namespace openfl.events {
	
	
	/**
	 * An object dispatches an ErrorEvent object when an error causes an
	 * asynchronous operation to fail.
	 *
	 * The ErrorEvent class defines only one type of `error` event:
	 * `ErrorEvent.ERROR`. The ErrorEvent class also serves as the base
	 * class for several other error event classes, including the AsyncErrorEvent,
	 * IOErrorEvent, SecurityErrorEvent, SQLErrorEvent, and UncaughtErrorEvent
	 * classes.
	 *
	 * You can check for `error` events that do not have any
	 * listeners by registering a listener for the `uncaughtError`
	 * (UncaughtErrorEvent.UNCAUGHT_ERROR) event.
	 *
	 * An uncaught error also causes an error dialog box displaying the error
	 * event to appear when content is running in the debugger version of Flash
	 * Player or the AIR Debug Launcher(ADL) application.
	 * 
	 */
	export class ErrorEvent extends TextEvent {
		
		
		/**
		 * Defines the value of the `type` property of an
		 * `error` event object.
		 *
		 * This event has the following properties:
		 */
		public static ERROR:string;
		
		
		/**
		 * Contains the reference number associated with the specific error. For a
		 * custom ErrorEvent object, this number is the value from the
		 * `id` parameter supplied in the constructor.
		 */
		public readonly errorID:number;
		
		
		/**
		 * Creates an Event object that contains information about error events.
		 * Event objects are passed as parameters to event listeners.
		 * 
		 * @param type       The type of the event. Event listeners can access this
		 *                   information through the inherited `type`
		 *                   property. There is only one type of error event:
		 *                   `ErrorEvent.ERROR`.
		 * @param bubbles    Determines whether the Event object bubbles. Event
		 *                   listeners can access this information through the
		 *                   inherited `bubbles` property.
		 * @param cancelable Determines whether the Event object can be canceled.
		 *                   Event listeners can access this information through the
		 *                   inherited `cancelable` property.
		 * @param text       Text to be displayed as an error message. Event
		 *                   listeners can access this information through the
		 *                   `text` property.
		 * @param id         A reference number to associate with the specific error
		 *                  (supported in Adobe AIR only).
		 */
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean, text?:string, id?:number);
		
		
	}
	
	
}


export default openfl.events.ErrorEvent;