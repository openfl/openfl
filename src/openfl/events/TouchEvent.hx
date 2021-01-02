package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;
import openfl.display.InteractiveObject;
import openfl.geom.Point;
import openfl.utils.ByteArray;

/**
	The TouchEvent class lets you handle events on devices that detect user
	contact with the device(such as a finger on a touch screen). When a user
	interacts with a device such as a mobile phone or tablet with a touch
	screen, the user typically touches the screen with his or her fingers or a
	pointing device. You can develop applications that respond to basic touch
	events(such as a single finger tap) with the TouchEvent class. Create
	event listeners using the event types defined in this class. For user
	interaction with multiple points of contact(such as several fingers moving
	across a touch screen at the same time) use the related GestureEvent,
	PressAndTapGestureEvent, and TransformGestureEvent classes. And, use the
	properties and methods of these classes to construct event handlers that
	respond to the user touching the device.

	Use the Multitouch class to determine the current environment's support
	for touch interaction, and to manage the support of touch interaction if
	the current environment supports it.

	**Note:** When objects are nested on the display list, touch events
	target the deepest possible nested object that is visible in the display
	list. This object is called the target node. To have a target node's
	ancestor(an object containing the target node in the display list) receive
	notification of a touch event, use
	`EventDispatcher.addEventListener()` on the ancestor node with
	the type parameter set to the specific touch event you want to detect.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class TouchEvent extends Event
{
	// @:noCompletion @:dox(hide) public static var PROXIMITY_BEGIN:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_END:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_MOVE:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_OUT:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_OVER:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_ROLL_OUT:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_ROLL_OVER:String;

	/**
		Defines the value of the `type` property of a `TOUCH_BEGIN` touch
		event object.
		The dispatched TouchEvent object has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows or Linux). |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `eventPhase` | The current phase in the event flow. |
		| `isRelatedObjectInaccessible` | `true` if the relatedObject property is set to `null` because of security sandbox rules. |
		| `localX` | The horizontal coordinate at which the event occurred relative to the containing sprite. |
		| `localY` | The vertical coordinate at which the event occurred relative to the containing sprite. |
		| `pressure` | A value between `0.0` and `1.0` indicating force of the contact with the device. If the device does not support detecting the pressure, the value is `1.0`. |
		| `relatedObject` | A reference to a display list object related to the event. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `sizeX` | Width of the contact area. |
		| `sizeY` | Height of the contact area. |
		| `stageX` | The horizontal coordinate at which the event occurred in global stage coordinates. |
		| `stageY` | The vertical coordinate at which the event occurred in global stage coordinates. |
		| `target` | The InteractiveObject instance under the touching device. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `touchPointID` | A unique identification number (as an int) assigned to the touch point. |
	**/
	public static inline var TOUCH_BEGIN:EventType<TouchEvent> = "touchBegin";

	/**
		Defines the value of the `type` property of a `TOUCH_END` touch event
		object.
		The dispatched TouchEvent object has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows or Linux). |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `eventPhase` | The current phase in the event flow. |
		| `isRelatedObjectInaccessible` | `true` if the relatedObject property is set to `null` because of security sandbox rules. |
		| `localX` | The horizontal coordinate at which the event occurred relative to the containing sprite. |
		| `localY` | The vertical coordinate at which the event occurred relative to the containing sprite. |
		| `pressure` | A value between `0.0` and `1.0` indicating force of the contact with the device. If the device does not support detecting the pressure, the value is `1.0`. |
		| `relatedObject` | A reference to a display list object related to the event. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `sizeX` | Width of the contact area. |
		| `sizeY` | Height of the contact area. |
		| `stageX` | The horizontal coordinate at which the event occurred in global stage coordinates. |
		| `stageY` | The vertical coordinate at which the event occurred in global stage coordinates. |
		| `target` | The InteractiveObject instance under the touching device. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `touchPointID` | A unique identification number (as an int) assigned to the touch point. |
	**/
	public static inline var TOUCH_END:EventType<TouchEvent> = "touchEnd";

	/**
		Defines the value of the `type` property of a `TOUCH_MOVE` touch event
		object.
		The dispatched TouchEvent object has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows or Linux). |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `eventPhase` | The current phase in the event flow. |
		| `isRelatedObjectInaccessible` | `true` if the relatedObject property is set to `null` because of security sandbox rules. |
		| `localX` | The horizontal coordinate at which the event occurred relative to the containing sprite. |
		| `localY` | The vertical coordinate at which the event occurred relative to the containing sprite. |
		| `pressure` | A value between `0.0` and `1.0` indicating force of the contact with the device. If the device does not support detecting the pressure, the value is `1.0`. |
		| `relatedObject` | A reference to a display list object related to the event. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `sizeX` | Width of the contact area. |
		| `sizeY` | Height of the contact area. |
		| `stageX` | The horizontal coordinate at which the event occurred in global stage coordinates. |
		| `stageY` | The vertical coordinate at which the event occurred in global stage coordinates. |
		| `target` | The InteractiveObject instance under the touching device. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `touchPointID` | A unique identification number (as an int) assigned to the touch point. |
	**/
	public static inline var TOUCH_MOVE:EventType<TouchEvent> = "touchMove";

	/**
		Defines the value of the `type` property of a `TOUCH_OUT` touch event
		object.
		The dispatched TouchEvent object has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows or Linux). |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `eventPhase` | The current phase in the event flow. |
		| `isRelatedObjectInaccessible` | `true` if the relatedObject property is set to `null` because of security sandbox rules. |
		| `localX` | The horizontal coordinate at which the event occurred relative to the containing sprite. |
		| `localY` | The vertical coordinate at which the event occurred relative to the containing sprite. |
		| `pressure` | A value between `0.0` and `1.0` indicating force of the contact with the device. If the device does not support detecting the pressure, the value is `1.0`. |
		| `relatedObject` | A reference to a display list object related to the event. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `sizeX` | Width of the contact area. |
		| `sizeY` | Height of the contact area. |
		| `stageX` | The horizontal coordinate at which the event occurred in global stage coordinates. |
		| `stageY` | The vertical coordinate at which the event occurred in global stage coordinates. |
		| `target` | The InteractiveObject instance under the touching device. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `touchPointID` | A unique identification number (as an int) assigned to the touch point. |
	**/
	public static inline var TOUCH_OUT:EventType<TouchEvent> = "touchOut";

	/**
		Defines the value of the `type` property of a `TOUCH_OVER` touch event
		object.
		The dispatched TouchEvent object has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows or Linux). |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `eventPhase` | The current phase in the event flow. |
		| `isRelatedObjectInaccessible` | `true` if the relatedObject property is set to `null` because of security sandbox rules. |
		| `localX` | The horizontal coordinate at which the event occurred relative to the containing sprite. |
		| `localY` | The vertical coordinate at which the event occurred relative to the containing sprite. |
		| `pressure` | A value between `0.0` and `1.0` indicating force of the contact with the device. If the device does not support detecting the pressure, the value is `1.0`. |
		| `relatedObject` | A reference to a display list object related to the event. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `sizeX` | Width of the contact area. |
		| `sizeY` | Height of the contact area. |
		| `stageX` | The horizontal coordinate at which the event occurred in global stage coordinates. |
		| `stageY` | The vertical coordinate at which the event occurred in global stage coordinates. |
		| `target` | The InteractiveObject instance under the touching device. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `touchPointID` | A unique identification number (as an int) assigned to the touch point. |
	**/
	public static inline var TOUCH_OVER:EventType<TouchEvent> = "touchOver";

	/**
		Defines the value of the `type` property of a `TOUCH_ROLL_OUT` touch
		event object.
		The dispatched TouchEvent object has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows or Linux). |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `eventPhase` | The current phase in the event flow. |
		| `isRelatedObjectInaccessible` | `true` if the relatedObject property is set to `null` because of security sandbox rules. |
		| `localX` | The horizontal coordinate at which the event occurred relative to the containing sprite. |
		| `localY` | The vertical coordinate at which the event occurred relative to the containing sprite. |
		| `pressure` | A value between `0.0` and `1.0` indicating force of the contact with the device. If the device does not support detecting the pressure, the value is `1.0`. |
		| `relatedObject` | A reference to a display list object related to the event. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `sizeX` | Width of the contact area. |
		| `sizeY` | Height of the contact area. |
		| `stageX` | The horizontal coordinate at which the event occurred in global stage coordinates. |
		| `stageY` | The vertical coordinate at which the event occurred in global stage coordinates. |
		| `target` | The InteractiveObject instance under the touching device. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `touchPointID` | A unique identification number (as an int) assigned to the touch point. |
	**/
	public static inline var TOUCH_ROLL_OUT:EventType<TouchEvent> = "touchRollOut";

	/**
		Defines the value of the `type` property of a `TOUCH_ROLL_OVER` touch
		event object.
		The dispatched TouchEvent object has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows or Linux). |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `eventPhase` | The current phase in the event flow. |
		| `isRelatedObjectInaccessible` | `true` if the relatedObject property is set to `null` because of security sandbox rules. |
		| `localX` | The horizontal coordinate at which the event occurred relative to the containing sprite. |
		| `localY` | The vertical coordinate at which the event occurred relative to the containing sprite. |
		| `pressure` | A value between `0.0` and `1.0` indicating force of the contact with the device. If the device does not support detecting the pressure, the value is `1.0`. |
		| `relatedObject` | A reference to a display list object related to the event. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `sizeX` | Width of the contact area. |
		| `sizeY` | Height of the contact area. |
		| `stageX` | The horizontal coordinate at which the event occurred in global stage coordinates. |
		| `stageY` | The vertical coordinate at which the event occurred in global stage coordinates. |
		| `target` | The InteractiveObject instance under the touching device. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `touchPointID` | A unique identification number (as an int) assigned to the touch point. |
	**/
	public static inline var TOUCH_ROLL_OVER:EventType<TouchEvent> = "touchRollOver";

	/**
		Defines the value of the `type` property of a `TOUCH_TAP` touch event
		object.
		The dispatched TouchEvent object has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows or Linux). |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `eventPhase` | The current phase in the event flow. |
		| `isRelatedObjectInaccessible` | `true` if the relatedObject property is set to `null` because of security sandbox rules. |
		| `localX` | The horizontal coordinate at which the event occurred relative to the containing sprite. |
		| `localY` | The vertical coordinate at which the event occurred relative to the containing sprite. |
		| `pressure` | A value between `0.0` and `1.0` indicating force of the contact with the device. If the device does not support detecting the pressure, the value is `1.0`. |
		| `relatedObject` | A reference to a display list object related to the event. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `sizeX` | Width of the contact area. |
		| `sizeY` | Height of the contact area. |
		| `stageX` | The horizontal coordinate at which the event occurred in global stage coordinates. |
		| `stageY` | The vertical coordinate at which the event occurred in global stage coordinates. |
		| `target` | The InteractiveObject instance under the touching device. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `touchPointID` | A unique identification number (as an int) assigned to the touch point. |
	**/
	public static inline var TOUCH_TAP:EventType<TouchEvent> = "touchTap";

	/**
		Indicates whether the Alt key is active(`true`) or inactive
		(`false`). Supported for Windows and Linux operating systems
		only.
	**/
	public var altKey:Bool;

	/**
		Indicates whether the command key is activated (Mac only).

		On a Mac OS, the value of the `commandKey` property is the same value as the
		`ctrlKey` property. This property is always `false` on Windows or Linux.
	**/
	public var commandKey:Bool;

	/**
		Indicates whether the Control key is activated on Mac and whether the Ctrl key is
		activated on Windows or Linux.
	**/
	public var controlKey:Bool;

	/**
		On Windows or Linux, indicates whether the Ctrl key is active
		(`true`) or inactive(`false`). On Macintosh,
		indicates whether either the Control key or the Command key is activated.
	**/
	public var ctrlKey:Bool;

	@SuppressWarnings("checkstyle:FieldDocComment") @:noCompletion @:dox(hide) public var delta:Int;

	/**
		Indicates whether the first point of contact is mapped to mouse events.
	**/
	public var isPrimaryTouchPoint:Bool;

	#if false
	/**
		If `true`, the `relatedObject` property is set to `null` for reasons
		related to security sandboxes. If the nominal value of `relatedObject`
		is a reference to a DisplayObject in another sandbox, `relatedObject`
		is set to `null` unless there is permission in both directions across
		this sandbox boundary. Permission is established by calling
		`Security.allowDomain()` from a SWF file, or by providing a policy
		file from the server of an image file, and setting the
		`LoaderContext.checkPolicyFile` property when loading the image.
	**/
	// @:noCompletion @:dox(hide) public var isRelatedObjectInaccessible:Bool;
	#end

	/**
		The horizontal coordinate at which the event occurred relative to the
		containing sprite.
	**/
	public var localX:Float;

	/**
		The vertical coordinate at which the event occurred relative to the
		containing sprite.
	**/
	public var localY:Float;

	/**
		A value between `0.0` and `1.0` indicating force of
		the contact with the device. If the device does not support detecting the
		pressure, the value is `1.0`.
	**/
	public var pressure:Float;

	/**
		A reference to a display list object that is related to the event. For
		example, when a `touchOut` event occurs,
		`relatedObject` represents the display list object to which the
		pointing device now points. This property applies to the
		`touchOut`, `touchOver`, `touchRollOut`,
		and `touchRollOver` events.

		The value of this property can be `null` in two
		circumstances: if there is no related object, or there is a related
		object, but it is in a security sandbox to which you don't have access.
		Use the `isRelatedObjectInaccessible()` property to determine
		which of these reasons applies.
	**/
	public var relatedObject:InteractiveObject;

	/**
		Indicates whether the Shift key is active(`true`) or inactive
		(`false`).
	**/
	public var shiftKey:Bool;

	/**
		Width of the contact area.
		Only supported on Android(C++ target), in the range of 0-1.
	**/
	public var sizeX:Float;

	/**
		Height of the contact area.
		Only supported on Android(C++ target), in the range of 0-1.
	**/
	public var sizeY:Float;

	/**
		The horizontal coordinate at which the event occurred in global Stage
		coordinates. This property is calculated when the `localX`
		property is set.
	**/
	public var stageX:Float;

	/**
		The vertical coordinate at which the event occurred in global Stage
		coordinates. This property is calculated when the `localY`
		property is set.
	**/
	public var stageY:Float;

	/**
		A unique identification number(as an int) assigned to the touch point.
	**/
	public var touchPointID:Int;

	// @:noCompletion private static var __pool:ObjectPool<TouchEvent> = new ObjectPool<TouchEvent>(function() return new TouchEvent(null),
	// function(event) event.__init());

	/**
		Creates an Event object that contains information about touch events.
		Event objects are passed as parameters to event listeners.

		@param type                The type of the event. Possible values are:
								   `TouchEvent.TOUCH_BEGIN`,
								   `TouchEvent.TOUCH_END`,
								   `TouchEvent.TOUCH_MOVE`,
								   `TouchEvent.TOUCH_OUT`,
								   `TouchEvent.TOUCH_OVER`,
								   `TouchEvent.TOUCH_ROLL_OUT`,
								   `TouchEvent.TOUCH_ROLL_OVER`, and
								   `TouchEvent.TOUCH_TAP`.
		@param bubbles             Determines whether the Event object
								   participates in the bubbling phase of the event
								   flow.
		@param cancelable          Determines whether the Event object can be
								   canceled.
		@param touchPointID        A unique identification number(as an int)
								   assigned to the touch point.
		@param isPrimaryTouchPoint Indicates whether the first point of contact is
								   mapped to mouse events.
		@param relatedObject       The complementary InteractiveObject instance
								   that is affected by the event. For example,
								   when a `touchOut` event occurs,
								   `relatedObject` represents the
								   display list object to which the pointing
								   device now points.
		@param ctrlKey             On Windows or Linux, indicates whether the Ctrl
								   key is activated. On Mac, indicates whether
								   either the Ctrl key or the Command key is
								   activated.
		@param altKey              Indicates whether the Alt key is activated
								  (Windows or Linux only).
		@param shiftKey            Indicates whether the Shift key is activated.
	**/
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, touchPointID:Int = 0, isPrimaryTouchPoint:Bool = false, localX:Float = 0,
			localY:Float = 0, sizeX:Float = 0, sizeY:Float = 0, pressure:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false,
			altKey:Bool = false, shiftKey:Bool = false, commandKey:Bool = false, controlKey:Bool = false, timestamp:Float = 0, touchIntent:String = null,
			samples:ByteArray = null, isTouchPointCanceled:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.touchPointID = touchPointID;
		this.isPrimaryTouchPoint = isPrimaryTouchPoint;
		this.localX = localX;
		this.localY = localY;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.pressure = pressure;
		this.relatedObject = relatedObject;
		this.ctrlKey = ctrlKey;
		this.altKey = altKey;
		this.shiftKey = shiftKey;
		this.commandKey = commandKey;
		this.controlKey = controlKey;

		stageX = Math.NaN;
		stageY = Math.NaN;
	}

	public override function clone():TouchEvent
	{
		var event = new TouchEvent(type, bubbles, cancelable, touchPointID, isPrimaryTouchPoint, localX, localY, sizeX, sizeY, pressure, relatedObject,
			ctrlKey, altKey, shiftKey, commandKey, controlKey);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("TouchEvent", [
			"type", "bubbles", "cancelable", "touchPointID", "isPrimaryTouchPoint", "localX", "localY", "sizeX", "sizeY", "pressure", "relatedObject",
			"ctrlKey", "altKey", "shiftKey", "commandKey", "controlKey"
		]);
	}

	/**
		Instructs Flash Player or Adobe AIR to render after processing of this
		event completes, if the display list has been modified.

	**/
	public function updateAfterEvent():Void {}

	@:noCompletion private static function __create(type:String, /*event:lime.ui.TouchEvent,*/ touch:Dynamic /*js.html.Touch*/, stageX:Float, stageY:Float,
			local:Point, target:InteractiveObject):TouchEvent
	{
		var evt = new TouchEvent(type, true, false, 0, true, local.x, local.y, 1, 1, 1);
		evt.stageX = stageX;
		evt.stageY = stageY;
		evt.target = target;

		return evt;
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		touchPointID = 0;
		isPrimaryTouchPoint = false;
		localX = 0;
		localY = 0;
		sizeX = 0;
		sizeY = 0;
		pressure = 0;
		relatedObject = null;
		ctrlKey = false;
		altKey = false;
		shiftKey = false;
		commandKey = false;
		controlKey = false;

		stageX = Math.NaN;
		stageY = Math.NaN;
	}
}
#else
typedef TouchEvent = flash.events.TouchEvent;
#end
