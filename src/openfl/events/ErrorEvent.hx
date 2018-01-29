package openfl.events;


class ErrorEvent extends TextEvent {
	
	
	public static inline var ERROR = "error";
	
	public var errorID (default, null):Int;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0):Void {
		
		super (type, bubbles, cancelable, text);
		errorID = id;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new ErrorEvent (type, bubbles, cancelable, text, errorID);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("ErrorEvent",  [ "type", "bubbles", "cancelable", "text", "errorID" ]);
		
	}
	
	
}