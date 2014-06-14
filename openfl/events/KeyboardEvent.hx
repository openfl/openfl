package openfl.events; #if !flash


import openfl.ui.KeyLocation;


class KeyboardEvent extends Event {
	
	
	public static var KEY_DOWN = "keyDown";
	public static var KEY_UP = "keyUp";
	
	public var altKey:Bool;
	public var charCode:Int;
	public var ctrlKey:Bool;
	public var commandKey:Bool;
	public var controlKey:Bool;
	public var keyCode:Int;
	public var keyLocation:KeyLocation;
	public var shiftKey:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, charCodeValue:Int = 0, keyCodeValue:Int = 0, keyLocationValue:KeyLocation = null, ctrlKeyValue:Bool = false, altKeyValue:Bool = false, shiftKeyValue:Bool = false, controlKeyValue:Bool = false, commandKeyValue:Bool = false) {
		
		super (type, bubbles, cancelable);
		
		charCode = charCodeValue;
		keyCode = keyCodeValue;
		keyLocation = keyLocationValue != null ? keyLocationValue : KeyLocation.STANDARD;
		ctrlKey = ctrlKeyValue;
		altKey = altKeyValue;
		shiftKey = shiftKeyValue;
		controlKey = controlKeyValue;
		commandKey = commandKeyValue;
		
	}
	
	
}


#else
typedef KeyboardEvent = flash.events.KeyboardEvent;
#end