package flash.events; #if (!display && flash)


extern class NetStatusEvent extends Event {
	
	
	public static var NET_STATUS (default, never):String;
	
	public var info:Dynamic;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, info:Dynamic = null);
	
	
}


#else
typedef NetStatusEvent = openfl.events.NetStatusEvent;
#end