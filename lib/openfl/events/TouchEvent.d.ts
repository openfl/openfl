import Event from "./Event";
import InteractiveObject from "./../display/InteractiveObject";
import ByteArray from "./../utils/ByteArray";


declare namespace openfl.events {
	
	
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
	export class TouchEvent extends Event {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public static PROXIMITY_BEGIN:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static PROXIMITY_END:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static PROXIMITY_MOVE:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static PROXIMITY_OUT:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static PROXIMITY_OVER:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static PROXIMITY_ROLL_OUT:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static PROXIMITY_ROLL_OVER:string;
		// #end
		
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_BEGIN` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static TOUCH_BEGIN:string;
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_END` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static TOUCH_END:string;
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_MOVE` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static TOUCH_MOVE:string;
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_OUT` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static TOUCH_OUT:string;
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_OVER` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static TOUCH_OVER:string;
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_ROLL_OUT` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static TOUCH_ROLL_OUT:string;
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_ROLL_OVER` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static TOUCH_ROLL_OVER:string;
		
		/**
		 * Defines the value of the `type` property of a
		 * `TOUCH_TAP` touch event object.
		 *
		 * The dispatched TouchEvent object has the following properties:
		 */
		public static TOUCH_TAP:string;
		
		
		/**
		 * Indicates whether the Alt key is active(`true`) or inactive
		 * (`false`). Supported for Windows and Linux operating systems
		 * only.
		 */
		public altKey:boolean;
		
		public commandKey:boolean;
		
		public controlKey:boolean;
		
		/**
		 * On Windows or Linux, indicates whether the Ctrl key is active
		 * (`true`) or inactive(`false`). On Macintosh,
		 * indicates whether either the Control key or the Command key is activated.
		 */
		public ctrlKey:boolean;
		
		public delta:number;
		
		/**
		 * Indicates whether the first point of contact is mapped to mouse events.
		 */
		public isPrimaryTouchPoint:boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) public isRelatedObjectInaccessible:boolean;
		// #end
		
		/**
		 * The horizontal coordinate at which the event occurred relative to the
		 * containing sprite.
		 */
		public localX:number;
		
		/**
		 * The vertical coordinate at which the event occurred relative to the
		 * containing sprite.
		 */
		public localY:number;
		
		/**
		 * A value between `0.0` and `1.0` indicating force of
		 * the contact with the device. If the device does not support detecting the
		 * pressure, the value is `1.0`.
		 */
		public pressure:number;
		
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
		public relatedObject:InteractiveObject;
		
		/**
		 * Indicates whether the Shift key is active(`true`) or inactive
		 * (`false`).
		 */
		public shiftKey:boolean;
		
		/**
		 * Width of the contact area.
		 * Only supported on Android(C++ target), in the range of 0-1.
		 */
		public sizeX:number;
		
		/**
		 * Height of the contact area.
		 * Only supported on Android(C++ target), in the range of 0-1.
		 */
		public sizeY:number;
		
		/**
		 * The horizontal coordinate at which the event occurred in global Stage
		 * coordinates. This property is calculated when the `localX`
		 * property is set.
		 */
		public stageX:number;
		
		/**
		 * The vertical coordinate at which the event occurred in global Stage
		 * coordinates. This property is calculated when the `localY`
		 * property is set.
		 */
		public stageY:number;
		
		/**
		 * A unique identification number(as an int) assigned to the touch point.
		 */
		public touchPointID:number;
		
		
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
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean, touchPointID?:number, isPrimaryTouchPoint?:boolean, localX?:number, localY?:number, sizeX?:number, sizeY?:number, pressure?:number, relatedObject?:InteractiveObject, ctrlKey?:boolean, altKey?:boolean, shiftKey?:boolean, commandKey?:boolean, controlKey?:boolean, timestamp?:number, touchIntent?:string, samples?:ByteArray, isTouchPointCanceled?:boolean);
		
		
		/**
		 * Instructs Flash Player or Adobe AIR to render after processing of this
		 * event completes, if the display list has been modified.
		 * 
		 */
		public updateAfterEvent ():void;
		
		
	}
	
	
}


export default openfl.events.TouchEvent;