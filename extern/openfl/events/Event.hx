package openfl.events; #if (display || !flash)


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
extern class Event {
	
	
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
	public static inline var ACTIVATE = "activate";
	
	/**
	 * The <code>Event.ADDED</code> constant defines the value of the
	 * <code>type</code> property of an <code>added</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var ADDED = "added";
	
	/**
	 * The <code>Event.ADDED_TO_STAGE</code> constant defines the value of the
	 * <code>type</code> property of an <code>addedToStage</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var ADDED_TO_STAGE = "addedToStage";
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash15) public static var BROWSER_ZOOM_CHANGE:String;
	#end
	
	/**
	 * The <code>Event.CANCEL</code> constant defines the value of the
	 * <code>type</code> property of a <code>cancel</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var CANCEL = "cancel";
	
	/**
	 * The <code>Event.CHANGE</code> constant defines the value of the
	 * <code>type</code> property of a <code>change</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var CHANGE = "change";
	
	#if flash
	@:noCompletion @:dox(hide) public static var CHANNEL_MESSAGE:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var CHANNEL_STATE:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var CLEAR:String;
	#end
	
	/**
	 * The <code>Event.CLOSE</code> constant defines the value of the
	 * <code>type</code> property of a <code>close</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var CLOSE = "close";
	
	/**
	 * The <code>Event.COMPLETE</code> constant defines the value of the
	 * <code>type</code> property of a <code>complete</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var COMPLETE = "complete";
	
	/**
	 * The <code>Event.CONNECT</code> constant defines the value of the
	 * <code>type</code> property of a <code>connect</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var CONNECT = "connect";
	
	public static inline var CONTEXT3D_CREATE = "context3DCreate";
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var COPY:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var CUT:String;
	#end
	
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
	public static inline var DEACTIVATE = "deactivate";
	
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
	public static inline var ENTER_FRAME = "enterFrame";
	
	#if air
	public static var EXITING : String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var EXIT_FRAME:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var FRAME_CONSTRUCTED:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var FRAME_LABEL:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var FULLSCREEN:String;
	#end
	
	/**
	 * The <code>Event.ID3</code> constant defines the value of the
	 * <code>type</code> property of an <code>id3</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var ID3 = "id3";
	
	/**
	 * The <code>Event.INIT</code> constant defines the value of the
	 * <code>type</code> property of an <code>init</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var INIT = "init";
	
	/**
	 * The <code>Event.MOUSE_LEAVE</code> constant defines the value of the
	 * <code>type</code> property of a <code>mouseLeave</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var MOUSE_LEAVE = "mouseLeave";
	
	/**
	 * The <code>Event.OPEN</code> constant defines the value of the
	 * <code>type</code> property of an <code>open</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var OPEN = "open";
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var PASTE:String;
	#end
	
	/**
	 * The <code>Event.REMOVED</code> constant defines the value of the
	 * <code>type</code> property of a <code>removed</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var REMOVED = "removed";
	
	/**
	 * The <code>Event.REMOVED_FROM_STAGE</code> constant defines the value of
	 * the <code>type</code> property of a <code>removedFromStage</code> event
	 * object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var REMOVED_FROM_STAGE = "removedFromStage";
	
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
	public static inline var RENDER = "render";
	
	/**
	 * The <code>Event.RESIZE</code> constant defines the value of the
	 * <code>type</code> property of a <code>resize</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var RESIZE = "resize";
	
	/**
	 * The <code>Event.SCROLL</code> constant defines the value of the
	 * <code>type</code> property of a <code>scroll</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var SCROLL = "scroll";
	
	/**
	 * The <code>Event.SELECT</code> constant defines the value of the
	 * <code>type</code> property of a <code>select</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var SELECT = "select";
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var SELECT_ALL:String;
	#end
	
	/**
	 * The <code>Event.SOUND_COMPLETE</code> constant defines the value of the
	 * <code>type</code> property of a <code>soundComplete</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var SOUND_COMPLETE = "soundComplete";
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var SUSPEND:String;
	#end
	
	/**
	 * The <code>Event.TAB_CHILDREN_CHANGE</code> constant defines the value of
	 * the <code>type</code> property of a <code>tabChildrenChange</code> event
	 * object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var TAB_CHILDREN_CHANGE = "tabChildrenChange";
	
	/**
	 * The <code>Event.TAB_ENABLED_CHANGE</code> constant defines the value of
	 * the <code>type</code> property of a <code>tabEnabledChange</code> event
	 * object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var TAB_ENABLED_CHANGE = "tabEnabledChange";
	
	/**
	 * The <code>Event.TAB_INDEX_CHANGE</code> constant defines the value of the
	 * <code>type</code> property of a <code>tabIndexChange</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var TAB_INDEX_CHANGE = "tabIndexChange";
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var TEXTURE_READY:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public static var TEXT_INTERACTION_MODE_CHANGE:String;
	#end
	
	/**
	 * The <code>Event.UNLOAD</code> constant defines the value of the
	 * <code>type</code> property of an <code>unload</code> event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static inline var UNLOAD = "unload";
	
	#if flash
	@:noCompletion @:dox(hide) public static var VIDEO_FRAME:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var WORKER_STATE:String;
	#end
	
	
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
	public var currentTarget (default, null):Dynamic;
	
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
	public var target (default, null):Dynamic;
	
	/**
	 * The type of event. The type is case-sensitive.
	 */
	public var type (default, null):String;
	
	
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
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false);
	
	
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
	public function clone ():Event;
	
	
	public function formatToString (className:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):String;
	
	
	/**
	 * Checks whether the <code>preventDefault()</code> method has been called on
	 * the event. If the <code>preventDefault()</code> method has been called,
	 * returns <code>true</code>; otherwise, returns <code>false</code>.
	 * 
	 * @return If <code>preventDefault()</code> has been called, returns
	 *         <code>true</code>; otherwise, returns <code>false</code>.
	 */
	public function isDefaultPrevented ():Bool;
	
	
	/**
	 * Cancels an event's default behavior if that behavior can be canceled.
	 * Many events have associated behaviors that are carried out by default. For example, if a user types a character into a text field, the default behavior is that the character is displayed in the text field. Because the <code>TextEvent.TEXT_INPUT</code> event's default behavior can be canceled, you can use the <code>preventDefault()</code> method to prevent the character from appearing.
	 * An example of a behavior that is not cancelable is the default behavior associated with the Event.REMOVED event, which is generated whenever Flash Player is about to remove a display object from the display list. The default behavior (removing the element) cannot be canceled, so the <code>preventDefault()</code> method has no effect on this default behavior.
	 * You can use the <code>Event.cancelable</code> property to check whether you can prevent the default behavior associated with a particular event. If the value of <code>Event.cancelable</code> is true, then <code>preventDefault()</code> can be used to cancel the event; otherwise, <code>preventDefault()</code> has no effect.
	 */
	public function preventDefault ():Void;
	
	
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
	public function stopImmediatePropagation ():Void;
	
	
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
	public function stopPropagation ():Void;
	
	
	/**
	 * Returns a string containing all the properties of the Event object. The
	 * string is in the following format:
	 *
	 * <p><code>[Event type=<i>value</i> bubbles=<i>value</i>
	 * cancelable=<i>value</i>]</code></p>
	 * 
	 * @return A string containing all the properties of the Event object.
	 */
	public function toString ():String;
	
	
}


#else
typedef Event = flash.events.Event;
#end