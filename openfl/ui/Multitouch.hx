package openfl.ui;


import openfl.Vector;


@:final class Multitouch {
	
	
	public static var inputMode:MultitouchInputMode;
	public static var maxTouchPoints (default, null):Int;
	public static var supportedGestures (default, null):Vector<String>;
	public static var supportsGestureEvents (default, null):Bool;
	public static var supportsTouchEvents (get, never):Bool;
	
	
	public static function __init__ () {
		
		maxTouchPoints = 2;
		supportedGestures = null;
		supportsGestureEvents = false;
		inputMode = MultitouchInputMode.TOUCH_POINT;
		
		#if openfljs
		untyped Object.defineProperties (Multitouch, {
			"supportsTouchEvents": { get: function () { return Multitouch.get_supportsTouchEvents (); } }
		});
		#end
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_supportsTouchEvents ():Bool {
		
		#if (js && html5)
		
		if (untyped __js__ ("('ontouchstart' in document.documentElement) || (window.DocumentTouch && document instanceof DocumentTouch)")) {
			
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