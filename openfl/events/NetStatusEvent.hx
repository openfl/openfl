package openfl.events; #if !flash


class NetStatusEvent extends Event {
	
	
	public static var NET_STATUS:String = "netStatus";
	
	public var info:Dynamic;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, info:Dynamic = null):Void {
		
		this.info = info;
		
		super (type, bubbles, cancelable);
		
	}
	
	
}


#else
typedef NetStatusEvent = flash.events.NetStatusEvent;
#end