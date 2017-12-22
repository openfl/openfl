import ErrorEvent from "./ErrorEvent";


declare namespace openfl.events {
	
	
	/**
	 * An IOErrorEvent object is dispatched when an error causes input or output
	 * operations to fail.
	 *
	 * You can check for error events that do not have any listeners by using
	 * the debugger version of Flash Player or the AIR Debug Launcher(ADL). The
	 * string defined by the `text` parameter of the IOErrorEvent
	 * constructor is displayed.
	 * 
	 */
	export class IOErrorEvent extends ErrorEvent {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var DISK_ERROR:string;
		// #end
		
		/**
		 * Defines the value of the `type` property of an
		 * `ioError` event object.
		 *
		 * This event has the following properties:
		 */
		public static IO_ERROR:string;
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var NETWORK_ERROR:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var VERIFY_ERROR:string;
		// #end
		
		
		/**
		 * Creates an Event object that contains specific information about
		 * `ioError` events. Event objects are passed as parameters to
		 * Event listeners.
		 * 
		 * @param type       The type of the event. Event listeners can access this
		 *                   information through the inherited `type`
		 *                   property. There is only one type of input/output error
		 *                   event: `IOErrorEvent.IO_ERROR`.
		 * @param bubbles    Determines whether the Event object participates in the
		 *                   bubbling stage of the event flow. Event listeners can
		 *                   access this information through the inherited
		 *                   `bubbles` property.
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


export default openfl.events.IOErrorEvent;