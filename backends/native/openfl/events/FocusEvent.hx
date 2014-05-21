package openfl.events;


import openfl.display.InteractiveObject;


class FocusEvent extends Event {
	
	
	static public var FOCUS_IN = "focusIn";
	static public var FOCUS_OUT = "focusOut";
	static public var KEY_FOCUS_CHANGE = "keyFocusChange";
	static public var MOUSE_FOCUS_CHANGE = "mouseFocusChange";
	
	public var keyCode (default, null):Int;
	public var relatedObject (default, null):InteractiveObject;
	public var shiftKey (default, null):Bool;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, relatedObject:InteractiveObject = null, shiftKey:Bool = false, keyCode:Int = 0, direction:String = "none") {
		
		super (type, bubbles, cancelable);
		
		this.relatedObject = relatedObject;
		this.keyCode = keyCode;
		this.shiftKey = shiftKey;
		
	}
	
	
	public override function clone ():Event {
		
		return new FocusEvent (type, bubbles, cancelable, relatedObject, shiftKey, keyCode);
		
	}
	
	
	public override function toString ():String {
		
		return "[FocusEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " relatedObject=" + relatedObject + " shiftKey=" + shiftKey + " keyCode=" + keyCode + "]";
		
	}
	
	
}