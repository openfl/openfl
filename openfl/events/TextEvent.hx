package openfl.events; #if !flash


class TextEvent extends Event {
	
	
	public static var LINK:String = "link";
	public static var TEXT_INPUT:String = "textInput";
	
	public var text:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "") {
		
		super (type, bubbles, cancelable);
		
		this.text = text;
		
	}
	
	
	public override function clone ():Event {
		
		return new TextEvent (type, bubbles, cancelable, text);
		
	}
	
	
	public override function toString ():String {
		
		return "[TextEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " text=" + text + "]";
		
	}
	
	
}


#else
typedef TextEvent = flash.events.TextEvent;
#end