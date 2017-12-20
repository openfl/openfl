package openfl.events; #if (display || !flash)


import openfl.display.InteractiveObject;
import openfl.utils.ByteArray;

@:jsRequire("openfl/events/TouchEvent", "default")

/**
 * The TouchEvent class lets you handle events on devices that detect user
 * contact with the device(such as a finger on a touch screen). When a user
 * interacts with a device such as a mobile phone or tablet with a touch
 * screen, the user typically touches the screen with his or her fingers or a
 * pointing device. You can develop applications that respond to basic touch
 * events(such as a single finger tap) with the TouchEvent class. Create
 * event listeners using the event types defined in this class. For user
 * interaction with multiple points of contact(such as several fingers moving
 * across a touch screen at the same time) use the related GestureEvent,
 * PressAndTapGestureEvent, and TransformGestureEvent classes. And, use the
 * properties and methods of these classes to construct event handlers that
 * respond to the user touching the device.
 *
 * Use the Multitouch class to determine the current environment's support
 * for touch interaction, and to manage the support of touch interaction if
 * the current environment supports it.
 *
 * **Note:** When objects are nested on the display list, touch events
 * target the deepest possible nested object that is visible in the display
 * list. This object is called the target node. To have a target node's
 * ancestor(an object containing the target node in the display list) receive
 * notification of a touch event, use
 * `EventDispatcher.addEventListener()` on the ancestor node with
 * the type parameter set to the specific touch event you want to detect.
 * 
 */
extern class TouchEvent extends Event {
	
	
	#if flash
	@:noCompletion @:dox(hide) public static var PROXIMITY_BEGIN:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var PROXIMITY_END:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var PROXIMITY_MOVE:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var PROXIMITY_OUT:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var PROXIMITY_OVER:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var PROXIMITY_ROLL_OUT:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var PROXIMITY_ROLL_OVER:String;
	#end
	
	
	/**
	 * Defines the value of the `type` property of a
	 * `TOUCH_BEGIN` touch event object.
	 *
	 * The dispatched TouchEvent object has the following properties:
	 */
	public static inline var TOUCH_BEGIN = "touchBegin";
	
	/**
	 * Defines the value of the `type` property of a
	 * `TOUCH_END` touch event object.
	 *
	 * The dispatched TouchEvent object has the following properties:
	 */
	public static inline var TOUCH_END = "touchEnd";
	
	/**
	 * Defines the value of the `type` property of a
	 * `TOUCH_MOVE` touch event object.
	 *
	 * The dispatched TouchEvent object has the following properties:
	 */
	public static inline var TOUCH_MOVE = "touchMove";
	
	/**
	 * Defines the value of the `type` property of a
	 * `TOUCH_OUT` touch event object.
	 *
	 * The dispatched TouchEvent object has the following properties:
	 */
	public static inline var TOUCH_OUT = "touchOut";
	
	/**
	 * Defines the value of the `type` property of a
	 * `TOUCH_OVER` touch event object.
	 *
	 * The dispatched TouchEvent object has the following properties:
	 */
	public static inline var TOUCH_OVER = "touchOver";
	
	/**
	 * Defines the value of the `type` property of a
	 * `TOUCH_ROLL_OUT` touch event object.
	 *
	 * The dispatched TouchEvent object has the following properties:
	 */
	public static inline var TOUCH_ROLL_OUT = "touchRollOut";
	
	/**
	 * Defines the value of the `type` property of a
	 * `TOUCH_ROLL_OVER` touch event object.
	 *
	 * The dispatched TouchEvent object has the following properties:
	 */
	public static inline var TOUCH_ROLL_OVER = "touchRollOver";
	
	/**
	 * Defines the value of the `type` property of a
	 * `TOUCH_TAP` touch event object.
	 *
	 * The dispatched TouchEvent object has the following properties:
	 */
	public static inline var TOUCH_TAP = "touchTap";
	
	
	/**
	 * Indicates whether the Alt key is active(`true`) or inactive
	 * (`false`). Supported for Windows and Linux operating systems
	 * only.
	 */
	public var altKey:Bool;
	
	public var commandKey:Bool;
	
	public var controlKey:Bool;
	
	/**
	 * On Windows or Linux, indicates whether the Ctrl key is active
	 * (`true`) or inactive(`false`). On Macintosh,
	 * indicates whether either the Control key or the Command key is activated.
	 */
	public var ctrlKey:Bool;
	
	public var delta:Int;
	
	/**
	 * Indicates whether the first point of contact is mapped to mouse events.
	 */
	public var isPrimaryTouchPoint:Bool;
	
	#if flash
	@:noCompletion @:dox(hide) public var isRelatedObjectInaccessible:Bool;
	#end
	
	/**
	 * The horizontal coordinate at which the event occurred relative to the
	 * containing sprite.
	 */
	public var localX:Float;
	
	/**
	 * The vertical coordinate at which the event occurred relative to the
	 * containing sprite.
	 */
	public var localY:Float;
	
	/**
	 * A value between `0.0` and `1.0` indicating force of
	 * the contact with the device. If the device does not support detecting the
	 * pressure, the value is `1.0`.
	 */
	public var pressure:Float;
	
	/**
	 * A reference to a display list object that is related to the event. For
	 * example, when a `touchOut` event occurs,
	 * `relatedObject` represents the display list object to which the
	 * pointing device now points. This property applies to the
	 * `touchOut`, `touchOver`, `touchRollOut`,
	 * and `touchRollOver` events.
	 *
	 * The value of this property can be `null` in two
	 * circumstances: if there is no related object, or there is a related
	 * object, but it is in a security sandbox to which you don't have access.
	 * Use the `isRelatedObjectInaccessible()` property to determine
	 * which of these reasons applies.
	 */
	public var relatedObject:InteractiveObject;
	
	/**
	 * Indicates whether the Shift key is active(`true`) or inactive
	 * (`false`).
	 */
	public var shiftKey:Bool;
	
	/**
	 * Width of the contact area.
	 * Only supported on Android(C++ target), in the range of 0-1.
	 */
	public var sizeX:Float;
	
	/**
	 * Height of the contact area.
	 * Only supported on Android(C++ target), in the range of 0-1.
	 */
	public var sizeY:Float;
	
	/**
	 * The horizontal coordinate at which the event occurred in global Stage
	 * coordinates. This property is calculated when the `localX`
	 * property is set.
	 */
	public var stageX:Float;
	
	/**
	 * The vertical coordinate at which the event occurred in global Stage
	 * coordinates. This property is calculated when the `localY`
	 * property is set.
	 */
	public var stageY:Float;
	
	/**
	 * A unique identification number(as an int) assigned to the touch point.
	 */
	public var touchPointID:Int;
	
	
	/**
	 * Creates an Event object that contains information about touch events.
	 * Event objects are passed as parameters to event listeners.
	 * 
	 * @param type                The type of the event. Possible values are:
	 *                            `TouchEvent.TOUCH_BEGIN`,
	 *                            `TouchEvent.TOUCH_END`,
	 *                            `TouchEvent.TOUCH_MOVE`,
	 *                            `TouchEvent.TOUCH_OUT`,
	 *                            `TouchEvent.TOUCH_OVER`,
	 *                            `TouchEvent.TOUCH_ROLL_OUT`,
	 *                            `TouchEvent.TOUCH_ROLL_OVER`, and
	 *                            `TouchEvent.TOUCH_TAP`.
	 * @param bubbles             Determines whether the Event object
	 *                            participates in the bubbling phase of the event
	 *                            flow.
	 * @param cancelable          Determines whether the Event object can be
	 *                            canceled.
	 * @param touchPointID        A unique identification number(as an int)
	 *                            assigned to the touch point.
	 * @param isPrimaryTouchPoint Indicates whether the first point of contact is
	 *                            mapped to mouse events.
	 * @param relatedObject       The complementary InteractiveObject instance
	 *                            that is affected by the event. For example,
	 *                            when a `touchOut` event occurs,
	 *                            `relatedObject` represents the
	 *                            display list object to which the pointing
	 *                            device now points.
	 * @param ctrlKey             On Windows or Linux, indicates whether the Ctrl
	 *                            key is activated. On Mac, indicates whether
	 *                            either the Ctrl key or the Command key is
	 *                            activated.
	 * @param altKey              Indicates whether the Alt key is activated
	 *                           (Windows or Linux only).
	 * @param shiftKey            Indicates whether the Shift key is activated.
	 */
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, touchPointID:Int = 0, isPrimaryTouchPoint:Bool = false, localX:Float = 0, localY:Float = 0, sizeX:Float = 0, sizeY:Float = 0, pressure:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, commandKey:Bool = false, controlKey:Bool = false, timestamp:Float = 0, touchIntent:String = null, samples:ByteArray = null, isTouchPointCanceled:Bool = false);
	
	
	/**
	 * Instructs Flash Player or Adobe AIR to render after processing of this
	 * event completes, if the display list has been modified.
	 * 
	 */
	public function updateAfterEvent ():Void;
	
	
}


#else
typedef TouchEvent = flash.events.TouchEvent;
#end