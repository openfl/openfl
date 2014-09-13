package openfl.events;


class SecurityErrorEvent extends ErrorEvent {
	
	
	public static inline var SECURITY_ERROR = "securityError";
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0) {
		
		super (type, bubbles, cancelable, text, id);
		
	}
	
	
	public override function clone ():Event {
		
		return new SecurityErrorEvent (type, bubbles, cancelable, text, errorID);
		
	}
	
	
	public override function toString ():String {
		
		return "[SecurityErrorEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " text=" + text + " errorID=" + errorID + "]";
		
	}
	
	
}