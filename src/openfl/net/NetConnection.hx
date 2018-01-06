package openfl.net;


import openfl.events.EventDispatcher;
import openfl.events.NetStatusEvent;


class NetConnection extends EventDispatcher {
	
	
	public static inline var CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public function connect (command:String, ?_, ?_, ?_, ?_, ?_):Void {
		
		if (command != null) {
			
			throw "Error: Can only connect in \"HTTP streaming\" mode";
			
		}
		
		this.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, true, { code: NetConnection.CONNECT_SUCCESS }));
		
	}
	
	
}
