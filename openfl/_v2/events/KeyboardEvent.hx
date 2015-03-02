package openfl._v2.events; #if lime_legacy


class KeyboardEvent extends Event {
	
	
	public static var KEY_DOWN = "keyDown";
	public static var KEY_UP = "keyUp";
	
	public var altKey:Bool;
	public var charCode:Int;
	public var ctrlKey:Bool;
	public var controlKey:Bool;
	public var commandKey:Bool;
	public var keyCode:Int;
	public var keyLocation:Int;
	public var shiftKey:Bool;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, charCodeValue:Int = 0, keyCodeValue:Int = 0, keyLocationValue:Int = 0, ctrlKeyValue:Bool = false, altKeyValue:Bool = false, shiftKeyValue:Bool = false, controlKeyValue:Bool = false, commandKeyValue:Bool = false) {
		
		super (type, bubbles, cancelable);
		
		keyCode = keyCodeValue;
		keyLocation = keyLocationValue;
		charCode = charCodeValue;
		
		shiftKey = shiftKeyValue;
		altKey = altKeyValue;
		controlKey = controlKeyValue;
		commandKey = commandKeyValue;
		ctrlKey = (ctrlKeyValue || controlKey || commandKey);
		
	}
	
	
	public override function clone ():Event {
		
		return new KeyboardEvent (type, bubbles, cancelable, charCode, keyCode, keyLocation, ctrlKey, altKey, shiftKey, controlKey, commandKey);
		
	}
	
	
	public override function toString ():String {
		
		return "[KeyboardEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " charCode=" + charCode + " keyCode=" + keyCode + " keyLocation=" + keyLocation + " ctrlKey=" + ctrlKey + " altKey=" + altKey + " shiftKey=" + shiftKey + "]";
		
	}
	
	
}


#end