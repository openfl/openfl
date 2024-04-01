package flash.ui;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract MultitouchInputMode(String) from String to String

{
	public var GESTURE = "gesture";
	public var NONE = "none";
	public var TOUCH_POINT = "touchPoint";
}
#else
typedef MultitouchInputMode = openfl.ui.MultitouchInputMode;
#end
