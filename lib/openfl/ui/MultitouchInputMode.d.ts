declare namespace openfl.ui {
	
	/**
	 * The MultitouchInputMode class provides values for the
	 * `inputMode` property in the flash.ui.Multitouch class. These
	 * values set the type of touch events the Flash runtime dispatches when the
	 * user interacts with a touch-enabled device.
	 */
	export enum MultitouchInputMode {
		
		/**
		 * Specifies that TransformGestureEvent, PressAndTapGestureEvent, and
		 * GestureEvent events are dispatched for the related user interaction
		 * supported by the current environment, and other touch events(such as a
		 * simple tap) are interpreted as mouse events.
		 */
		GESTURE = "gesture",
		
		NONE = "none",
		
		/**
		 * Specifies that all user contact with a touch-enabled device is interpreted
		 * as a type of mouse event.
		 */
		TOUCH_POINT = "touchPoint"
		
	}
	
}


export default openfl.ui.MultitouchInputMode;