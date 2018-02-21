package openfl.events;


class NetStatusEvent extends Event {
	
	
	public static inline var NET_STATUS = "netStatus";
	
	public var info:Dynamic;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, info:Dynamic = null):Void {
		
		this.info = info;
		
		super (type, bubbles, cancelable);
		
	}
	
	
	public override function clone ():Event {
		
		var event = new NetStatusEvent (type, bubbles, cancelable, info);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("NetStatusEvent",  [ "type", "bubbles", "cancelable", "info" ]);
		
	}
	
	
}