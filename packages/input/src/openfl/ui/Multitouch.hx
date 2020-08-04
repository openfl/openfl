package openfl.ui;

#if !flash
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class Multitouch
{
	public static var inputMode:MultitouchInputMode;
	// @:noCompletion @:dox(hide) public static var mapTouchToMouse:Bool;
	public static var maxTouchPoints(default, null):Int;
	public static var supportedGestures(default, null):Vector<String>;
	public static var supportsGestureEvents(default, null):Bool;
	public static var supportsTouchEvents(get, never):Bool;

	private static function __init__():Void
	{
		maxTouchPoints = 2;
		supportedGestures = null;
		supportsGestureEvents = false;
		inputMode = MultitouchInputMode.TOUCH_POINT;

		#if openfljs
		untyped Object.defineProperties(Multitouch, {
			"supportsTouchEvents": {
				get: function()
				{
					return Multitouch.get_supportsTouchEvents();
				}
			}
		});
		#end
	}

	// Getters & Setters
	@:noCompletion private static function get_supportsTouchEvents():Bool
	{
		#if (js && html5)
		if (untyped #if haxe4 js.Syntax.code #else __js__ #end ("('ontouchstart' in document.documentElement) || (window.DocumentTouch && document instanceof DocumentTouch)"))
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
#else
typedef Multitouch = flash.ui.Multitouch;
#end
