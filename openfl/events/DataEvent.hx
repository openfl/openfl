package openfl.events; #if (!display && !flash)


class DataEvent extends TextEvent {
	
	
	public static var DATA = "data";
	public static var UPLOAD_COMPLETE_DATA = "uploadCompleteData";
	
	public var data:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "") {
		
		super (type, bubbles, cancelable);
		
		this.data = data;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new DataEvent (type, bubbles, cancelable, data);
		event.target = target;
		event.currentTarget = currentTarget;
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("DataEvent",  [ "type", "bubbles", "cancelable", "data" ]);
		
	}
	
	
}


#else


#if flash
@:native("flash.events.DataEvent")
#end

extern class DataEvent extends TextEvent {
	
	
	public static var DATA:String;
	public static var UPLOAD_COMPLETE_DATA:String;
	
	public var data:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "");
	
	
}


#end