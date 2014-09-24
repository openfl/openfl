package openfl.events; #if !flash #if (display || openfl_next || js)


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
	
	
	
	
	public override function clone ():Event {
		
		return new KeyboardEvent (type, bubbles, cancelable, charCode, keyCode, keyLocation, ctrlKey, altKey, shiftKey, controlKey, commandKey);
		
	}
	
	
	public override function toString ():String {
		
		return "[KeyboardEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " charCode=" + charCode + " keyCode=" + keyCode + " keyLocation=" + keyLocation + " ctrlKey=" + ctrlKey + " altKey=" + altKey + " shiftKey=" + shiftKey + "]";
		
	}
	
	
}


#else
typedef KeyboardEvent = openfl._v2.events.KeyboardEvent;
#end
#else
typedef KeyboardEvent = flash.events.KeyboardEvent;
#end