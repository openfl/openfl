import EventPhase from "./EventPhase";


declare namespace openfl.events {
	
	
	/**
	 * The Event class is used as the base class for the creation of Event
	 * objects, which are passed as parameters to event listeners when an event
	 * occurs.
	 *
	 * The properties of the Event class carry basic information about an
	 * event, such as the event's type or whether the event's default behavior can
	 * be canceled. For many events, such as the events represented by the Event
	 * class constants, this basic information is sufficient. Other events,
	 * however, may require more detailed information. Events associated with a
	 * mouse click, for example, need to include additional information about the
	 * location of the click event and whether any keys were pressed during the
	 * click event. You can pass such additional information to event listeners by
	 * extending the Event class, which is what the MouseEvent class does.
	 * ActionScript 3.0 API defines several Event subclasses for common events
	 * that require additional information. Events associated with each of the
	 * Event subclasses are described in the documentation for each class.
	 *
	 * The methods of the Event class can be used in event listener functions
	 * to affect the behavior of the event object. Some events have an associated
	 * default behavior. For example, the `doubleClick` event has an
	 * associated default behavior that highlights the word under the mouse
	 * pointer at the time of the event. Your event listener can cancel this
	 * behavior by calling the `preventDefault()` method. You can also
	 * make the current event listener the last one to process an event by calling
	 * the `stopPropagation()` or
	 * `stopImmediatePropagation()` method.
	 *
	 * Other sources of information include:
	 *
	 * 
	 *  * A useful description about the timing of events, code execution, and
	 * rendering at runtime in Ted Patrick's blog entry: <a
	 * [Flash Player Mental Model - The Elastic](http://www.onflex.org/ted/2005/07/flash-player-mental-model-elastic.php).
	 *  * A blog entry by Johannes Tacskovics about the timing of frame events,
	 * such as ENTER_FRAME, EXIT_FRAME: [The MovieClip Lifecycle](http://blog.johannest.com/2009/06/15/the-movieclip-life-cycle-revisited-from-event-added-to-event-removed_from_stage/).
	 *  * An article by Trevor McCauley about the order of ActionScript
	 * operations: [Order of Operations in ActionScript](http://www.senocular.com/flash/tutorials/orderofoperations/).
	 *  * A blog entry by Matt Przybylski on creating custom events:
	 * [AS3: Custom Events](http://evolve.reintroducing.com/2007/10/23/as3/as3-custom-events/).
	 */
	export class Event {
		
		
		/**
		 * The `ACTIVATE` constant defines the value of the
		 * `type` property of an `activate` event object.
		 *
		 * **Note:** This event has neither a "capture phase" nor a "bubble
		 * phase", which means that event listeners must be added directly to any
		 * potential targets, whether the target is on the display list or not.
		 *
		 * AIR for TV devices never automatically dispatch this event. You can,
		 * however, dispatch it manually.
		 *
		 * This event has the following properties:
		 */
		public static ACTIVATE:string;
		
		/**
		 * The `Event.ADDED` constant defines the value of the
		 * `type` property of an `added` event object.
		 *
		 * This event has the following properties:
		 */
		public static ADDED:string;
		
		/**
		 * The `Event.ADDED_TO_STAGE` constant defines the value of the
		 * `type` property of an `addedToStage` event object.
		 *
		 * This event has the following properties:
		 */
		public static ADDED_TO_STAGE:string;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash15) public static var BROWSER_ZOOM_CHANGE:string;
		// #end
		
		/**
		 * The `Event.CANCEL` constant defines the value of the
		 * `type` property of a `cancel` event object.
		 *
		 * This event has the following properties:
		 */
		public static CANCEL:string;
		
		/**
		 * The `Event.CHANGE` constant defines the value of the
		 * `type` property of a `change` event object.
		 *
		 * This event has the following properties:
		 */
		public static CHANGE:string;
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var CHANNEL_MESSAGE:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var CHANNEL_STATE:string;
		// #end
		
		public static CLEAR:string;
		
		/**
		 * The `Event.CLOSE` constant defines the value of the
		 * `type` property of a `close` event object.
		 *
		 * This event has the following properties:
		 */
		public static CLOSE:string;
		
		/**
		 * The `Event.COMPLETE` constant defines the value of the
		 * `type` property of a `complete` event object.
		 *
		 * This event has the following properties:
		 */
		public static COMPLETE:string;
		
		/**
		 * The `Event.CONNECT` constant defines the value of the
		 * `type` property of a `connect` event object.
		 *
		 * This event has the following properties:
		 */
		public static CONNECT:string;
		
		public static CONTEXT3D_CREATE:string;
		
		public static COPY:string;
		
		public static CUT:string;
		
		/**
		 * The `Event.DEACTIVATE` constant defines the value of the
		 * `type` property of a `deactivate` event object.
		 *
		 * **Note:** This event has neither a "capture phase" nor a "bubble
		 * phase", which means that event listeners must be added directly to any
		 * potential targets, whether the target is on the display list or not.
		 *
		 * AIR for TV devices never automatically dispatch this event. You can,
		 * however, dispatch it manually.
		 *
		 * This event has the following properties:
		 */
		public static DEACTIVATE:string;
		
		/**
		 * The `Event.ENTER_FRAME` constant defines the value of the
		 * `type` property of an `enterFrame` event object.
		 *
		 * **Note:** This event has neither a "capture phase" nor a "bubble
		 * phase", which means that event listeners must be added directly to any
		 * potential targets, whether the target is on the display list or not.
		 *
		 * This event has the following properties:
		 */
		public static ENTER_FRAME:string;
		
		// #if (flash && air)
		// public static var EXITING : String;
		// #end
		
		public static EXIT_FRAME:string;
		
		public static FRAME_CONSTRUCTED:string;
		
		public static FRAME_LABEL:string;
		
		public static FULLSCREEN:string;
		
		/**
		 * The `Event.ID3` constant defines the value of the
		 * `type` property of an `id3` event object.
		 *
		 * This event has the following properties:
		 */
		public static ID3:string;
		
		/**
		 * The `Event.INIT` constant defines the value of the
		 * `type` property of an `init` event object.
		 *
		 * This event has the following properties:
		 */
		public static INIT:string;
		
		/**
		 * The `Event.MOUSE_LEAVE` constant defines the value of the
		 * `type` property of a `mouseLeave` event object.
		 *
		 * This event has the following properties:
		 */
		public static MOUSE_LEAVE:string;
		
		/**
		 * The `Event.OPEN` constant defines the value of the
		 * `type` property of an `open` event object.
		 *
		 * This event has the following properties:
		 */
		public static OPEN:string;
		
		public static PASTE:string;
		
		/**
		 * The `Event.REMOVED` constant defines the value of the
		 * `type` property of a `removed` event object.
		 *
		 * This event has the following properties:
		 */
		public static REMOVED:string;
		
		/**
		 * The `Event.REMOVED_FROM_STAGE` constant defines the value of
		 * the `type` property of a `removedFromStage` event
		 * object.
		 *
		 * This event has the following properties:
		 */
		public static REMOVED_FROM_STAGE:string;
		
		/**
		 * The `Event.RENDER` constant defines the value of the
		 * `type` property of a `render` event object.
		 *
		 * **Note:** This event has neither a "capture phase" nor a "bubble
		 * phase", which means that event listeners must be added directly to any
		 * potential targets, whether the target is on the display list or not.
		 *
		 * This event has the following properties:
		 */
		public static RENDER:string;
		
		/**
		 * The `Event.RESIZE` constant defines the value of the
		 * `type` property of a `resize` event object.
		 *
		 * This event has the following properties:
		 */
		public static RESIZE:string;
		
		/**
		 * The `Event.SCROLL` constant defines the value of the
		 * `type` property of a `scroll` event object.
		 *
		 * This event has the following properties:
		 */
		public static SCROLL:string;
		
		/**
		 * The `Event.SELECT` constant defines the value of the
		 * `type` property of a `select` event object.
		 *
		 * This event has the following properties:
		 */
		public static SELECT:string;
		
		public static SELECT_ALL:string;
		
		/**
		 * The `Event.SOUND_COMPLETE` constant defines the value of the
		 * `type` property of a `soundComplete` event object.
		 *
		 * This event has the following properties:
		 */
		public static SOUND_COMPLETE:string;
		
		// #if (flash && air)
		// @:noCompletion @:dox(hide) @:require(flash11_3) public static var SUSPEND:string;
		// #end
		
		/**
		 * The `Event.TAB_CHILDREN_CHANGE` constant defines the value of
		 * the `type` property of a `tabChildrenChange` event
		 * object.
		 *
		 * This event has the following properties:
		 */
		public static TAB_CHILDREN_CHANGE:string;
		
		/**
		 * The `Event.TAB_ENABLED_CHANGE` constant defines the value of
		 * the `type` property of a `tabEnabledChange` event
		 * object.
		 *
		 * This event has the following properties:
		 */
		public static TAB_ENABLED_CHANGE:string;
		
		/**
		 * The `Event.TAB_INDEX_CHANGE` constant defines the value of the
		 * `type` property of a `tabIndexChange` event object.
		 *
		 * This event has the following properties:
		 */
		public static TAB_INDEX_CHANGE:string;
		
		public static TEXTURE_READY:string;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public static var TEXT_INTERACTION_MODE_CHANGE:string;
		// #end
		
		/**
		 * The `Event.UNLOAD` constant defines the value of the
		 * `type` property of an `unload` event object.
		 *
		 * This event has the following properties:
		 */
		public static UNLOAD:string;
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var VIDEO_FRAME:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var WORKER_STATE:string;
		// #end
		
		
		/**
		 * Indicates whether an event is a bubbling event. If the event can bubble,
		 * this value is `true`; otherwise it is `false`.
		 *
		 * When an event occurs, it moves through the three phases of the event
		 * flow: the capture phase, which flows from the top of the display list
		 * hierarchy to the node just before the target node; the target phase, which
		 * comprises the target node; and the bubbling phase, which flows from the
		 * node subsequent to the target node back up the display list hierarchy.
		 *
		 * Some events, such as the `activate` and `unload`
		 * events, do not have a bubbling phase. The `bubbles` property
		 * has a value of `false` for events that do not have a bubbling
		 * phase.
		 */
		public readonly bubbles:boolean;
		
		/**
		 * Indicates whether the behavior associated with the event can be prevented.
		 * If the behavior can be canceled, this value is `true`;
		 * otherwise it is `false`.
		 */
		public readonly cancelable:boolean;
		
		/**
		 * The object that is actively processing the Event object with an event
		 * listener. For example, if a user clicks an OK button, the current target
		 * could be the node containing that button or one of its ancestors that has
		 * registered an event listener for that event.
		 */
		public readonly currentTarget:any;
		
		/**
		 * The current phase in the event flow. This property can contain the
		 * following numeric values:
		 * 
		 *  *  The capture phase(`EventPhase.CAPTURING_PHASE`).
		 *  *  The target phase(`EventPhase.AT_TARGET`).
		 *  *  The bubbling phase(`EventPhase.BUBBLING_PHASE`).
		 * 
		 */
		public readonly eventPhase:EventPhase;
		
		/**
		 * The event target. This property contains the target node. For example, if
		 * a user clicks an OK button, the target node is the display list node
		 * containing that button.
		 */
		public readonly target:any;
		
		/**
		 * The type of event. The type is case-sensitive.
		 */
		public readonly type:string;
		
		
		/**
		 * Creates an Event object to pass as a parameter to event listeners.
		 * 
		 * @param type       The type of the event, accessible as
		 *                   `Event.type`.
		 * @param bubbles    Determines whether the Event object participates in the
		 *                   bubbling stage of the event flow. The default value is
		 *                   `false`.
		 * @param cancelable Determines whether the Event object can be canceled. The
		 *                   default values is `false`.
		 */
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean);
		
		
		/**
		 * Duplicates an instance of an Event subclass.
		 *
		 * Returns a new Event object that is a copy of the original instance of
		 * the Event object. You do not normally call `clone()`; the
		 * EventDispatcher class calls it automatically when you redispatch an
		 * event - that is, when you call `dispatchEvent(event)` from a
		 * handler that is handling `event`.
		 *
		 * The new Event object includes all the properties of the original.
		 *
		 * When creating your own custom Event class, you must override the
		 * inherited `Event.clone()` method in order for it to duplicate
		 * the properties of your custom class. If you do not set all the properties
		 * that you add in your event subclass, those properties will not have the
		 * correct values when listeners handle the redispatched event.
		 *
		 * In this example, `PingEvent` is a subclass of
		 * `Event` and therefore implements its own version of
		 * `clone()`.
		 * 
		 * @return A new Event object that is identical to the original.
		 */
		public clone ():Event;
		
		
		public formatToString (className:string, ...args:any[]):string;
		
		
		/**
		 * Checks whether the `preventDefault()` method has been called on
		 * the event. If the `preventDefault()` method has been called,
		 * returns `true`; otherwise, returns `false`.
		 * 
		 * @return If `preventDefault()` has been called, returns
		 *         `true`; otherwise, returns `false`.
		 */
		public isDefaultPrevented ():boolean;
		
		
		/**
		 * Cancels an event's default behavior if that behavior can be canceled.
		 * Many events have associated behaviors that are carried out by default. For example, if a user types a character into a text field, the default behavior is that the character is displayed in the text field. Because the `TextEvent.TEXT_INPUT` event's default behavior can be canceled, you can use the `preventDefault()` method to prevent the character from appearing.
		 * An example of a behavior that is not cancelable is the default behavior associated with the Event.REMOVED event, which is generated whenever Flash Player is about to remove a display object from the display list. The default behavior (removing the element) cannot be canceled, so the `preventDefault()` method has no effect on this default behavior.
		 * You can use the `Event.cancelable` property to check whether you can prevent the default behavior associated with a particular event. If the value of `Event.cancelable` is true, then `preventDefault()` can be used to cancel the event; otherwise, `preventDefault()` has no effect.
		 */
		public preventDefault ():void;
		
		
		/**
		 * Prevents processing of any event listeners in the current node and any
		 * subsequent nodes in the event flow. This method takes effect immediately,
		 * and it affects event listeners in the current node. In contrast, the
		 * `stopPropagation()` method doesn't take effect until all the
		 * event listeners in the current node finish processing.
		 *
		 * **Note: ** This method does not cancel the behavior associated with
		 * this event; see `preventDefault()` for that functionality.
		 * 
		 */
		public stopImmediatePropagation ():void;
		
		
		/**
		 * Prevents processing of any event listeners in nodes subsequent to the
		 * current node in the event flow. This method does not affect any event
		 * listeners in the current node(`currentTarget`). In contrast,
		 * the `stopImmediatePropagation()` method prevents processing of
		 * event listeners in both the current node and subsequent nodes. Additional
		 * calls to this method have no effect. This method can be called in any
		 * phase of the event flow.
		 *
		 * **Note: ** This method does not cancel the behavior associated with
		 * this event; see `preventDefault()` for that functionality.
		 * 
		 */
		public stopPropagation ():void;
		
		
		/**
		 * Returns a string containing all the properties of the Event object. The
		 * string is in the following format:
		 *
		 * `[Event type=_value_ bubbles=_value_
		 * cancelable=_value_]`
		 * 
		 * @return A string containing all the properties of the Event object.
		 */
		public toString ():string;
		
		
	}
	
	
}


export default openfl.events.Event;