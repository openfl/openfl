package openfl.ui;

import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Multitouch
{
	public static var inputMode:MultitouchInputMode;
	public static var maxTouchPoints:Int;
	public static var supportedGestures:Vector<String>;
	public static var supportsGestureEvents:Bool;
	public static var supportsTouchEvents(get, never):Bool;

	public static function __init__():Void
	{
		maxTouchPoints = 2;
		supportedGestures = null;
		supportsGestureEvents = false;
		inputMode = MultitouchInputMode.TOUCH_POINT;
	}

	// Getters & Setters
	public static function get_supportsTouchEvents():Bool
	{
		#if openfl_html5
		if (untyped __js__("('ontouchstart' in document.documentElement) || (window.DocumentTouch && document instanceof DocumentTouch)"))
		{
			return true;
		}

		return false;
		#elseif !mac
		return true;
		#else
		return false;
		#end
	}
}
