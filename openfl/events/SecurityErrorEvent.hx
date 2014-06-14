package openfl.events; #if !flash


class SecurityErrorEvent extends ErrorEvent {
	
	
	static public var SECURITY_ERROR:String = "securityError";
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = ""):Void {
		
		super (type, bubbles, cancelable);
		
		this.text = text;
		
	}
	
	
}


#else
typedef SecurityErrorEvent = flash.events.SecurityErrorEvent;
#end