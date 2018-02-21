package openfl.events;


class IOErrorEvent extends ErrorEvent {
	
	
	public static inline var IO_ERROR = "ioError";
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, text:String = "", id:Int = 0) {
		
		super (type, bubbles, cancelable, text, id);
		
	}
	
	
	public override function clone ():Event {
		
		var event = new IOErrorEvent (type, bubbles, cancelable, text, errorID);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("IOErrorEvent",  [ "type", "bubbles", "cancelable", "text", "errorID" ]);
		
	}
	
	
}