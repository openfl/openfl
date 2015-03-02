package openfl._v2.ui; #if lime_legacy


import openfl.ui.MultitouchInputMode;
import openfl.Lib;


class Multitouch {
	
	
	public static var inputMode (get, set):MultitouchInputMode;
	public static var maxTouchPoints (default, null):Int;
	public static var supportedGestures (default, null):Array<String>;
	public static var supportsGestureEvents (default, null):Bool;
	public static var supportsTouchEvents (get, null):Bool;
	
	
	@:noCompletion public static function __init__():Void {
		
		maxTouchPoints = 2;
		supportedGestures = null;
		supportsGestureEvents = false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_inputMode ():MultitouchInputMode {
		
		if (lime_stage_get_multitouch_active (Lib.current.stage.__handle)) {
			
			return MultitouchInputMode.TOUCH_POINT;
			
		} else {
			
			return MultitouchInputMode.NONE;
			
		}
		
	}
	
	
	private static function set_inputMode (value:MultitouchInputMode):MultitouchInputMode {
		
		if (value == MultitouchInputMode.GESTURE) {
			
			return inputMode;
			
		}
		
		lime_stage_set_multitouch_active (Lib.current.stage.__handle, value == MultitouchInputMode.TOUCH_POINT);
		return value;
		
	}
	
	
	private static function get_supportsTouchEvents ():Bool { return lime_stage_get_multitouch_supported (Lib.current.stage.__handle); }
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_stage_get_multitouch_supported = Lib.load ("lime", "lime_stage_get_multitouch_supported", 1);
	private static var lime_stage_get_multitouch_active = Lib.load ("lime", "lime_stage_get_multitouch_active", 1);
	private static var lime_stage_set_multitouch_active = Lib.load ("lime", "lime_stage_set_multitouch_active", 2);
	
	
}


#end