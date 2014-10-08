package openfl.ui; #if !flash #if (display || openfl_next || js)


import openfl.ui.MultitouchInputMode;
import openfl.Lib;

#if js
import js.Browser;
#end


class Multitouch {
	
	
	public static var inputMode (get, set):MultitouchInputMode;
	public static var maxTouchPoints (default, null):Int;
	public static var supportedGestures (default, null):Array<String>;
	public static var supportsGestureEvents (default, null):Bool;
	public static var supportsTouchEvents (get, null):Bool;
	
	
	@:noCompletion public static function __init__ () {
		
		maxTouchPoints = 2;
		supportedGestures = null;
		supportsGestureEvents = false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private static function get_inputMode ():MultitouchInputMode {
		
		return MultitouchInputMode.TOUCH_POINT;
		
	}
	
	
	@:noCompletion private static function set_inputMode (inMode:MultitouchInputMode):MultitouchInputMode {
		
		if (inMode == MultitouchInputMode.GESTURE) {
			
			return inputMode;
			
		}
		
		// @todo set input mode
		return inMode;
		
	}
	
	
	@:noCompletion private static function get_supportsTouchEvents ():Bool {
		
		#if js
		if (untyped __js__ ("('ontouchstart' in document.documentElement) || (window.DocumentTouch && document instanceof DocumentTouch)")) {
			
			return true;
			
		}
		#end
		
		return false;
		
	}
	
	
}


#else
typedef Multitouch = openfl._v2.ui.Multitouch;
#end
#else
typedef Multitouch = flash.ui.Multitouch;
#end