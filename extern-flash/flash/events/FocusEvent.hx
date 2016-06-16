package flash.events; #if (!display && flash)


import openfl.display.InteractiveObject;


extern class FocusEvent extends Event {
	
	
	public static var FOCUS_IN (default, never):String;
	public static var FOCUS_OUT (default, never):String;
	public static var KEY_FOCUS_CHANGE (default, never):String;
	public static var MOUSE_FOCUS_CHANGE (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var isRelatedObjectInaccessible:Bool;
	#end
	
	public var keyCode:Int;
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, relatedObject:InteractiveObject = null, shiftKey:Bool = false, keyCode:Int = 0);
	
	
}


#else
typedef FocusEvent = openfl.events.FocusEvent;
#end