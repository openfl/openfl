package flash.events; #if (!display && flash)


extern class SecurityErrorEvent extends ErrorEvent {
	
	
	public static var SECURITY_ERROR (default, never):String;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0);
	
	
}


#else
typedef SecurityErrorEvent = openfl.events.SecurityErrorEvent;
#end