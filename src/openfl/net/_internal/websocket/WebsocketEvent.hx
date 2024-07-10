package openfl.net._internal.websocket;
#if sys
class WebsocketEvent 
{
	public static var OPEN:String = "open";
	public static var MESSAGE:String = "message";
	public static var ERROR:String = "error";
	public static var CLOSE:String = "close";
	
	public var type:String;
	public var target:Dynamic;
	public var data:Dynamic;
	public var code:Null<Int>;
	public var reason:Null<String>;
	
	public function new(type:String, target:WebSocket, ?data:Dynamic, ?code:Int, ?reason:String ) 
	{
		this.type = type;
		this.target = target;
		this.data = data;
		this.code = code;
		
		if (type == CLOSE && reason == null){
			switch(code){
				case 1000: reason = "Normal closure";
				case 1001: reason = "Going away";
				case 1002: reason = "Protocol error";
				case 1003: reason = "Message too big";
				case 1007: reason = "Invalid data";
				case 1008: reason = "Policy violation";
				case 1009: reason = "Message too big";
				case 1010: reason = "Missing extension(s)";
				case 1011: reason = "Internal server error";
				case 1015: reason = "TLS handshake failed";
				default: reason = "";
			}
			
		}
		
		this.reason = reason;
	}
	
}
#end