package openfl.events; #if (display || !flash)


extern class UncaughtErrorEvent extends ErrorEvent {
	
	
	public static inline var UNCAUGHT_ERROR = "uncaughtError";
	
	public var error (default, null):Dynamic;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null);
	
	
}


#else
typedef UncaughtErrorEvent = flash.events.UncaughtErrorEvent;
#end