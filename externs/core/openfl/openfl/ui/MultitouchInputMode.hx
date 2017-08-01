package openfl.ui; #if (display || !flash)


/**
 * The MultitouchInputMode class provides values for the
 * `inputMode` property in the flash.ui.Multitouch class. These
 * values set the type of touch events the Flash runtime dispatches when the
 * user interacts with a touch-enabled device.
 */
@:enum abstract MultitouchInputMode(Null<Int>) {
	
	/**
	 * Specifies that TransformGestureEvent, PressAndTapGestureEvent, and
	 * GestureEvent events are dispatched for the related user interaction
	 * supported by the current environment, and other touch events(such as a
	 * simple tap) are interpreted as mouse events.
	 */
	public var GESTURE = 0;
	
	public var NONE = 1;
	
	/**
	 * Specifies that all user contact with a touch-enabled device is interpreted
	 * as a type of mouse event.
	 */
	public var TOUCH_POINT = 2;
	
	@:from private static function fromString (value:String):MultitouchInputMode {
		
		return switch (value) {
			
			case "gesture": GESTURE;
			case "none": NONE;
			case "touchPoint": TOUCH_POINT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case MultitouchInputMode.GESTURE: "gesture";
			case MultitouchInputMode.NONE: "none";
			case MultitouchInputMode.TOUCH_POINT: "touchPoint";
			default: null;
			
		}
		
	}
	
}


#else
typedef MultitouchInputMode = flash.ui.MultitouchInputMode;
#end