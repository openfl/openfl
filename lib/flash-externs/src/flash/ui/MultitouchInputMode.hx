package flash.ui;

#if flash
@:enum abstract MultitouchInputMode(String) from String to String
{
	public var GESTURE = "gesture";
	public var NONE = "none";
	public var TOUCH_POINT = "touchPoint";
}
#else
typedef MultitouchInputMode = openfl.ui.MultitouchInputMode;
#end
