package openfl.events;


class IOErrorEvent extends ErrorEvent {
	
	
	public static inline var IO_ERROR = "ioError";
	
	#if air
	public static inline var STANDARD_ERROR_IO_ERROR : String = "standardErrorIoError";
	public static inline var STANDARD_INPUT_IO_ERROR : String = "standardInputIoError"
	public static inline var STANDARD_OUTPUT_IO_ERROR : String = "standardOutputIoError"
	#end
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, text:String = "", id:Int = 0) {
		
		super (type, bubbles, cancelable, text, id);
		
	}
	
	
	public override function clone ():Event {
		
		var event = new IOErrorEvent (type, bubbles, cancelable, text, errorID);
		event.target = target;
		event.currentTarget = currentTarget;
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("IOErrorEvent",  [ "type", "bubbles", "cancelable", "text", "errorID" ]);
		
	}
	
	
}