package openfl.ui; #if !flash #if !lime_legacy


import openfl.ui.MultitouchInputMode;
import openfl.Lib;

#if js
import js.Browser;
#end


/**
 * The Multitouch class manages and provides information about the current
 * environment's support for handling contact from user input devices,
 * including contact that has two or more touch points(such as a user's
 * fingers on a touch screen). When a user interacts with a device such as a
 * mobile phone or tablet with a touch screen, the user typically touches the
 * screen with his or her fingers or a pointing device. While there is a broad
 * range of pointing devices, such as a mouse or a stylus, many of these
 * devices only have a single point of contact with an application. For
 * pointing devices with a single point of contact, user interaction events
 * can be handled as a mouse event, or using a basic set of touch events
 * (called "touch point" events). However, for pointing devices that have
 * several points of contact and perform complex movement, such as the human
 * hand, Flash runtimes support an additional set of event handling API called
 * gesture events. The API for handling user interaction with these gesture
 * events includes the following classes:
 *
 * <p>
 * <ul>
 *   <li>flash.events.TouchEvent</li>
 *   <li>flash.events.GestureEvent</li>
 *   <li>flash.events.GesturePhase</li>
 *   <li>flash.events.TransformGestureEvent</li>
 *   <li>flash.events.PressAndTapGestureEvent</li>
 * </ul>
 * </p>
 *
 * <p>Use the listed classes to write code that handles touch events. Use the
 * Multitouch class to determine the current environment's support for touch
 * interaction, and to manage the support of touch interaction if the current
 * environment supports touch input.</p>
 *
 * <p>You cannot create a Multitouch object directly from ActionScript code.
 * If you call <code>new Multitouch()</code>, an exception is thrown.</p>
 *
 * <p><b>Note:</b> The Multitouch feature is not supported for SWF files
 * embedded in HTML running on Mac OS.</p>
 */
class Multitouch {
	
	
	/**
	 * Identifies the multi-touch mode for touch and gesture event handling. Use
	 * this property to manage whether or not events are dispatched as touch
	 * events with multiple points of contact and specific events for different
	 * gestures(such as rotation and pan), or only a single point of contact
	 * (such as tap), or none at all(contact is handled as a mouse event). To
	 * set this property, use values from the flash.ui.MultitouchInputMode class.
	 * 
	 * @default gesture
	 */
	public static var inputMode (get, set):MultitouchInputMode;
	
	/**
	 * The maximum number of concurrent touch points supported by the current
	 * environment.
	 */
	public static var maxTouchPoints (default, null):Int;
	
	/**
	 * A Vector array(a typed array of string values) of multi-touch contact
	 * types supported in the current environment. The array of strings can be
	 * used as event types to register event listeners. Possible values are
	 * constants from the GestureEvent, PressAndTapGestureEvent, and
	 * TransformGestureEvent classes(such as <code>GESTURE_PAN</code>).
	 *
	 * <p>If the Flash runtime is in an environment that does not support any
	 * multi-touch gestures, the value is <code>null</code>.</p>
	 *
	 * <p><b>Note:</b> For Mac OS 10.5.3 and later,
	 * <code>Multitouch.supportedGestures</code> returns non-null values
	 * (possibly indicating incorrectly that gesture events are supported) even
	 * if the current hardware does not support gesture input.</p>
	 *
	 * <p>Use this property to test for multi-touch gesture support. Then, use
	 * event handlers for the available multi-touch gestures. For those gestures
	 * that are not supported in the current evironment, you'll need to create
	 * alternative event handling.</p>
	 */
	public static var supportedGestures (default, null):Array<String>;
	
	/**
	 * Indicates whether the current environment supports gesture input, such as
	 * rotating two fingers around a touch screen. Gesture events are listed in
	 * the TransformGestureEvent, PressAndTapGestureEvent, and GestureEvent
	 * classes.
	 *
	 * <p><b>Note:</b> For Mac OS 10.5.3 and later, this value is always
	 * <code>true</code>. <code>Multitouch.supportsGestureEvent</code> returns
	 * <code>true</code> even if the hardware does not support gesture
	 * events.</p>
	 */
	public static var supportsGestureEvents (default, null):Bool;
	
	/**
	 * Indicates whether the current environment supports basic touch input, such
	 * as a single finger tap. Touch events are listed in the TouchEvent class.
	 */
	public static var supportsTouchEvents (get, null):Bool;
	
	
	@:noCompletion public static function __init__ () {
		
		maxTouchPoints = 2;
		supportedGestures = null;
		supportsGestureEvents = false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private static function get_inputMode ():MultitouchInputMode {
		
		return MultitouchInputMode.TOUCH_POINT;
		
	}
	
	
	@:noCompletion private static function set_inputMode (inMode:MultitouchInputMode):MultitouchInputMode {
		
		if (inMode == MultitouchInputMode.GESTURE) {
			
			return inputMode;
			
		}
		
		// @todo set input mode
		return inMode;
		
	}
	
	
	@:noCompletion private static function get_supportsTouchEvents ():Bool {
		
		#if js
		if (untyped __js__ ("('ontouchstart' in document.documentElement) || (window.DocumentTouch && document instanceof DocumentTouch)")) {
			
			return true;
			
		}
		#end
		
		return false;
		
	}
	
	
}


#else
typedef Multitouch = openfl._v2.ui.Multitouch;
#end
#else
typedef Multitouch = flash.ui.Multitouch;
#end