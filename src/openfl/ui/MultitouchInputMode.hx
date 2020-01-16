package openfl.ui;

#if !flash

#if !openfljs
/**
	The MultitouchInputMode class provides values for the
	`inputMode` property in the openfl.ui.Multitouch class. These
	values set the type of touch events the Flash runtime dispatches when the
	user interacts with a touch-enabled device.
**/
@:enum abstract MultitouchInputMode(Null<Int>)
{
	/**
		Specifies that TransformGestureEvent, PressAndTapGestureEvent, and
		GestureEvent events are dispatched for the related user interaction
		supported by the current environment, and other touch events(such as a
		simple tap) are interpreted as mouse events.
	**/
	public var GESTURE = 0;

	/**
		Specifies that all user contact with a touch-enabled device is interpreted as a
		type of mouse event.
	**/
	public var NONE = 1;

	/**
		Specifies that all user contact with a touch-enabled device is interpreted
		as a type of mouse event.
	**/
	public var TOUCH_POINT = 2;

	@:from private static function fromString(value:String):MultitouchInputMode
	{
		return switch (value)
		{
			case "gesture": GESTURE;
			case "none": NONE;
			case "touchPoint": TOUCH_POINT;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : MultitouchInputMode)
		{
			case MultitouchInputMode.GESTURE: "gesture";
			case MultitouchInputMode.NONE: "none";
			case MultitouchInputMode.TOUCH_POINT: "touchPoint";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract MultitouchInputMode(String) from String to String
{
	public var GESTURE = "gesture";
	public var NONE = "none";
	public var TOUCH_POINT = "touchPoint";
}
#end
#else
typedef MultitouchInputMode = flash.ui.MultitouchInputMode;
#end
