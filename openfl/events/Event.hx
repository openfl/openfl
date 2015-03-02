package openfl.events; #if !flash #if !lime_legacy


import openfl.display.InteractiveObject;


/**
 * The Event class is used as the base class for the creation of Event
 * objects, which are passed as parameters to event listeners when an event
 * occurs.
 *
 * <p>The properties of the Event class carry basic information about an
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
 * Event subclasses are described in the documentation for each class.</p>
 *
 * <p>The methods of the Event class can be used in event listener functions
 * to affect the behavior of the event object. Some events have an associated
 * default behavior. For example, the <code>doubleClick</code> event has an
 * associated default behavior that highlights the word under the mouse
 * pointer at the time of the event. Your event listener can cancel this
 * behavior by calling the <code>preventDefault()</code> method. You can also
 * make the current event listener the last one to process an event by calling
 * the <code>stopPropagation()</code> or
 * <code>stopImmediatePropagation()</code> method.</p>
 *
 * <p>Other sources of information include:</p>
 *
 * <ul>
 *   <li>A useful description about the timing of events, code execution, and
 * rendering at runtime in Ted Patrick's blog entry: <a
 * href="http://www.onflex.org/ted/2005/07/flash-player-mental-model-elastic.php"
 * scope="external">Flash Player Mental Model - The Elastic
 * Racetrack</a>.</li>
 *   <li>A blog entry by Johannes Tacskovics about the timing of frame events,
 * such as ENTER_FRAME, EXIT_FRAME: <a
 * href="http://blog.johannest.com/2009/06/15/the-movieclip-life-cycle-revisited-from-event-added-to-event-removed_from_stage/"
 * scope="external">The MovieClip Lifecycle</a>.</li>
 *   <li>An article by Trevor McCauley about the order of ActionScript
 * operations: <a
 * href="http://www.senocular.com/flash/tutorials/orderofoperations/"
 * scope="external">Order of Operations in ActionScript</a>.</li>
 *   <li>A blog entry by Matt Przybylski on creating custom events: <a
 * href="http://evolve.reintroducing.com/2007/10/23/as3/as3-custom-events/"
 * scope="external">AS3: Custom Events</a>.</li>
 * </ul>
 * 
 */
class Event {
	
	
	/**
	 * The <code>ACTIVATE</code> constant defines the value of the
	 * <code>type</code> property of an <code>activate</code> event object.
	 *
	 * <p><b>Note:</b> This event has neither a "capture phase" nor a "bubble
	 * phase", which means that event listeners must be added directly to any
	 * potential targets, whether the target is on the display list or not.</p>
	 *
	 * <p>AIR for TV devices never automatically dispatch this event. You can,
	 * however, dispatch it manually.</p>
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var ACTIVATE = "activate";
	
	/**
	 * The <code>Event.ADDED</code> constant defines the value of the
	 * <code>type</code> property of an <code>added</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var ADDED = "added";
	
	/**
	 * The <code>Event.ADDED_TO_STAGE</code> constant defines the value of the
	 * <code>type</code> property of an <code>addedToStage</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var ADDED_TO_STAGE = "addedToStage";
	
	/**
	 * The <code>Event.CANCEL</code> constant defines the value of the
	 * <code>type</code> property of a <code>cancel</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var CANCEL = "cancel";
	
	/**
	 * The <code>Event.CHANGE</code> constant defines the value of the
	 * <code>type</code> property of a <code>change</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var CHANGE = "change";
	
	/**
	 * The <code>Event.CLOSE</code> constant defines the value of the
	 * <code>type</code> property of a <code>close</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var CLOSE = "close";
	
	/**
	 * The <code>Event.COMPLETE</code> constant defines the value of the
	 * <code>type</code> property of a <code>complete</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var COMPLETE = "complete";
	
	/**
	 * The <code>Event.CONNECT</code> constant defines the value of the
	 * <code>type</code> property of a <code>connect</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var CONNECT = "connect";
	public static var CONTEXT3D_CREATE = "context3DCreate";
	
	/**
	 * The <code>Event.DEACTIVATE</code> constant defines the value of the
	 * <code>type</code> property of a <code>deactivate</code> event object.
	 *
	 * <p><b>Note:</b> This event has neither a "capture phase" nor a "bubble
	 * phase", which means that event listeners must be added directly to any
	 * potential targets, whether the target is on the display list or not.</p>
	 *
	 * <p>AIR for TV devices never automatically dispatch this event. You can,
	 * however, dispatch it manually.</p>
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var DEACTIVATE = "deactivate";
	
	/**
	 * The <code>Event.ENTER_FRAME</code> constant defines the value of the
	 * <code>type</code> property of an <code>enterFrame</code> event object.
	 *
	 * <p><b>Note:</b> This event has neither a "capture phase" nor a "bubble
	 * phase", which means that event listeners must be added directly to any
	 * potential targets, whether the target is on the display list or not.</p>
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var ENTER_FRAME = "enterFrame";
	
	/**
	 * The <code>Event.ID3</code> constant defines the value of the
	 * <code>type</code> property of an <code>id3</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var ID3 = "id3";
	
	/**
	 * The <code>Event.INIT</code> constant defines the value of the
	 * <code>type</code> property of an <code>init</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var INIT = "init";
	
	/**
	 * The <code>Event.MOUSE_LEAVE</code> constant defines the value of the
	 * <code>type</code> property of a <code>mouseLeave</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var MOUSE_LEAVE = "mouseLeave";
	
	/**
	 * The <code>Event.OPEN</code> constant defines the value of the
	 * <code>type</code> property of an <code>open</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var OPEN = "open";
	
	/**
	 * The <code>Event.REMOVED</code> constant defines the value of the
	 * <code>type</code> property of a <code>removed</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var REMOVED = "removed";
	
	/**
	 * The <code>Event.REMOVED_FROM_STAGE</code> constant defines the value of
	 * the <code>type</code> property of a <code>removedFromStage</code> event
	 * object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var REMOVED_FROM_STAGE = "removedFromStage";
	
	/**
	 * The <code>Event.RENDER</code> constant defines the value of the
	 * <code>type</code> property of a <code>render</code> event object.
	 *
	 * <p><b>Note:</b> This event has neither a "capture phase" nor a "bubble
	 * phase", which means that event listeners must be added directly to any
	 * potential targets, whether the target is on the display list or not.</p>
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var RENDER = "render";
	
	/**
	 * The <code>Event.RESIZE</code> constant defines the value of the
	 * <code>type</code> property of a <code>resize</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var RESIZE = "resize";
	
	/**
	 * The <code>Event.SCROLL</code> constant defines the value of the
	 * <code>type</code> property of a <code>scroll</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var SCROLL = "scroll";
	
	/**
	 * The <code>Event.SELECT</code> constant defines the value of the
	 * <code>type</code> property of a <code>select</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var SELECT = "select";
	
	/**
	 * The <code>Event.SOUND_COMPLETE</code> constant defines the value of the
	 * <code>type</code> property of a <code>soundComplete</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var SOUND_COMPLETE = "soundComplete";
	
	/**
	 * The <code>Event.TAB_CHILDREN_CHANGE</code> constant defines the value of
	 * the <code>type</code> property of a <code>tabChildrenChange</code> event
	 * object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var TAB_CHILDREN_CHANGE = "tabChildrenChange";
	
	/**
	 * The <code>Event.TAB_ENABLED_CHANGE</code> constant defines the value of
	 * the <code>type</code> property of a <code>tabEnabledChange</code> event
	 * object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var TAB_ENABLED_CHANGE = "tabEnabledChange";
	
	/**
	 * The <code>Event.TAB_INDEX_CHANGE</code> constant defines the value of the
	 * <code>type</code> property of a <code>tabIndexChange</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var TAB_INDEX_CHANGE = "tabIndexChange";
	
	/**
	 * The <code>Event.UNLOAD</code> constant defines the value of the
	 * <code>type</code> property of an <code>unload</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var UNLOAD = "unload";
	
	
	/**
	 * Indicates whether an event is a bubbling event. If the event can bubble,
	 * this value is <code>true</code>; otherwise it is <code>false</code>.
	 *
	 * <p>When an event occurs, it moves through the three phases of the event
	 * flow: the capture phase, which flows from the top of the display list
	 * hierarchy to the node just before the target node; the target phase, which
	 * comprises the target node; and the bubbling phase, which flows from the
	 * node subsequent to the target node back up the display list hierarchy.</p>
	 *
	 * <p>Some events, such as the <code>activate</code> and <code>unload</code>
	 * events, do not have a bubbling phase. The <code>bubbles</code> property
	 * has a value of <code>false</code> for events that do not have a bubbling
	 * phase.</p>
	 */
	public var bubbles (default, null):Bool;
	
	/**
	 * Indicates whether the behavior associated with the event can be prevented.
	 * If the behavior can be canceled, this value is <code>true</code>;
	 * otherwise it is <code>false</code>.
	 */
	public var cancelable (default, null):Bool;
	
	/**
	 * The object that is actively processing the Event object with an event
	 * listener. For example, if a user clicks an OK button, the current target
	 * could be the node containing that button or one of its ancestors that has
	 * registered an event listener for that event.
	 */
	public var currentTarget:Dynamic;
	
	/**
	 * The current phase in the event flow. This property can contain the
	 * following numeric values:
	 * <ul>
	 *   <li> The capture phase(<code>EventPhase.CAPTURING_PHASE</code>).</li>
	 *   <li> The target phase(<code>EventPhase.AT_TARGET</code>).</li>
	 *   <li> The bubbling phase(<code>EventPhase.BUBBLING_PHASE</code>).</li>
	 * </ul>
	 */
	public var eventPhase (default, null):EventPhase;
	
	/**
	 * The event target. This property contains the target node. For example, if
	 * a user clicks an OK button, the target node is the display list node
	 * containing that button.
	 */
	public var target:Dynamic;
	
	/**
	 * The type of event. The type is case-sensitive.
	 */
	public var type (default, null):String;
	
	@:noCompletion private var __isCancelled:Bool;
	@:noCompletion private var __isCancelledNow:Bool;
	
	
	/**
	 * Creates an Event object to pass as a parameter to event listeners.
	 * 
	 * @param type       The type of the event, accessible as
	 *                   <code>Event.type</code>.
	 * @param bubbles    Determines whether the Event object participates in the
	 *                   bubbling stage of the event flow. The default value is
	 *                   <code>false</code>.
	 * @param cancelable Determines whether the Event object can be canceled. The
	 *                   default values is <code>false</code>.
	 */
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false) {
		
		this.type = type;
		this.bubbles = bubbles;
		this.cancelable = cancelable;
		eventPhase = EventPhase.AT_TARGET;
		
	}
	
	
	/**
	 * Duplicates an instance of an Event subclass.
	 *
	 * <p>Returns a new Event object that is a copy of the original instance of
	 * the Event object. You do not normally call <code>clone()</code>; the
	 * EventDispatcher class calls it automatically when you redispatch an
	 * event - that is, when you call <code>dispatchEvent(event)</code> from a
	 * handler that is handling <code>event</code>.</p>
	 *
	 * <p>The new Event object includes all the properties of the original.</p>
	 *
	 * <p>When creating your own custom Event class, you must override the
	 * inherited <code>Event.clone()</code> method in order for it to duplicate
	 * the properties of your custom class. If you do not set all the properties
	 * that you add in your event subclass, those properties will not have the
	 * correct values when listeners handle the redispatched event.</p>
	 *
	 * <p>In this example, <code>PingEvent</code> is a subclass of
	 * <code>Event</code> and therefore implements its own version of
	 * <code>clone()</code>.</p>
	 * 
	 * @return A new Event object that is identical to the original.
	 */
	public function clone ():Event {
		
		var event = new Event (type, bubbles, cancelable);
		event.eventPhase = eventPhase;
		event.target = target;
		event.currentTarget = currentTarget;
		return event;
		
	}
	
	
	/**
	 * Checks whether the <code>preventDefault()</code> method has been called on
	 * the event. If the <code>preventDefault()</code> method has been called,
	 * returns <code>true</code>; otherwise, returns <code>false</code>.
	 * 
	 * @return If <code>preventDefault()</code> has been called, returns
	 *         <code>true</code>; otherwise, returns <code>false</code>.
	 */
	public function isDefaultPrevented ():Bool {
		
		return (__isCancelled || __isCancelledNow);
		
	}
	
	
	/**
	 * Prevents processing of any event listeners in the current node and any
	 * subsequent nodes in the event flow. This method takes effect immediately,
	 * and it affects event listeners in the current node. In contrast, the
	 * <code>stopPropagation()</code> method doesn't take effect until all the
	 * event listeners in the current node finish processing.
	 *
	 * <p><b>Note: </b> This method does not cancel the behavior associated with
	 * this event; see <code>preventDefault()</code> for that functionality.</p>
	 * 
	 */
	public function stopImmediatePropagation ():Void {
		
		__isCancelled = true;
		__isCancelledNow = true;
		
	}
	
	
	/**
	 * Prevents processing of any event listeners in nodes subsequent to the
	 * current node in the event flow. This method does not affect any event
	 * listeners in the current node(<code>currentTarget</code>). In contrast,
	 * the <code>stopImmediatePropagation()</code> method prevents processing of
	 * event listeners in both the current node and subsequent nodes. Additional
	 * calls to this method have no effect. This method can be called in any
	 * phase of the event flow.
	 *
	 * <p><b>Note: </b> This method does not cancel the behavior associated with
	 * this event; see <code>preventDefault()</code> for that functionality.</p>
	 * 
	 */
	public function stopPropagation ():Void {
		
		__isCancelled = true;
		
	}
	
	
	/**
	 * Returns a string containing all the properties of the Event object. The
	 * string is in the following format:
	 *
	 * <p><code>[Event type=<i>value</i> bubbles=<i>value</i>
	 * cancelable=<i>value</i>]</code></p>
	 * 
	 * @return A string containing all the properties of the Event object.
	 */
	public function toString ():String {
		
		return "[Event type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + "]";
		
	}
	
	
}


#else
typedef Event = openfl._v2.events.Event;
#end
#else
typedef Event = flash.events.Event;
#end