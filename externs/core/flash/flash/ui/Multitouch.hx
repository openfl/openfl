package flash.ui; #if (!display && flash)


import openfl.Vector;


@:final extern class Multitouch {
	
	
	public static var inputMode:MultitouchInputMode;
	
	#if flash
	@:noCompletion @:dox(hide) public static var mapTouchToMouse:Bool;
	#end
	
	public static var maxTouchPoints (default, null):Int;
	public static var supportedGestures (default, null):Vector<String>;
	public static var supportsGestureEvents (default, null):Bool;
	public static var supportsTouchEvents (default, null):Bool;
	
	
}


#else
typedef Multitouch = openfl.ui.Multitouch;
#end