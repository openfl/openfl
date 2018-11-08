package openfl.events {
	
	
	import openfl.display.InteractiveObject;
	import openfl.utils.ByteArray;
	
	
	/**
	 * @externs
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
	public class TouchEvent extends Event {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var PROXIMITY_BEGIN:String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var PROXIMITY_END:String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var PROXIMITY_MOVE:String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var PROXIMITY_OUT:String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var PROXIMITY_OVER:String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var PROXIMITY_ROLL_OUT:String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var PROXIMITY_ROLL_OVER:String;
		// #end
		
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_BEGIN` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static const TOUCH_BEGIN:String = "touchBegin";
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_END` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static const TOUCH_END:String = "touchEnd";
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_MOVE` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static const TOUCH_MOVE:String = "touchMove";
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_OUT` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static const TOUCH_OUT:String = "touchOut";
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_OVER` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static const TOUCH_OVER:String = "touchOver";
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_ROLL_OUT` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static const TOUCH_ROLL_OUT:String = "touchRollOut";
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_ROLL_OVER` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static const TOUCH_ROLL_OVER:String = "touchRollOver";
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_TAP` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static const TOUCH_TAP:String = "touchTap";
		
		
		/**
		 * Indicates whether the Alt key is active(`true`) or inactive
		 * (`false`). Supported for Windows and Linux operating systems
		 * only.
		 */
		public var altKey:Boolean;
		
		public var commandKey:Boolean;
		
		public var controlKey:Boolean;
		
		/**
		 * On Windows or Linux, indicates whether the Ctrl key is active
		 * (`true`) or inactive(`false`). On Macintosh,
		 * indicates whether either the Control key or the Command key is activated.
		 */
		public var ctrlKey:Boolean;
		
		public var delta:int;
		
		/**
		 * Indicates whether the first point of contact is mapped to mouse events.
		 */
		public var isPrimaryTouchPoint:Boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) public var isRelatedObjectInaccessible:Boolean;
		// #end
		
		/**
		 * The horizontal coordinate at which the event occurred relative to the
		 * containing sprite.
		 */
		public var localX:Number;
		
		/**
		 * The vertical coordinate at which the event occurred relative to the
		 * containing sprite.
		 */
		public var localY:Number;
		
		/**
		 * A value between `0.0` and `1.0` indicating force of
		 * the contact with the device. If the device does not support detecting the
		 * pressure, the value is `1.0`.
		 */
		public var pressure:Number;
		
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
		public var shiftKey:Boolean;
		
		/**
		 * Width of the contact area.
		 * Only supported on Android(C++ target), in the range of 0-1.
		 */
		public var sizeX:Number;
		
		/**
		 * Height of the contact area.
		 * Only supported on Android(C++ target), in the range of 0-1.
		 */
		public var sizeY:Number;
		
		/**
		 * The horizontal coordinate at which the event occurred in global Stage
		 * coordinates. This property is calculated when the `localX`
		 * property is set.
		 */
		public var stageX:Number;
		
		/**
		 * The vertical coordinate at which the event occurred in global Stage
		 * coordinates. This property is calculated when the `localY`
		 * property is set.
		 */
		public var stageY:Number;
		
		/**
		 * A unique identification number(as an int) assigned to the touch point.
		 */
		public var touchPointID:int;
		
		
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
		public function TouchEvent (type:String, bubbles:Boolean = true, cancelable:Boolean = false, touchPointID:int = 0, isPrimaryTouchPoint:Boolean = false, localX:Number = 0, localY:Number = 0, sizeX:Number = 0, sizeY:Number = 0, pressure:Number = 0, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, commandKey:Boolean = false, controlKey:Boolean = false, timestamp:Number = 0, touchIntent:String = null, samples:ByteArray = null, isTouchPointCanceled:Boolean = false) { super (type); }
		
		
		/**
		 * Instructs Flash Player or Adobe AIR to render after processing of this
		 * event completes, if the display list has been modified.
		 * 
		 */
		public function updateAfterEvent ():void {}
		
		
	}
	
	
}