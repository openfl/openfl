package openfl.ui;

#if !flash
#if !openfljs
@:enum abstract MultitouchInputMode(Null<Int>)
{
	public var GESTURE = 0;
	public var NONE = 1;
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
