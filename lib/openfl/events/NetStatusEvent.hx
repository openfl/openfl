package openfl.events; #if (display || !flash)


@:jsRequire("openfl/events/NetStatusEvent", "default")

extern class NetStatusEvent extends Event {
	
	
	public static inline var NET_STATUS = "netStatus";
	
	public var info:Dynamic;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, info:Dynamic = null);
	
	
}


#else
typedef NetStatusEvent = flash.events.NetStatusEvent;
#end