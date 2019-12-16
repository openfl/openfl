package flash.ui;

#if flash
import openfl.Vector;

@:final extern class Multitouch
{
	public static var inputMode:MultitouchInputMode;
	#if flash
	public static var mapTouchToMouse:Bool;
	#end
	public static var maxTouchPoints(default, never):Int;
	public static var supportedGestures(default, never):Vector<String>;
	public static var supportsGestureEvents(default, never):Bool;
	public static var supportsTouchEvents(default, never):Bool;
}
#else
typedef Multitouch = openfl.ui.Multitouch;
#end
