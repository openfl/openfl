package openfl.ui; #if !openfl_legacy


import openfl.ui.MultitouchInputMode;
import openfl.Lib;
import openfl.Vector;

#if (js && html5)
import js.Browser;
#end


@:final class Multitouch {
	
	
	public static var inputMode (get, set):MultitouchInputMode;
	public static var maxTouchPoints (default, null):Int;
	public static var supportedGestures (default, null):Vector<String>;
	public static var supportsGestureEvents (default, null):Bool;
	public static var supportsTouchEvents (get, null):Bool;
	
	
	public static function __init__ () {
		
		maxTouchPoints = 2;
		supportedGestures = null;
		supportsGestureEvents = false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_inputMode ():MultitouchInputMode {
		
		return MultitouchInputMode.TOUCH_POINT;
		
	}
	
	
	private static function set_inputMode (inMode:MultitouchInputMode):MultitouchInputMode {
		
		if (inMode == MultitouchInputMode.GESTURE) {
			
			return inputMode;
			
		}
		
		// @todo set input mode
		return inMode;
		
	}
	
	
	private static function get_supportsTouchEvents ():Bool {
		
		#if (js && html5)
		if (untyped __js__ ("('ontouchstart' in document.documentElement) || (window.DocumentTouch && document instanceof DocumentTouch)")) {
			
			return true;
			
		}
		#elseif (cpp)
		return true;
		#end
		
		return false;
		
	}
	
	
}


#else
typedef Multitouch = openfl._legacy.ui.Multitouch;
#end