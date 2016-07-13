package openfl.events;


class UncaughtErrorEvent extends ErrorEvent {
	
	
	public static inline var UNCAUGHT_ERROR = "uncaughtError";
	
	public var error (default, null):Dynamic;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null) {
		
		super (type, bubbles, cancelable);
		
		this.error = error;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new UncaughtErrorEvent (type, bubbles, cancelable, error);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("UncaughtErrorEvent",  [ "type", "bubbles", "cancelable", "error" ]);
		
	}
	
	
}