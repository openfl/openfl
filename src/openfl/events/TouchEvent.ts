import ObjectPool from "../_internal/utils/ObjectPool";
import InteractiveObject from "../display/InteractiveObject";
import Event from "../events/Event";
import EventType from "../events/EventType";
import Point from "../geom/Point";
import ByteArray from "../utils/ByteArray";

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
export default class TouchEvent extends Event
{
	// /** @hidden */ @:dox(hide) public static PROXIMITY_BEGIN:String;
	// /** @hidden */ @:dox(hide) public static PROXIMITY_END:String;
	// /** @hidden */ @:dox(hide) public static PROXIMITY_MOVE:String;
	// /** @hidden */ @:dox(hide) public static PROXIMITY_OUT:String;
	// /** @hidden */ @:dox(hide) public static PROXIMITY_OVER:String;
	// /** @hidden */ @:dox(hide) public static PROXIMITY_ROLL_OUT:String;
	// /** @hidden */ @:dox(hide) public static PROXIMITY_ROLL_OVER:String;

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
	public static readonly TOUCH_BEGIN: EventType<TouchEvent> = "touchBegin";

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
	public static readonly TOUCH_END: EventType<TouchEvent> = "touchEnd";

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
	public static readonly TOUCH_MOVE: EventType<TouchEvent> = "touchMove";

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
	public static readonly TOUCH_OUT: EventType<TouchEvent> = "touchOut";

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
	public static readonly TOUCH_OVER: EventType<TouchEvent> = "touchOver";

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
	public static readonly TOUCH_ROLL_OUT: EventType<TouchEvent> = "touchRollOut";

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
	public static readonly TOUCH_ROLL_OVER: EventType<TouchEvent> = "touchRollOver";

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
	public static readonly TOUCH_TAP: EventType<TouchEvent> = "touchTap";

	/**
		Indicates whether the Alt key is active(`true`) or inactive
		(`false`). Supported for Windows and Linux operating systems
		only.
	**/
	public altKey: boolean;

	/**
		Indicates whether the command key is activated (Mac only).

		On a Mac OS, the value of the `commandKey` property is the same value as the
		`ctrlKey` property. This property is always `false` on Windows or Linux.
	**/
	public commandKey: boolean;

	/**
		Indicates whether the Control key is activated on Mac and whether the Ctrl key is
		activated on Windows or Linux.
	**/
	public controlKey: boolean;

	/**
		On Windows or Linux, indicates whether the Ctrl key is active
		(`true`) or inactive(`false`). On Macintosh,
		indicates whether either the Control key or the Command key is activated.
	**/
	public ctrlKey: boolean;

	/** @hidden */
	public delta: number;

	/**
		Indicates whether the first point of contact is mapped to mouse events.
	**/
	public isPrimaryTouchPoint: boolean;

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
	// /** @hidden */ @:dox(hide) public isRelatedObjectInaccessible:Bool;

	/**
		The horizontal coordinate at which the event occurred relative to the
		containing sprite.
	**/
	public localX: number;

	/**
		The vertical coordinate at which the event occurred relative to the
		containing sprite.
	**/
	public localY: number;

	/**
		A value between `0.0` and `1.0` indicating force of
		the contact with the device. If the device does not support detecting the
		pressure, the value is `1.0`.
	**/
	public pressure: number;

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
	public relatedObject: InteractiveObject;

	/**
		Indicates whether the Shift key is active(`true`) or inactive
		(`false`).
	**/
	public shiftKey: boolean;

	/**
		Width of the contact area.
		Only supported on Android(C++ target), in the range of 0-1.
	**/
	public sizeX: number;

	/**
		Height of the contact area.
		Only supported on Android(C++ target), in the range of 0-1.
	**/
	public sizeY: number;

	/**
		The horizontal coordinate at which the event occurred in global Stage
		coordinates. This property is calculated when the `localX`
		property is set.
	**/
	public stageX: number;

	/**
		The vertical coordinate at which the event occurred in global Stage
		coordinates. This property is calculated when the `localY`
		property is set.
	**/
	public stageY: number;

	/**
		A unique identification number(as an int) assigned to the touch point.
	**/
	public touchPointID: number;

	protected static __pool: ObjectPool<TouchEvent> = new ObjectPool<TouchEvent>(() => new TouchEvent(null),
		(event) => event.__init());

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
	public constructor(type: string, bubbles: boolean = true, cancelable: boolean = false, touchPointID: number = 0, isPrimaryTouchPoint: boolean = false, localX: number = 0,
		localY: number = 0, sizeX: number = 0, sizeY: number = 0, pressure: number = 0, relatedObject: InteractiveObject = null, ctrlKey: boolean = false,
		altKey: boolean = false, shiftKey: boolean = false, commandKey: boolean = false, controlKey: boolean = false, timestamp: number = 0, touchIntent: string = null,
		samples: ByteArray = null, isTouchPointCanceled: boolean = false)
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

		this.stageX = NaN;
		this.stageY = NaN;
	}

	public clone(): TouchEvent
	{
		var event = new TouchEvent(this.__type, this.__bubbles, this.__cancelable, this.touchPointID, this.isPrimaryTouchPoint, this.localX, this.localY, this.sizeX, this.sizeY, this.pressure, this.relatedObject,
			this.ctrlKey, this.altKey, this.shiftKey, this.commandKey, this.controlKey);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("TouchEvent",
			"type", "bubbles", "cancelable", "touchPointID", "isPrimaryTouchPoint", "localX", "localY", "sizeX", "sizeY", "pressure", "relatedObject",
			"ctrlKey", "altKey", "shiftKey", "commandKey", "controlKey"
		);
	}

	/**
		Instructs Flash Player or Adobe AIR to render after processing of this
		event completes, if the display list has been modified.

	**/
	public updateAfterEvent(): void { }

	protected static __create(type: string, /*event:lime.ui.TouchEvent,*/ touch: Object /*js.html.Touch*/, stageX: number, stageY: number,
		local: Point, target: InteractiveObject): TouchEvent
	{
		var evt = new TouchEvent(type, true, false, 0, true, local.x, local.y, 1, 1, 1);
		evt.stageX = stageX;
		evt.stageY = stageY;
		evt.__target = target;

		return evt;
	}

	protected __init(): void
	{
		super.__init();
		this.touchPointID = 0;
		this.isPrimaryTouchPoint = false;
		this.localX = 0;
		this.localY = 0;
		this.sizeX = 0;
		this.sizeY = 0;
		this.pressure = 0;
		this.relatedObject = null;
		this.ctrlKey = false;
		this.altKey = false;
		this.shiftKey = false;
		this.commandKey = false;
		this.controlKey = false;

		this.stageX = NaN;
		this.stageY = NaN;
	}
}
