package openfl.events; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class ActivityEvent extends Event {
	
	
	public static inline var ACTIVITY = "activity";
	
	public var activating:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, activating:Bool = false) {
		
		super (type, bubbles, cancelable);
		
		this.activating = activating;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new ActivityEvent (type, bubbles, cancelable, activating);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("ActivityEvent",  [ "type", "bubbles", "cancelable", "activating" ]);
		
	}
	
	
}


#else
typedef ActivityEvent = flash.events.ActivityEvent;
#end