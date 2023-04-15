package openfl.events;

#if !flash
import openfl.utils.Object;
#if openfl_pool_events
import openfl.utils.ObjectPool;
#end

/**
	The Event class is used as the base class for the creation of Event
	objects, which are passed as parameters to event listeners when an event
	occurs.

	The properties of the Event class carry basic information about an
	event, such as the event's type or whether the event's default behavior can
	be canceled. For many events, such as the events represented by the Event
	class constants, this basic information is sufficient. Other events,
	however, may require more detailed information. Events associated with a
	mouse click, for example, need to include additional information about the
	location of the click event and whether any keys were pressed during the
	click event. You can pass such additional information to event listeners by
	extending the Event class, which is what the MouseEvent class does.
	ActionScript 3.0 API defines several Event subclasses for common events
	that require additional information. Events associated with each of the
	Event subclasses are described in the documentation for each class.

	The methods of the Event class can be used in event listener functions
	to affect the behavior of the event object. Some events have an associated
	default behavior. For example, the `doubleClick` event has an
	associated default behavior that highlights the word under the mouse
	pointer at the time of the event. Your event listener can cancel this
	behavior by calling the `preventDefault()` method. You can also
	make the current event listener the last one to process an event by calling
	the `stopPropagation()` or
	`stopImmediatePropagation()` method.

	Other sources of information include:

	* A useful description about the timing of events, code execution, and
	rendering at runtime in Ted Patrick's blog entry: <a
	[Flash Player Mental Model - The Elastic Racetrack](http://tedpatrick.com/2005/07/19/flash-player-mental-model-the-elastic-racetrack/).
	* A blog entry by Johannes Tacskovics about the timing of frame events,
	such as ENTER_FRAME, EXIT_FRAME: [The MovieClip Lifecycle](http://web.archive.org/web/20110623195412/http://blog.johannest.com:80/2009/06/15/the-movieclip-life-cycle-revisited-from-event-added-to-event-removed_from_stage/).
	* An article by Trevor McCauley about the order of ActionScript
	operations: [Order of Operations in ActionScript](http://web.archive.org/web/20171009141202/http://www.senocular.com:80/flash/tutorials/orderofoperations/).
	* A blog entry by Matt Przybylski on creating custom events:
	[AS3: Custom Events](http://evolve.reintroducing.com/2007/10/23/as3/as3-custom-events/).
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Event
{
	/**
		The `ACTIVATE` constant defines the value of the `type` property of an
		`activate` event object.
		**Note:** This event has neither a "capture phase" nor a "bubble
		phase", which means that event listeners must be added directly to any
		potential targets, whether the target is on the display list or not.

		AIR for TV devices never automatically dispatch this event. You can,
		however, dispatch it manually.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any DisplayObject instance with a listener registered for the `activate` event. |
	**/
	public static inline var ACTIVATE:EventType<Event> = "activate";

	/**
		The `Event.ADDED` constant defines the value of the `type` property of
		an `added` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The DisplayObject instance being added to the display list. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var ADDED:EventType<Event> = "added";

	/**
		The `Event.ADDED_TO_STAGE` constant defines the value of the `type`
		property of an `addedToStage` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The DisplayObject instance being added to the on stage display list, either directly or through the addition of a sub tree in which the DisplayObject instance is contained. If the DisplayObject instance is being directly added, the `added` event occurs before this event. |
	**/
	public static inline var ADDED_TO_STAGE:EventType<Event> = "addedToStage";

	// @:noCompletion @:dox(hide) @:require(flash15) public static var BROWSER_ZOOM_CHANGE:String;

	/**
		The `Event.CANCEL` constant defines the value of the `type` property
		of a `cancel` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | A reference to the object on which the operation is canceled. |
	**/
	public static inline var CANCEL:EventType<Event> = "cancel";

	/**
		The `Event.CHANGE` constant defines the value of the `type` property
		of a `change` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object that has had its value modified. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var CHANGE:EventType<Event> = "change";

	// @:noCompletion @:dox(hide) public static var CHANNEL_MESSAGE:String;
	// @:noCompletion @:dox(hide) public static var CHANNEL_STATE:String;

	/**
		The `Event.CLEAR` constant defines the value of the `type` property of
		a `clear` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any InteractiveObject instance with a listener registered for the `clear` event. |

		**Note:** TextField objects do _not_ dispatch `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. TextField objects always include Cut,
		Copy, Paste, Clear, and Select All commands in the context menu. You
		cannot remove these commands from the context menu for TextField
		objects. For TextField objects, selecting these commands (or their
		keyboard equivalents) does not generate `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. However, other classes that extend the
		InteractiveObject class, including components built using the Flash
		Text Engine (FTE), will dispatch these events in response to user
		actions such as keyboard shortcuts and context menus.
	**/
	public static inline var CLEAR:EventType<Event> = "clear";

	/**
		The `Event.CLOSE` constant defines the value of the `type` property of
		a `close` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object whose connection has been closed. |
	**/
	public static inline var CLOSE:EventType<Event> = "close";

	/**
		The `Event.COMPLETE` constant defines the value of the `type` property
		of a `complete` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The network object that has completed loading. |
	**/
	public static inline var COMPLETE:EventType<Event> = "complete";

	/**
		The `Event.CONNECT` constant defines the value of the `type` property
		of a `connect` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Socket or XMLSocket object that has established a network connection. |
	**/
	public static inline var CONNECT:EventType<Event> = "connect";

	/**
		The `Event.CONTEXT3D_CREATE` constant defines the value of the type property of a
		`context3Dcreate` event object. This event is raised only by Stage3D objects in
		response to either a call to `Stage3D.requestContext3D` or in response to an OS
		triggered reset of the Context3D bound to the Stage3D object. Inspect the
		`Stage3D.context3D` property to get the newly created Context3D object.
	**/
	public static inline var CONTEXT3D_CREATE:EventType<Event> = "context3DCreate";

	/**
		Defines the value of the `type` property of a `copy` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any InteractiveObject instance with a listener registered for the `copy` event. |

		**Note:** TextField objects do _not_ dispatch `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. TextField objects always include Cut,
		Copy, Paste, Clear, and Select All commands in the context menu. You
		cannot remove these commands from the context menu for TextField
		objects. For TextField objects, selecting these commands (or their
		keyboard equivalents) does not generate `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. However, other classes that extend the
		InteractiveObject class, including components built using the Flash
		Text Engine (FTE), will dispatch these events in response to user
		actions such as keyboard shortcuts and context menus.
	**/
	public static inline var COPY:EventType<Event> = "copy";

	/**
		Defines the value of the `type` property of a `cut` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any InteractiveObject instance with a listener registered for the `cut` event. |

		**Note:** TextField objects do _not_ dispatch `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. TextField objects always include Cut,
		Copy, Paste, Clear, and Select All commands in the context menu. You
		cannot remove these commands from the context menu for TextField
		objects. For TextField objects, selecting these commands (or their
		keyboard equivalents) does not generate `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. However, other classes that extend the
		InteractiveObject class, including components built using the Flash
		Text Engine (FTE), will dispatch these events in response to user
		actions such as keyboard shortcuts and context menus.
	**/
	public static inline var CUT:EventType<Event> = "cut";

	/**
		The `Event.DEACTIVATE` constant defines the value of the `type`
		property of a `deactivate` event object.
		**Note:** This event has neither a "capture phase" nor a "bubble
		phase", which means that event listeners must be added directly to any
		potential targets, whether the target is on the display list or not.

		AIR for TV devices never automatically dispatch this event. You can,
		however, dispatch it manually.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any DisplayObject instance with a listener registered for the `deactivate` event. |
	**/
	public static inline var DEACTIVATE:EventType<Event> = "deactivate";

	/**
		The `Event.ENTER_FRAME` constant defines the value of the `type`
		property of an `enterFrame` event object.
		**Note:** This event has neither a "capture phase" nor a "bubble
		phase", which means that event listeners must be added directly to any
		potential targets, whether the target is on the display list or not.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any DisplayObject instance with a listener registered for the `enterFrame` event. |
	**/
	public static inline var ENTER_FRAME:EventType<Event> = "enterFrame";

	/**
		The `Event.EXIT_FRAME` constant defines the value of the `type`
		property of an `exitFrame` event object.
		**Note:** This event has neither a "capture phase" nor a "bubble
		phase", which means that event listeners must be added directly to any
		potential targets, whether the target is on the display list or not.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any DisplayObject instance with a listener registered for the `enterFrame` event. |
	**/
	public static inline var EXIT_FRAME:EventType<Event> = "exitFrame";

	/**
		The `Event.FRAME_CONSTRUCTED` constant defines the value of the `type`
		property of an `frameConstructed` event object.
		**Note:** This event has neither a "capture phase" nor a "bubble
		phase", which means that event listeners must be added directly to any
		potential targets, whether the target is on the display list or not.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any DisplayObject instance with a listener registered for the `frameConstructed` event. |
	**/
	public static inline var FRAME_CONSTRUCTED:EventType<Event> = "frameConstructed";

	/**
		The `Event.FRAME_LABEL` constant defines the value of the type property of a
		`frameLabel` event object.

		**Note:** This event has neither a "capture phase" nor a "bubble phase", which
		means that event listeners must be added directly to FrameLabel objects.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The FrameLabel object that is actively processing the Event object with an event listener. |
		| `target` | Any FrameLabel instance with a listener registered for the frameLabel event. |
	**/
	public static inline var FRAME_LABEL:EventType<Event> = "frameLabel";

	/**
		The `Event.FULL_SCREEN` constant defines the value of the `type`
		property of a `fullScreen` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Stage object. |
	**/
	public static inline var FULLSCREEN:EventType<Event> = "fullScreen";

	/**
		The `Event.ID3` constant defines the value of the `type` property of
		an `id3` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Sound object loading the MP3 for which ID3 data is now available. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var ID3:EventType<Event> = "id3";

	/**
		The `Event.INIT` constant defines the value of the `type` property of
		an `init` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The LoaderInfo object associated with the SWF file being loaded. |
	**/
	public static inline var INIT:EventType<Event> = "init";

	/**
		The `Event.MOUSE_LEAVE` constant defines the value of the `type`
		property of a `mouseLeave` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Stage object. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var MOUSE_LEAVE:EventType<Event> = "mouseLeave";

	/**
		The `Event.OPEN` constant defines the value of the `type` property of
		an `open` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The network object that has opened a connection. |
	**/
	public static inline var OPEN:EventType<Event> = "open";

	/**
		The `Event.PASTE` constant defines the value of the `type` property of
		a `paste` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any InteractiveObject instance with a listener registered for the `paste` event. |

		**Note:** TextField objects do _not_ dispatch `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. TextField objects always include Cut,
		Copy, Paste, Clear, and Select All commands in the context menu. You
		cannot remove these commands from the context menu for TextField
		objects. For TextField objects, selecting these commands (or their
		keyboard equivalents) does not generate `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. However, other classes that extend the
		InteractiveObject class, including components built using the Flash
		Text Engine (FTE), will dispatch these events in response to user
		actions such as keyboard shortcuts and context menus.
	**/
	public static inline var PASTE:EventType<Event> = "paste";

	/**
		The `Event.REMOVED` constant defines the value of the `type` property
		of a `removed` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The DisplayObject instance to be removed from the display list. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var REMOVED:EventType<Event> = "removed";

	/**
		The `Event.REMOVED_FROM_STAGE` constant defines the value of the
		`type` property of a `removedFromStage` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The DisplayObject instance being removed from the on stage display list, either directly or through the removal of a sub tree in which the DisplayObject instance is contained. If the DisplayObject instance is being directly removed, the `removed` event occurs before this event. |
	**/
	public static inline var REMOVED_FROM_STAGE:EventType<Event> = "removedFromStage";

	/**
		The `Event.RENDER` constant defines the value of the `type` property
		of a `render` event object.
		**Note:** This event has neither a "capture phase" nor a "bubble
		phase", which means that event listeners must be added directly to any
		potential targets, whether the target is on the display list or not.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; the default behavior cannot be canceled. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any DisplayObject instance with a listener registered for the `render` event. |
	**/
	public static inline var RENDER:EventType<Event> = "render";

	/**
		The `Event.RESIZE` constant defines the value of the `type` property
		of a `resize` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Stage object. |
	**/
	public static inline var RESIZE:EventType<Event> = "resize";

	/**
		The `Event.SCROLL` constant defines the value of the `type` property
		of a `scroll` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The TextField object that has been scrolled. The `target` property is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var SCROLL:EventType<Event> = "scroll";

	/**
		The `Event.SELECT` constant defines the value of the `type` property
		of a `select` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object on which an item has been selected. |
	**/
	public static inline var SELECT:EventType<Event> = "select";

	/**
		The `Event.SELECT_ALL` constant defines the value of the `type`
		property of a `selectAll` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | Any InteractiveObject instance with a listener registered for the `selectAll` event. |

		**Note:** TextField objects do _not_ dispatch `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. TextField objects always include Cut,
		Copy, Paste, Clear, and Select All commands in the context menu. You
		cannot remove these commands from the context menu for TextField
		objects. For TextField objects, selecting these commands (or their
		keyboard equivalents) does not generate `clear`, `copy`, `cut`,
		`paste`, or `selectAll` events. However, other classes that extend the
		InteractiveObject class, including components built using the Flash
		Text Engine (FTE), will dispatch these events in response to user
		actions such as keyboard shortcuts and context menus.
	**/
	public static inline var SELECT_ALL:EventType<Event> = "selectAll";

	/**
		The `Event.SOUND_COMPLETE` constant defines the value of the `type`
		property of a `soundComplete` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The SoundChannel object in which a sound has finished playing. |
	**/
	public static inline var SOUND_COMPLETE:EventType<Event> = "soundComplete";

	/**
		The `Event.TAB_CHILDREN_CHANGE` constant defines the value of the
		`type` property of a `tabChildrenChange` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object whose tabChildren flag has changed. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var TAB_CHILDREN_CHANGE:EventType<Event> = "tabChildrenChange";

	/**
		The `Event.TAB_ENABLED_CHANGE` constant defines the value of the
		`type` property of a `tabEnabledChange` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The InteractiveObject whose tabEnabled flag has changed. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var TAB_ENABLED_CHANGE:EventType<Event> = "tabEnabledChange";

	/**
		The `Event.TAB_INDEX_CHANGE` constant defines the value of the `type`
		property of a `tabIndexChange` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The object whose tabIndex has changed. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static inline var TAB_INDEX_CHANGE:EventType<Event> = "tabIndexChange";

	/**
		The `Event.TEXTURE_READY` constant defines the value of the type property of a
		`textureReady` event object. This event is dispatched by Texture and CubeTexture
		objects to signal the completion of an asynchronous upload. Request an asynchronous
		upload by using the `uploadCompressedTextureFromByteArray()` method on Texture or
		CubeTexture. This event neither bubbles nor is cancelable.
	**/
	public static inline var TEXTURE_READY:EventType<Event> = "textureReady";

	#if false
	/**
		The `Event.TEXT_INTERACTION_MODE_CHANGE` constant defines the value of
		the `type` property of a `interaction mode` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The TextField object whose interaction mode property is changed. For example on Android, one can change the interaction mode to SELECTION via context menu. The `target` property is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	// @:noCompletion @:dox(hide) @:require(flash11) public static var TEXT_INTERACTION_MODE_CHANGE:String;
	#end

	/**
		The `Event.UNLOAD` constant defines the value of the `type` property
		of an `unload` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The LoaderInfo object associated with the SWF file being unloaded or replaced. |
	**/
	public static inline var UNLOAD:EventType<Event> = "unload";

	// @:noCompletion @:dox(hide) public static var VIDEO_FRAME:String;
	// @:noCompletion @:dox(hide) public static var WORKER_STATE:String;

	/**
		Indicates whether an event is a bubbling event. If the event can bubble,
		this value is `true`; otherwise it is `false`.

		When an event occurs, it moves through the three phases of the event
		flow: the capture phase, which flows from the top of the display list
		hierarchy to the node just before the target node; the target phase, which
		comprises the target node; and the bubbling phase, which flows from the
		node subsequent to the target node back up the display list hierarchy.

		Some events, such as the `activate` and `unload`
		events, do not have a bubbling phase. The `bubbles` property
		has a value of `false` for events that do not have a bubbling
		phase.
	**/
	public var bubbles(default, null):Bool;

	/**
		Indicates whether the behavior associated with the event can be prevented.
		If the behavior can be canceled, this value is `true`;
		otherwise it is `false`.
	**/
	public var cancelable(default, null):Bool;

	/**
		The object that is actively processing the Event object with an event
		listener. For example, if a user clicks an OK button, the current target
		could be the node containing that button or one of its ancestors that has
		registered an event listener for that event.
	**/
	public var currentTarget(default, null):Object;

	/**
		The current phase in the event flow. This property can contain the
		following numeric values:

		* The capture phase(`EventPhase.CAPTURING_PHASE`).
		* The target phase(`EventPhase.AT_TARGET`).
		* The bubbling phase(`EventPhase.BUBBLING_PHASE`).
	**/
	public var eventPhase(default, null):EventPhase;

	/**
		The event target. This property contains the target node. For example, if
		a user clicks an OK button, the target node is the display list node
		containing that button.
	**/
	public var target(default, null):Object;

	/**
		The type of event. The type is case-sensitive.
	**/
	public var type(default, null):String;

	#if openfl_pool_events
	@:noCompletion private static var __pool:ObjectPool<Event> = new ObjectPool<Event>(function() return new Event(null), function(event) event.__init());
	#end

	@:noCompletion private var __isCanceled:Bool;
	@:noCompletion private var __isCanceledNow:Bool;
	@:noCompletion private var __preventDefault:Bool;

	/**
		Creates an Event object to pass as a parameter to event listeners.

		@param type       The type of the event, accessible as
						  `Event.type`.
		@param bubbles    Determines whether the Event object participates in the
						  bubbling stage of the event flow. The default value is
						  `false`.
		@param cancelable Determines whether the Event object can be canceled. The
						  default values is `false`.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		this.type = type;
		this.bubbles = bubbles;
		this.cancelable = cancelable;
		eventPhase = EventPhase.AT_TARGET;
	}

	/**
		Duplicates an instance of an Event subclass.

		Returns a new Event object that is a copy of the original instance of
		the Event object. You do not normally call `clone()`; the
		EventDispatcher class calls it automatically when you redispatch an
		event - that is, when you call `dispatchEvent(event)` from a
		handler that is handling `event`.

		The new Event object includes all the properties of the original.

		When creating your own custom Event class, you must override the
		inherited `Event.clone()` method in order for it to duplicate
		the properties of your custom class. If you do not set all the properties
		that you add in your event subclass, those properties will not have the
		correct values when listeners handle the redispatched event.

		In this example, `PingEvent` is a subclass of
		`Event` and therefore implements its own version of
		`clone()`.

		@return A new Event object that is identical to the original.
	**/
	public function clone():Event
	{
		var event = new Event(type, bubbles, cancelable);
		event.eventPhase = eventPhase;
		event.target = target;
		event.currentTarget = currentTarget;
		return event;
	}

	/**
		A utility function for implementing the `toString()` method in custom
		ActionScript 3.0 Event classes. Overriding the `toString()` method is
		recommended, but not required.

		```haxe
		class PingEvent extends Event {
			var URL:String;

			public function new() {
				super();
			}

			public override function toString():String {
				return formatToString("PingEvent", "type", "bubbles", "cancelable", "eventPhase", "URL");
			}
		}
		```

		@param className The name of your custom Event class. In the previous
						 example, the `className` parameter is `PingEvent`.
		@return The name of your custom Event class and the String value of
				your `...arguments` parameter.
	**/
	public function formatToString(className:String, p1:String = null, p2:String = null, p3:String = null, p4:String = null, p5:String = null):String
	{
		var parameters = [];
		if (p1 != null) parameters.push(p1);
		if (p2 != null) parameters.push(p2);
		if (p3 != null) parameters.push(p3);
		if (p4 != null) parameters.push(p4);
		if (p5 != null) parameters.push(p5);

		return Reflect.callMethod(this, __formatToString, [className, parameters]);
	}

	/**
		Checks whether the `preventDefault()` method has been called on
		the event. If the `preventDefault()` method has been called,
		returns `true`; otherwise, returns `false`.

		@return If `preventDefault()` has been called, returns
				`true`; otherwise, returns `false`.
	**/
	public function isDefaultPrevented():Bool
	{
		return __preventDefault;
	}

	/**
		Cancels an event's default behavior if that behavior can be canceled.
		Many events have associated behaviors that are carried out by default. For example, if a user types a character into a text field, the default behavior is that the character is displayed in the text field. Because the `TextEvent.TEXT_INPUT` event's default behavior can be canceled, you can use the `preventDefault()` method to prevent the character from appearing.
		An example of a behavior that is not cancelable is the default behavior associated with the Event.REMOVED event, which is generated whenever Flash Player is about to remove a display object from the display list. The default behavior (removing the element) cannot be canceled, so the `preventDefault()` method has no effect on this default behavior.
		You can use the `Event.cancelable` property to check whether you can prevent the default behavior associated with a particular event. If the value of `Event.cancelable` is true, then `preventDefault()` can be used to cancel the event; otherwise, `preventDefault()` has no effect.
	**/
	public function preventDefault():Void
	{
		if (cancelable)
		{
			__preventDefault = true;
		}
	}

	/**
		Prevents processing of any event listeners in the current node and any
		subsequent nodes in the event flow. This method takes effect immediately,
		and it affects event listeners in the current node. In contrast, the
		`stopPropagation()` method doesn't take effect until all the
		event listeners in the current node finish processing.

		**Note: ** This method does not cancel the behavior associated with
		this event; see `preventDefault()` for that functionality.

	**/
	public function stopImmediatePropagation():Void
	{
		__isCanceled = true;
		__isCanceledNow = true;
	}

	/**
		Prevents processing of any event listeners in nodes subsequent to the
		current node in the event flow. This method does not affect any event
		listeners in the current node(`currentTarget`). In contrast,
		the `stopImmediatePropagation()` method prevents processing of
		event listeners in both the current node and subsequent nodes. Additional
		calls to this method have no effect. This method can be called in any
		phase of the event flow.

		**Note: ** This method does not cancel the behavior associated with
		this event; see `preventDefault()` for that functionality.

	**/
	public function stopPropagation():Void
	{
		__isCanceled = true;
	}

	/**
		Returns a string containing all the properties of the Event object. The
		string is in the following format:

		`[Event type=_value_ bubbles=_value_
		cancelable=_value_]`

		@return A string containing all the properties of the Event object.
	**/
	public function toString():String
	{
		return __formatToString("Event", ["type", "bubbles", "cancelable"]);
	}

	@:noCompletion private function __formatToString(className:String, parameters:Array<String>):String
	{
		// TODO: Make this a macro function, and handle at compile-time, with rest parameters?

		var output = '[$className';
		var arg:Dynamic = null;

		for (param in parameters)
		{
			arg = Reflect.field(this, param);

			if ((arg is String))
			{
				output += ' $param="$arg"';
			}
			else
			{
				output += ' $param=$arg';
			}
		}

		output += "]";
		return output;
	}

	@:noCompletion private function __init():Void
	{
		// type = null;
		target = null;
		currentTarget = null;
		bubbles = false;
		cancelable = false;
		eventPhase = AT_TARGET;
		__isCanceled = false;
		__isCanceledNow = false;
		__preventDefault = false;
	}
}
#else
typedef Event = flash.events.Event;
#end
