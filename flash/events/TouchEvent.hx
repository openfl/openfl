package flash.events;
#if (flash || display)


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
 * <p>Use the Multitouch class to determine the current environment's support
 * for touch interaction, and to manage the support of touch interaction if
 * the current environment supports it.</p>
 *
 * <p><b>Note:</b> When objects are nested on the display list, touch events
 * target the deepest possible nested object that is visible in the display
 * list. This object is called the target node. To have a target node's
 * ancestor(an object containing the target node in the display list) receive
 * notification of a touch event, use
 * <code>EventDispatcher.addEventListener()</code> on the ancestor node with
 * the type parameter set to the specific touch event you want to detect.</p>
 * 
 */
@:require(flash10_1) extern class TouchEvent extends Event {

	/**
	 * Indicates whether the Alt key is active(<code>true</code>) or inactive
	 * (<code>false</code>). Supported for Windows and Linux operating systems
	 * only.
	 */
	var altKey : Bool;

	/**
	 * On Windows or Linux, indicates whether the Ctrl key is active
	 * (<code>true</code>) or inactive(<code>false</code>). On Macintosh,
	 * indicates whether either the Control key or the Command key is activated.
	 */
	var ctrlKey : Bool;

	/**
	 * Indicates whether the first point of contact is mapped to mouse events.
	 */
	var isPrimaryTouchPoint : Bool;

	/**
	 * If <code>true</code>, the <code>relatedObject</code> property is set to
	 * <code>null</code> for reasons related to security sandboxes. If the
	 * nominal value of <code>relatedObject</code> is a reference to a
	 * DisplayObject in another sandbox, <code>relatedObject</code> is set to
	 * <code>null</code> unless there is permission in both directions across
	 * this sandbox boundary. Permission is established by calling
	 * <code>Security.allowDomain()</code> from a SWF file, or by providing a
	 * policy file from the server of an image file, and setting the
	 * <code>LoaderContext.checkPolicyFile</code> property when loading the
	 * image.
	 */
	var isRelatedObjectInaccessible : Bool;

	/**
	 * The horizontal coordinate at which the event occurred relative to the
	 * containing sprite.
	 */
	var localX : Float;

	/**
	 * The vertical coordinate at which the event occurred relative to the
	 * containing sprite.
	 */
	var localY : Float;

	/**
	 * A value between <code>0.0</code> and <code>1.0</code> indicating force of
	 * the contact with the device. If the device does not support detecting the
	 * pressure, the value is <code>1.0</code>.
	 */
	var pressure : Float;

	/**
	 * A reference to a display list object that is related to the event. For
	 * example, when a <code>touchOut</code> event occurs,
	 * <code>relatedObject</code> represents the display list object to which the
	 * pointing device now points. This property applies to the
	 * <code>touchOut</code>, <code>touchOver</code>, <code>touchRollOut</code>,
	 * and <code>touchRollOver</code> events.
	 *
	 * <p>The value of this property can be <code>null</code> in two
	 * circumstances: if there is no related object, or there is a related
	 * object, but it is in a security sandbox to which you don't have access.
	 * Use the <code>isRelatedObjectInaccessible()</code> property to determine
	 * which of these reasons applies.</p>
	 */
	var relatedObject : flash.display.InteractiveObject;

	/**
	 * Indicates whether the Shift key is active(<code>true</code>) or inactive
	 * (<code>false</code>).
	 */
	var shiftKey : Bool;

	/**
	 * Width of the contact area.
	 * Only supported on Android(C++ target), in the range of 0-1.
	 */
	var sizeX : Float;

	/**
	 * Height of the contact area.
	 * Only supported on Android(C++ target), in the range of 0-1.
	 */
	var sizeY : Float;

	/**
	 * The horizontal coordinate at which the event occurred in global Stage
	 * coordinates. This property is calculated when the <code>localX</code>
	 * property is set.
	 */
	var stageX(default,null) : Float;

	/**
	 * The vertical coordinate at which the event occurred in global Stage
	 * coordinates. This property is calculated when the <code>localY</code>
	 * property is set.
	 */
	var stageY(default,null) : Float;

	/**
	 * A unique identification number(as an int) assigned to the touch point.
	 */
	var touchPointID : Int;

	/**
	 * Creates an Event object that contains information about touch events.
	 * Event objects are passed as parameters to event listeners.
	 * 
	 * @param type                The type of the event. Possible values are:
	 *                            <code>TouchEvent.TOUCH_BEGIN</code>,
	 *                            <code>TouchEvent.TOUCH_END</code>,
	 *                            <code>TouchEvent.TOUCH_MOVE</code>,
	 *                            <code>TouchEvent.TOUCH_OUT</code>,
	 *                            <code>TouchEvent.TOUCH_OVER</code>,
	 *                            <code>TouchEvent.TOUCH_ROLL_OUT</code>,
	 *                            <code>TouchEvent.TOUCH_ROLL_OVER</code>, and
	 *                            <code>TouchEvent.TOUCH_TAP</code>.
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
	 *                            when a <code>touchOut</code> event occurs,
	 *                            <code>relatedObject</code> represents the
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
	function new(type : String, bubbles : Bool = true, cancelable : Bool = false, touchPointID : Int = 0, isPrimaryTouchPoint : Bool = false, localX : Float = 0./*NaN*/, localY : Float = 0./*NaN*/, sizeX : Float = 0./*NaN*/, sizeY : Float = 0./*NaN*/, pressure : Float = 0./*NaN*/, ?relatedObject : flash.display.InteractiveObject, ctrlKey : Bool = false, altKey : Bool = false, shiftKey : Bool = false) : Void;

	/**
	 * Instructs Flash Player or Adobe AIR to render after processing of this
	 * event completes, if the display list has been modified.
	 * 
	 */
	function updateAfterEvent() : Void;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>TOUCH_BEGIN</code> touch event object.
	 *
	 * <p>The dispatched TouchEvent object has the following properties:</p>
	 */
	static var TOUCH_BEGIN : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>TOUCH_END</code> touch event object.
	 *
	 * <p>The dispatched TouchEvent object has the following properties:</p>
	 */
	static var TOUCH_END : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>TOUCH_MOVE</code> touch event object.
	 *
	 * <p>The dispatched TouchEvent object has the following properties:</p>
	 */
	static var TOUCH_MOVE : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>TOUCH_OUT</code> touch event object.
	 *
	 * <p>The dispatched TouchEvent object has the following properties:</p>
	 */
	static var TOUCH_OUT : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>TOUCH_OVER</code> touch event object.
	 *
	 * <p>The dispatched TouchEvent object has the following properties:</p>
	 */
	static var TOUCH_OVER : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>TOUCH_ROLL_OUT</code> touch event object.
	 *
	 * <p>The dispatched TouchEvent object has the following properties:</p>
	 */
	static var TOUCH_ROLL_OUT : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>TOUCH_ROLL_OVER</code> touch event object.
	 *
	 * <p>The dispatched TouchEvent object has the following properties:</p>
	 */
	static var TOUCH_ROLL_OVER : String;

	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>TOUCH_TAP</code> touch event object.
	 *
	 * <p>The dispatched TouchEvent object has the following properties:</p>
	 */
	static var TOUCH_TAP : String;
}


#end
