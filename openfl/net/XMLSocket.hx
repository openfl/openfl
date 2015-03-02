package openfl.net; #if !flash #if !lime_legacy


import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.EventDispatcher;


class XMLSocket extends EventDispatcher {
	
	
	public var connected (default, null):Bool;
	public var timeout:Int;
	
	private var _socket:Dynamic;
	
	
	public function new (host:String = null, port:Int = 80):Void {
		
		super();
		
		if (host != null) {
			
			connect (host, port);
			
		}
		
	}
	
	
	public function close ():Void {
		
		_socket.close ();
		
	}
	
	
	public function connect (host: String, port:Int):Void {
		
		connectWithProto(host, port, null);
		
	}
	
	
	public function connectWithProto (host: String, port:Int, protocol:String):Void {
		
		#if js
		if (protocol == null) {
            _socket = untyped __js__("new WebSocket(\"ws://\" + host + \":\" + port)");
        }
        else {
            _socket = untyped __js__("new WebSocket(\"ws://\" + host + \":\" + port, protocol)");
        }
		
		connected = false;
		
		_socket.onopen = onOpenHandler;
		_socket.onmessage = onMessageHandler;
		_socket.onclose = onCloseHandler;
		_socket.onerror = onErrorHandler;
		#end
		
	}
	
	
	public function send (object:Dynamic):Void {
		
		_socket.send (object);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function onMessageHandler (msg:Dynamic):Void {
		
		dispatchEvent (new DataEvent (DataEvent.DATA, false, false, msg.data));
		
	}
	
	
	@:noCompletion private function onOpenHandler (_):Void {
		
		connected = true;
		dispatchEvent (new Event (Event.CONNECT));
		
	}
	
	
	@:noCompletion private function onCloseHandler (_):Void {
		
		dispatchEvent (new Event (Event.CLOSE));
		
	}
	
	
	@:noCompletion private function onErrorHandler (_):Void {
		
		dispatchEvent (new Event (IOErrorEvent.IO_ERROR));
		
	}
	
	
}


#else
typedef XMLSocket = openfl._v2.net.XMLSocket;
#end
#else
typedef XMLSocket = flash.net.XMLSocket;
#end