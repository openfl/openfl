package flash.ui;

#if flash
import openfl.Vector;

@:final extern class Multitouch
{
	#if (haxe_ver < 4.3)
	public static var inputMode:MultitouchInputMode;
	public static var mapTouchToMouse:Bool;
	public static var maxTouchPoints(default, never):Int;
	public static var supportedGestures(default, never):Vector<String>;
	public static var supportsGestureEvents(default, never):Bool;
	public static var supportsTouchEvents(default, never):Bool;
	#else
	@:flash.property static var inputMode(get, set):MultitouchInputMode;
	@:flash.property static var mapTouchToMouse(get, set):Bool;
	@:flash.property static var maxTouchPoints(get, never):Int;
	@:flash.property static var supportedGestures(get, never):Vector<String>;
	@:flash.property static var supportsGestureEvents(get, never):Bool;
	@:flash.property static var supportsTouchEvents(get, never):Bool;
	#end

	#if (haxe_ver >= 4.3)
	private static function get_inputMode():MultitouchInputMode;
	private static function get_mapTouchToMouse():Bool;
	private static function get_maxTouchPoints():Int;
	private static function get_supportedGestures():Vector<String>;
	private static function get_supportsGestureEvents():Bool;
	private static function get_supportsTouchEvents():Bool;
	private static function set_inputMode(value:MultitouchInputMode):MultitouchInputMode;
	private static function set_mapTouchToMouse(value:Bool):Bool;
	#end
}
#else
typedef Multitouch = openfl.ui.Multitouch;
#end
