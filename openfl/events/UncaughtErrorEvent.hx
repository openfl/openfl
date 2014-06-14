package openfl.events; #if !flash


class UncaughtErrorEvent extends ErrorEvent {
	
	
	public static var UNCAUGHT_ERROR = "uncaughtError";
	
	public var error:Dynamic;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null) {
		
		super (type, bubbles, cancelable);
		this.error = error;
		
	}
	
	
	public override function clone ():Event {
		
		return new UncaughtErrorEvent (type, bubbles, cancelable, error);
		
	}
	
	
	public override function toString ():String {
		
		return "[UncaughtErrorEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + "]";
		
	}
	
	
}


#else
typedef UncaughtErrorEvent = flash.events.UncaughtErrorEvent;
#end