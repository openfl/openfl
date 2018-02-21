package openfl.events;


import openfl.ui.KeyLocation;


class KeyboardEvent extends Event {
	
	
	public static inline var KEY_DOWN = "keyDown";
	public static inline var KEY_UP = "keyUp";
	
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
		
		var event = new KeyboardEvent (type, bubbles, cancelable, charCode, keyCode, keyLocation, ctrlKey, altKey, shiftKey, controlKey, commandKey);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("KeyboardEvent",  [ "type", "bubbles", "cancelable", "charCode", "keyCode", "keyLocation", "ctrlKey", "altKey", "shiftKey" ]);
		
	}
	
	
}