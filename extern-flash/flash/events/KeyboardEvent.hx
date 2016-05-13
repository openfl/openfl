package flash.events; #if (!display && flash)


import openfl.ui.KeyLocation;

extern class KeyboardEvent extends Event {
	
	
	public static var KEY_DOWN (default, never):String;
	public static var KEY_UP (default, never):String;
	
	public var altKey:Bool;
	public var charCode:Int;
	public var ctrlKey:Bool;
	public var commandKey:Bool;
	public var controlKey:Bool;
	public var keyCode:Int;
	public var keyLocation:KeyLocation;
	public var shiftKey:Bool;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, charCodeValue:Int = 0, keyCodeValue:Int = 0, keyLocationValue:KeyLocation = null, ctrlKeyValue:Bool = false, altKeyValue:Bool = false, shiftKeyValue:Bool = false, controlKeyValue:Bool = false, commandKeyValue:Bool = false);
	
	
}


#else
typedef KeyboardEvent = openfl.events.KeyboardEvent;
#end