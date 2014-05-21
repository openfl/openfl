/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.ui;
#if display


/**
 * The MultitouchInputMode class provides values for the
 * <code>inputMode</code> property in the openfl.ui.Multitouch class. These
 * values set the type of touch events the Flash runtime dispatches when the
 * user interacts with a touch-enabled device.
 */
@:fakeEnum(String) extern enum MultitouchInputMode {

	/**
	 * Specifies that TransformGestureEvent, PressAndTapGestureEvent, and
	 * GestureEvent events are dispatched for the related user interaction
	 * supported by the current environment, and other touch events(such as a
	 * simple tap) are interpreted as mouse events.
	 */
	GESTURE;

	/**
	 * Specifies that all user contact with a touch-enabled device is interpreted
	 * as a type of mouse event.
	 */
	NONE;
	TOUCH_POINT;
}


#end
