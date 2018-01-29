package openfl.events;


class DataEvent extends TextEvent {
	
	
	public static inline var DATA = "data";
	public static inline var UPLOAD_COMPLETE_DATA = "uploadCompleteData";
	
	public var data:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "") {
		
		super (type, bubbles, cancelable);
		
		this.data = data;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new DataEvent (type, bubbles, cancelable, data);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("DataEvent",  [ "type", "bubbles", "cancelable", "data" ]);
		
	}
	
	
}