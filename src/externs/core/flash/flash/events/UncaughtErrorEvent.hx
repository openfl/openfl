package flash.events; #if (!display && flash)


extern class UncaughtErrorEvent extends ErrorEvent {
	
	
	public static var UNCAUGHT_ERROR (default, never):String;
	
	public var error (default, null):Dynamic;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null);
	
	
}


#else
typedef UncaughtErrorEvent = openfl.events.UncaughtErrorEvent;
#end