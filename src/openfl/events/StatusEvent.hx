package openfl.events; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class StatusEvent extends Event {
	
	
	public static inline var STATUS = "status";
	
	public var code:StatusEventCode;
	public var level:StatusEventLevel;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, code:StatusEventCode = "", level:StatusEventLevel = ""):Void {
		
		this.code = code;
		this.level = level;
		
		super (type, bubbles, cancelable);
		
	}
	
	
	public override function clone ():Event {
		
		var event = new StatusEvent (type, bubbles, cancelable, code, level);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("StatusEvent",  [ "type", "bubbles", "cancelable", "code", "level" ]);
		
	}
	
	
}


#else
typedef StatusEvent = flash.events.StatusEvent;
#end

@:enum abstract StatusEventLevel(String) from String to String {
	
	public var STATUS = 'status';
	public var WARNING = 'warning';
	public var ERROR = 'error';
}

@:enum abstract StatusEventCode(String) from String to String {
	
	public var ACTIVE = 'active'; // need to check how AIR handles this
	public var INACTIVE = 'inactive'; // need to check how AIR handles this
	public var CAMERA_MUTED = 'Camera.Muted';
	public var CAMERA_UNMUTED = 'Camera.Unmuted';
}