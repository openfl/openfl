package openfl.events;

class UncaughtErrorEvent extends ErrorEvent {
	public static var UNCAUGHT_ERROR = "uncaughtError";
	
	public var error : Dynamic;
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = true, error_in:Dynamic = null ) {
		
		super (type, bubbles, cancelable);
		error = error_in;
		
	}
	
	
	public override function clone ():Event {
		
		return new UncaughtErrorEvent(type, bubbles, cancelable, error);
		
	}
	
	
	public override function toString ():String {
		
		return "[UncaughtErrorEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + "]";
		
	}
}