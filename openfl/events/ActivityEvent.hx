package openfl.events; #if (!display && !flash)


class ActivityEvent extends Event {
	
	
	public static var ACTIVITY = "activity";
	
	public var activating:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false) {
		
		super (type, bubbles, cancelable);
		
		this.activating = activating;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new ActivityEvent (type, bubbles, cancelable, activating);
		event.target = target;
		event.currentTarget = currentTarget;
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("ActivityEvent",  [ "type", "bubbles", "cancelable", "activating" ]);
		
	}
	
	
}


#else


#if flash
@:native("flash.events.ActivityEvent")
#end

extern class ActivityEvent extends Event {
	
	
	public static var ACTIVITY:String;
	
	public var activating:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false);
	
	
}


#end